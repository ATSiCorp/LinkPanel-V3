%define debug_package %{nil}
%global _hardened_build 1

Name:           linkpanel
Version:        1.9.0~alpha
Release:        1%{dist}
Summary:        LinkPanel Control Panel
Group:          System Environment/Base
License:        GPLv3
URL:            https://www.linkpanelcp.com
Source0:        linkpanel-%{version}.tar.gz
Source1:        linkpanel.service
Vendor:         linkpanelcp.com
Requires:       redhat-release >= 8
Requires:       bash, chkconfig, gawk, sed, acl, sysstat, (setpriv or util-linux), zstd, jq, jailkit
Conflicts:      vesta
Provides:       linkpanel = %{version}
BuildRequires:  systemd

%description
This package contains the LinkPanel Control Panel.

%prep
%autosetup -p1 -n linkpanelcp

%build

%install
%{__rm} -rf $RPM_BUILD_ROOT
mkdir -p %{buildroot}%{_unitdir} %{buildroot}/usr/local/linkpanel
cp -R %{_builddir}/linkpanelcp/* %{buildroot}/usr/local/linkpanel/
%{__install} -m644 %{SOURCE1} %{buildroot}%{_unitdir}/linkpanel.service

%clean
%{__rm} -rf $RPM_BUILD_ROOT

%pre
# Run triggers only on updates
if [ -e "/usr/local/linkpanel/data/users/" ]; then
    # Validate version number and replace if different
    LINKPANEL_V=$(rpm --queryformat="%{VERSION}" -q linkpanel)
    if [ ! "$LINKPANEL_V" = "%{version}" ]; then
        sed -i "s/VERSION=.*/VERSION='$LINKPANEL_V'/g" /usr/local/linkpanel/conf/linkpanel.conf
    fi
fi

%post
%systemd_post linkpanel.service

if [ ! -e /etc/profile.d/linkpanel.sh ]; then
    LINKPANEL='/usr/local/linkpanel'
    echo "export LINKPANEL='$LINKPANEL'" > /etc/profile.d/linkpanel.sh
    echo 'PATH=$PATH:'$LINKPANEL'/bin' >> /etc/profile.d/linkpanel.sh
    echo 'export PATH' >> /etc/profile.d/linkpanel.sh
    chmod 755 /etc/profile.d/linkpanel.sh
    source /etc/profile.d/linkpanel.sh
fi

if [ -e "/usr/local/linkpanel/data/users/" ]; then
    ###############################################################
    #                Initialize functions/variables               #
    ###############################################################

    # Load upgrade functions and refresh variables/configuration
    source /usr/local/linkpanel/func/upgrade.sh
    upgrade_refresh_config

    ###############################################################
    #             Set new version numbers for packages            #
    ###############################################################
    # LinkPanel Control Panel
    new_version=$(rpm --queryformat="%{VERSION}" -q linkpanel)

    # phpMyAdmin
    pma_v='5.0.2'

    ###############################################################
    #               Begin standard upgrade routines               #
    ###############################################################

    # Initialize backup directories
    upgrade_init_backup

    # Set up console display and welcome message
    upgrade_welcome_message

    # Execute version-specific upgrade scripts
    upgrade_start_routine

    # Update Web domain templates
    upgrade_rebuild_web_templates | tee -a $LOG

    # Update Mail domain templates
    upgrade_rebuild_mail_templates | tee -a $LOG

    # Update DNS zone templates
    upgrade_rebuild_dns_templates | tee -a $LOG

    # Upgrade File Manager and update configuration
    upgrade_filemanager | tee -a $LOG

    # Upgrade SnappyMail if applicable
    upgrade_snappymail | tee -a $LOG

    # Upgrade Roundcube if applicable
    upgrade_roundcube | tee -a $LOG

    # Upgrade PHPMailer if applicable
    upgrade_phpmailer | tee -a $LOG

    # Update Cloudflare IPs if applicable
    upgrade_cloudflare_ip | tee -a $LOG

    # Upgrade phpMyAdmin if applicable
    upgrade_phpmyadmin | tee -a $LOG

    # Upgrade phpPgAdmin if applicable
    upgrade_phppgadmin | tee -a $LOG

    # Upgrade blackblaze-cli-took if applicable
    upgrade_b2_tool | tee -a $LOG

	# update whitelabel logo's
	update_whitelabel_logo | tee -a $LOG

    # Set new version number in linkpanel.conf
    upgrade_set_version

    # Perform account and domain rebuild to ensure configuration files are correct
    upgrade_rebuild_users

    # Restart necessary services for changes to take full effect
    upgrade_restart_services

    # Add upgrade notification to admin user's panel and display completion message
    upgrade_complete_message
fi

%preun
%systemd_preun linkpanel.service

%postun
%systemd_postun_with_restart linkpanel.service

%files
%defattr(-,root,root)
%attr(755,root,root) /usr/local/linkpanel
%{_unitdir}/linkpanel.service

%changelog
* Sun May 14 2023 Istiak Ferdous <hello@istiak.com> - 1.8.0-1
- LinkPanelCP RHEL 9 support

* Thu Jun 25 2020 Ernesto Nicolás Carrea <equistango@gmail.com> - 1.2.0
- LinkPanelCP CentOS 8 support
