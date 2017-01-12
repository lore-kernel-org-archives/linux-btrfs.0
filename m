Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34693 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1759617AbdALBZs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 20:25:48 -0500
Subject: Re: corruption: yet another one after deleting a ro snapshot
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <1484183243.10253.5.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a7b82ec9-bd8d-d6bb-27e7-3732b466ca06@cn.fujitsu.com>
Date: Thu, 12 Jan 2017 09:25:40 +0800
MIME-Version: 1.0
In-Reply-To: <1484183243.10253.5.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 01/12/2017 09:07 AM, Christoph Anton Mitterer wrote:
> Hey.
>
> Linux heisenberg 4.8.0-2-amd64 #1 SMP Debian 4.8.15-2 (2017-01-04)
> x86_64 GNU/Linux
> btrfs-progs v4.7.3
>
> I've had this already at least once some year ago or so:
>
> I was doing backups (incremental via send/receive).
> After everything was copied, I unmounted the destination fs, made a
> fsck, all fine.
> Then I mounted it again and did nothing but deleting the old snapshot.
> After that, another fsck with the following errors:
>

According to the messages, some tree blocks has wrong extent backref.

And since you just deleted a subvolume and unmount it soon, I assume the 
btrfs is still doing background subvolume deletion, maybe it's just a 
false alert from btrfsck.

Would you please try btrfs check --mode=lowmem using latest btrfs-progs?

Sometimes bugs in original mode are fixed in lowmem mode.

And it's also recommended to call btrfs fi sync, then wait for some time 
(depending on the subvolume size) to allow btrfs to fully delete the 
subvolume, then try btrfsck.

Thanks,
Qu
>
> Usually I have quite positive experiences with btrfs (things seem to be
> fine even after a crash or accidental removal of the USB cable which
> attaches the HDD)... but I'm every time shocked again, when supposedly
> simple and basic operations like this cause such corruptions.
> Kinda gives one the feeling as if quite deep bugs are still everywhere
> in place, especially as such "hard to explain" errors happens every now
> and then (take e.g. my mails "strange btrfs deadlock", "csum errors
> during btrfs check" from the last days... and I don't seem to be the
> only one who suffers from such problems, even with the basic parts of
> btrfs which are considered to be stable - I mean we're not talking
> about RAID56 here)... sigh :-(
>
>
> While these files are precious, I have in total copies of all these
> files, 3 on btrfs and 1 on ext4 (just to be on the safe side if btrfs
> gets corrupted for no good reason :-( ).... so I could do some
> debugging here if some developer tells me what to do.
>
>
> Anyway... what should I do to repair the fs? Or is it better to simply
> re-create that backup from scratch?
>
>
> Cheers,
> Chris.
>


