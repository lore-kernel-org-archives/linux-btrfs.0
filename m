Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab3APMnD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jan 2013 07:43:03 -0500
Date: Wed, 16 Jan 2013 13:43:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: dsterba@suse.cz, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 05/11] Btrfs: protect fs_info->alloc_start
Message-ID: <20130116124300.GR20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <50EEB880.4060308@cn.fujitsu.com>
 <20130110171040.GG20089@twin.jikos.cz>
 <50F3BC2B.2010407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50F3BC2B.2010407@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 14, 2013 at 04:04:59PM +0800, Miao Xie wrote:
> On Thu, 10 Jan 2013 18:10:40 +0100, David Sterba wrote:
> > On Thu, Jan 10, 2013 at 08:48:00PM +0800, Miao Xie wrote:
> >> fs_info->alloc_start was not protected strictly, it might be changed while
> >> we were accessing it. This patch fixes this problem by using two locks to
> >> protect it (fs_info->chunk_mutex and sb->s_umount). On the read side, we
> >> just need get one of these two locks, and on the write side, we must lock
> >> all of them.
> > 
> > Can you please describe how this can theoretically cause any problems?
> > 
> > Out of curiosity I've been running this command on a 60G ssd disk for a while
> > 
> > for i in `seq 1 10000|shuf`;do
> > 	mount -o remount,alloc_start=$(($i*1024*1024)) /mnt/sdc;done
> > 	#sleep 0 / 1 / 5
> > done
> > 
> > together with one of my favourite stresstests (heavy writes, subvolume
> > activity).
> > 
> > There are two direct users of fs_info->alloc_start:
> > 
> > * statfs via btrfs_calc_avail_data_space
> > * find_free_dev_extent
> > 
> > 960         search_start = max(root->fs_info->alloc_start, 1024ull * 1024);
> > 
> > as remount calls sync, there is a very tiny window where an allocation could
> > get the old value of alloc_start just between sync and do_remount. Theoretical
> > and without any visible effect.
> 
> ->alloc_start is a 64bits variant, on the 32bits machine, we have to load it
> by two instructions.
> 
> Assuming -> alloc_start is 0x00010000 at the beginning, then we remount and
> set ->alloc_start to 0x00000100
> 	Task0 			Task1
> 				load low 32 bits
> 	set high 32 bits
> 				load high 32 bits
> 	set low 32 bits
> 
> Task1 will get 0.

That's an insufficient description of how a race could actually happen,
it's only a high-level scheme how a 64bit value can get mixed up with
32bit access.

How exactly does it cause problems in btrfs code?

IMO the bug is not there due to various reasons like instruction
scheduling and cache effect that may hide the actual split of the 32bit
value.

* the value set on one cpu is not immediatelly visible on another cpu
* the full 64bit value of alloc_start lives inside a single cacheline
  and will be updated as a whole in context of btrfs -- there's only one
  place where it's set so multiple places that would store the value and
  fight over the cacheline exclusivity are out of question;
  the storing cpu will flush the pending writes at some point in time
  so they're visible by other cpus, until then the load side reads a
  consistent value -- in almost all cases, and this gets even more wild
  and counts on exact timing of a memory barriers triggered from other
  cpu and cacheline ownership, so the store finishes only one half,
  barrier, load finds half new and half old value, store does the other
  half
* this needs to happen within 4-5 instructions for an operation that
  involves a IO sync -- makes it much harder to provoke right timing

Your example with 0x00010000 and 0x00000100 uses only 32bit values, so
it cannot be applied here. Also, alloc_start is always compared with the
hardcoded 1M limit so it cannot go below to 0.

The point is not the one extra mutex lock, but that you're attempting to
fix a bug highly improbable if possible at all without a proper
description and analysis. I don't want to spend the time on this and do
the work for instead of you next time, please try harder to convince us.

david
