Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from locke.effortlessis.com ([208.53.66.14]:57229 "EHLO
	locke.effortlessis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbaDDQ00 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 12:26:26 -0400
Message-ID: <533EDD2E.6090308@benjamindsmith.com>
Date: Fri, 04 Apr 2014 09:26:22 -0700
From: Lists <lists@benjamindsmith.com>
MIME-Version: 1.0
To: Avi.Miller@twin.jikos.cz, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Hard restart required
References: <533DFC46.8020704@benjamindsmith.com> <EDB7426B-B4CA-45F7-A8A4-F7CD0C876DC8@oracle.com>
In-Reply-To: <EDB7426B-B4CA-45F7-A8A4-F7CD0C876DC8@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/03/2014 05:41 PM, Avi Miller wrote:
> UUID should work fine on OL6. Can you confirm that you have the UEK3 (3.8.18) kernel running? If you’ve installed from OL6U5 media, it should be enabled by default, but older OL6 ISOs only had UEK2 on the media and the UEK3 yum channel would need to be manually enabled.

As suggested earlier on this list, I started with a fresh, vanilla 
CentOS 6 install and used the centos2ol.sh script to switch to using OL 
before doing a yum update/upgrade and install of BTRFS. Here's the 
relevant info after the switchover.

[root@oracle ~]# uname -a
Linux oracle.schoolpathways.com 2.6.32-431.11.2.el6.x86_64 #1 SMP Tue 
Mar 25 08:15:39 PDT 2014 x86_64 x86_64 x86_64 GNU/Linux
[root@oracle ~]# rpm -qa | grep -i kernel
dracut-kernel-004-336.0.1.el6_5.2.noarch
kernel-firmware-2.6.32-431.11.2.el6.noarch
kernel-2.6.32-431.11.2.el6.x86_64
kernel-2.6.32-358.el6.x86_64
[root@oracle ~]# cat /etc/yum.repos.d/public-yum-ol6.repo
[ol6_latest]
name=Oracle Linux $releasever Latest ($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/latest/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=1

[ol6_addons]
name=Oracle Linux $releasever Add ons ($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/addons/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol6_ga_base]
name=Oracle Linux $releasever GA installation media copy ($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/0/base/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol6_u1_base]
name=Oracle Linux $releasever Update 1 installation media copy ($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/1/base/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol6_u2_base]
name=Oracle Linux $releasever Update 2 installation media copy ($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/2/base/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol6_u3_base]
name=Oracle Linux $releasever Update 3 installation media copy ($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/3/base/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol6_u4_base]
name=Oracle Linux $releasever Update 4 installation media copy ($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/4/base/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol6_u5_base]
name=Oracle Linux $releasever Update 5 installation media copy ($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/5/base/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol6_UEKR3_latest]
name=Latest Unbreakable Enterprise Kernel for Oracle Linux $releasever 
($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/UEKR3/latest/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol6_UEK_latest]
name=Latest Unbreakable Enterprise Kernel for Oracle Linux $releasever 
($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/UEK/latest/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=1

[ol6_UEK_base]
name=Unbreakable Enterprise Kernel for Oracle Linux $releasever ($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/UEK/base/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol6_playground_latest]
name=Latest mainline stable kernel for Oracle Linux 6 ($basearch) - 
Unsupported
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/playground/latest/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol6_MySQL]
name=MySQL 5.5 for Oracle Linux 6 ($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/MySQL/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol6_gdm_multiseat]
name=Oracle Linux 6 GDM Multiseat ($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/gdm_multiseat/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol6_ofed_UEK]
name=OFED supporting tool packages for Unbreakable Enterprise Kernel on 
Oracle Linux 6 ($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/ofed_UEK/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol6_MySQL56]
name=MySQL 5.6 for Oracle Linux 6 ($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/MySQL56/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol6_spacewalk20_server]
name=Spacewalk Server 2.0 for Oracle Linux 6 ($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/spacewalk20/server/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol6_spacewalk20_client]
name=Spacewalk Client 2.0 for Oracle Linux 6 ($basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/spacewalk20/client/$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[root@oracle ~]# yum check-update && echo $?
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
0
[root@oracle ~]#

