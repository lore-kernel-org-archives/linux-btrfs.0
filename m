Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32719 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751581AbaCHAAU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Mar 2014 19:00:20 -0500
Message-ID: <531A5D88.1020308@fb.com>
Date: Fri, 7 Mar 2014 19:00:08 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 4/9] Btrfs: use bitfield instead of integer data type
 for the some variants in btrfs_root
References: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com> <1392890939-19044-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1392890939-19044-4-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/20/2014 05:08 AM, Miao Xie wrote:
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com> --- fs/btrfs/ctree.c
> | 25 ++++++++++++++----------- fs/btrfs/ctree.h       | 39
> +++++++++++++++++++++------------------ fs/btrfs/disk-io.c     | 33
> +++++++++++++++------------------ fs/btrfs/extent-tree.c |  6
> +++--- fs/btrfs/file.c        |  4 +++- fs/btrfs/inode.c       | 29
> ++++++++++++++++++----------- fs/btrfs/ioctl.c       |  4 ++-- 
> fs/btrfs/relocation.c  | 17 +++++++++-------- fs/btrfs/root-tree.c
> |  2 +- fs/btrfs/transaction.c | 33
> +++++++++++++++++---------------- fs/btrfs/tree-defrag.c |  2 +- 
> fs/btrfs/tree-log.c    |  9 +++++---- 12 files changed, 109
> insertions(+), 94 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c index
> cbd3a7d..9067d79 100644 --- a/fs/btrfs/ctree.c +++
> b/fs/btrfs/ctree.c @@ -224,7 +224,8 @@ static struct extent_buffer
> *btrfs_read_lock_root_node(struct btrfs_root *root) static void
> add_root_to_dirty_list(struct btrfs_root *root) { 
> spin_lock(&root->fs_info->trans_lock); -	if (root->track_dirty &&
> list_empty(&root->dirty_list)) { +	if
> (test_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state) && +
> list_empty(&root->dirty_list)) { list_add(&root->dirty_list, 
> &root->fs_info->dirty_cowonly_roots); } @@ -246,9 +247,10 @@ int
> btrfs_copy_root(struct btrfs_trans_handle *trans, int level; struct
> btrfs_disk_key disk_key;
> 
> -	WARN_ON(root->ref_cows && trans->transid != -
> root->fs_info->running_transaction->transid); -
> WARN_ON(root->ref_cows && trans->transid != root->last_trans); +
> WARN_ON(test_bit(BTRFS_ROOT_REF_COWS, &root->state) && +
> trans->transid != root->fs_info->running_transaction->transid); +
> WARN_ON(test_bit(BTRFS_ROOT_REF_COWS, &root->state) && +
> trans->transid != root->last_trans);
> 
> level = btrfs_header_level(buf); if (level == 0) @@ -997,14 +999,14
> @@ int btrfs_block_can_be_shared(struct btrfs_root *root, *
> snapshot and the block was not allocated by tree relocation, * we
> know the block is not shared. */ -	if (root->ref_cows && +	if
> (test_bit(BTRFS_ROOT_REF_COWS, &root->state) && buf != root->node
> && buf != root->commit_root && (btrfs_header_generation(buf) <= 
> btrfs_root_last_snapshot(&root->root_item) || 
> btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC))) return 1; #ifdef
> BTRFS_COMPAT_EXTENT_TREE_V0 -	if (root->ref_cows && +	if
> (test_bit(BTRFS_ROOT_REF_COWS, &root->state) && 
> btrfs_header_backref_rev(buf) < BTRFS_MIXED_BACKREF_REV) return 1; 
> #endif @@ -1146,9 +1148,10 @@ static noinline int
> __btrfs_cow_block(struct btrfs_trans_handle *trans,
> 
> btrfs_assert_tree_locked(buf);
> 
> -	WARN_ON(root->ref_cows && trans->transid != -
> root->fs_info->running_transaction->transid); -
> WARN_ON(root->ref_cows && trans->transid != root->last_trans); +
> WARN_ON(test_bit(BTRFS_ROOT_REF_COWS, &root->state) && +
> trans->transid != root->fs_info->running_transaction->transid); +
> WARN_ON(test_bit(BTRFS_ROOT_REF_COWS, &root->state) && +
> trans->transid != root->last_trans);
> 
> level = btrfs_header_level(buf);
> 
> @@ -1193,7 +1196,7 @@ static noinline int __btrfs_cow_block(struct
> btrfs_trans_handle *trans, return ret; }
> 
> -	if (root->ref_cows) { +	if (test_bit(BTRFS_ROOT_REF_COWS,
> &root->state)) { ret = btrfs_reloc_cow_block(trans, root, buf,
> cow); if (ret) return ret; @@ -1556,7 +1559,7 @@ static inline int
> should_cow_block(struct btrfs_trans_handle *trans, 
> !btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN) && 
> !(root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID && 
> btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC)) && -
> !root->force_cow) +	    !test_bit(BTRFS_ROOT_REF_COWS,
> &root->state))

This may or may not be the problem.  Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTGl2IAAoJEANb+wAKly3Br0EQAKWfEahMQ1ZV9jkgSYF/9c6r
ytoH2/Y3u7HYeeqf+Z/j2lkMyvAaWQ9EQCkWSUyCqoU7RPXHEROSCQ11UCk8qYXh
fhV2r3plOWIZ/KDHFvqPTN5FTg97OLvDalyvOR6UP/Ws6Z4Ycm0ePm7kb+25iK9u
N+PkiqHoQqUVw8Z2EEJ2SN/82SyNnuPDG2RkDD9xW8el5fBplAPgUox8W8Z+ubIo
FPiSNv4euly2Zco+Vs3NDFb2tqQBPyAVzE2IC4Nyq1Hci/vyC9k8YfIcCJnsP0Dk
10mVDhSSStWLuqt2L7fUV8nOTyjKT1gBNgoz/eMBeOzWLDbRKD2hpS6wpkw/6/iQ
/ff9Spikw7a87epYo4dxft32aQsDIu6JfgFPggL+VkXyn114MK4U5z7KNOPQUSBq
neFOVELgN1L75TI9v9/p1qKGeZ47vV1lvd6GP717SDF0yv9wgvHR0Ma47KSaLq79
WlwzmqXDYJYdOedKGQky6GZ7EFji5DDlazx7h1pQTN5rEdiQJTEFxrxtMOKzAttF
3EL9wxVAi2ggD2EYWWsk+SJNJxgU59bxTR9ZiOH+tj29+gFcGUpRsXMsj4KampK1
j0a0BSLj+1yUlLcT8qem05aJk720zxy4UBiZGcRP7qySlrOTwU5Xtk0BXXyfUXLg
guOgjR0pj494irbM53RT
=H5nB
-----END PGP SIGNATURE-----
