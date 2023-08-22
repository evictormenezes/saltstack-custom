{% set gget = salt['grains.get'] %}

{# RHEL/CentOS #}
{% if gget('os_family','') == 'RedHat' %}
{% if gget('osmajorrelease','') == 7 %}
zabbix_repo_package:
  pkg.installed:
    - sources:
      - zabbix-release: https://repo.zabbix.com/zabbix/{{ pillar['versions']['ops']['zabbix'] }}/rhel/7/x86_64/zabbix-release-{{ pillar['versions']['ops']['zabbix_release_package'] }}.el7.noarch.rpm
  cmd.run:
    - name: /bin/yum-config-manager --disable zabbix --disable zabbix-non-supported | grep -e '^\[.*\]$' -e '^enabled'
    - unless:
      - '/bin/grep -E -q "^\[zabbix-non-supported\]" /etc/yum.repos.d/zabbix.repo && \
           grep -E -q "enabled=0" /etc/yum.repos.d/zabbix.repo && \
           grep -E -q "^\[zabbix-unstable\]" /etc/yum.repos.d/zabbix.repo && \
           grep -E -q "enabled=0" /etc/yum.repos.d/zabbix.repo'

{% elif gget('osmajorrelease','') == 8 %}
zabbix_repo_package:
  pkg.installed:
    - sources:
      - zabbix-release: https://repo.zabbix.com/zabbix/{{
        pillar['versions']['ops']['zabbix'] }}/rhel/8/x86_64/zabbix-release-{{ pillar['versions']['ops']['zabbix_release_package'] }}.el8.noarch.rpm
  cmd.run:
    - name: /bin/dnf config-manager --set-disabled zabbix --set-disabled zabbix-non-supported
    - unless:
      - '/bin/grep -E -q "^\[zabbix-non-supported\]" /etc/yum.repos.d/zabbix.repo && \
           grep -E -q "enabled=0" /etc/yum.repos.d/zabbix.repo && \
           grep -E -q "^\[zabbix-unstable\]" /etc/yum.repos.d/zabbix.repo && \
           grep -E -q "enabled=0" /etc/yum.repos.d/zabbix.repo'

{% endif %}
