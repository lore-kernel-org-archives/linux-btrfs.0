Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60788 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933376AbcHNLQS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Aug 2016 07:16:18 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bYjts-0006RB-Aq
	for linux-btrfs@vger.kernel.org; Sun, 14 Aug 2016 03:07:40 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Likelihood of read error, recover device failure raid10
Date: Sun, 14 Aug 2016 01:07:33 +0000 (UTC)
Message-ID: <pan$3f308$3d89ddaa$dd23cf7$c705e7d7@cox.net>
References: <2336793.AMaAIAxWk4@discus>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wolfgang Mader posted on Sat, 13 Aug 2016 17:39:18 +0200 as excerpted:

> Hi,
> 
> I have two questions
> 
> 1) Layout of raid10 in btrfs btrfs pools all devices and than stripes
> and mirrors across this pool. Is it therefore correct, that a raid10
> layout consisting of 4 devices a,b,c,d is _not_
> 
>               raid0
>        |---------------|
> ------------      ------------
> |a|      |b|      |c|      |d|
>    raid1             raid1
> 
> Rather, there is no clear distinction of device level between two
> devices which form a raid1 set which are than paired by raid0, but
> simply, each bit is mirrored across two different devices. Is this
> correct?

Not correct in detail, but you have the general idea, yes.

The key thing to remember with btrfs in this context is that it's chunk-
based raid, /not/ device-based (or for that matter, bit- or byte-based) 
raid.  If the "each bit" in your last sentence above is substituted with 
"each chunk", where chunks are nominally (that is, they can vary from 
this) 1 GiB for data, 256 MiB for metadata, thus billions of times your 
"each bit" size, /then/ your description gets much more accurate (tho 
technically each strip is 64 KiB, I believe, with each strip mirrored at 
the raid1 level and then combined with other strips at the raid0 level to 
make a stripe, and multiple stripes then composing a chunk, with the 
device assignment variable at the chunk level).

At the chunk level, mirroring and striping is as you indicate.  Chunks 
are allocated on-demand from the available unallocated space such that 
the two mirrors of each strip can vary from one chunk to the next, which 
if I'm not mistaken, was the point you were making.

The effect is that btrfs raid10 doesn't have the ability to tolerate loss 
of two devices as long as the two devices are from separate raid1s 
underneath the raid0, that per-device raid10 has, because once there are 
a decent amount of chunks allocated, there's no distinctive raid1s at the 
btrfs device level, such that loss of any two devices is virtually 
guaranteed to be the loss of both mirrors of some strip of a chunk for 
/some/ number of chunks.


Of course it remains possible, indeed quite viably so, to create a hybrid 
raid, btrfs raid1 on top of md- or dm-raid0, for instance.  Altho that's 
technically raid01 instead of raid10, btrfs raid1 has some distinctive 
advantages that make it the preferred top layer in this sort of hybrid, 
as opposed to btrfs raid0 on top of md/dm-raid1, the conventionally 
preferred raid10 arrangement.

Namely, btrfs raid1 has the file integrity feature in the form of 
checksumming and checksum validation failure detection, and for raid1, 
checksum validation failure repair from the mirror copy, assuming of 
course that it passes checksum validation.  Few raid schemes have that, 
and it's enough of a feature leap that it justifies making the top layer 
btrfs raid1, as opposed to btrfs raid0, which would lack that automatic 
error repair feature, tho it could still detect the error based on the 
checksums, but even manual repair would be difficult as you'd have to 
somehow figure out which was the bad copy that it read from and then 
check the other copy and see if it was good before overwriting the bad 
copy.

> 2) Recover raid10 from a failed disk Raid10 inherits its redundancy from
> the raid1 scheme. If I build a raid10 from n devices, each bit is
> mirrored across two devices. Therefore, in order to restore a raid10
> from a single failed device, I need to read the amount of data worth
> this device from the remaining n-1 devices. In case, the amount of data
> on the failed disk is in the order of the number of bits for which I can
> expect an unrecoverable read error from a device, I will most likely not
> be able to recover from the disk failure. Is this conclusion correct, or
> am I am missing something here.

Again, not each bit, but (each strip of) each chunk (with the strips 
being 64 KiB IIRC).

But your conclusion is generally correct, since the problem would be 
quite likely to be detected by checksum verification failure, but if it 
were to occur in the raid1 pair that was degraded, there would be no 
second copy to fall back on to repair with.

Of course that's a 50% chance, with the other possibility being that the 
IO read error occurs in the undegraded raid1, and thus can be corrected 
normally.

Which means given a random read error, if you try the recovery enough 
times you should eventually succeed, because eventually any occurring 
read error will happen on the still undegraded raid1 area.

Tho of course if the read error isn't random and it happens repeatedly in 
the degraded area, you're screwed, for whatever file or metadata covering 
multiple files it was in, at least.  You should still be able to recover 
the rest of the filesystem, however.

Which all goes to demonstrate once again that raid != backup, and there's 
no substitute for the latter, to whatever level the value of the data in 
question justifies.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

