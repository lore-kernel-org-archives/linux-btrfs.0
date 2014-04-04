Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16843 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaDDVTd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Apr 2014 17:19:33 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: Hard restart required
From: Avi Miller <avi.miller@oracle.com>
In-Reply-To: <533EDD2E.6090308@benjamindsmith.com>
Date: Sat, 5 Apr 2014 08:19:27 +1100
Cc: Avi.Miller@userp1020.oracle.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <EE50E6C7-94F9-494A-A930-194FABFC6B68@oracle.com>
References: <533DFC46.8020704@benjamindsmith.com> <EDB7426B-B4CA-45F7-A8A4-F7CD0C876DC8@oracle.com> <533EDD2E.6090308@benjamindsmith.com>
To: Lists <lists@benjamindsmith.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 5 Apr 2014, at 3:26 am, Lists <lists@benjamindsmith.com> wrote:

> On 04/03/2014 05:41 PM, Avi Miller wrote:
>> UUID should work fine on OL6. Can you confirm that you have the UEK3 (3.8.18) kernel running? If you’ve installed from OL6U5 media, it should be enabled by default, but older OL6 ISOs only had UEK2 on the media and the UEK3 yum channel would need to be manually enabled.
> 
> As suggested earlier on this list, I started with a fresh, vanilla CentOS 6 install and used the centos2ol.sh script to switch to using OL before doing a yum update/upgrade and install of BTRFS. Here's the relevant info after the switchover.

Any particular reason why you didn’t just start with Oracle Linux 6? The installation media is available for download from the official Oracle Software Delivery Cloud at http://edelivery.oracle.com/linux or if you can’t be bothered with the registration requirement, from one of the mirrors listed at https://wikis.oracle.com/display/oraclelinux/Downloading+Oracle+Linux

There is no good reason to start with CentOS. 

> [root@oracle ~]# uname -a
> Linux oracle.schoolpathways.com 2.6.32-431.11.2.el6.x86_64 #1 SMP Tue Mar 25 08:15:39 PDT 2014 x86_64 x86_64 x86_64 GNU/Linux

This kernel is very, very, very old in btrfs terms. In fact, this is the RHCK or Red Hat Compatible Kernel that ships with RHEL6/C6 and isn’t one of the newer Oracle UEK releases at all.

> [ol6_UEKR3_latest]
> name=Latest Unbreakable Enterprise Kernel for Oracle Linux $releasever ($basearch)
> baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL6/UEKR3/latest/$basearch/
> gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
> gpgcheck=1
> enabled=0

Enable this repository and do a yum update to get the latest UEK Release 3, i.e. the 3.8.13 kernel.

Cheers,
Avi

--
Oracle <http://www.oracle.com>
Avi Miller | Product Management Director | +61 (3) 8616 3496
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia

