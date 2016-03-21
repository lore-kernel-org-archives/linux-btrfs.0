Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sender163-mail.zoho.com ([74.201.84.163]:24325 "EHLO
	sender163-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbcCUEdx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 00:33:53 -0400
From: "James Johnston" <johnstonj.public@codenest.com>
To: "'Chris Murphy'" <lists@colorremedies.com>
Cc: "'Btrfs BTRFS'" <linux-btrfs@vger.kernel.org>
References: <000c01d18300$93b757c0$bb260740$@codenest.com> <CAJCQCtQWC8g5v61aAKeH4Zwer6xF=etiEfu5SAfnO-v0zcK+Jg@mail.gmail.com>
In-Reply-To: <CAJCQCtQWC8g5v61aAKeH4Zwer6xF=etiEfu5SAfnO-v0zcK+Jg@mail.gmail.com>
Subject: RE: kernel BUG at fs/btrfs/volumes.c:5519 when hot-removing device in RAID-1
Date: Mon, 21 Mar 2016 04:33:47 -0000
Message-ID: <000d01d1832a$dd3fb520$97bf1f60$@codenest.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Thanks for the quick response.

> There are a number of things missing from multiple device support,
> including any concept of a device becoming faulty (i.e. persistent
> failures rather than transient which Btrfs seems to handle OK for the
> most part), and then also getting it to go degraded automatically, and
> finally hot spare support. There are patches that could use testing.

I also noticed that it just seemed to be treated as a bunch of transient
errors, and assumed it to just be a limitation of btrfs.

Never-the-less, I should expect it to gracefully continue to handle the
"transient" I/O errors (even though they are really permanent), and not
explode on an I/O error at random.  Or am I misunderstanding this?

The hot spare feature is a "nice-to-have" but not one I'm currently
looking to use; I just want a two-drive RAID-1 that works.  If it gets
stuck on I/O errors and doesn't take the drive offline ("automatic
degrading"), that's also ok for my use as long as (1) data is not
corrupted (even if the drive temporarily came back online), (2) the
kernel doesn't oops or panic like it does now.  I would notice the I/O
errors soon enough and be able to cleanly power down the system and
replace a drive.

> 
> https://www.spinics.net/lists/linux-btrfs/msg52084.html
> http://www.spinics.net/lists/linux-btrfs/msg53048.html

So I have a question: should I expect these patches to fix the issue -
do they fix the root cause of this crash?  Or will they just mask it,
most of the time, by just taking down the failing device sooner rather
than later?

To put another way: skimming through the patches, it sounds like if
there is a write error, the drive is marked as failed and the array
is degraded.  Now, the log I sent in my last e-mail shows btrfs
logging several write errors, before the kernel crashed.  That is,
most I/O errors did not crash the kernel.  Will this patch merely
mask the issue, say, 95% (or more) of the time, with 5% of the time
being the one I/O that crashes the kernel (with potential data
loss?)? - i.e. where you are unlucky and the first I/O is the one that
makes the kernel die, before the patches can degrade the array? 

In order to try them, I guess I'll have to build a kernel; I'm not
currently set up to do that - unless someone has one prebuilt?

> I think when testing, it's simpler to not use any additional device
> mapper layers. Yes those should work, but it has to work with Btrfs on
> the raw partition or device first. Then add additional layers one at a
> time as the use case requires, testing in between the additions.
> Otherwise it makes it harder to isolate.

You are right, I was hoping there would be an easy answer before I went
to the trouble of doing that.

I went on ahead and eliminated LVM/dm-crypt.  The problem still
reproduces.  My procedure was to add a new, temporary disk, use dd from
a bootable DVD to clone the LVM/dm-crypt volumes to regular GPT
partitions on the new disk, destroy the LVM volume group, repartition
the original drives, dd the data back, and most importantly, destroy
the temporary drive before mounting to avoid having the duplicate
btrfs partitions around.

In other words, the system has the same bit-for-bit partitions that were
on LVM/dm-crypt, but now just on simple GPT partitions with no
LVM/dmcrypt.  I'm still getting the same crash when hot-removing, on the
same line of code in volume.c.

I've also attempted to reproduce the issue on a brand-new virtual machine
with LVM/dm-crypt, but I've been unsuccessful in doing so.  The original
VM wasn't set up this way originally; it was originally not LVM and I
transitioned it to that via a series of btrfs device adds/removes/balance/
conversions, and repartitioning with LVM/dm-crypt along the way.  I also
tried to reproduce that sequence in the second VM, but again - I'm
forgetting some step along the way or some critical detail because I
haven't had much luck outside the original VM.  IIRC nothing particularly
anomalous happened during this conversion (e.g. scary errors/warnings).

There's something about the file system on the original VM that is making
the btrfs driver die very badly, but I don't know what.  btrfs scrub says
there are no errors...

Best regards,

James Johnston


