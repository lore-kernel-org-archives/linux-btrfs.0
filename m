Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36371 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbcCWSeM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 14:34:12 -0400
Received: by mail-io0-f178.google.com with SMTP id 124so56312061iov.3
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 11:34:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56F2C991.9080500@gmail.com>
References: <56F1E7BE.1000004@gmail.com>
	<56F21510.6050707@cn.fujitsu.com>
	<56F21FC5.50209@gmail.com>
	<CAJCQCtR6xGMUPf3g6R8J21qv7MubideNLOVxC2X=f7bQa=CDCw@mail.gmail.com>
	<56F22F80.501@gmail.com>
	<CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
	<56F2C991.9080500@gmail.com>
Date: Wed, 23 Mar 2016 12:34:10 -0600
Message-ID: <CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
Subject: Re: RAID-1 refuses to balance large drive
From: Chris Murphy <lists@colorremedies.com>
To: Brad Templeton <bradtem@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 23, 2016 at 10:51 AM, Brad Templeton <bradtem@gmail.com> wrote:
> Thanks for assist.  To reiterate what I said in private:
>
> a) I am fairly sure I swapped drives by adding the 6TB drive and then
> removing the 2TB drive, which would not have made the 6TB think it was
> only 2TB.    The btrfs statistics commands have shown from the beginning
> the size of the device as 6TB, and that after the remove, it haad 4TB
> unallocated.

I agree this seems to be consistent with what's been reported.


>
> So I am looking for other options, or if people have commands I might
> execute to diagnose this (as it seems to be a flaw in balance) let me know.

What version of btrfs-progs is this? I'm vaguely curious what 'btrfs
check' reports (without --repair). Any version is OK but it's better
to use something fairly recent since the check code continues to
change a lot.

Another thing you could try is a newer kernel. Maybe there's a related
bug in 4.2.0. I think it may be more likely this is just an edge case
bug that's always been there, but it's valuable to know if recent
kernels exhibit the problem.

And before proceeding with a change in layout (converting to another
profile) I suggest taking an image of the metadata with btrfs-image,
it might come in handy for a developer.



>
> Some options remaining open to me:
>
> a) I could re-add the 2TB device, which is still there.  Then balance
> again, which hopefully would move a lot of stuff.   Then remove it again
> and hopefully the new stuff would distribute mostly to the large drive.
>  Then I could try balance again.

Yeah, to do this will require -f to wipe the signature info from that
drive when you add it. But I don't think this is a case of needing
more free space, I think it might be due to the odd number of drives
that are also fairly different in size.

But then what happens when you delete the 2TB drive after the balance?
Do you end up right back in this same situation?



>
> b) It was suggested I could (with a good backup) convert the drive to
> non-RAID1 to free up tons of space and then re-convert.  What's the
> precise procedure for that?  Perhaps I can do it with a limit to see how
> it works as an experiment?   Any way to specifically target the blocks
> that have their two copies on the 2 smaller drives for conversion?

btrfs balance -dconvert=single -mconvert=single -f   ## you have to
use -f to force reduction in redundancy
btrfs balance -dconvert=raid1 -mconvert=raid1

There is the devid= filter but I'm not sure of the consequences of
limiting the conversion to two of three devices, that's kinda
confusing and is sufficiently an edge case I wonder how many bugs
you're looking to find today? :-)



> c) Finally, I could take a full-full backup (my normal backups don't
> bother with cached stuff and certain other things that you can recover)
> and take the system down for a while to just wipe and restore the
> volumes.  That doesn't find the bug, however.

I'd have the full backup no matter what choice you make. At any time
for any reason any filesystem can face plant without warning.

But yes this should definitely work or else you've definitely found a
bug. Finding the bug in your current scenario is harder because the
history of this volume makes it really non-deterministic whereas if
you start with a 3 disk volume at mkfs time, and then you reproduce
this problem, for sure it's a bug. And fairly straightforward to
reproduce.

I still recommend a newer kernel and progs though, just because
there's no work being done on 4.2 anymore. I suggest 4.4.6 and 4.4.1
progs. And then if you reproduce it, it's not just a bug, it's a
current bug.



-- 
Chris Murphy
