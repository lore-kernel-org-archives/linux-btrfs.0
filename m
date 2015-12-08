Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from front-a.remote-shell.net ([212.129.33.91]:45923 "EHLO
	mx-a.remote-shell.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbbLHCba (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Dec 2015 21:31:30 -0500
Received: from localhost (mx-a.remote-shell.net [127.0.0.1])
	by mx-a.remote-shell.net (Postfix) with ESMTP id 0D8FF7D0011
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Dec 2015 02:24:42 +0000 (UTC)
Received: from mx-a.remote-shell.net ([127.0.0.1])
	by localhost (mx-a.remote-shell.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0Oy8VimlzPfm for <linux-btrfs@vger.kernel.org>;
	Tue,  8 Dec 2015 02:24:41 +0000 (UTC)
From: =?UTF-8?Q?Tristan_Mah=c3=a9?= <gled@remote-shell.net>
Subject: Re: PAX: size overflow detected in function try_merge_map
 fs/btrfs/extent_map.c:238
To: toralf.foerster@gmx.de
Cc: linux-btrfs@vger.kernel.org
Message-ID: <56663F61.40208@remote-shell.net>
Date: Mon, 7 Dec 2015 18:24:33 -0800
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jNxtP3SX95h1dnRgscJ7pkjLH5H9Md4ts"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jNxtP3SX95h1dnRgscJ7pkjLH5H9Md4ts
Content-Type: multipart/mixed;
 boundary="------------000905000609030705080705"

This is a multi-part message in MIME format.
--------------000905000609030705080705
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Compiled the patch on 4.2.6-hardened-r8 on gentoo 64bit and it's still
failing :/

[  182.316487] PAX: size overflow detected in function try_merge_map
fs/btrfs/extent_map.c:241 cicus.108_106 max, count: 13, decl: block_len;
num: 0; context: extent_map;
[  182.316490] CPU: 3 PID: 11196 Comm: insserv Tainted: G     U     O  =20
4.2.6-hardened-r8 #2
[  182.316491] Hardware name: LENOVO 20ANCTO1WW/20ANCTO1WW, BIOS
GLET78WW (2.32 ) 03/03/2015
[  182.316492]  ffffffff81c3f37d 0000000000000000 ffffffff81c3f367
ffffc90010403678
[  182.316493]  ffffffff819b9f6c ffff88043e2cec30 ffffffff81c3f37d
ffffc900104036a8
[  182.316494]  ffffffff81226d26 ffff880351bf4390 ffff8800aa2e84c0
ffff88041c8c32e8
[  182.316496] Call Trace:
[  182.316500]  [<ffffffff819b9f6c>] dump_stack+0x45/0x5d
[  182.316502]  [<ffffffff81226d26>] report_size_overflow+0x36/0x40
[  182.316504]  [<ffffffff814b293a>] try_merge_map+0x2ca/0x340
[  182.316505]  [<ffffffff814b2bed>] add_extent_mapping+0x12d/0x1b0
[  182.316507]  [<ffffffff8149a162>] btrfs_get_extent+0x6b2/0xe40
[  182.316509]  [<ffffffff814bcaf9>] __do_readpage+0x249/0xb90
[  182.316511]  [<ffffffff81499ab0>] ? btrfs_direct_IO+0x380/0x380
[  182.316512]  [<ffffffff814bd91d>]
__extent_readpages.constprop.36+0x2dd/0x320
[  182.316515]  [<ffffffff811ad7b5>] ?
__add_to_page_cache_locked+0x155/0x200
[  182.316516]  [<ffffffff81499ab0>] ? btrfs_direct_IO+0x380/0x380
[  182.316518]  [<ffffffff814bf562>] extent_readpages+0x1c2/0x1d0
[  182.316519]  [<ffffffff81499ab0>] ? btrfs_direct_IO+0x380/0x380
[  182.316522]  [<ffffffff811fd6ad>] ? alloc_pages_current+0x8d/0x100
[  182.316523]  [<ffffffff81497f15>] btrfs_readpages+0x35/0x50
[  182.316525]  [<ffffffff811bc895>] __do_page_cache_readahead+0x1b5/0x23=
0
[  182.316526]  [<ffffffff811bc9fc>] ondemand_readahead+0xec/0x2e0
[  182.316528]  [<ffffffff811bcd2a>] page_cache_sync_readahead+0x4a/0x80
[  182.316529]  [<ffffffff811afe59>] generic_file_read_iter+0x5f9/0x790
[  182.316531]  [<ffffffff8121eba9>] __vfs_read+0xd9/0x100
[  182.316532]  [<ffffffff8121f620>] vfs_read+0xd0/0x230
[  182.316533]  [<ffffffff81220866>] SyS_read+0x46/0xb0
[  182.316534]  [<ffffffff819c1850>] entry_SYSCALL_64_fastpath+0x12/0x78


Very easy to reproduce here:

1/ install docker with btrfs as the storage driver
2/ start a debian 7 container ( /sbin/init as the command, openssh to be
able to ssh in )
3/ attempt to use insserv ( for example insserv -r -f ntpd )

Till a reboot, anything launched that will try to access what was in use
and caused the crash will hang.

And quick question, sorry I am not familiar at all with btrfs code, but
if em->block_start =3D=3D EXTENT_MAP_HOLE then em->block_len is not updat=
ed
to its new value, wouldn't that be a source of trouble ?



--------------000905000609030705080705
Content-Type: text/x-csrc;
 name="extent_map.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="extent_map.c"

#include <linux/err.h>
#include <linux/slab.h>
#include <linux/spinlock.h>
#include <linux/hardirq.h>
#include "ctree.h"
#include "extent_map.h"


static struct kmem_cache *extent_map_cache;

int __init extent_map_init(void)
{
	extent_map_cache =3D kmem_cache_create("btrfs_extent_map",
			sizeof(struct extent_map), 0,
			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD, NULL);
	if (!extent_map_cache)
		return -ENOMEM;
	return 0;
}

void extent_map_exit(void)
{
	if (extent_map_cache)
		kmem_cache_destroy(extent_map_cache);
}

/**
 * extent_map_tree_init - initialize extent map tree
 * @tree:		tree to initialize
 *
 * Initialize the extent tree @tree.  Should be called for each new inode=

 * or other user of the extent_map interface.
 */
void extent_map_tree_init(struct extent_map_tree *tree)
{
	tree->map =3D RB_ROOT;
	INIT_LIST_HEAD(&tree->modified_extents);
	rwlock_init(&tree->lock);
}

/**
 * alloc_extent_map - allocate new extent map structure
 *
 * Allocate a new extent_map structure.  The new structure is
 * returned with a reference count of one and needs to be
 * freed using free_extent_map()
 */
struct extent_map *alloc_extent_map(void)
{
	struct extent_map *em;
	em =3D kmem_cache_zalloc(extent_map_cache, GFP_NOFS);
	if (!em)
		return NULL;
	RB_CLEAR_NODE(&em->rb_node);
	em->flags =3D 0;
	em->compress_type =3D BTRFS_COMPRESS_NONE;
	em->generation =3D 0;
	atomic_set(&em->refs, 1);
	INIT_LIST_HEAD(&em->list);
	return em;
}

/**
 * free_extent_map - drop reference count of an extent_map
 * @em:		extent map beeing releasead
 *
 * Drops the reference out on @em by one and free the structure
 * if the reference count hits zero.
 */
void free_extent_map(struct extent_map *em)
{
	if (!em)
		return;
	WARN_ON(atomic_read(&em->refs) =3D=3D 0);
	if (atomic_dec_and_test(&em->refs)) {
		WARN_ON(extent_map_in_tree(em));
		WARN_ON(!list_empty(&em->list));
		if (test_bit(EXTENT_FLAG_FS_MAPPING, &em->flags))
			kfree(em->bdev);
		kmem_cache_free(extent_map_cache, em);
	}
}

/* simple helper to do math around the end of an extent, handling wrap */=

static u64 range_end(u64 start, u64 len)
{
	if (start + len < start)
		return (u64)-1;
	return start + len;
}

static int tree_insert(struct rb_root *root, struct extent_map *em)
{
	struct rb_node **p =3D &root->rb_node;
	struct rb_node *parent =3D NULL;
	struct extent_map *entry =3D NULL;
	struct rb_node *orig_parent =3D NULL;
	u64 end =3D range_end(em->start, em->len);

	while (*p) {
		parent =3D *p;
		entry =3D rb_entry(parent, struct extent_map, rb_node);

		if (em->start < entry->start)
			p =3D &(*p)->rb_left;
		else if (em->start >=3D extent_map_end(entry))
			p =3D &(*p)->rb_right;
		else
			return -EEXIST;
	}

	orig_parent =3D parent;
	while (parent && em->start >=3D extent_map_end(entry)) {
		parent =3D rb_next(parent);
		entry =3D rb_entry(parent, struct extent_map, rb_node);
	}
	if (parent)
		if (end > entry->start && em->start < extent_map_end(entry))
			return -EEXIST;

	parent =3D orig_parent;
	entry =3D rb_entry(parent, struct extent_map, rb_node);
	while (parent && em->start < entry->start) {
		parent =3D rb_prev(parent);
		entry =3D rb_entry(parent, struct extent_map, rb_node);
	}
	if (parent)
		if (end > entry->start && em->start < extent_map_end(entry))
			return -EEXIST;

	rb_link_node(&em->rb_node, orig_parent, p);
	rb_insert_color(&em->rb_node, root);
	return 0;
}

/*
 * search through the tree for an extent_map with a given offset.  If
 * it can't be found, try to find some neighboring extents
 */
static struct rb_node *__tree_search(struct rb_root *root, u64 offset,
				     struct rb_node **prev_ret,
				     struct rb_node **next_ret)
{
	struct rb_node *n =3D root->rb_node;
	struct rb_node *prev =3D NULL;
	struct rb_node *orig_prev =3D NULL;
	struct extent_map *entry;
	struct extent_map *prev_entry =3D NULL;

	while (n) {
		entry =3D rb_entry(n, struct extent_map, rb_node);
		prev =3D n;
		prev_entry =3D entry;

		if (offset < entry->start)
			n =3D n->rb_left;
		else if (offset >=3D extent_map_end(entry))
			n =3D n->rb_right;
		else
			return n;
	}

	if (prev_ret) {
		orig_prev =3D prev;
		while (prev && offset >=3D extent_map_end(prev_entry)) {
			prev =3D rb_next(prev);
			prev_entry =3D rb_entry(prev, struct extent_map, rb_node);
		}
		*prev_ret =3D prev;
		prev =3D orig_prev;
	}

	if (next_ret) {
		prev_entry =3D rb_entry(prev, struct extent_map, rb_node);
		while (prev && offset < prev_entry->start) {
			prev =3D rb_prev(prev);
			prev_entry =3D rb_entry(prev, struct extent_map, rb_node);
		}
		*next_ret =3D prev;
	}
	return NULL;
}

/* check to see if two extent_map structs are adjacent and safe to merge =
*/
static int mergable_maps(struct extent_map *prev, struct extent_map *next=
)
{
	if (test_bit(EXTENT_FLAG_PINNED, &prev->flags))
		return 0;

	/*
	 * don't merge compressed extents, we need to know their
	 * actual size
	 */
	if (test_bit(EXTENT_FLAG_COMPRESSED, &prev->flags))
		return 0;

	if (test_bit(EXTENT_FLAG_LOGGING, &prev->flags) ||
	    test_bit(EXTENT_FLAG_LOGGING, &next->flags))
		return 0;

	/*
	 * We don't want to merge stuff that hasn't been written to the log yet
	 * since it may not reflect exactly what is on disk, and that would be
	 * bad.
	 */
	if (!list_empty(&prev->list) || !list_empty(&next->list))
		return 0;

	if (extent_map_end(prev) =3D=3D next->start &&
	    prev->flags =3D=3D next->flags &&
	    prev->bdev =3D=3D next->bdev &&
	    ((next->block_start =3D=3D EXTENT_MAP_HOLE &&
	      prev->block_start =3D=3D EXTENT_MAP_HOLE) ||
	     (next->block_start =3D=3D EXTENT_MAP_INLINE &&
	      prev->block_start =3D=3D EXTENT_MAP_INLINE) ||
	     (next->block_start =3D=3D EXTENT_MAP_DELALLOC &&
	      prev->block_start =3D=3D EXTENT_MAP_DELALLOC) ||
	     (next->block_start < EXTENT_MAP_LAST_BYTE - 1 &&
	      next->block_start =3D=3D extent_map_block_end(prev)))) {
		return 1;
	}
	return 0;
}

static void try_merge_map(struct extent_map_tree *tree, struct extent_map=
 *em)
{
	struct extent_map *merge =3D NULL;
	struct rb_node *rb;

	if (em->start !=3D 0) {
		rb =3D rb_prev(&em->rb_node);
		if (rb)
			merge =3D rb_entry(rb, struct extent_map, rb_node);
		if (rb && mergable_maps(merge, em)) {
			em->start =3D merge->start;
			em->orig_start =3D merge->orig_start;
			em->len +=3D merge->len;
			// BREAKPOINT TRY TO PATCH BTRFS bug
			// em->block_len +=3D merge->block_len;
			if (em->block_start !=3D EXTENT_MAP_HOLE)
                        	em->block_len +=3D merge->block_len;
			em->block_start =3D merge->block_start;
			em->mod_len =3D (em->mod_len + em->mod_start) - merge->mod_start;
			em->mod_start =3D merge->mod_start;
			em->generation =3D max(em->generation, merge->generation);

			rb_erase(&merge->rb_node, &tree->map);
			RB_CLEAR_NODE(&merge->rb_node);
			free_extent_map(merge);
		}
	}

	rb =3D rb_next(&em->rb_node);
	if (rb)
		merge =3D rb_entry(rb, struct extent_map, rb_node);
	if (rb && mergable_maps(em, merge)) {
		em->len +=3D merge->len;
		// BREAKPOINT TRY TO PATCH BTRFS bug
		// em->block_len +=3D merge->block_len;
		if (em->block_start !=3D EXTENT_MAP_HOLE)
			em->block_len +=3D merge->block_len;
		rb_erase(&merge->rb_node, &tree->map);
		RB_CLEAR_NODE(&merge->rb_node);
		em->mod_len =3D (merge->mod_start + merge->mod_len) - em->mod_start;
		em->generation =3D max(em->generation, merge->generation);
		free_extent_map(merge);
	}
}

/**
 * unpin_extent_cache - unpin an extent from the cache
 * @tree:	tree to unpin the extent in
 * @start:	logical offset in the file
 * @len:	length of the extent
 * @gen:	generation that this extent has been modified in
 *
 * Called after an extent has been written to disk properly.  Set the gen=
eration
 * to the generation that actually added the file item to the inode so we=
 know
 * we need to sync this extent when we call fsync().
 */
int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
		       u64 gen)
{
	int ret =3D 0;
	struct extent_map *em;
	bool prealloc =3D false;

	write_lock(&tree->lock);
	em =3D lookup_extent_mapping(tree, start, len);

	WARN_ON(!em || em->start !=3D start);

	if (!em)
		goto out;

	em->generation =3D gen;
	clear_bit(EXTENT_FLAG_PINNED, &em->flags);
	em->mod_start =3D em->start;
	em->mod_len =3D em->len;

	if (test_bit(EXTENT_FLAG_FILLING, &em->flags)) {
		prealloc =3D true;
		clear_bit(EXTENT_FLAG_FILLING, &em->flags);
	}

	try_merge_map(tree, em);

	if (prealloc) {
		em->mod_start =3D em->start;
		em->mod_len =3D em->len;
	}

	free_extent_map(em);
out:
	write_unlock(&tree->lock);
	return ret;

}

void clear_em_logging(struct extent_map_tree *tree, struct extent_map *em=
)
{
	clear_bit(EXTENT_FLAG_LOGGING, &em->flags);
	if (extent_map_in_tree(em))
		try_merge_map(tree, em);
}

static inline void setup_extent_mapping(struct extent_map_tree *tree,
					struct extent_map *em,
					int modified)
{
	atomic_inc(&em->refs);
	em->mod_start =3D em->start;
	em->mod_len =3D em->len;

	if (modified)
		list_move(&em->list, &tree->modified_extents);
	else
		try_merge_map(tree, em);
}

/**
 * add_extent_mapping - add new extent map to the extent tree
 * @tree:	tree to insert new map in
 * @em:		map to insert
 *
 * Insert @em into @tree or perform a simple forward/backward merge with
 * existing mappings.  The extent_map struct passed in will be inserted
 * into the tree directly, with an additional reference taken, or a
 * reference dropped if the merge attempt was successful.
 */
int add_extent_mapping(struct extent_map_tree *tree,
		       struct extent_map *em, int modified)
{
	int ret =3D 0;

	ret =3D tree_insert(&tree->map, em);
	if (ret)
		goto out;

	setup_extent_mapping(tree, em, modified);
out:
	return ret;
}

static struct extent_map *
__lookup_extent_mapping(struct extent_map_tree *tree,
			u64 start, u64 len, int strict)
{
	struct extent_map *em;
	struct rb_node *rb_node;
	struct rb_node *prev =3D NULL;
	struct rb_node *next =3D NULL;
	u64 end =3D range_end(start, len);

	rb_node =3D __tree_search(&tree->map, start, &prev, &next);
	if (!rb_node) {
		if (prev)
			rb_node =3D prev;
		else if (next)
			rb_node =3D next;
		else
			return NULL;
	}

	em =3D rb_entry(rb_node, struct extent_map, rb_node);

	if (strict && !(end > em->start && start < extent_map_end(em)))
		return NULL;

	atomic_inc(&em->refs);
	return em;
}

/**
 * lookup_extent_mapping - lookup extent_map
 * @tree:	tree to lookup in
 * @start:	byte offset to start the search
 * @len:	length of the lookup range
 *
 * Find and return the first extent_map struct in @tree that intersects t=
he
 * [start, len] range.  There may be additional objects in the tree that
 * intersect, so check the object returned carefully to make sure that no=

 * additional lookups are needed.
 */
struct extent_map *lookup_extent_mapping(struct extent_map_tree *tree,
					 u64 start, u64 len)
{
	return __lookup_extent_mapping(tree, start, len, 1);
}

/**
 * search_extent_mapping - find a nearby extent map
 * @tree:	tree to lookup in
 * @start:	byte offset to start the search
 * @len:	length of the lookup range
 *
 * Find and return the first extent_map struct in @tree that intersects t=
he
 * [start, len] range.
 *
 * If one can't be found, any nearby extent may be returned
 */
struct extent_map *search_extent_mapping(struct extent_map_tree *tree,
					 u64 start, u64 len)
{
	return __lookup_extent_mapping(tree, start, len, 0);
}

/**
 * remove_extent_mapping - removes an extent_map from the extent tree
 * @tree:	extent tree to remove from
 * @em:		extent map beeing removed
 *
 * Removes @em from @tree.  No reference counts are dropped, and no check=
s
 * are done to see if the range is in use
 */
int remove_extent_mapping(struct extent_map_tree *tree, struct extent_map=
 *em)
{
	int ret =3D 0;

	WARN_ON(test_bit(EXTENT_FLAG_PINNED, &em->flags));
	rb_erase(&em->rb_node, &tree->map);
	if (!test_bit(EXTENT_FLAG_LOGGING, &em->flags))
		list_del_init(&em->list);
	RB_CLEAR_NODE(&em->rb_node);
	return ret;
}

void replace_extent_mapping(struct extent_map_tree *tree,
			    struct extent_map *cur,
			    struct extent_map *new,
			    int modified)
{
	WARN_ON(test_bit(EXTENT_FLAG_PINNED, &cur->flags));
	ASSERT(extent_map_in_tree(cur));
	if (!test_bit(EXTENT_FLAG_LOGGING, &cur->flags))
		list_del_init(&cur->list);
	rb_replace_node(&cur->rb_node, &new->rb_node, &tree->map);
	RB_CLEAR_NODE(&cur->rb_node);

	setup_extent_mapping(tree, new, modified);
}

--------------000905000609030705080705--

--jNxtP3SX95h1dnRgscJ7pkjLH5H9Md4ts
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWZj9hAAoJEDNpRerHpGkmW5kH/RFKqXjDI4hbcsw31DFB5npm
8ugJgzAWrXLdDawQ19bsI92kuD+up3bWjqsqd7rXaRx8RTGAN2Cvr063trzivIzc
mzGeNWq5q/k6nk5+LIIZlaoGpe8ldthA2o0Z+TF/UG2ooNv7cG24SpChHF2N8OtZ
ewTpjJL2qWc8bYNvWGOhpPQOuZn2ZNV6vd+nERfqpCVp8cV0Jj1x2SV+gzzCy0gE
QUOO9dySHpJrrdiVklltU7Tj4/DrOMW4zwKDDcOPi3BZycEwC632hLpB2b9MnL/z
f2K8q9fCLfvIgoEt7HdS+YlMsUOM1mde8qYxnXVjrlsMkd7oJDcKgXYtG7lmfYk=
=/dkc
-----END PGP SIGNATURE-----

--jNxtP3SX95h1dnRgscJ7pkjLH5H9Md4ts--
