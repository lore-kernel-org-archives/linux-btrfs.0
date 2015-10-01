Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:50561 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701AbbJAMsR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Oct 2015 08:48:17 -0400
Received: from /spool/local
	by e28smtp06.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Thu, 1 Oct 2015 18:18:14 +0530
Received: from d28relay03.in.ibm.com (d28relay03.in.ibm.com [9.184.220.60])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 487F5E0059
	for <linux-btrfs@vger.kernel.org>; Thu,  1 Oct 2015 18:17:57 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay03.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t91CmAVT50790552
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Oct 2015 18:18:11 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t91Cm8In022276
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Oct 2015 18:18:09 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: fdmanana@gmail.com, "dsterba@suse.cz" <dsterba@suse.cz>,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        chandan@mykolab.com
Subject: Re: [PATCH] Btrfs: create_subvol: Commit the current transaction if stale root entry exists.
Date: Thu, 01 Oct 2015 18:18:06 +0530
Message-ID: <1902334.loiai0JUMI@localhost.localdomain>
In-Reply-To: <CAL3q7H5BA8=32dt2k553gtTa6usOOGkNZj5Z5QY27omnF4hpAg@mail.gmail.com>
References: <1443696595-20641-1-git-send-email-chandan@linux.vnet.ibm.com> <20151001115712.GA5885@twin.jikos.cz> <CAL3q7H5BA8=32dt2k553gtTa6usOOGkNZj5Z5QY27omnF4hpAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 01 Oct 2015 13:36:50 Filipe Manana wrote:
> On Thu, Oct 1, 2015 at 12:57 PM, David Sterba <dsterba@suse.cz> wrote:
> > On Thu, Oct 01, 2015 at 04:19:55PM +0530, Chandan Rajendra wrote:
> >> This occurs because,
> >> 
> >> Mount filesystem
> >> Create subvol with ID 257
> >> Unmount filesystem
> >> Mount filesystem
> >> Delete subvol with ID 257
> >> 
> >>   btrfs_drop_snapshot()
> >>   
> >>     Add root corresponding to subvol 257 into
> >>     btrfs_transaction->dropped_roots list
> >> 
> >> Create new subvol (i.e. create_subvol())
> >> 
> >>   257 is returned as the next free objectid
> > 
> > How is this possible? We do not intentionally reuse the subvol ids so
> > this means that the bug is in the id assignment code.

Sorry, I didn't know about the "Don't reuse subvol ids" heuristic.

> Very simple. Just look at inode-map.c's btrfs_find_free_objectid and
> btrfs_find_highest_objectid...
> As long as the deleted subvolume as the highest object id and before
> deleting it no one called  btrfs_find_free_objectid() against the root
> of tree roots.
> 
> If we do the initialization of a root's highest object id when we load
> the root, instead of when we need to get an object id, the problem
> shouldn't happen anymore.
>
Filipe, this approach looks good to me. I will write the V2 patch and send it
to the mailing list.

> >>   btrfs_read_fs_root_no_name()
> >>   
> >>     Finds the btrfs_root instance corresponding to the old subvol with ID
> >>     257
> >>     in btrfs_fs_info->fs_roots_radix.
> >>     Returns error since btrfs_root_item->refs has the value of 0.
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
chandan

