Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53016 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752437AbdIXN02 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Sep 2017 09:26:28 -0400
Date: Sun, 24 Sep 2017 15:24:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: bo.li.liu@oracle.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use self-explaining variable
Message-ID: <20170924132454.GS29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170913182521.31304-1-bo.li.liu@oracle.com>
 <20170922233618.20034-1-bo.li.liu@oracle.com>
 <4d9fe9dd-ccde-964c-ea88-bce4eeafc81a@gmx.com>
 <20170923004837.GD8109@lim.localdomain>
 <02a5af04-f1b3-cdef-d77d-55c0517c12ad@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <02a5af04-f1b3-cdef-d77d-55c0517c12ad@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 23, 2017 at 09:09:24AM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年09月23日 08:48, Liu Bo wrote:
> > On Sat, Sep 23, 2017 at 08:46:55AM +0800, Qu Wenruo wrote:
> >>
> >>
> >> On 2017年09月23日 07:36, Liu Bo wrote:
> >>> This uses a bool 'do_backup' to help understand this piece of code.
> >>>
> >>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> >>> ---
> >>> This is based on a patch "Btrfs: do not backup tree roots when fsync".
> >>>
> >>>    fs/btrfs/disk-io.c | 3 ++-
> >>>    1 file changed, 2 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> >>> index cdb7043..9811b9d 100644
> >>> --- a/fs/btrfs/disk-io.c
> >>> +++ b/fs/btrfs/disk-io.c
> >>> @@ -3691,6 +3691,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
> >>>    	int max_errors;
> >>>    	int total_errors = 0;
> >>>    	u64 flags;
> >>> +	bool do_backup = (max_mirrors == 0);
> >>
> >> Why not replacing @max_mirrors with @do_backup as parameter?
> > 
> > If I read the code correctly, max_mirrors is not just for deciding
> > backup.
> 
> That's strange.
> 
> write_all_supers() only uses @max_mirrors by passing it to 
> write_dev_supers() and wait_dev_supers().
> 
> Both of the write/wait_dev_supers() will replace @max_mirrors to 
> BTRFS_SUPER_MIRROR_MAX if it's zero.
> 
> Further more, all write_all_supers() callers just pass @max_mirrors as 
> bool (either 0 or 1).
> 
> So I don't see any point not replacing the parameter as bool.

Agreed, the idea was to replace the parameter by the bool.
