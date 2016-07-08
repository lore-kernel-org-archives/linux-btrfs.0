Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36509 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbcGHEvm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 00:51:42 -0400
Received: by mail-pf0-f193.google.com with SMTP id i123so3876210pfg.3
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 21:51:42 -0700 (PDT)
Subject: Re: raid1 has failing disks, but smart is clear
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <577D82AE.3040005@gmail.com>
 <03E1A820-7029-4022-9D46-900C4FCA1ADC@gmail.com> <577DF95E.7080100@gmail.com>
 <pan$90586$9ef8a2d7$381c8c69$44837006@cox.net>
From: Corey Coughlin <corey.coughlin.cc3@gmail.com>
Message-ID: <577F315C.8080509@gmail.com>
Date: Thu, 7 Jul 2016 21:51:40 -0700
MIME-Version: 1.0
In-Reply-To: <pan$90586$9ef8a2d7$381c8c69$44837006@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan,
     Thanks for the info!  I've seen that done in the fstab, but it 
didn't work for me the last time I tried it on the command line. Worth a 
shot!

     ------ Corey

On 07/07/2016 06:24 PM, Duncan wrote:
> Corey Coughlin posted on Wed, 06 Jul 2016 23:40:30 -0700 as excerpted:
>
>> Well yeah, if I was mounting all the disks to different mount points, I
>> would definitely use UUIDs to get them mounted.  But I haven't seen any
>> way to set up a "mkfs.btrfs" command to use UUID or anything else for
>> individual drives.  Am I missing something?  I've been doing a lot of
>> googling.
> FWIW, you can use the /dev/disk/by-*/* symlinks (as normally setup by
> udev) to reference various devices.
>
> Of course because the identifiers behind by-uuid and by-label are per-
> filesystem, those will normally only identify the one device of a multi-
> device filesystem, but the by-id links ID on device serials and partition
> number, and if you are using GPT partitioning, you have by-partuuid and
> (if you set them when setting up the partitions) by-partlabel as well.
>

