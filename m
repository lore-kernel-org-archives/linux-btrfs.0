Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbcFIJOy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jun 2016 05:14:54 -0400
Date: Thu, 9 Jun 2016 11:15:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3] btrfs: fix check_shared for fiemap ioctl
Message-ID: <20160609091528.GG3905@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1465362783-27078-1-git-send-email-lufq.fnst@cn.fujitsu.com>
 <20160608155300.GX7633@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160608155300.GX7633@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 08, 2016 at 08:53:00AM -0700, Mark Fasheh wrote:
> On Wed, Jun 08, 2016 at 01:13:03PM +0800, Lu Fengqi wrote:
> > Only in the case of different root_id or different object_id, check_shared
> > identified extent as the shared. However, If a extent was referred by
> > different offset of same file, it should also be identified as shared.
> > In addition, check_shared's loop scale is at least  n^3, so if a extent
> > has too many references,  even causes soft hang up.
> > 
> > First, add all delayed_ref to the ref_tree and calculate the unqiue_refs,
> > if the unique_refs is greater than one, return BACKREF_FOUND_SHARED.
> > Then individually add the  on-disk reference(inline/keyed) to the ref_tree
> > and calculate the unique_refs of the ref_tree to check if the unique_refs
> > is greater than one.Because once there are two references to return
> > SHARED, so the time complexity is close to the constant.
> > 
> > Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> > Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> > ---
> > The caller is fiemap that called from an ioctl. Because it isn't on a
> > writeout path, so we temporarily use GFP_KERNEL in ref_root_alloc() and
> > ref_tree_add(). If we use ref_tree replace the existing backref structure
> > later, we can consider whether to use GFP_NOFS again.
> 
> NACK.
> 
> You don't need to be on a writeout path to deadlock, you simply need to be
> holding locks that the writeout path takes when you allocate. If the
> allocator does writeout to free memory then you deadlock. Fiemap is locking 
> down extents which may also get locked down when you allocate within those  
> locks. See my e-mail here for details,
> 
> http://www.spinics.net/lists/linux-btrfs/msg55789.html

There seems to be a code path that leads to a deadlock scenario, it
depends on the extent state of the file under fiemap. If there's a
delalloc range in the middle of the file, fiemap locks the whole range,
asks for memory that could trigger writeout, the delalloc range would
need to be written and requests locking the dealloc range again. There's
no direct locking but rather waiting for the extent LOCKED bit unset.

So, use GFP_NOFS now, though I still hope we can find a way to avoid
rb-tree and allocations alltogether.
