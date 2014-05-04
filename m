Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw6a-delilah.wadns.net ([196.220.39.210]:17274 "EHLO
	fw6a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753575AbaEDG5b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 May 2014 02:57:31 -0400
Message-ID: <5365E4CF.3050405@swiftspirit.co.za>
Date: Sun, 04 May 2014 08:57:19 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, linux-btrfs@vger.kernel.org
Subject: Re: Is metadata redundant over more than one drive with raid0 too?
References: <20140503232702.GC9061@merlins.org>
In-Reply-To: <20140503232702.GC9061@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Marc

Raid0 is not redundant in any way. See inline below.

On 2014/05/04 01:27 AM, Marc MERLIN wrote:
> So, I was thinking. In the past, I've done this:
> mkfs.btrfs -d raid0 -m raid1 -L btrfs_raid0 /dev/mapper/raid0d*
>
> My rationale at the time was that if I lose a drive, I'll still have
> full metadata for the entire filesystem and only missing files.
> If I have raid1 with 2 drives, I should end up with 4 copies of each
> file's metadata, right?
>
> But now I have 2 questions
> 1) btrfs has two copies of all metadata on even a single drive, correct?

Only when *specifically* using -m dup (which is the default on a single 
non-SSD device), will there be two copies of the metadata stored on a 
single device. This is not recommended when using multiple devices as it 
means one device failure will likely cause critical loss of metadata. 
When using -m raid1 (as is the case in your first example above and as 
is the default with multiple devices), two copies of the metadata are 
distributed across two devices (each of those devices with a copy has 
only a single copy).
> If so, and I have a -d raid0 -m raid0 filesystem, are both copies of the
> metadata on the same drive or is btrfs smart enough to spread out
> metadata copies so that they're not on the same drive?

This will mean there is only a single copy, albeit striped across the 
drives.
>
> 2) does btrfs lay out files on raid0 so that files aren't striped across
> more than one drive, so that if I lose a drive, I only lose whole files,
> but not little chunks of all my files, making my entire FS toast?

"raid0" currently allocates a single chunk on each device and then makes 
use of "RAID0-like" stripes across these chunks until a new chunk needs 
to be allocated. This is good for performance but not good for 
redundancy. A total failure of a single device will mean any large files 
will be lost and only files smaller than the default per-disk stripe 
width (I believe this used to be 4K and is now 16K - I could be wrong) 
stored only on the remaining disk will be available.

The scenario you mentioned at the beginning, "if I lose a drive, I'll 
still have full metadata for the entire filesystem and only missing 
files" is more applicable to using "-m raid1 -d single". Single is not 
geared towards performance and, though it doesn't guarantee a file is 
only on a single disk, the allocation does mean that the majority of all 
files smaller than a chunk will be stored on only one disk or the other 
- not both.
>
> Thanks,
> Marc

I hope the above is helpful.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

