Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57288 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750980AbaF0WM3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 18:12:29 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Can't mount subvolume with ro option
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <B87E6AE0-F47D-4F75-9628-E1151BB7467D@colorremedies.com>
Date: Fri, 27 Jun 2014 16:12:25 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <54D8214E-1C00-43AB-A68A-D450069D878C@colorremedies.com>
References: <53ADCF0B.4010109@free.fr> <B87E6AE0-F47D-4F75-9628-E1151BB7467D@colorremedies.com>
To: =?iso-8859-1?Q?S=E9bastien_ROHAUT?= <sebastien.rohaut@free.fr>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 27, 2014, at 4:08 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Jun 27, 2014, at 2:07 PM, Sébastien ROHAUT <sebastien.rohaut@free.fr> wrote:
> 
>> Hi,
>> 
>> In the wiki, it's said we can mount subvolumes with different mount options. nosuid, nodev, rw and ro are listed, as valid generic mount options.
> 
> This might require 3.15. I don't recall it working with early 3.14 kernels, but by 3.14.3 I'd moved onto testing 3.15.


[root@f20v ~]# mount /dev/sda3 /mnt
[root@f20v ~]# btrfs subvol create /mnt/test
Create subvolume '/mnt/test'
[root@f20v ~]# umount /mnt
[root@f20v ~]# mount -o ro,subvol=test /dev/sda3 /mnt
mount: /dev/sda3 is already mounted or /mnt busy
       /dev/sda3 is already mounted on /
       /dev/sda3 is already mounted on /home
       /dev/sda3 is already mounted on /var
       /dev/sda3 is already mounted on /boot
[root@f20v ~]# uname -r
3.14.6-200.fc20.x86_64


I don't know if this feature will be backported to stable kernels. If not, then probably the wiki should say it's a 3.15+ feature.

Chris Murphy

