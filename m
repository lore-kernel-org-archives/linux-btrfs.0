Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1.pop2.wanet.net ([65.244.248.2]:34751 "EHLO
	serv004.pop2.wanet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752620AbaLGS2R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 13:28:17 -0500
Message-ID: <88937b9f24bc72160d80977c9edefba2.squirrel@webmail.wanet.net>
In-Reply-To: <44320137.fRRuR6EFMP@merkaba>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
    <44320137.fRRuR6EFMP@merkaba>
Date: Sun, 7 Dec 2014 10:20:27 -0800
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
From: ashford@whisperpc.com
To: "Martin Steigerwald" <Martin@lichtvoll.de>
Cc: "Shriramana Sharma" <samjnaa@gmail.com>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin,

> I read that the actual
> what is free is unknown. And there are several reasons for that:
>
> 1) On a compressed filesystem you cannot know, but only estimate the
> compression ratio for future data.

It is NOT the job of BTRFS, or ANY file-system, to try to prodict the
future.  The future is unknown.  Don't try to account for it.  When asked
for the status (i.e. 'df'), it should return the current status.

> 2) On a compressed filesystem you can choose to have parts of it
> uncompressed by file / directory attributes, I think. BTRFS can't
> know how much of the
> future data you are going to store compressed or uncompressed.

Same as above.

If the user sees 18GB free space and has 20GB of data to write, it is up
to them to determine whether or not compression will allow it to fit.

> 3) From what I gathered it is planned to allow different raid /
> redundancy levels for different subvolumes. BTRFS can´t know
> beforehand where applications request to save future data, i.e.
> in which subvolume.

Same as above.

If a user will be requesting to use a specific subvolume, it is up to them
to verify that adequate free space exists there, or handle the exception.

> 4) Even on a convential filesystem the free space is an estimate,
> cause it can not predict the activity of other processes writing
> to the filesystem. You may have 10 GiB free at some point, but if
> another process is currently writing another 5 GiB at the time
> your process is writing it will continue to have less and less
> than the estimated 10 GiB free and if it wanted to write 10 GiB
> it will not be able to.

Same as above.

This  is normal for multi-user systems.  It happens.  There's no way
around it, and other file-systems don't try.

> What might be possible but still has the limitation of the fourth
> point above, would be a query: How much free space do you have
> *right* know, on this directory path, if I write with standard
> settings.

That's what the 'df' command is supposed to return, and what it DOES
return on other file-systems, including file-systems that support
compression.

> But the only guarantee you can ever get is to pre-allocate your files
> with fallocate. When the fallocate file succeeded, you get a guarantee
> that you can write to the amount of allocated space into the file.
> Whether BTRFS can hold to that guarantee in any case? That depends on
> how bug free it is in that regard with its free space handling.

This is the same as in all other file-systems.

> And in case you do not need all the fallocated space, other processes
> may not be able to write data anymore even if there would be free
> space in your fallocated files.

Again, this is the same as in other file-systems.

> That written: Filling up a filesystem 100% will limit the performance
> of any filesystem that is non to me considerably and ask for further
> troubel. So better have at least 10-20% of the space free, except
> maybe for very large filesystem

Once again, this is the normal recommendation for most (all?)
file-systems.  As they fill, they get less efficient.  The impact is
minimal for a while, then the curve hits a knee and performance drops. 
Some file-systems have a setting to only allow the ROOT user to exceed a
specified percentage of file-system use.

Peter Ashford

