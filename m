Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37AEC04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 06:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6DA720878
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 06:59:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6DA720878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbeLFG7J (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 01:59:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:59414 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728489AbeLFG7J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 01:59:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2A83BAE98
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Dec 2018 06:59:07 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/8] btrfs: Refactor delayed ref parameter list
Date:   Thu,  6 Dec 2018 14:58:55 +0800
Message-Id: <20181206065903.11343-1-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Current delayed ref interface has several problems:
- Longer and longer parameter lists
  bytenr
  num_bytes
  parent
  ---- So far so good
  ref_root
  owner
  offset
  ---- I don't feel well now
  for_reloc
  ^^^^ This parameter only makes sense for qgroup code, but we need
       to pass the parameter a long way.

  This makes later expand on parameter list more and more tricky.

- Different interpretation for the same parameter
  Above @owner for data ref is ino who owns this extent,
  while for tree ref, it's level. They are even in different size range.

  For level we only need 0~8, while for ino it's
  BTRFS_FIRST_FREE_OBJECTID~BTRFS_LAST_FREE_OBJECTID, so it's still
  possible to distinguish them, but it's never a straight-forward thing
  to grasp.

  And @offset doesn't even makes sense for tree ref.

  Such parameter reuse may look clever as an hidden union, but it
  destroys code readability.

This patchset will change the way how we pass parameters for delayed
ref.
Instead of calling delayed ref interface like:
  ret = btrfs_inc_extent_ref(trans, root, bytenr, num_bytes, parent,
			     ref_root, owner, offset);
Or
  ret = btrfs_inc_extent_ref(trans, root, bytenr, nodesize, parent,
			     level, ref_root, 0);

We now call like:
  btrfs_init_generic_ref(&ref, bytenr, num_bytes,
			 root->root_key.objectid, parent);
  btrfs_init_data_ref(&ref, ref_root, owner, offset);
  ret = btrfs_inc_extent_ref(trans, &ref);
Or
  btrfs_init_generic_ref(&ref, bytenr, num_bytes,
			 root->root_key.objectid, parent);
  btrfs_init_tree_ref(&ref, level, ref_root);
  ret = btrfs_inc_extent_ref(trans, &ref);

To determine if a ref is tree or data, instead of calling like:
  if (owner < BTRFS_FIRST_FREE_OBJECTID) {
  } else {
  }
We do it straight-forward:
  if (ref->type == BTRFS_REF_METADATA) {
  } else {
  }

And for newer and minor new members, we don't need to add a new
parameter to btrfs_add_delayed_tree|data_ref() or
btrfs_inc_extent_ref(), just assign them after generic/data/tree init:
  btrfs_init_generic_ref(&ref, bytenr, num_bytes,
			 root->root_key.objectid, parent);
  btrfs_init_data_ref(&ref, ref_root, owner, offset);
  ref->skip_qgroup = true; /* @skip_qgroup is default to false, so new
			      code doesn't need to care */
  ret = btrfs_inc_extent_ref(trans, &ref);

This should improve the code readability and make later code easier to
write.


Qu Wenruo (8):
  btrfs: delayed-ref: Introduce better documented delayed ref structures
  btrfs: extent-tree: Open-code process_func in __btrfs_mod_ref
  btrfs: delayed-ref: Use btrfs_ref to refactor
    btrfs_add_delayed_tree_ref()
  btrfs: delayed-ref: Use btrfs_ref to refactor
    btrfs_add_delayed_data_ref()
  btrfs: ref-verify: Use btrfs_ref to refactor btrfs_ref_tree_mod()
  btrfs: extent-tree: Use btrfs_ref to refactor add_pinned_bytes()
  btrfs: extent-tree: Use btrfs_ref to refactor btrfs_inc_extent_ref()
  btrfs: extent-tree: Use btrfs_ref to refactor btrfs_free_extent()

 fs/btrfs/ctree.h       |  11 +--
 fs/btrfs/delayed-ref.c |  43 ++++++---
 fs/btrfs/delayed-ref.h | 121 +++++++++++++++++++++++--
 fs/btrfs/extent-tree.c | 195 +++++++++++++++++++----------------------
 fs/btrfs/file.c        |  43 +++++----
 fs/btrfs/inode.c       |  23 +++--
 fs/btrfs/ioctl.c       |  17 ++--
 fs/btrfs/ref-verify.c  |  53 ++++++-----
 fs/btrfs/ref-verify.h  |  10 +--
 fs/btrfs/relocation.c  |  70 +++++++++------
 fs/btrfs/tree-log.c    |  12 ++-
 11 files changed, 375 insertions(+), 223 deletions(-)

-- 
2.19.2

