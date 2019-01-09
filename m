Return-Path: <SRS0=3FID=PR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5226DC43444
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 220602146F
	for <linux-btrfs@archiver.kernel.org>; Wed,  9 Jan 2019 01:27:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6f4Enmi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbfAIB10 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 20:27:26 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37383 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729309AbfAIB1Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 20:27:25 -0500
Received: by mail-wr1-f66.google.com with SMTP id s12so6030268wrt.4;
        Tue, 08 Jan 2019 17:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CfIn1q5pu8L6jlVn3cbnKevtsWNnVw0UwjxYhhAlQO0=;
        b=O6f4EnmiqtWH81l7h2yglppFRLbDyG1lghdRkdFnB9ggQrszz1GAS1oy+MBXRWc3Kc
         PDXxj9NsiFRmSXYsbTeutkQZhgUmJvOCzybRYpS1EFsnBctkbFPg/UF8woD5B8wTnGcT
         RWijUIjK3q/m4CEPGLBi2KyCjXbbKnP+EPIWwKurzyWJ4570u46KiOdun4Y3zaaizIlD
         rq0Ok7S9wzZegokBkXyQ1Bt14wMSlFGgx/UhBt6lClLZEja8NHObCkN/S3Mto9QUoQBp
         j8dZGE+I6TvHolud7gtlnzWND3gM5rD3DDKVITkScJuISU91JV44S8YeQEXWyZDCdISV
         sKmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=CfIn1q5pu8L6jlVn3cbnKevtsWNnVw0UwjxYhhAlQO0=;
        b=ih+b40/OGoaY7zNYxgh3pZm/GAYk4qeuHxMA0gvH+HKLHKbyPbrIuwaKncwJdSnzVB
         Ftu5HPbCSw/0i1erEm/Hl2I9Uzci5n+4jKOl1WChcLYA+klD8+BcTf6NcAS7CKEbw4qd
         JfSioAoQoVNFIlA3NhXEbWKdYPpXalT44eolohxoFqomdayZhmRpowXdRGLNMVLfwwhk
         ltV3YDnigoum8MPF04UQh8C+gAPOrsSCmXVBwUknZE5lOVIb5KcSKoKtdEOy4p35NIrd
         6TA0pAtSvRRh8fEtjCLZD5gMZy5NFPgDLooMBtJBFMPhouj19ufQNPWK9NUvwHxoaLKV
         e5LQ==
X-Gm-Message-State: AJcUukcY+PACILBIRnTIK5wSvELgFn3sjbIh2VQAHwFHIENCsX1xMRw4
        7P1wE5kWM9uPTk9je7HDVi8=
X-Google-Smtp-Source: ALg8bN5zOnR5iIn0ldGRGMRBedlOxwuUJMy4z14K0fFG8dR9c086sEs9Vdeg1P/xjp52y39uUoOGLQ==
X-Received: by 2002:a5d:5443:: with SMTP id w3mr2913752wrv.4.1546997244140;
        Tue, 08 Jan 2019 17:27:24 -0800 (PST)
Received: from beren.harmstone.com ([88.97.13.154])
        by smtp.gmail.com with ESMTPSA id y34sm156915088wrd.68.2019.01.08.17.27.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 17:27:23 -0800 (PST)
From:   Mark Harmstone <mark@harmstone.com>
Cc:     mark@harmstone.com, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 03/19] btrfs: load key tree
Date:   Wed,  9 Jan 2019 01:26:45 +0000
Message-Id: <20190109012701.26441-3-mark@harmstone.com>
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
 fs/btrfs/ctree.h   |  2 ++
 fs/btrfs/disk-io.c | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 68f322f600a0..bd2e59dd0eba 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -758,6 +758,7 @@ struct btrfs_fs_info {
 	struct btrfs_root *quota_root;
 	struct btrfs_root *uuid_root;
 	struct btrfs_root *free_space_root;
+	struct btrfs_root *key_root;
 
 	/* the log root tree is a directory of all the other log roots */
 	struct btrfs_root *log_root_tree;
@@ -2957,6 +2958,7 @@ static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 	kfree(fs_info->quota_root);
 	kfree(fs_info->uuid_root);
 	kfree(fs_info->free_space_root);
+	kfree(fs_info->key_root);
 	kfree(fs_info->super_copy);
 	kfree(fs_info->super_for_commit);
 	security_free_mnt_opts(&fs_info->security_opts);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6d776717d8b3..a533c00855be 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1559,6 +1559,9 @@ struct btrfs_root *btrfs_get_fs_root(struct btrfs_fs_info *fs_info,
 	if (location->objectid == BTRFS_FREE_SPACE_TREE_OBJECTID)
 		return fs_info->free_space_root ? fs_info->free_space_root :
 						  ERR_PTR(-ENOENT);
+	if (location->objectid == BTRFS_KEY_TREE_OBJECTID)
+		return fs_info->key_root ? fs_info->key_root :
+					     ERR_PTR(-ENOENT);
 again:
 	root = btrfs_lookup_fs_root(fs_info, location->objectid);
 	if (root) {
@@ -2029,6 +2032,7 @@ static void free_root_pointers(struct btrfs_fs_info *info, int chunk_root)
 	if (chunk_root)
 		free_root_extent_buffers(info->chunk_root);
 	free_root_extent_buffers(info->free_space_root);
+	free_root_extent_buffers(info->key_root);
 }
 
 void btrfs_free_fs_roots(struct btrfs_fs_info *fs_info)
@@ -2349,6 +2353,13 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
 		fs_info->free_space_root = root;
 	}
 
+	location.objectid = BTRFS_KEY_TREE_OBJECTID;
+	root = btrfs_read_tree_root(tree_root, &location);
+	if (!IS_ERR(root)) {
+		set_bit(BTRFS_ROOT_TRACK_DIRTY, &root->state);
+		fs_info->key_root = root;
+	}
+
 	return 0;
 out:
 	btrfs_warn(fs_info, "failed to read root (objectid=%llu): %d",
-- 
2.19.2

