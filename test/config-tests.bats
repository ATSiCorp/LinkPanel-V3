#!/usr/bin/env bats

if [ "${PATH#*/usr/local/linkpanel/bin*}" = "$PATH" ]; then
    . /etc/profile.d/linkpanel.sh
fi

load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'
load 'test_helper/bats-file/load'

function random() {
head /dev/urandom | tr -dc 0-9 | head -c$1
}

function setup() {
    # echo "# Setup_file" > &3
    if [ $BATS_TEST_NUMBER = 1 ]; then
        echo 'user=test-5285' > /tmp/linkpanel-test-env.sh
        echo 'user2=test-5286' >> /tmp/linkpanel-test-env.sh
        echo 'userbk=testbk-5285' >> /tmp/linkpanel-test-env.sh
        echo 'userpass1=test-5285' >> /tmp/linkpanel-test-env.sh
        echo 'userpass2=t3st-p4ssw0rd' >> /tmp/linkpanel-test-env.sh
        echo 'LINKPANEL=/usr/local/linkpanel' >> /tmp/linkpanel-test-env.sh
        echo 'domain=test-5285.linkpanelcp.com' >> /tmp/linkpanel-test-env.sh
        echo 'domainuk=test-5285.linkpanelcp.com.uk' >> /tmp/linkpanel-test-env.sh
        echo 'rootdomain=testlinkpanelcp.com' >> /tmp/linkpanel-test-env.sh
        echo 'subdomain=cdn.testlinkpanelcp.com' >> /tmp/linkpanel-test-env.sh
        echo 'database=test-5285_database' >> /tmp/linkpanel-test-env.sh
        echo 'dbuser=test-5285_dbuser' >> /tmp/linkpanel-test-env.sh
    fi

    source /tmp/linkpanel-test-env.sh
    source $LINKPANEL/func/main.sh
    source $LINKPANEL/conf/linkpanel.conf
    source $LINKPANEL/func/ip.sh
}

@test "Setup Test domain" {
    run v-add-user $user $user $user@linkpanelcp.com default "Super Test"
    assert_success
    refute_output

    run v-add-web-domain $user 'testlinkpanelcp.com'
    assert_success
    refute_output

    ssl=$(v-generate-ssl-cert "testlinkpanelcp.com" "info@testlinkpanelcp.com" US CA "Orange County" LinkPanelCP IT "mail.$domain" | tail -n1 | awk '{print $2}')
    mv $ssl/testlinkpanelcp.com.crt /tmp/testlinkpanelcp.com.crt
    mv $ssl/testlinkpanelcp.com.key /tmp/testlinkpanelcp.com.key

    # Use self signed certificates during last test
    run v-add-web-domain-ssl $user testlinkpanelcp.com /tmp
    assert_success
    refute_output
}

@test "Web Config test" {
    for template in $(v-list-web-templates plain); do
        run v-change-web-domain-tpl $user testlinkpanelcp.com $template
        assert_success
        refute_output
    done
}

@test "Proxy Config test" {
    if [ "$PROXY_SYSTEM" = "nginx" ]; then
        for template in $(v-list-proxy-templates plain); do
            run v-change-web-domain-proxy-tpl $user testlinkpanelcp.com $template
            assert_success
            refute_output
        done
    else
        skip "Proxy not installed"
    fi
}

@test "Clean up" {
    run v-delete-user $user
    assert_success
    refute_output
}
