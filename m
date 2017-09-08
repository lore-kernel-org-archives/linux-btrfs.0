Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([46.4.129.203]:49362 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755161AbdIHMpy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 08:45:54 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id B8732A5FB65
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Sep 2017 12:45:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Sep 2017 12:45:51 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 08 Sep 2017 21:45:51 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 4.13: No space left with plenty of free space
 (/home/kernel/COD/linux/fs/btrfs/extent-tree.c:6989
 __btrfs_free_extent.isra.62+0xc2c/0xdb0)
In-Reply-To: <409e33c45cf1defe5c582381f00fa562@wpkg.org>
References: <7459bb074e417c066b525d832d8006ca@wpkg.org>
 <409e33c45cf1defe5c582381f00fa562@wpkg.org>
Message-ID: <07038afceffac186c98f02572e5a7aac@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> So the numbers that matter are:
> 
>> Data,single: Size:12.84TiB, Used:7.13TiB
>>     /dev/md2       12.84TiB
>> Metadata,DUP: Size:79.00GiB, Used:77.87GiB
>>     /dev/md2      158.00GiB
>> Unallocated:
>>     /dev/md2        3.31TiB


> * If you are using the 'space_cache' it has a known issue:
>   https://btrfs.wiki.kernel.org/index.php/Gotchas#Free_space_cache

# mount | grep btrfs
/dev/md2 on /data type btrfs 
(rw,noatime,compress-force=zlib,space_cache,subvolid=5,subvol=/)


Citing from the URL you pasted:

  Free space cache

     Currently sometimes the free space cache v1 and v2 lose track of 
free space and a volume can be reported as not having free space when it 
obviously does.
         Fix: disable use of the free space cache with mount option 
nospace_cache.
         Fix: remount the volume with -o remount,clear_cache.
         Switch to to new free space tree.


What does "switch to to new free space tree" mean / how to do it?


> I also notice that your volume's data free space seems to be
> extremely fragmented, as the large difference here shows
> "Data,single: Size:12.84TiB, Used:7.13TiB".

Yes, it's possible it will be very fragmented: lots of rsync + inplace 
and many snapshots. Also - not sure if it matters - IO load is 100% or 
close for most of the day.


> Which may mean that it is mounted with 'ssd' and/or has gone a
> long time without a 'balance', and conceivably this can make it
> easier for the free space cache to fail finding space (some
> handwaving here).

It's using HDDs, not mounted with "ssd" option.

I think there wasn't ever a balance run there. Since full balance may 
take a few months to finish (!) and causes even more IO, I'm not a big 
fan of running it.

Still, it does seem like a bug to me to error with "no space left", when 
there is a lot of space left?


Tomasz Chmielewski
https://lxadm.com
