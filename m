Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54758 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbcFQPeG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 11:34:06 -0400
Date: Fri, 17 Jun 2016 17:34:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH 2/2] btrfs-progs: btrfsck: verify qgroups above level 0
Message-ID: <20160617153440.GE4915@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1466031002-14533-1-git-send-email-mfasheh@suse.de>
 <1466031002-14533-3-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466031002-14533-3-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have non-qgroup related comments:

On Wed, Jun 15, 2016 at 03:50:02PM -0700, Mark Fasheh wrote:
> --- a/qgroup-verify.c
> +++ b/qgroup-verify.c
> @@ -35,7 +35,8 @@
>  /*#define QGROUP_VERIFY_DEBUG*/
>  static unsigned long tot_extents_scanned = 0;
>  
> -static void add_bytes(u64 root_objectid, u64 num_bytes, int exclusive);
> +struct qgroup_count;
> +static struct qgroup_count *find_count(u64 qgroupid);
>  
>  struct qgroup_info {
>  	u64 referenced;
> @@ -54,6 +55,14 @@ struct qgroup_count {
>  	struct qgroup_info info;
>  
>  	struct rb_node rb_node;
> +
> +	struct list_head groups;  /* parents when we are a child group */
> +	struct list_head members; /* children when we are a parent
> +				     group (not currently used but
> +				     maintained to mirror kernel
> +				     handling of qgroups) */

A long comment would be better on the line above the declaration.

> +
> +	u64 cur_refcnt;
>  };
>  
>  static struct counts_tree {
> @@ -66,6 +75,39 @@ static struct counts_tree {
>  static struct rb_root by_bytenr = RB_ROOT;
>  
>  /*
> + * glue structure to represent the relations between qgroups. Mirrored

"Glue structure ..." ie. capital letter if it's a sentence, there's more
of these.

> + * from kernel.
> + */
> +struct btrfs_qgroup_list {
> +	struct list_head next_group;
> +	struct list_head next_member;
> +	struct qgroup_count *group; /* Parent group */
> +	struct qgroup_count *member;
> +};
> +
> +/* allow us to reset ref counts during accounting without zeroing each group */
> +static u64 qgroup_seq = 1ULL;
> +
> +static inline void update_cur_refcnt(struct qgroup_count *c)
> +{
> +	if (c->cur_refcnt < qgroup_seq)
> +		c->cur_refcnt = qgroup_seq;
> +	c->cur_refcnt += 1;

	c->cur_refcnt++;

> +}
> +
> +static inline u64 group_get_cur_refcnt(struct qgroup_count *c)
> +{
> +	if (c->cur_refcnt < qgroup_seq)
> +		return 0;
> +	return c->cur_refcnt - qgroup_seq;
> +}
> +
> +static void inc_qgroup_seq(int root_count)
> +{
> +	qgroup_seq += root_count + 1;
> +}
> +
> +/*
>   * List of interior tree blocks. We walk this list after loading the
>   * extent tree to resolve implied refs. For each interior node we'll
>   * place a shared ref in the ref tree against each child object. This
> @@ -296,9 +338,10 @@ static void find_parent_roots(struct ulist *roots, u64 parent)
>  	}
>  
>  	do {
> -		if (ref->root)
> -			ulist_add(roots, ref->root, 0, 0);
> -		else
> +		if (ref->root) {
> +			if (is_fstree(ref->root))
> +				ulist_add(roots, ref->root, 0, 0);
> +		} else

		} else {

>  			find_parent_roots(roots, ref->parent);

		}

>  
>  		node = rb_next(node);
> @@ -307,6 +350,116 @@ static void find_parent_roots(struct ulist *roots, u64 parent)
>  	} while (node && ref->bytenr == parent);
>  }
>  
> +static int account_one_extent(struct ulist *roots, u64 bytenr, u64 num_bytes)
> +{
> +	int ret;
> +	u64 id, nr_roots, nr_refs;
> +	struct qgroup_count *count;
> +	struct ulist *counts = ulist_alloc(0);
> +	struct ulist *tmp = ulist_alloc(0);
> +	struct ulist_iterator uiter;
> +	struct ulist_iterator tmp_uiter;
> +	struct ulist_node *unode;
> +	struct ulist_node *tmp_unode;
> +	struct btrfs_qgroup_list *glist;
> +
> +	if (!counts || !tmp) {
> +		ulist_free(counts);
> +		ulist_free(tmp);
> +		return ENOMEM;

For a separate patch, but negative error values are preferred.

> +	}
> +
> +	ULIST_ITER_INIT(&uiter);
> +	while ((unode = ulist_next(roots, &uiter))) {
> +		BUG_ON(unode->val == 0ULL);
> +
> +		/*
> +		 * For each root, find their corresponding tracking group and
> +		 * add it to our qgroups list.
> +		 */
> +		count = find_count(unode->val);
> +		if (!count)
> +			continue;
> +
> +		BUG_ON(!is_fstree(unode->val));
> +		ret = ulist_add(counts, count->qgroupid, ptr_to_u64(count), 0);
> +		if (ret < 0)
> +			goto out;
> +
> +		/*
> +		 * Now we look for parents (and parents of
> +		 * those...). Use a tmp ulist here to avoid re-walking
> +		 * (and re-incrementing) our already added items on every
> +		 * loop iteration.

Please reformat to 80 columns.

> +		 */
> +		ulist_reinit(tmp);
> +		ret = ulist_add(tmp, count->qgroupid, ptr_to_u64(count), 0);
> +		if (ret < 0)
> +			goto out;
> +
> +		ULIST_ITER_INIT(&tmp_uiter);
> +		while ((tmp_unode = ulist_next(tmp, &tmp_uiter))) {
> +			/* bump the refcount on a node every time we
> +			 * see it. */

/*
 * Text...
 */

> +			count = u64_to_ptr(tmp_unode->aux);
> +			update_cur_refcnt(count);
> +
> +			list_for_each_entry(glist, &count->groups, next_group) {
> +				struct qgroup_count *parent;
> +				parent = glist->group;
> +				id = parent->qgroupid;
> +
> +				BUG_ON(!count);
> +
> +				ret = ulist_add(counts, id, ptr_to_u64(parent),
> +						0);
> +				if (ret < 0)
> +					goto out;
> +				ret = ulist_add(tmp, id, ptr_to_u64(parent),
> +						0);
> +				if (ret < 0)
> +					goto out;
> +			}
> +		}
> +	}
> +
> +	/*
> +	 * Now that we have gathered up and counted all the groups, we
> +	 * can add bytes for this ref.
> +	 */
> +	nr_roots = roots->nnodes;
> +	ULIST_ITER_INIT(&uiter);
> +	while ((unode = ulist_next(counts, &uiter))) {
> +		count = u64_to_ptr(unode->aux);
> +
> +		nr_refs = group_get_cur_refcnt(count);
> +		if (nr_refs) {
> +			count->info.referenced += num_bytes;
> +			count->info.referenced_compressed += num_bytes;
> +
> +			if (nr_refs == nr_roots) {
> +				count->info.exclusive += num_bytes;
> +				count->info.exclusive_compressed += num_bytes;
> +			}
> +		}
> +#ifdef QGROUP_VERIFY_DEBUG
> +		printf("account (%llu, %llu), qgroup %llu/%llu, rfer %llu,"
> +		       " excl %llu, refs %llu, roots %llu\n", bytenr, num_bytes,
> +		       btrfs_qgroup_level(count->qgroupid),
> +		       btrfs_qgroup_subvid(count->qgroupid),
> +		       count->info.referenced, count->info.exclusive, nr_refs,
> +		       nr_roots);
> +#endif
> +	}
> +
> +	inc_qgroup_seq(roots->nnodes);
> +	ret = 0;
> +out:
> +	ulist_free(counts);
> +	ulist_free(tmp);
> +	return ret;
> +}
> +
>  static void print_subvol_info(u64 subvolid, u64 bytenr, u64 num_bytes,
>  			      struct ulist *roots);
>  /*
> @@ -318,18 +471,15 @@ static void print_subvol_info(u64 subvolid, u64 bytenr, u64 num_bytes,
>   * - resolve all possible roots for shared refs, insert each
>   *   of those into ref_roots ulist (this is a recursive process)
>   *
> - * - Walk ref_roots ulist, adding extent bytes to each qgroup count that
> - *    cooresponds to a found root.
> + * - With all roots resolved we can account the ref - this is done in
> + *   account_one_extent().
>   */
>  static void account_all_refs(int do_qgroups, u64 search_subvol)
>  {
> -	int exclusive;
>  	struct ref *ref;
>  	struct rb_node *node;
>  	u64 bytenr, num_bytes;
>  	struct ulist *roots = ulist_alloc(0);
> -	struct ulist_iterator uiter;
> -	struct ulist_node *unode;
>  
>  	node = rb_first(&by_bytenr);
>  	while (node) {
> @@ -347,10 +497,14 @@ static void account_all_refs(int do_qgroups, u64 search_subvol)
>  		do {
>  			BUG_ON(ref->bytenr != bytenr);
>  			BUG_ON(ref->num_bytes != num_bytes);
> -			if (ref->root)
> -				ulist_add(roots, ref->root, 0, 0);
> -			else
> +			if (ref->root) {
> +				if (is_fstree(ref->root)) {
> +					if (ulist_add(roots, ref->root, 0, 0) < 0)
> +						goto enomem;
> +				}
> +			} else {
>  				find_parent_roots(roots, ref->parent);
> +			}
>  
>  			/*
>  			 * When we leave this inner loop, node is set
> @@ -362,29 +516,23 @@ static void account_all_refs(int do_qgroups, u64 search_subvol)
>  				ref = rb_entry(node, struct ref, bytenr_node);
>  		} while (node && ref->bytenr == bytenr);
>  
> -		/*
> -		 * Now that we have all roots, we can properly account
> -		 * this extent against the corresponding qgroups.
> -		 */
> -		if (roots->nnodes == 1)
> -			exclusive = 1;
> -		else
> -			exclusive = 0;
> -
>  		if (search_subvol)
>  			print_subvol_info(search_subvol, bytenr, num_bytes,
>  					  roots);
>  
> -		ULIST_ITER_INIT(&uiter);
> -		while ((unode = ulist_next(roots, &uiter))) {
> -			BUG_ON(unode->val == 0ULL);
> -			/* We only want to account fs trees */
> -			if (is_fstree(unode->val) && do_qgroups)
> -				add_bytes(unode->val, num_bytes, exclusive);
> -		}
> +		if (!do_qgroups)
> +			continue;
> +
> +		if (account_one_extent(roots, bytenr, num_bytes))
> +			goto enomem;
>  	}
>  
>  	ulist_free(roots);
> +	return;
> +enomem:
> +	fprintf(stderr,
> +		"ERROR: Out of memory while accounting refs for qgroups!\n");
> +	abort();

I don't like this kind of error handling. Fail with a message and return
error to the caller chain.

>  }
>  
>  static u64 resolve_one_root(u64 bytenr)
> @@ -668,6 +816,8 @@ static struct qgroup_count *alloc_count(struct btrfs_disk_key *key,
>  		item->exclusive = btrfs_qgroup_info_exclusive(leaf, disk);
>  		item->exclusive_compressed =
>  			btrfs_qgroup_info_exclusive_compressed(leaf, disk);
> +		INIT_LIST_HEAD(&c->groups);
> +		INIT_LIST_HEAD(&c->members);
>  
>  		if (insert_count(c)) {
>  			free(c);
> @@ -677,29 +827,30 @@ static struct qgroup_count *alloc_count(struct btrfs_disk_key *key,
>  	return c;
>  }
>  
> -static void add_bytes(u64 root_objectid, u64 num_bytes, int exclusive)
> +static int add_qgroup_relation(u64 memberid, u64 parentid)
>  {
> -	struct qgroup_count *count = find_count(root_objectid);
> -	struct qgroup_info *qg;
> +	struct qgroup_count *member;
> +	struct qgroup_count *parent;
> +	struct btrfs_qgroup_list *list;
>  
> -	BUG_ON(num_bytes < 4096); /* Random sanity check. */
> +	if (memberid > parentid)
> +		return 0;
>  
> -	if (!count)
> -		return;
> +	member = find_count(memberid);
> +	parent = find_count(parentid);
> +	if (!member || !parent)
> +		return -ENOENT;
>  
> -	qg = &count->info;
> +	list = calloc(1, sizeof(*list));
> +	if (!list)
> +		return -ENOMEM;
>  
> -	qg->referenced += num_bytes;
> -	/*
> -	 * count of compressed bytes is unimplemented, so we do the
> -	 * same as kernel.
> -	 */
> -	qg->referenced_compressed += num_bytes;
> +	list->group = parent;
> +	list->member = member;
> +	list_add_tail(&list->next_group, &member->groups);
> +	list_add_tail(&list->next_member, &parent->members);
>  
> -	if (exclusive) {
> -		qg->exclusive += num_bytes;
> -		qg->exclusive_compressed += num_bytes;
> -	}
> +	return 0;
>  }
>  
>  static void read_qgroup_status(struct btrfs_path *path,
> @@ -728,11 +879,18 @@ static int load_quota_info(struct btrfs_fs_info *info)
>  	struct btrfs_qgroup_info_item *item;
>  	struct qgroup_count *count;
>  	int i, nr;
> +	int search_relations = 0;
>  
> +loop:
> +	/*
> +	 * Do 2 passes, the first allocates group counts and reads status
> +	 * items. The 2nd pass picks up relation items and glues them
> +	 * to their respective count structures.
> +	 */
>  	btrfs_init_path(&path);
>  
>  	key.offset = 0;
> -	key.objectid = 0;
> +	key.objectid = search_relations ? 0 : BTRFS_QGROUP_RELATION_KEY;
>  	key.type = 0;
>  
>  	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
> @@ -749,17 +907,27 @@ static int load_quota_info(struct btrfs_fs_info *info)
>  			btrfs_item_key(leaf, &disk_key, i);
>  			btrfs_disk_key_to_cpu(&key, &disk_key);
>  
> +			if (search_relations) {
> +				if (key.type == BTRFS_QGROUP_RELATION_KEY) {
> +					ret = add_qgroup_relation(key.objectid,
> +								  key.offset);
> +					if (ret) {
> +						fprintf(stderr,
> +						"ERROR: out of memory\n");

Please use the error("...") helper.

> +						goto out;
> +					}
> +				}
> +				continue;
> +			}
> +
>  			if (key.type == BTRFS_QGROUP_STATUS_KEY) {
>  				read_qgroup_status(&path, &counts);
>  				continue;
>  			}
> -			if (key.type == BTRFS_QGROUP_RELATION_KEY)
> -				printf("Ignoring qgroup relation key %llu\n",
> -				       key.objectid);
>  
>  			/*
> -			 * Ignore: BTRFS_QGROUP_LIMIT_KEY,
> -			 * 	   BTRFS_QGROUP_RELATION_KEY
> +			 * At this point, we can ignore anything that
> +			 * isn't a qgroup info.
>  			 */
>  			if (key.type != BTRFS_QGROUP_INFO_KEY)
>  				continue;
> @@ -791,6 +959,12 @@ static int load_quota_info(struct btrfs_fs_info *info)
>  
>  	ret = 0;
>  	btrfs_release_path(&path);
> +
> +	if (!search_relations) {
> +		search_relations = 1;
> +		goto loop;
> +	}
> +
>  out:
>  	return ret;
>  }
> @@ -1035,6 +1209,11 @@ static void print_fields_signed(long long bytes,
>  	       prefix, type, bytes, type, bytes_compressed);
>  }
>  
> +static inline int qgroup_printable(struct qgroup_count *c)
> +{
> +	return !!(c->subvol_exists || btrfs_qgroup_level(c->qgroupid));
> +}
> +
>  static int report_qgroup_difference(struct qgroup_count *count, int verbose)
>  {
>  	int is_different;
> @@ -1045,9 +1224,10 @@ static int report_qgroup_difference(struct qgroup_count *count, int verbose)
>  
>  	is_different = excl_diff || ref_diff;
>  
> -	if (verbose || (is_different && count->subvol_exists)) {
> -		printf("Counts for qgroup id: %llu %s\n",
> -		       (unsigned long long)count->qgroupid,
> +	if (verbose || (is_different && qgroup_printable(count))) {
> +		printf("Counts for qgroup id: %llu/%llu %s\n",
> +		       btrfs_qgroup_level(count->qgroupid),
> +		       btrfs_qgroup_subvid(count->qgroupid),
>  		       is_different ? "are different" : "");
>  
>  		print_fields(info->referenced, info->referenced_compressed,
> @@ -1099,10 +1279,27 @@ void free_qgroup_counts(void)
>  {
>  	struct rb_node *node;
>  	struct qgroup_count *c;
> +	struct btrfs_qgroup_list *glist, *tmpglist;
> +
>  	node = rb_first(&counts.root);
>  	while (node) {
>  		c = rb_entry(node, struct qgroup_count, rb_node);
> +
> +		list_for_each_entry_safe(glist, tmpglist, &c->groups,
> +					 next_group) {
> +			list_del(&glist->next_group);
> +			list_del(&glist->next_member);
> +			free(glist);
> +		}
> +		list_for_each_entry_safe(glist, tmpglist, &c->members,
> +					 next_group) {
> +			list_del(&glist->next_group);
> +			list_del(&glist->next_member);
> +			free(glist);
> +		}
> +
>  		node = rb_next(node);
> +
>  		rb_erase(&c->rb_node, &counts.root);
>  		free(c);
>  	}
