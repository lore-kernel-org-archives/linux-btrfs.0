Return-Path: <SRS0=csn1=7W=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 324E7C433E0
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Jun 2020 01:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0C2720737
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Jun 2020 01:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591664638;
	bh=7lCL1hVeQtz8UAGaoIfOTGrlJ/SDpMvUCqHKhlreOeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=OX1b13zvTMshTLJNVvrdWvLutZ3F7Lo2nMNfdizYtlp5dwXb2KdevOc9SXvwAVUys
	 cNM5MXeoWRZUiuP9/7eQeR7Jp8Z1N+k1xgL+HHnh4ZDpTc7DIiOEvUyLx+FeFFhHpc
	 rLqIramQ3bHrEWDpEV0rbErpPMI7cgJYBMIvMQHo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgFIBD5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 21:03:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:52032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727939AbgFHXHg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jun 2020 19:07:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D502E20801;
        Mon,  8 Jun 2020 23:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657655;
        bh=7lCL1hVeQtz8UAGaoIfOTGrlJ/SDpMvUCqHKhlreOeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XEL/+7mLxvvUxT2QKq39eZVZZaS/2ZOBpbcH4wqXloqqDLsb5I5cShQj8Sem/LCvd
         ZCKyYUupsC6Dzb/TJLJ9WYinUVnMBPa6oQeDnIrk0i3+pxg3NObhKfEHdJaYenATPs
         LMK4dC5JX4kG1m02DO2jG92XSmK3d3dqEid21ziQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 068/274] btrfs: do not ignore error from btrfs_next_leaf() when inserting checksums
Date:   Mon,  8 Jun 2020 19:02:41 -0400
Message-Id: <20200608230607.3361041-68-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 7e4a3f7ed5d54926ec671bbb13e171cfe179cc50 ]

We are currently treating any non-zero return value from btrfs_next_leaf()
the same way, by going to the code that inserts a new checksum item in the
tree. However if btrfs_next_leaf() returns an error (a value < 0), we
should just stop and return the error, and not behave as if nothing has
happened, since in that case we do not have a way to know if there is a
next leaf or we are currently at the last leaf already.

So fix that by returning the error from btrfs_next_leaf().

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/file-item.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index b618ad5339ba..a88a8bf4b12c 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -887,10 +887,12 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 		nritems = btrfs_header_nritems(path->nodes[0]);
 		if (!nritems || (path->slots[0] >= nritems - 1)) {
 			ret = btrfs_next_leaf(root, path);
-			if (ret == 1)
+			if (ret < 0) {
+				goto out;
+			} else if (ret > 0) {
 				found_next = 1;
-			if (ret != 0)
 				goto insert;
+			}
 			slot = path->slots[0];
 		}
 		btrfs_item_key_to_cpu(path->nodes[0], &found_key, slot);
-- 
2.25.1

