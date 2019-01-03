Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A371CC43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 07:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55E222073D
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 07:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbfACHc1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 02:32:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:46022 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728276AbfACHc0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 02:32:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1FA9AB00D
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 07:32:25 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/5] Fix incorrectly created uuid tree
Date:   Thu,  3 Jan 2019 15:32:16 +0800
Message-Id: <20190103073221.10525-1-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset can be fetched from github:
https://github.com/adam900710/btrfs-progs/tree/uuid_tree_support
Which is based on v4.19.1 tag.

Commit 2a496a5b8b74 ("btrfs-progs: mkfs: precreate the uuid tree")
creates uuid tree at mkfs time.

However it doesn't populate uuid tree correctly nor just create an empty
root.
It uses create_tree(), which just copies the content of fs root,
containing meaningless INODE_ITEM:

v4.15 mkfs (no uuid tree creation) + kernel mount:
  uuid tree key (UUID_TREE ROOT_ITEM 0)
  leaf 30572544 items 1 free space 16250 generation 7 owner UUID_TREE
  leaf 30572544 flags 0x1(WRITTEN) backref revision 1
  fs uuid 33ecddef-fc86-481a-93ce-846b01c11376
  chunk uuid 9e58f646-b0da-43ca-9c7d-8bbe3e120246
	item 0 key (0x92457c59d31491be UUID_KEY_SUBVOL 0xef908b5e79aa76a1) itemoff 16275 itemsize 8
		subvol_id 5

v4.19.1 mkfs (incorrect one), no kernel mount:
  uuid tree key (UUID_TREE ROOT_ITEM 0)
  leaf 30507008 items 2 free space 16061 generation 4 owner UUID_TREE
  leaf 30507008 flags 0x1(WRITTEN) backref revision 1
  fs uuid 162f5333-9b5d-4217-877c-ddaeaa79398e
  chunk uuid 7bc2c5c6-a6d2-4eec-a513-142b549c6541
	item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
		generation 3 transid 0 size 0 nbytes 16384
		block group 0 mode 40755 links 1 uid 0 gid 0 rdev 0
		sequence 0 flags 0x0(none)
	item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
		index 0 namelen 2 name: ..

This patchset will fix it by populuating uuid tree properly, as kernel
tree checker now doesn't accept empty uuid tree.

w/ this patchset, no kernel mount:
  uuid tree key (UUID_TREE ROOT_ITEM 0)
  leaf 30507008 items 1 free space 16250 generation 4 owner UUID_TREE
  leaf 30507008 flags 0x1(WRITTEN) backref revision 1
  fs uuid ae53079e-dbbc-409b-a565-5326c7b27731
  chunk uuid b5fb1bea-f20d-4af1-80f8-6ca3f0038d67
	item 0 key (0x334ba6b032d89c07 UUID_KEY_SUBVOL 0x86cde09cb78bcca0) itemoff 16275 itemsize 8
		subvol_id 5

changelog:
v2:
- Don't use btrfs_copy_root() to create empty root.
  Instead, use btrfs_create_tree() to create an empty tree and fill it
  from scratch.
- Rename functions:
  create_inode_root() -> create_data_reloc_root()
- Better patch order


Qu Wenruo (5):
  btrfs-progs: Export btrfs_create_tree() and move it to disk-io.c
  btrfs-progs: mkfs: Create data reloc tree from scratch
  btrfs-progs: uuid: Port kernel btrfs_uuid_tree_lookup()
  btrfs-progs: uuid: Port btrfs_uuid_tree_add() function
  btrfs-progs: Create uuid tree with proper contents

 ctree.h           |   7 ++-
 disk-io.c         |  94 ++++++++++++++++++++++++++++++-
 disk-io.h         |   5 +-
 free-space-tree.c |  72 ------------------------
 mkfs/main.c       | 131 +++++++++++++++++++++++++++++++------------
 uuid-tree.c       | 138 +++++++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 334 insertions(+), 113 deletions(-)

-- 
2.20.1

