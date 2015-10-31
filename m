Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out.rrz.uni-koeln.de ([134.95.19.53]:46198 "EHLO
	smtp-out.rrz.uni-koeln.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbbJaRbt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 Oct 2015 13:31:49 -0400
Received: from smtp-auth.rrz.uni-koeln.de (smtp-auth.rrz.uni-koeln.de [134.95.19.93])
	by smtp-out.rrz.uni-koeln.de (8.14.4/8.14.4) with ESMTP id t9VHVlwF011864
	for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2015 18:31:48 +0100
Received: from linux-va3e.site ([176.0.113.210])
	(authenticated as user sking using CRAM-MD5 bits=0)
	by smtp-auth.uni-koeln.de (8.13.8/8.13.8) with ESMTP id t9VHVjZK007726
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Sat, 31 Oct 2015 18:31:47 +0100
Subject: Re: How to delete this snapshot, and how to succeed with balancing?
To: linux-btrfs@vger.kernel.org
References: <5634DD93.9050605@uni-koeln.de>
 <20151031164112.GF21103@carfax.org.uk>
From: Simon King <simon.king@uni-koeln.de>
Message-ID: <5634FB01.9030602@uni-koeln.de>
Date: Sat, 31 Oct 2015 18:31:45 +0100
MIME-Version: 1.0
In-Reply-To: <20151031164112.GF21103@carfax.org.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

Am 31.10.2015 um 17:41 schrieb Hugo Mills:
>> linux-va3e:~ # uname -a
>> Linux linux-va3e.site 3.16.7-29-desktop #1 SMP PREEMPT Fri Oct 23
>> 00:46:04 UTC 2015 (6be6a97) x86_64 x86_64 x86_64 GNU/Linux
> 
>    OK, that's a bit old -- you would probably do well to upgrade this
> anyway, regardless of the issues you're having. (I'd recommend 4.1 at
> the moment; there's a bug in 4.2 at the moment that affects
> balancing).

The latest version of openSuse is Tumbleweed, in a few days there will
be openSuse Leap; I am not sure what kernel it would give me.

>    I thought snapper could automatically delete old snapshots. (I've
> never used it, though, so I'm not sure). Worth looking at the snapper
> config to see if you can tell it how many to keep.

Probably it can, right.

>    You're telling it to move the first two chunks with less than 10%
> usage. If all the other chunks are full, and there are two chunks (one
> data, one metadata) with less than 10% usage, then they'll be moved to
> two new chunks... with less than 10% usage. So it's perfectly possible
> that the same command will show the same output.

Do I understand correctly: In that situation, balancing would have no
benefit, as two old chunks are moved to two new chunks? Then why are
they moved at all?

>    Incidentally, I would suggest using -dlimit=2 on its own, rather
> than both limit and usage.

I combined the two, since -dlimit on its own won't work:

linux-va3e:~ # btrfs balance start -dlimit=2 /
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail

>    "btrfs balance start /" should rebalance the whole filesystem --

linux-va3e:~ # btrfs balance start /
ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail
linux-va3e:~ # dmesg | tail
[ 9814.499013] BTRFS info (device sda2): found 8153 extents
[ 9815.254270] BTRFS info (device sda2): relocating block group
820062978048 flags 36
[ 9826.335122] BTRFS info (device sda2): found 8182 extents
[ 9826.858482] BTRFS info (device sda2): relocating block group
805064146944 flags 36
[ 9839.444820] BTRFS info (device sda2): found 8184 extents
[ 9839.822108] BTRFS info (device sda2): relocating block group
794595164160 flags 36
[ 9850.456697] BTRFS info (device sda2): found 8143 extents
[ 9850.778264] BTRFS info (device sda2): relocating block group
794460946432 flags 36
[ 9862.546336] BTRFS info (device sda2): found 8140 extents
[ 9862.890330] BTRFS info (device sda2): 12 enospc errors during balance


> not that you'd need to for purposes of dealing with space usage
> issues.

I know that "df" is different from "btrfs fi df". However, I see that df
shows significantly more free space after balancing. Also, when my
computer became unusable, the problem disappeared by balancing and
defragmentation (deleting the old snapshots was not enough).

Unfortunately, df also shows significantly less free space after
UNSUCCESSFUL balancing.

>    You may have more success using mkfs.btrfs --mixed when you create
> the FS, which puts data and metadata in the same chunks.

Can I do this in the running system? Or would that only be an option
during upgrade of openSuse Harlequin to Tumbleweed/Leap? Or even worse:
Only an option after nuking the old installation and installing a new
one from scratch?

Best regards,
Simon
