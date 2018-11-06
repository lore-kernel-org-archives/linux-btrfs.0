Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FA95C46464
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 591642081D
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:41:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 591642081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387578AbeKFQFV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 11:05:21 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:31748 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387527AbeKFQFV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2018 11:05:21 -0500
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="47417668"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 06 Nov 2018 14:41:38 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 705414B71EA0;
        Tue,  6 Nov 2018 14:41:37 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 6 Nov
 2018 14:41:41 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH v15.1 12/13] btrfs: relocation: Enhance error handling to avoid BUG_ON
Date:   Tue, 6 Nov 2018 14:41:21 +0800
Message-ID: <20181106064122.6154-13-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
References: <20181106064122.6154-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 705414B71EA0.A8AF1
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Qu Wenruo <quwenruo@cn.fujitsu.com>

Since the introduction of btrfs dedupe tree, it's possible that balance can
race with dedupe disabling.

When this happens, dedupe_enabled will make btrfs_get_fs_root() return
PTR_ERR(-ENOENT).
But due to a bug in error handling branch, when this happens
backref_cache->nr_nodes is increased but the node is neither added to
backref_cache or nr_nodes decreased.
Causing BUG_ON() in backref_cache_cleanup()

[ 2611.668810] ------------[ cut here ]------------
[ 2611.669946] kernel BUG at
/home/sat/ktest/linux/fs/btrfs/relocation.c:243!
[ 2611.670572] invalid opcode: 0000 [#1] SMP
[ 2611.686797] Call Trace:
[ 2611.687034]  [<ffffffffa01f71d3>]
btrfs_relocate_block_group+0x1b3/0x290 [btrfs]
[ 2611.687706]  [<ffffffffa01cc177>]
btrfs_relocate_chunk.isra.40+0x47/0xd0 [btrfs]
[ 2611.688385]  [<ffffffffa01cdb12>] btrfs_balance+0xb22/0x11e0 [btrfs]
[ 2611.688966]  [<ffffffffa01d9611>] btrfs_ioctl_balance+0x391/0x3a0
[btrfs]
[ 2611.689587]  [<ffffffffa01ddaf0>] btrfs_ioctl+0x1650/0x2290 [btrfs]
[ 2611.690145]  [<ffffffff81171cda>] ? lru_cache_add+0x3a/0x80
[ 2611.690647]  [<ffffffff81171e4c>] ?
lru_cache_add_active_or_unevictable+0x4c/0xc0
[ 2611.691310]  [<ffffffff81193f04>] ? handle_mm_fault+0xcd4/0x17f0
[ 2611.691842]  [<ffffffff811da423>] ? cp_new_stat+0x153/0x180
[ 2611.692342]  [<ffffffff8119913d>] ? __vma_link_rb+0xfd/0x110
[ 2611.692842]  [<ffffffff81199209>] ? vma_link+0xb9/0xc0
[ 2611.693303]  [<ffffffff811e7e81>] do_vfs_ioctl+0xa1/0x5a0
[ 2611.693781]  [<ffffffff8104e024>] ? __do_page_fault+0x1b4/0x400
[ 2611.694310]  [<ffffffff811e83c1>] SyS_ioctl+0x41/0x70
[ 2611.694758]  [<ffffffff816dfc6e>] entry_SYSCALL_64_fastpath+0x12/0x71
[ 2611.695331] Code: ff 48 8b 45 bf 49 83 af a8 05 00 00 01 49 89 87 a0
05 00 00 e9 2e fd ff ff b8 f4 ff ff ff e9 e4 fb ff ff 0f 0b 0f 0b 0f 0b
0f 0b <0f> 0b 0f 0b 41 89 c6 e9 b8 fb ff ff e8 9e a6 e8 e0 4c 89 e7 44
[ 2611.697870] RIP  [<ffffffffa01f6fc1>]
relocate_block_group+0x741/0x7a0 [btrfs]
[ 2611.698818]  RSP <ffff88002a81fb30>

This patch will call remove_backref_node() in error handling branch, and
cache the returned -ENOENT in relocate_tree_block() and continue
balancing.

Reported-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/relocation.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b7c304c6e741..ee96390d1e42 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -854,6 +854,13 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 		root = read_fs_root(rc->extent_root->fs_info, key.offset);
 		if (IS_ERR(root)) {
 			err = PTR_ERR(root);
+			/*
+			 * Don't forget to cleanup current node.
+			 * As it may not be added to backref_cache but nr_node
+			 * increased.
+			 * This will cause BUG_ON() in backref_cache_cleanup().
+			 */
+			remove_backref_node(&rc->backref_cache, cur);
 			goto out;
 		}
 
@@ -3021,8 +3028,15 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 		node = build_backref_tree(rc, &block->key,
 					  block->level, block->bytenr);
 		if (IS_ERR(node)) {
+			/*
+			 * The root(dedupe tree yet) of the tree block is
+			 * going to be freed and can't be reached.
+			 * Just skip it and continue balancing.
+			 */
+			if (PTR_ERR(node) == -ENOENT)
+				continue;
 			err = PTR_ERR(node);
-			goto out;
+			break;
 		}
 
 		ret = relocate_tree_block(trans, rc, node, &block->key,
@@ -3030,10 +3044,9 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 		if (ret < 0) {
 			if (ret != -EAGAIN || &block->rb_node == rb_first(blocks))
 				err = ret;
-			goto out;
+			break;
 		}
 	}
-out:
 	err = finish_pending_nodes(trans, rc, path, err);
 
 out_free_path:
-- 
2.19.1



