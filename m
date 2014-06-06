Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:41987 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaFFTGx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jun 2014 15:06:53 -0400
Received: by mail-ob0-f172.google.com with SMTP id uy5so1352236obc.31
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jun 2014 12:06:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$95296$7c52a8f8$5f80de1d$977b2dd9@cox.net>
References: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com>
	<pan$765af$b28af9a8$903ce16b$940baf34@cox.net>
	<CAEezp7sxyEP2Bmp9vWB843pb7VQvWyHmG+1uPU_Dk--hhu2LAw@mail.gmail.com>
	<CAGqmi77dGTaZOT8u=XDMnYnDxhNoWhrhjZtHpD35OB28VvY8YQ@mail.gmail.com>
	<pan$95296$7c52a8f8$5f80de1d$977b2dd9@cox.net>
Date: Fri, 6 Jun 2014 14:06:53 -0500
Message-ID: <CAKcLGm8fFX-Hqz0iEgk2qtsUXrSNW=XsKMHiVWZvV4AoJCBGVQ@mail.gmail.com>
Subject: Re: Very slow filesystem
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 5, 2014 at 2:53 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Timofey Titovets posted on Thu, 05 Jun 2014 19:13:08 +0300 as excerpted:
>
>> 2014-06-05 18:52 GMT+03:00 Igor M <igork20@gmail.com>:
>>> One more question. Is there any other way to find out file
>>> fragmentation ?
>>> I just copied 35Gb file on new btrfs filesystem (compressed) and
>>> filefrag reports 282275 extents found. This can't be right ?
>
>> hes, because filefrag show compressed block (128kbite) as one extent.
>
> Correct.  Which is why my original answer had this:
>
>>>> While compression changes things up a bit (filefrag doesn't know
>>>> how to deal with it yet and its report isn't reliable),
>
> I skipped over the "why" at the time as it wasn't necessary for the then-
> current discussion, but indeed, the reason is because filefrag counts
> each 128 KiB block as a separate fragment because it doesn't understand
> them, and as a result, it's not (currently) usable for btrfs-compressed
> files.
>

In the context of a compressed database file, the 128 KiB compressed
block size has more severe consequences.

First, even if the 128 KiB blocks are contiguous, each 128 KiB block
has it's own metadata entry.  So you already have much higher metadata
utilization than without compression.  And the metadata can also get
fragmented.

Every time you update your database, btrfs is going to update
whichever 128 KiB blocks need to be modified.

Even for a tiny modification, the new compressed block may be slightly
more or slightly less than 128 KiB.

If you have a 1-2 GB database that is being updated with any
frequency, you can see how you will quickly end up with lots of
metadata fragmentation as well as inefficient data block utilization.
I think this will be the case even if you switch to NOCOW due to the
compression.

On a very fundamental level, file system compression and large
databases are two use cases that are difficult to reconcile.
