Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46445 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786AbbD1JUs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Apr 2015 05:20:48 -0400
Message-ID: <553F50E3.6060002@oracle.com>
Date: Tue, 28 Apr 2015 17:20:35 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Ermanno Baschiera <ebaschiera@gmail.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: help on broken file system
References: <CAGMbsDWrzYi5jQTKhSfTn0YAbFKfcQzsMktuw5rM9yK17j3Urw@mail.gmail.com>
In-Reply-To: <CAGMbsDWrzYi5jQTKhSfTn0YAbFKfcQzsMktuw5rM9yK17j3Urw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> I have a 3 disks file system configured in RAID1, created with Ubuntu

::

 > Having not a spare disk, and being the file system
 > a RAID1, I decided to use one of the 3 disks as target for the
 > restore. I formatted it in EXT4 and tried the restore. The process
::
> [liveuser@localhost ~]$ sudo btrfs fi show
> warning, device 1 is missing
> warning devid 1 not found already


> Label: none  uuid: 32eeac52-699b-4fa2-be61-06206910a37f
>      Total devices 3 FS bytes used 3.79TiB
>      devid    3 size 2.73TiB used 2.73TiB path /dev/sda
>      devid    4 size 2.73TiB used 2.73TiB path /dev/sdc2
>      *** Some devices missing
>
> Btrfs v3.18.2


Looks like you didn't use btrfs device del to remove a disk, FS still
shows total devices as 3. presumably kernel knows about a device
missing. then , 'btrfs device del missing /mnt' will be the first step. IMO.

