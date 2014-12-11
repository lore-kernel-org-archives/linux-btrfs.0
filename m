Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:42678 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967523AbaLKXBR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 18:01:17 -0500
Received: by mail-yk0-f176.google.com with SMTP id q200so2630953ykb.35
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 15:01:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54896F65.20708@pobox.com>
References: <CAA7pwKNhYxeQjfTyd4WQrsQ7MuapKgRfjwF3kHY+VWDnVk+cTA@mail.gmail.com>
	<54896F65.20708@pobox.com>
Date: Fri, 12 Dec 2014 00:01:15 +0100
Message-ID: <CAA7pwKNTS770TZ9ENxMMQA9-50tfrr2aRb5BWJRFheVy9NOWtQ@mail.gmail.com>
Subject: Re: ENOSPC after conversion [Was: Fixing Btrfs Filesystem Full
 Problems typo?]
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: Robert White <rwhite@pobox.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11 December 2014 at 11:18, Robert White <rwhite@pobox.com> wrote:
> So far I don't see a "bug".

Fair enough, lets call it a huge problem with btrfs convert. I think
it warrants a note in the wiki.


> On 12/11/2014 12:18 AM, Patrik Lundquist wrote:
>>
>> Running defrag several more times and balance again doesn't help.
>
> That sounds correct as defrag defrags files, it does not reallocate extents.

>From https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3

"A notable caveat is that a balance can fail with "ENOSPC" if the
defragment is skipped. This is usually due to large extents on ext
being larger than the maximum size btrfs normally operates with (1
GB). A defrag of all large files will avoid this:"

I interpreted it as breaking down large extents and reallocating them,
thus avoiding my current situation.


> There's a good chance that if you balanced again and again the number of no
> space errors might decrease. With only one 2-ish gig empty slot sliding
> around like one of those puzzles where you have to sort the numbers from 1
> to 15 by sliding them around in the 4x4=16 element grid.

I was never fond of those puzzles.


> The first step is admitting that you _don't_ have a problem.

I've got 99 problems and balance is one of them (the other are block
groups). :-)

Of course the filesystem is in a problematic state after the
conversion, even if it's not a bug. ~1.5TB of free space and yet out
of space and it can't be fixed with a balance. It might not be wrong
per se but it's very problematic from a user perspective.

Anyway, this thread has turned up lots of good information.


> You are _not_ out of space in which to create files. (or so I presume, you
> still haven't posted the output of /bin/df or btrfs filesystem df).

I'm not; creating new files works.

$ df
Filesystem      1K-blocks       Used  Available Use% Mounted on
/dev/sdc1      2930265088 1402223656 1526389096  48% /mnt

$ btrfs fi df /mnt
Data, single: total=1.41TiB, used=1.30TiB
System, DUP: total=32.00MiB, used=124.00KiB
Metadata, DUP: total=2.50GiB, used=1.49GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


> Your next step is to either add storage in accordance with your plan of
> adding four more volumes to make a RAID (as expressed elsewhere), or make a
> clean filesystem and copy your files over.

I've already decided to start over with a clean filesystem to get rid
of the ext4 legacy. I'm only curious about how to solve the balance
problem, and now I know how.
