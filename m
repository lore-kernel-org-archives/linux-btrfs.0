Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34754 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965457AbbD1Mml (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Apr 2015 08:42:41 -0400
Received: by wgso17 with SMTP id o17so150232263wgs.1
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2015 05:42:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <553F50E3.6060002@oracle.com>
References: <CAGMbsDWrzYi5jQTKhSfTn0YAbFKfcQzsMktuw5rM9yK17j3Urw@mail.gmail.com>
 <553F50E3.6060002@oracle.com>
From: Ermanno Baschiera <ebaschiera@gmail.com>
Date: Tue, 28 Apr 2015 14:42:20 +0200
Message-ID: <CAGMbsDW3HaNc_OrOa-oPtgBYn2xpLW2-WPZoM4HEsW2Qj8EYBw@mail.gmail.com>
Subject: Re: help on broken file system
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you Anand, but, if I'm not wrong, the "delete device" has to be
run against a mount point. But my file system can't be mounted.

2015-04-28 11:20 GMT+02:00 Anand Jain <anand.jain@oracle.com>:
>
>> I have a 3 disks file system configured in RAID1, created with Ubuntu
>
>
> ::
>
>> Having not a spare disk, and being the file system
>> a RAID1, I decided to use one of the 3 disks as target for the
>> restore. I formatted it in EXT4 and tried the restore. The process
> ::
>>
>> [liveuser@localhost ~]$ sudo btrfs fi show
>> warning, device 1 is missing
>> warning devid 1 not found already
>
>
>
>> Label: none  uuid: 32eeac52-699b-4fa2-be61-06206910a37f
>>      Total devices 3 FS bytes used 3.79TiB
>>      devid    3 size 2.73TiB used 2.73TiB path /dev/sda
>>      devid    4 size 2.73TiB used 2.73TiB path /dev/sdc2
>>      *** Some devices missing
>>
>> Btrfs v3.18.2
>
>
>
> Looks like you didn't use btrfs device del to remove a disk, FS still
> shows total devices as 3. presumably kernel knows about a device
> missing. then , 'btrfs device del missing /mnt' will be the first step. IMO.
>
