Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:39251 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbeEKHFf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 03:05:35 -0400
Received: by mail-pl0-f67.google.com with SMTP id c19-v6so2769966pls.6
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 00:05:35 -0700 (PDT)
Date: Fri, 11 May 2018 00:05:33 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2 10/12] Btrfs: get rid of btrfs_orphan_commit_root()
 and root->orphan_inodes
Message-ID: <20180511070533.GC30748@vader>
References: <cover.1525997057.git.osandov@fb.com>
 <ee9f8f4941b459e525a9e88a11ca5a58bf8a095d.1525997057.git.osandov@fb.com>
 <946921a1-900f-cd2b-8f83-ad6ee853675a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <946921a1-900f-cd2b-8f83-ad6ee853675a@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 11, 2018 at 10:01:34AM +0300, Nikolay Borisov wrote:
> 
> 
> On 11.05.2018 03:11, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > btrfs_orphan_commit_root() tries to delete an orphan item for a
> > subvolume in the tree root, but we don't actually insert that item in
> > the first place. See commit 0a0d4415e338 ("Btrfs: delete dead code in
> > btrfs_orphan_add()"). We can get rid of it.
> > 
> > root->orphan_inodes was used to as a refcount for root->orphan_block_rsv
> > and for btrfs_orphan_commit_root(), but both are gone now, so we can get
> > rid of it, as well.
> 
> So this really means that the logic for orphaned root item is completely
> defunct. Perhaps:
> 
> a) This commit should be expanded to delete all the logic surrounding
> orphaned roots: btrfs_find_orphan_roots, BTRFS_ROOT_ORPHAN_ITEM_INSERTED
> flag define and any accompanying logic that utilizes this flag (end of
> btrfs_orphan_cleanup, orphan root logic at the end of btrfs_get_fs_root
> as well)
> 
> b) Have those changes in a separate patch

The root orphan handling is still necessary for subvolume deletion.
