From: Spelic <spelic@shiftmail.org>
Subject: Re: BTRFS fsck tool
Date: Tue, 08 Mar 2011 03:17:48 +0100
Message-ID: <4D7591CC.6060301@shiftmail.org>
References: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Alexey A Nikitin <moonwalker@syrius.us>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/05/2011 12:59 AM, Alexey A Nikitin wrote:
> Hi, everybody
>
> I have BTRFS RAID0 setup with two disks. After some incident where I
> had to force shutdown machine this array won't mount anymore


Have you "reset" the machine or cut the power?
I don't really know btrfs, but in btrfs wiki there is written:

"Note that Btrfs does not yet have a fsck tool that can fix errors.
While Btrfs is stable on a stable machine, it is currently possible to
corrupt a filesystem irrecoverably if your machine crashes or loses
power on disks that don't handle flush requests correctly. This will be
fixed when the fsck tool is ready."

is this your scenario? If you leave the power and stop submitting writes
to the disks (like with a reset) the filesystem should be preserved, if
that sentence is true.
Did you cut the power while there was some process writing to it? If the
kernel was panicked it is probably safe to cut the power (because the
last write happened long time ago and disks had time to put that to the
platters)

Also what disks brand/model do you have? The sentence speaks about disks
which don't honour flush+FUA requests, I think. Enterprise disks should
honour that, consumer disks might not.

I am interesed in what happened because I am evaluating using btrfs for
very large backups (still losing those wouldn't be totally nice)

Thank you
