Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11139 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750921AbbFWBox (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 21:44:53 -0400
Subject: Re: Corrupted btrfs partition (converted from ext4) after balance
To: Vianney Stroebel <capsule@likwid.fr>, <linux-btrfs@vger.kernel.org>
References: <55835A55.7000308@stroebel.fr>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5588BA12.4010104@cn.fujitsu.com>
Date: Tue, 23 Jun 2015 09:44:50 +0800
MIME-Version: 1.0
In-Reply-To: <55835A55.7000308@stroebel.fr>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Vianney Stroebel wrote on 2015/06/19 01:55 +0200:
> One of my btrfs partition seems to have been corrupted.
>
> Since I've tried to balance it, I can only mount it read-only. I have
> been able to use it read-only without problem so far so the data seems
> safe.
>
> When I remove the "ro" option, the "mount" command hangs and some
> programs do not function properly (iotop hangs too and Firefox cannot
> load new web pages). Every few seconds a message is printed on syslog
> (see attached file).
>
> If I try to terminate the "mount" process with ctrl+c, my whole system
> hangs.
>
> This partition was converted from ext4 and I could use it fine after
> that. It got corrupted when I tried to balance it a few days ago (even
> though I think I had balanced it before, but I'm not sure about this).
> The balance would seem to have started but "balance status" showed no
> progress even after one hour.
>
> This partition is on one hard disk (no raid). Mount options:
> defaults,compress=lzo,noatime,nodiratime,noauto,ro). My system also runs
> on btrfs on another disk (ssd) without any problems apart from quite
> poor performance (but that's for another post).
>
> The command "btrfs scrub start /_big -r" hangs my system.
>
> The command Konsole output "btrfs check /dev/sdb1" outputs :
> "Checking filesystem on /dev/sdb1
> UUID: 21873ba7-438a-4fbf-a051-ace28bffd264
> checking extents"
> and stops after a few minutes with no other output.
Maybe I'm too late to point out the problem,
but you may be impatient about btrfsck.

Unlike fsck from ext4/xfs, btrfsck will always read the whole metadata 
to check the consistence, so it may takes a long time for that.

Without the full output of btrfsck, it's quite hard to call it a clear 
bug report if you want to save your data in the corrupted partition.

On the other hand, if you can provide the full output, there is a chance 
that developers interested in btrfsck can help solving your problem.

BTW, it seems that you are also impatient about the reply speed in btrfs 
mail list.

IMHO, current btrfs mail list is much like a developer mail list.
Although there are talent sysadmins like Ducan or Marc here, most of the 
developers are hardly interested in a bug report without a reproducer or 
even btrfsck output.
Not to mention they are also busy fixing but or developing new features.

So just calm down and be patient for both btrfsck and developers.

Thanks,
Qu


>
> I did not try "btrfs check --repair".
>
> "Btrfs-zero-log" doesn't seem to apply here.
> Konsole output
> I could copy the data on another freshly formatted disk and reformat
> this one but I am wondering if btrfs is stable enough to be used on my
> professional laptop (where I cannot afford such downtime)or if I should
> go back to ext4.
>
> So the goal of this message is not only to see if I can repair this
> partition, but also to assess if btrfs corrupt partitions randomly and
> irreversibly. If the root cause resides in a non-essential feature
> (conversion or balancing for example), I would happily continue to use
> it without this feature.
>
> This is my first message on this mailing list. I've spent the last hours
> trying to solve this.
>
> More info:
>
> uname -a
> Linux viybel-pc 3.19.0-21-generic #21-Ubuntu SMP Sun Jun 14 18:31:11 UTC
> 2015 x86_64 x86_64 x86_64 GNU/Linux
>
> btrfs --version
> btrfs-progs v3.19.1
>
> btrfs fi show
> Label: none  uuid: 358f485d-690d-436d-ad35-3a1f47329ed7
>          Total devices 1 FS bytes used 107.75GiB
>          devid    1 size 111.79GiB used 111.79GiB path /dev/sda1
>
> Label: none  uuid: 21873ba7-438a-4fbf-a051-ace28bffd264
>          Total devices 1 FS bytes used 606.17GiB
>          devid    1 size 698.63GiB used 660.03GiB path /dev/sdb1
>
> btrfs fi df /_big
> Data, single: total=431.00GiB, used=419.49GiB
> System, single: total=32.00MiB, used=64.00KiB
> Metadata, single: total=229.00GiB, used=186.67GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> dmesg > dmesg.log (attached)
>
> Konsole outp
> Vianney
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
