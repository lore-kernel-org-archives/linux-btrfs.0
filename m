Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155AbcGHLTq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 07:19:46 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 65C67AC3F
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Jul 2016 11:19:44 +0000 (UTC)
Date: Fri, 8 Jul 2016 13:20:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <DSterba@suse.com>
Subject: Re: [PATCH 05/31] btrfs: tests, require fs_info for root
Message-ID: <20160708112003.GE13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
 <1466806524-27508-6-git-send-email-jeffm@suse.com>
 <dda2dc27-7422-c261-a59b-0b271ca94195@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <dda2dc27-7422-c261-a59b-0b271ca94195@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 07, 2016 at 09:32:37PM -0400, Jeff Mahoney wrote:
> On 6/24/16 6:14 PM, jeffm@suse.com wrote:
> > From: Jeff Mahoney <jeffm@suse.com>
> > 
> > This allows the upcoming patchset to push nodesize and sectorsize into
> > fs_info.
> > 
> > Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> > ---
> >  fs/btrfs/ctree.h                       |  1 +
> >  fs/btrfs/disk-io.c                     | 15 +++++++----
> >  fs/btrfs/disk-io.h                     |  3 ++-
> >  fs/btrfs/tests/btrfs-tests.c           | 20 ++++++++++++---
> >  fs/btrfs/tests/btrfs-tests.h           |  1 +
> >  fs/btrfs/tests/extent-buffer-tests.c   | 23 +++++++++++------
> >  fs/btrfs/tests/free-space-tests.c      | 14 +++++++----
> >  fs/btrfs/tests/free-space-tree-tests.c | 18 +++++++------
> >  fs/btrfs/tests/inode-tests.c           | 46 ++++++++++++++++++----------------
> >  fs/btrfs/tests/qgroup-tests.c          | 23 +++++++++--------
> >  10 files changed, 103 insertions(+), 61 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 100d2ea..4781057 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -117,6 +117,7 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
> >  #define BTRFS_FS_STATE_REMOUNTING	1
> >  #define BTRFS_FS_STATE_TRANS_ABORTED	2
> >  #define BTRFS_FS_STATE_DEV_REPLACING	3
> > +#define BTRFS_FS_STATE_DUMMY_FS_INFO	4
> >  
> >  #define BTRFS_BACKREF_REV_MAX		256
> >  #define BTRFS_BACKREF_REV_SHIFT		56
> > diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> > index 8f27127..418163d 100644
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -1233,6 +1233,7 @@ static void __setup_root(u32 nodesize, u32 sectorsize, u32 stripesize,
> >  			 struct btrfs_root *root, struct btrfs_fs_info *fs_info,
> >  			 u64 objectid)
> >  {
> > +	bool dummy = test_bit(BTRFS_FS_STATE_DUMMY_FS_INFO, &fs_info->fs_state);
> >  	root->node = NULL;
> >  	root->commit_root = NULL;
> >  	root->sectorsize = sectorsize;
> > @@ -1287,14 +1288,14 @@ static void __setup_root(u32 nodesize, u32 sectorsize, u32 stripesize,
> >  	root->log_transid = 0;
> >  	root->log_transid_committed = -1;
> >  	root->last_log_commit = 0;
> > -	if (fs_info)
> > +	if (dummy)
> 
> This should be:
> if (!dummy)
> 
> >  		extent_io_tree_init(&root->dirty_log_pages,
> >  				     fs_info->btree_inode->i_mapping);
> >  
> >  	memset(&root->root_key, 0, sizeof(root->root_key));
> >  	memset(&root->root_item, 0, sizeof(root->root_item));
> >  	memset(&root->defrag_progress, 0, sizeof(root->defrag_progress));
> > -	if (fs_info)
> > +	if (dummy)
> 
> So should this.

Updated in the patch.
