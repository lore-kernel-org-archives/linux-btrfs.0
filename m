From: Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 6/7] btrfs: Don't BUG_ON alloc_path errors in find_next_chunk
Date: Mon, 25 Jul 2011 14:37:51 -0700
Message-ID: <20110725213751.GF6911@wotan.suse.de>
References: <1311277713-7747-1-git-send-email-mfasheh@suse.com> <1311277713-7747-2-git-send-email-mfasheh@suse.com> <1311277713-7747-3-git-send-email-mfasheh@suse.com> <1311277713-7747-4-git-send-email-mfasheh@suse.com> <1311277713-7747-5-git-send-email-mfasheh@suse.com> <1311277713-7747-6-git-send-email-mfasheh@suse.com> <1311277713-7747-7-git-send-email-mfasheh@suse.com> <4E28CAA0.2070801@jp.fujitsu.com>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E28CAA0.2070801@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 22, 2011 at 09:56:00AM +0900, Tsutomu Itoh wrote:
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index aa91773..ff339b2 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -3277,6 +3277,9 @@ again:
> >  	}
> >  
> >  	ret = btrfs_alloc_chunk(trans, extent_root, flags);
> > +	if (ret < 0 && ret != -ENOSPC)
> > +		return ret;
> > +
> 
> You need mutex_unlock() before return.

Of course... Here's an updated patch (git tree has also been updated).

Thanks,
	--Mark

--
Mark Fasheh

From: Mark Fasheh <mfasheh@suse.com>

[PATCH] btrfs: Don't BUG_ON alloc_path errors in find_next_chunk

I also removed the BUG_ON from error return of find_next_chunk in
init_first_rw_device(). It turns out that the only caller of
init_first_rw_device() also BUGS on any nonzero return so no actual behavior
change has occurred here.

do_chunk_alloc() also needed an update since it calls btrfs_alloc_chunk()
which can now return -ENOMEM. Instead of setting space_info->full on any
error from btrfs_alloc_chunk() I catch and return every error value _except_
-ENOSPC. Thanks goes to Tsutomu Itoh for pointing that issue out.

Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/btrfs/extent-tree.c |    4 ++++
 fs/btrfs/volumes.c     |    6 ++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index aa91773..f6af423 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3277,6 +3277,9 @@ again:
 	}
 
 	ret = btrfs_alloc_chunk(trans, extent_root, flags);
+	if (ret < 0 && ret != -ENOSPC)
+		goto out;
+
 	spin_lock(&space_info->lock);
 	if (ret)
 		space_info->full = 1;
@@ -3286,6 +3289,7 @@ again:
 	space_info->force_alloc = CHUNK_ALLOC_NO_FORCE;
 	space_info->chunk_alloc = 0;
 	spin_unlock(&space_info->lock);
+out:
 	mutex_unlock(&extent_root->fs_info->chunk_mutex);
 	return ret;
 }
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 530a2fc..90d956c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1037,7 +1037,8 @@ static noinline int find_next_chunk(struct btrfs_root *root,
 	struct btrfs_key found_key;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	key.objectid = objectid;
 	key.offset = (u64)-1;
@@ -2663,7 +2664,8 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans,
 
 	ret = find_next_chunk(fs_info->chunk_root,
 			      BTRFS_FIRST_CHUNK_TREE_OBJECTID, &chunk_offset);
-	BUG_ON(ret);
+	if (ret)
+		return ret;
 
 	alloc_profile = BTRFS_BLOCK_GROUP_METADATA |
 			(fs_info->metadata_alloc_profile &
-- 
1.7.6

