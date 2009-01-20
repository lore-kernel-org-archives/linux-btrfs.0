From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Discussion] Extent Block Group allocations
Date: Tue, 20 Jan 2009 18:07:21 -0500
Message-ID: <1232492841.16352.2.camel@think.oraclecorp.com>
References: <52232.75.80.183.92.1232484873.squirrel@www.whisperpc.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: ashford@whisperpc.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <52232.75.80.183.92.1232484873.squirrel@www.whisperpc.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-20 at 12:54 -0800, ashford@whisperpc.com wrote:
> Hi all,
> 
> I searched the archives, and didn't find any answers to my questions, so I
> think it's time to ask.
> 
> From:  http://btrfs.wiki.kernel.org/index.php/Btrfs_design#Extent_Block_Groups
> 
>         Block groups have a flag that indicate if they are preferred for data
>         or metadata allocations, and at mkfs time the disk is broken up into
>         alternating metadata (33% of the disk) and data groups (66% of the
>         disk). As the disk fills, a group's preference may change back and
>         forth, but Btrfs always tries to avoid intermixing data and metadata
>         extents in the same group. This substantially improves fsck throughput,
>         and reduces seeks during writeback while the FS is mounted. It does
>         slightly increase the seeks while reading.
> 

I missed this when I last updated the design doc.  It is much more
flexible now.  Chunks of storage are allocated from each device for use
as data or metadata as required.

> Based on this, it appears that there is a semi-fixed allocation of 33% of the
> disk to metadata, but that this allocation can change dynamically as the disk
> fills.  It would appear that if the metadata approaches/exceeds its
> allocation, a data group will be reallocated to it, and the same with the data
> (an extent group would be reallocated).
> 
> At the present, there is only one logical device per file-system (single,
> RAID-0, RAID-1 or RAID-10 - each is one logical device).  Based on the
> documentation, there appears to be an intent to support RAID-6 (and optionally
> RAID-5 - I believe this would be good) as logical devices.
> 

There is one logical address space per FS right now.  Each device in the
FS can contribute to the logical address space.

> >From what I see in the Multiple Device Support page
> (http://btrfs.wiki.kernel.org/index.php/Multiple_Device_Support), it appears
> that the intent in the future is to allow a BTRFS file-system to reside on
> multiple logical devices.  This is the starting point for my questions.
> 
> In an installation where a large number of physical devices are available for
> use (something like a Sun Thumper - 48 total disks, or a server connected to a
> SAN), the optimum configuration might be to dedicate certain logical devices
> (small/fast disks in RAID-1) to metadata, and other devices (large/slow disks
> in RAID-5 or RAID-6) to data.  To perform this, the metadata allocation
> percentage would need to be tunable (0% for data-only and 100% for
> metadata-only), and it would have to be able to be locked, so that the block
> group reallocation between metadata and data would be disabled (another option
> might be to allow metadata to reallocate data block groups, but not the other
> way around).
> 

Yes, we definitely want to be able to tie metadata or data to specific
drives.  The disk format has what it needs for this, but it hasn't been
coded up yet.

> I believe that a configuration like this would be more flexible than having
> the metadata block groups interleaved with the data block groups.  I also
> believe that this should be able to provide better overall response and
> throughput on a large multi-user server.
> 
> Is something like this intended to be possible?

Definitely ;)  Thanks for these comments.

-chris


