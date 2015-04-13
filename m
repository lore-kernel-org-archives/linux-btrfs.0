Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33436 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbbDMLcX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 07:32:23 -0400
Received: by wgin8 with SMTP id n8so77218037wgi.0
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 04:32:22 -0700 (PDT)
Message-ID: <552BA941.1000409@sjeng.org>
Date: Mon, 13 Apr 2015 13:32:17 +0200
From: Gian-Carlo Pascutto <gcp@sjeng.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Subject: Re: Big disk space usage difference, even after defrag, on identical
 data
References: <55297D36.8090808@sjeng.org> <20150413040436.GB4711@hungrycats.org>
In-Reply-To: <20150413040436.GB4711@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 13-04-15 06:04, Zygo Blaxell wrote:

>> I would think that compression differences or things like
>> fragmentation or bookending for modified files shouldn't affect
>> this, because the first filesystem has been
>> defragmented/recompressed and didn't shrink.
>> 
>> So what can explain this? Where did the 66G go?
> 
> There are a few places:  the kernel may have decided your files are
> not compressible and disabled compression on them (some older kernels
> did this with great enthusiasm);

As stated in the previous mail, this is 3.19.1. Moreover, the data is
either uniformly compressible or not at all. Lastly, note that the
*exact same* mount options are being used on *the exact same kernel*
with *the exact same data*. Getting a different compressible decision
given the same inputs would point to bugs.

> your files might have preallocated space from the fallocate system
> call (which disables compression and allocates contiguous space, so
> defrag will not touch it).

So defrag -clzo or -czlib won't actually re-compress mostly-continuous
files? That's evil. I have no idea whether PostgreSQL allocates files
that way, though.

> 'filefrag -v' can tell you if this is happening to your files.

Not sure how to interpret that. Without "-v", I see most of the (DB)
data has 2-5 extents per Gigabyte. A few have 8192 extents per Gigabyte.

Comparing to the copy that takes 66G less, there every (compressible)
file has about 8192 extents per Gigabyte, and the others 5 or 6.

So you may be right that some DB files are "wedged" in a format that
btrfs can't compress. I forced the files to be rewritten (VACUUM FULL)
and that "fixed" the problem.

> In practice database files take about double the amount of space
> they appear to because of extent shingling.

This is what I called "bookending" in the original mail, I didn't know
the correct name, but I understand doing updates can result in N^2/2 or
thereabouts disk space usage, however:

> Defragmenting the files helps free space temporarily; however, space
> usage will quickly grow again until it returns to the steady state
> around 2x the file size.

As stated in the original mail, the filesystem was *freshly
defragmented* so that can't have been the cause.

> Until this is fixed, the most space-efficient approach seems to be to
> force compression (so the maximum extent is 128K instead of 1GB)

Would that fix the problem with fallocated() files?

-- 
GCP

