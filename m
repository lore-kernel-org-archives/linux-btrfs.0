Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-02v.sys.comcast.net ([69.252.207.34]:59752 "EHLO
	resqmta-ch2-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752474AbaLLXZY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 18:25:24 -0500
Message-ID: <548B795F.2050509@pobox.com>
Date: Fri, 12 Dec 2014 15:25:19 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RAID0 extent sizes?
References: <548B7220.1040403@pobox.com> <20141212225918.GG1442@carfax.org.uk>
In-Reply-To: <20141212225918.GG1442@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/12/2014 02:59 PM, Hugo Mills wrote:
> On Fri, Dec 12, 2014 at 02:54:24PM -0800, Robert White wrote:
>> I've seen it mentioned here that generally data extents are 1G and
>> metadata extents are 256M.
>>
>> Is that per-drive or per-stripe in the case of RAID0?
>>
>> That is, if I have data mode raid0 across N drives does the system
>> allocate one 1G extent on each drive making the full stripe
>> allocation N-gigs; or does it allocate 1/Nth(gig) on each drive
>> making the total new allocation 1G?
>>
>> Does the raid0 have any arity constraints (like how raid1 is always
>> arity-2)?
>
>     The 1 GiB (or 256 MiB for metadata) is the allocation unit. So for
> striped RAID levels (like 0, 10, 5, 6), the FS will allocate as many
> as it can across all the available devices, and stripe within those.
>
>     Now on to your question -- the stripes within the allocation unit
> are 64 KiB in size, so the first 64k goes on the first device, the
> next 64k on the second device, and so on.
>
>     The minimum stripe width (e.g. number of devices) is 2 for RAID-0,
> 4 for RAID-10, 2 for RAID-5 and 3 for RAID-6.
>
>     Hugo.
>

[So to check my understanding, and just sticking to RAID-0 data only].

So for RAID-0 data on 5 drives with ample space, the expected outcome of 
allocating more data space is 5GiB, one 1GiB allocated on each drive.

If one drive is too full (say it was smaller) and didn't have 1G of 
contiguous space available, the allocation would simply fail.

The net effect is to create an association of allocations, one on each 
available drive that had "enough space", each of which will contribute 
exactly 1GiB to the association. So every time the data space allocation 
expands its going to expand by N-GiB total on an N-drive data=raid0 system.

Since data and metadata are separate you can end up being "out of space" 
for big files but still be able to create files small enough to fit into 
the metadata with the inode.

Am I correct?
