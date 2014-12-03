Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:51285 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbaLCOav (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Dec 2014 09:30:51 -0500
From: Ed Tomlinson <edt@aei.ca>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH v2 6/6] btrfs-progs: Add fixing function for inodes whose nlink dismatch
Date: Wed, 03 Dec 2014 09:30:48 -0500
Message-ID: <3392890.p9hJPZbuVy@grover>
In-Reply-To: <1417580312-8516-7-git-send-email-quwenruo@cn.fujitsu.com>
References: <1417580312-8516-1-git-send-email-quwenruo@cn.fujitsu.com> <1417580312-8516-7-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Looks like 

Reported-by:  Daniel Miranda <danielkza2@gmail.com>

also needs to be added see: "Re: Apparent metadata corruption (file that simultaneously does/does not exist) on kernel 3.17.3"
Where Daniel reports these patches fixed his fs too.  

I expect an fsck with --repair specified to change my fs and creating and populating an lost+found directory is not an unexpected result.
While btrfs is not supposed to need this - its obvious that it does and that this corruption is not that uncommon.

Three victims repaired in less than two weeks - how many more are out there?

Thanks
Ed

PS. The other important question is how do we find the bug causing this and fix it?

On Wednesday 03 December 2014 12:18:32 Qu Wenruo wrote:
> [BUG]
> At least two users have already hit a bug in btrfs causing file
> missing(Chromium config file).
> The missing file's nlink is still 1 but its backref points to non-exist
> parent inode.
> 
> This should be a kernel bug, but btrfsck fix is needed anyway.
> 
> [FIX]
> For such nlink mismatch inode, we will delete all the invalid backref,
> if there is no valid backref for it, create 'lost+found' under the root
> of the subvolume and add link to the directory.
> 
> Reported-by: Mike Gavrilov <mikhail.v.gavrilov@gmail.com>
> Reported-by: Ed Tomlinson <edt@aei.ca>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> 
> ---
> changelog:
> v2:
>    Use the a more generic fucntion, reset_nlink(), to repair the inode
>    nlink.
>    It will remove all, including valid, backref(along with
>    dir_item/index) and set nlink to 0, and add valid ones back.
>    This reset_nlink() method can handle more nlink error, not only
>    invalid inode_ref but also pure nlinks mismatch(2 valid inode_ref but
>    nlink is 1)
> ---
>  cmds-check.c | 236 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 232 insertions(+), 4 deletions(-)
> 
> diff --git a/cmds-check.c b/cmds-check.c
> index 6419caf..627b794 100644
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -27,6 +27,7 @@
>  #include <unistd.h>
>  #include <getopt.h>
>  #include <uuid/uuid.h>
> +#include <math.h>
>  #include "ctree.h"
>  #include "volumes.h"
>  #include "repair.h"
> @@ -1837,6 +1838,18 @@ static int repair_inode_backrefs(struct btrfs_root *root,
>  			struct btrfs_trans_handle *trans;
>  			struct btrfs_key location;
>  
> +			ret = check_dir_conflict(root, backref->name,
> +						 backref->namelen,
> +						 backref->dir,
> +						 backref->index);
> +			if (ret) {
> +				/*
> +				 * let nlink fixing routine to handle it,
> +				 * which can do it better.
> +				 */
> +				ret = 0;
> +				break;
> +			}
>  			location.objectid = rec->ino;
>  			location.type = BTRFS_INODE_ITEM_KEY;
>  			location.offset = 0;
> @@ -1874,20 +1887,233 @@ static int repair_inode_backrefs(struct btrfs_root *root,
>  	return ret ? ret : repaired;
>  }
>  
> +/*
> + * Search for the inode_ref of given 'ino' to get the filename and
> + * btrfs type.
> + * This will only use the first inode_ref.
> + */
> +static int find_file_name_type(struct btrfs_root *root,
> +			       struct btrfs_path *path,
> +			       u64 ino, char *buf,
> +			       int *namelen, u8 *type)
> +{
> +	struct btrfs_key key;
> +	struct btrfs_key found_key;
> +	struct btrfs_inode_ref *inode_ref;
> +	struct btrfs_inode_item *inode_item;
> +	struct extent_buffer *node;
> +	u32 ret_namelen;
> +	int slot;
> +	int ret = 0;
> +
> +	/* Search for name in backref(Use the first one) */
> +	key.objectid = ino;
> +	key.type = BTRFS_INODE_REF_KEY;
> +	key.offset = 0;
> +
> +	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
> +	if (ret < 0)
> +		goto out;
> +	node = path->nodes[0];
> +	slot = path->slots[0];
> +	btrfs_item_key_to_cpu(node, &found_key, slot);
> +	if (found_key.objectid != ino ||
> +	    found_key.type != BTRFS_INODE_REF_KEY) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +	inode_ref = btrfs_item_ptr(node, slot, struct btrfs_inode_ref);
> +	ret_namelen = btrfs_inode_ref_name_len(node, inode_ref);
> +	read_extent_buffer(node, buf, (unsigned long)(inode_ref + 1),
> +			   ret_namelen);
> +	/* Search for inode type */
> +	ret = btrfs_previous_item(root, path, ino, BTRFS_INODE_ITEM_KEY);
> +	if (ret) {
> +		if (ret > 0)
> +			ret = -ENOENT;
> +		goto out;
> +	}
> +	node = path->nodes[0];
> +	slot = path->slots[0];
> +	inode_item = btrfs_item_ptr(node, slot, struct btrfs_inode_item);
> +
> +	if (namelen)
> +		*namelen = ret_namelen;
> +	if (type)
> +		*type = imode_to_type(btrfs_inode_mode(node, inode_item));
> +out:
> +	btrfs_release_path(path);
> +	return ret;
> +}
> +
> +/* Reset the nlink of the inode to the correct one */
> +static int reset_nlink(struct btrfs_trans_handle *trans,
> +		       struct btrfs_root *root,
> +		       struct btrfs_path *path,
> +		       struct inode_record *rec)
> +{
> +	struct inode_backref *backref;
> +	struct inode_backref *tmp;
> +	struct btrfs_key key;
> +	struct btrfs_inode_item *inode_item;
> +	int ret = 0;
> +
> +	/* Remove all backref including the valid ones */
> +	list_for_each_entry_safe(backref, tmp, &rec->backrefs, list) {
> +		ret = btrfs_unlink(trans, root, rec->ino, backref->dir,
> +				   backref->index, backref->name,
> +				   backref->namelen, 0);
> +		if (ret < 0)
> +			goto out;
> +
> +		/* remove invalid backref, so it won't be added back */
> +		if (!(backref->found_dir_index &&
> +		      backref->found_dir_item &&
> +		      backref->found_inode_ref)) {
> +			list_del(&backref->list);
> +			free(backref);
> +		}
> +	}
> +
> +	/* Set nlink to 0 */
> +	key.objectid = rec->ino;
> +	key.type = BTRFS_INODE_ITEM_KEY;
> +	key.offset = 0;
> +	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
> +	if (ret < 0)
> +		goto out;
> +	if (ret > 0) {
> +		ret = -ENOENT;
> +		goto out;
> +	}
> +	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
> +				    struct btrfs_inode_item);
> +	btrfs_set_inode_nlink(path->nodes[0], inode_item, 0);
> +	btrfs_mark_buffer_dirty(path->nodes[0]);
> +	btrfs_release_path(path);
> +
> +	/*
> +	 * Add back valid inode_ref/dir_item/dir_index,
> +	 * add_link() will handle the nlink inc, so new nlink must be correct
> +	 */
> +	list_for_each_entry(backref, &rec->backrefs, list) {
> +		ret = btrfs_add_link(trans, root, rec->ino, backref->dir,
> +				     backref->name, backref->namelen,
> +				     backref->ref_type, &backref->index, 1);
> +		if (ret < 0)
> +			goto out;
> +	}
> +out:
> +	btrfs_release_path(path);
> +	return ret;
> +}
> +
> +static int repair_inode_nlinks(struct btrfs_trans_handle *trans,
> +			       struct btrfs_root *root,
> +			       struct btrfs_path *path,
> +			       struct inode_record *rec)
> +{
> +	char *dir_name = "lost+found";
> +	char namebuf[BTRFS_NAME_LEN] = {0};
> +	u64 lost_found_ino;
> +	u32 mode = 0700;
> +	u8 type = 0;
> +	int namelen = 0;
> +	int ret = 0;
> +
> +	/*
> +	 * Get file name and type first before these invalid inode ref
> +	 * are deleted by remove_all_invalid_backref()
> +	 */
> +	ret = find_file_name_type(root, path, rec->ino, namebuf,
> +				  &namelen, &type);
> +	if (ret < 0) {
> +		fprintf(stderr,
> +			"Fail to get file name of inode %llu: %s\n",
> +			rec->ino, strerror(-ret));
> +		goto out;
> +	}
> +	ret = reset_nlink(trans, root, path, rec);
> +	if (ret < 0) {
> +		fprintf(stderr,
> +			"Fail to reset nlink for inode %llu: %s\n",
> +			rec->ino, strerror(-ret));
> +		goto out;
> +	}
> +
> +	if (rec->found_link == 0) {
> +		ret = btrfs_mkdir(trans, root, dir_name, strlen(dir_name),
> +				  BTRFS_FIRST_FREE_OBJECTID, &lost_found_ino,
> +				  mode);
> +		if (ret < 0) {
> +			fprintf(stderr, "Failed to create '%s' dir: %s",
> +				dir_name, strerror(-ret));
> +			goto out;
> +		}
> +		ret = btrfs_add_link(trans, root, rec->ino, lost_found_ino,
> +				     namebuf, namelen, type, NULL, 1);
> +		if (ret == -EEXIST) {
> +			/*
> +			 * Conflicting file name, add ".INO" as suffix
> +			 * +1 for '.' and +1 for log10
> +			 */
> +			if (namelen + log10(rec->ino) + 2 > BTRFS_NAME_LEN) {
> +				ret = -EFBIG;
> +				goto out;
> +			}
> +			snprintf(namebuf + namelen, BTRFS_NAME_LEN - namelen,
> +				 ".%llu", rec->ino);
> +			namelen += (log10(rec->ino) + 2);
> +			ret = btrfs_add_link(trans, root, rec->ino,
> +					     lost_found_ino, namebuf,
> +					     namelen, type, NULL, 1);
> +		}
> +		if (ret < 0) {
> +			fprintf(stderr,
> +				"Fail to link the inode %llu to %s dir: %s",
> +				rec->ino, dir_name, strerror(-ret));
> +			goto out;
> +		}
> +		/*
> +		 * Just increase the found_link, don't actually add the
> +		 * backref. This will make things easiler and this inode
> +		 * record will be freed after the repair is done.
> +		 * So fsck will not report problem about this inode.
> +		 */
> +		rec->found_link++;
> +		printf("Moving file '%.*s' to '%s' dir since it has no valid backref\n",
> +		       namelen, namebuf, dir_name);
> +	}
> +	rec->errors &= ~I_ERR_LINK_COUNT_WRONG;
> +	printf("Fixed the nlink of inode %llu\n", rec->ino);
> +out:
> +	btrfs_release_path(path);
> +	return ret;
> +}
> +
>  static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
>  {
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_path *path;
>  	int ret = 0;
>  
> -	if (!(rec->errors & (I_ERR_DIR_ISIZE_WRONG | I_ERR_NO_ORPHAN_ITEM)))
> +	if (!(rec->errors & (I_ERR_DIR_ISIZE_WRONG |
> +			     I_ERR_NO_ORPHAN_ITEM |
> +			     I_ERR_LINK_COUNT_WRONG)))
>  		return rec->errors;
>  
>  	path = btrfs_alloc_path();
>  	if (!path)
>  		return -ENOMEM;
>  
> -	trans = btrfs_start_transaction(root, 1);
> +	/*
> +	 * For nlink repair, it may create a dir and add link, so
> +	 * 2 for parent(256)'s dir_index and dir_item
> +	 * 2 for lost+found dir's inode_item and inode_ref
> +	 * 1 for the new inode_ref of the file
> +	 * 2 for lost+found dir's dir_index and dir_item for the file
> +	 */
> +	trans = btrfs_start_transaction(root, 7);
>  	if (IS_ERR(trans)) {
>  		btrfs_free_path(path);
>  		return PTR_ERR(trans);
> @@ -1897,6 +2123,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
>  		ret = repair_inode_isize(trans, root, path, rec);
>  	if (!ret && rec->errors & I_ERR_NO_ORPHAN_ITEM)
>  		ret = repair_inode_orphan_item(trans, root, path, rec);
> +	if (!ret && rec->errors & I_ERR_LINK_COUNT_WRONG)
> +		ret = repair_inode_nlinks(trans, root, path, rec);
>  	btrfs_commit_transaction(trans, root);
>  	btrfs_free_path(path);
>  	return ret;
> @@ -2032,6 +2260,8 @@ static int check_inode_recs(struct btrfs_root *root,
>  			}
>  		}
>  
> +		if (rec->found_link != rec->nlink)
> +			rec->errors |= I_ERR_LINK_COUNT_WRONG;
>  		if (repair) {
>  			ret = try_repair_inode(root, rec);
>  			if (ret == 0 && can_free_inode_rec(rec)) {
> @@ -2044,8 +2274,6 @@ static int check_inode_recs(struct btrfs_root *root,
>  		error++;
>  		if (!rec->found_inode_item)
>  			rec->errors |= I_ERR_NO_INODE_ITEM;
> -		if (rec->found_link != rec->nlink)
> -			rec->errors |= I_ERR_LINK_COUNT_WRONG;
>  		print_inode_error(root, rec);
>  		list_for_each_entry(backref, &rec->backrefs, list) {
>  			if (!backref->found_dir_item)
> 

