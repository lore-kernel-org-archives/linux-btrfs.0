Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E241C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11C7B20821
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:29:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ljK5Z0em"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbfAIB3I (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:29:08 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33314 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729371AbfAIB1f (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:35 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so6056025wrr.0;
        Tue, 08 Jan 2019 17:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/673uL4vlQMZBXJmxviPI34h12gFdF0Rlg9s5QdcR5o=;
        b=ljK5Z0emcK72bH4yw6g/LKs6hBT112EBdIW2lGjy8rfyhL18kNMnTE+85XeP2MRAoX
         j8d3qFmmtggvbUchps2nIGSuLqd9V2GibkVcRxFOaK7D82EqJ3z+YHz4QoG4TicVkxId
         3+GfUq9qQlFGb78fcMEuS4K5GC/MFbdNUFjh1HsHXoS1i5PcLQKGA7AuEljfEABPB1JJ
         jnKiQFq4n27B6XA3mISc4+tFrTeiqccGxWkec5lE1FPJNZzNJBqwcni/x1GP4Z72R56v
         UMJaxfO/lyuw7URtaLHjLfTR7aPMkAuQYvNVAo2NMrwEbAa5L4+lsoMzcJ4RPlatajn5
         ia7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=/673uL4vlQMZBXJmxviPI34h12gFdF0Rlg9s5QdcR5o=;
        b=LUMQ5KUEBG9sI79nFEtMIxtCAFhlIbzqQfag+QhACFhQhgl5MRL0k3GoAeM5or6JZy
         8tr73Y98zEaSJDbofyLV80cWh4mEConVCVl9Mv+5C+x9swXlqak/vvpf3xcjse5s6tsY
         aiMxkgwR/wndylxGdK6NMvw3C0y4lUKmmc1SFfQclPYEKFUl3EHomSfsDpNG4Al+ymPH
         27wXm/XEM+tbahKSsHvDRnIBPaKdXbkrlbB618MobWixeCn0OnZEdJLkM2kI197f3eu0
         VKf0eS7Z50mf+1JcbCsaUvkFzSVKC21NU2MKk4tXL3s3J0qm+T2HRIQXoHJ49H7SHTXy
         wDlA==
X-Gm-Message-State: AJcUukejgr0NFUkQ20Ao2HoFAfnMUjh4Y4tY8mYyKL6HxEGu/bjWA7Kz
        54bIJf2bhMFJ7SRoeidhDKc=
X-Google-Smtp-Source: ALg8bN6gCnmo+vXqrk2Ryc673oA9NKrFJ7KkRapkjmW9Nf0oJhdAqvTVPBUU9i4GBgRB6vJHzXPouA==
X-Received: by 2002:adf:e54a:: with SMTP id z10mr3011799wrm.238.1546997253101;
        Tue, 08 Jan 2019 17:27:33 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:32 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 07/19] btrfs: add new keys to key root when flushed
Date:   Wed,  9 Jan 2019 01:26:49 +0000
Message-Id: <20190109012701.26441-7-mark@harmstone.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190109012701.26441-1-mark@harmstone.com>
References: <20190109012701.26441-1-mark@harmstone.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Signed-off-by: Mark Harmstone <mark@harmstone.com>
---
 fs/btrfs/transaction.c | 79 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index d1eeef9ec5da..a6c8d49b6962 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -19,6 +19,7 @@
 #include "volumes.h"
 #include "dev-replace.h"
 #include "qgroup.h"
+#include "encryption.h"
 
 #define BTRFS_ROOT_TRANS_TAG 0
 
@@ -520,7 +521,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	 * and then we deadlock with somebody doing a freeze.
 	 *
 	 * If we are ATTACH, it means we just want to catch the current
-	 * transaction and commit it, so we needn't do sb_start_intwrite(). 
+	 * transaction and commit it, so we needn't do sb_start_intwrite().
 	 */
 	if (type & __TRANS_FREEZABLE)
 		sb_start_intwrite(fs_info->sb);
@@ -1918,12 +1919,74 @@ btrfs_wait_pending_ordered(struct btrfs_transaction *cur_trans)
 		   atomic_read(&cur_trans->pending_ordered) == 0);
 }
 
+static int flush_key(struct btrfs_trans_handle *trans,
+		     struct btrfs_enc_key *k)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	struct btrfs_encryption_key_item *item;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	path->leave_spinning = 1;
+
+	if (!fs_info->key_root) {
+		struct btrfs_root *root;
+
+		root = btrfs_create_tree(trans, fs_info,
+					 BTRFS_KEY_TREE_OBJECTID);
+
+		if (IS_ERR(root)) {
+			btrfs_free_path(path);
+			return PTR_ERR(root);
+		}
+
+		fs_info->key_root = root;
+
+		btrfs_set_fs_incompat(fs_info, ENCRYPTION);
+	}
+
+	key.objectid = k->key_number;
+	key.type = BTRFS_ENCRYPTION_KEY;
+	key.offset = 0;
+
+	ret = btrfs_insert_empty_item(trans, fs_info->key_root, path, &key,
+				      sizeof(struct btrfs_encryption_key_item));
+
+	if (ret) {
+		btrfs_free_path(path);
+		return ret;
+	}
+
+	leaf = path->nodes[0];
+
+	btrfs_mark_buffer_dirty(leaf);
+
+	item = btrfs_item_ptr(leaf, path->slots[0],
+			      struct btrfs_encryption_key_item);
+
+	write_eb_member(leaf, item, struct btrfs_encryption_key_item,
+			key_id, k->key_id);
+
+	btrfs_free_path(path);
+
+	k->added = false;
+
+	return ret;
+}
+
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_transaction *prev_trans = NULL;
 	int ret;
+	struct btrfs_enc_key *key;
 
 	/* Stop the commit early if ->aborted is set */
 	if (unlikely(READ_ONCE(cur_trans->aborted))) {
@@ -2071,6 +2134,20 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 		ret = cur_trans->aborted;
 		goto scrub_continue;
 	}
+
+	down_read(&fs_info->key_sem);
+
+	list_for_each_entry(key, &fs_info->key_list, key_list) {
+		if (key->added && key->used) {
+			ret = flush_key(trans, key);
+
+			if (ret)
+				goto scrub_continue;
+		}
+	}
+
+	up_read(&fs_info->key_sem);
+
 	/*
 	 * the reloc mutex makes sure that we stop
 	 * the balancing code from coming in and moving
-- 
2.19.2

