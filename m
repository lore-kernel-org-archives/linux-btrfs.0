Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:48091 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaERQJj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 May 2014 12:09:39 -0400
From: Russell Coker <russell@coker.com.au>
To: Martin <m_btrfs@ml1.co.uk>
Reply-To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ditto blocks on ZFS
Date: Mon, 19 May 2014 02:09:34 +1000
Message-ID: <10946613.XrCytCZfuu@xev>
In-Reply-To: <ll7lvd$ulk$1@ger.gmane.org>
References: <2308735.51F3c4eZQ7@xev> <ll7lvd$ulk$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 17 May 2014 13:50:52 Martin wrote:
> On 16/05/14 04:07, Russell Coker wrote:
> > https://blogs.oracle.com/bill/entry/ditto_blocks_the_amazing_tape
> > 
> > Probably most of you already know about this, but for those of you who
> > haven't the above describes ZFS "ditto blocks" which is a good feature we
> > need on BTRFS.  The briefest summary is that on top of the RAID
> > redundancy there...
> [... are additional copies of metadata ...]
> 
> 
> Is that idea not already implemented in effect in btrfs with the way
> that the superblocks are replicated multiple times, ever more times, for
> ever more huge storage devices?

No.  If the metadata for the root directory is corrupted then everything is 
lost even if the superblock is OK.  At every level in the directory tree a 
corruption will lose all levels below that, a corruption for /home would be 
very significant as would a corruption of /home/importantuser/major-project.

> The one exception is for SSDs whereby there is the excuse that you
> cannot know whether your data is usefully replicated across different
> erase blocks on a single device, and SSDs are not 'that big' anyhow.

I am not convinced by that argument.  While you can't know that it's usefully 
replicated you also can't say for sure that replication will never save you.  
There will surely be some random factors involved.  If dup on ssd will save 
you from 50% of corruption problems is it worth doing?  What if it's 80% or 
20%?

I have BTRFS running as the root filesystem on Intel SSDs on four machines 
(one of which is a file server with a pair of large disks in a BTRFS RAID-1).  
On all of those systems I have dup for metadata, it doesn't take up any amount 
of space I need for something else and it might save me.

> So... Your idea of replicating metadata multiple times in proportion to
> assumed 'importance' or 'extent of impact if lost' is an interesting
> approach. However, is that appropriate and useful considering the real
> world failure mechanisms that are to be guarded against?

Firstly it's not my idea, it's the idea of the ZFS developers.  Secondly I 
started reading about this after doing some experiments with a failing SATA 
disk.  In spite of having ~14,000 read errors (which sounds like a lot but is 
a small fraction of a 2TB disk) the vast majority of the data was readable, 
largely due to ~2000 errors corrected by dup metadata.

> Do you see or measure any real advantage?

Imagine that you have a RAID-1 array where both disks get ~14,000 read errors.  
This could happen due to a design defect common to drives of a particular 
model or some shared environmental problem.  Most errors would be corrected by 
RAID-1 but there would be a risk of some data being lost due to both copies 
being corrupt.  Another possibility is that one disk could entirely die 
(although total disk death seems rare nowadays) and the other could have 
corruption.  If metadata was duplicated in addition to being on both disks 
then the probability of data loss would be reduced.

Another issue is the case where all drive slots are filled with active drives 
(a very common configuration).  To replace a disk you have to physically 
remove the old disk before adding the new one.  If the array is a RAID-1 or 
RAID-5 then ANY error during reconstruction loses data.  Using dup for 
metadata on top of the RAID protections (IE the ZFS ditto idea) means that 
case doesn't lose you data.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

