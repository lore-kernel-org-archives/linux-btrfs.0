Return-Path: <SRS0=csn1=7W=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15AD5C433E0
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Jun 2020 01:04:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDCB220737
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Jun 2020 01:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591664643;
	bh=P9JcKZNM/8l/scsQa6x9Ys0iK7XhzU3x66U2UwdZeQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Hf4SL4+f8mdeKKdREUSYa6HZWP0rMlhJO5QL+zdOt06mdDcKQZxuL3Vymm3068Pas
	 sU04Fcdgmcs9K/PYktyJj4zM2z/ybHhG7jwlveSF+Z/R2/BozbvY/fMKUOvaQGqfoC
	 Msvfx9VIke5CZyQvQ1u1JbjPlVRDfnSF+92ccBj8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730543AbgFIBED (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 21:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbgFHXHf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Jun 2020 19:07:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B391E20885;
        Mon,  8 Jun 2020 23:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657654;
        bh=P9JcKZNM/8l/scsQa6x9Ys0iK7XhzU3x66U2UwdZeQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZ3HKNaWkgGU9iBOv0lhEAM32EnvC1FV529OMzedjSkyqOwPP0VjxQ3DNO5CM4wU+
         Uh3BsOLaxwna/S8KF8EtyNmBOIhCUD9lMNBZtHFyn83IzUK12/TljrH2IQBT28MviZ
         YdGyg4/+1ot/bTpN7PkNksYAgNy6lWwckbVuNOeQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 067/274] btrfs: account for trans_block_rsv in may_commit_transaction
Date:   Mon,  8 Jun 2020 19:02:40 -0400
Message-Id: <20200608230607.3361041-67-sashal@kernel.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit bb4f58a747f0421b10645fbf75a6acc88da0de50 ]

On ppc64le with 64k page size (respectively 64k block size) generic/320
was failing and debug output showed we were getting a premature ENOSPC
with a bunch of space in btrfs_fs_info::trans_block_rsv.

This meant there were still open transaction handles holding space, yet
the flusher didn't commit the transaction because it deemed the freed
space won't be enough to satisfy the current reserve ticket. Fix this
by accounting for space in trans_block_rsv when deciding whether the
current transaction should be committed or not.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Tested-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/space-info.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index ff17a4420358..3c0e9999bfd7 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -626,6 +626,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	struct reserve_ticket *ticket = NULL;
 	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_block_rsv;
 	struct btrfs_block_rsv *delayed_refs_rsv = &fs_info->delayed_refs_rsv;
+	struct btrfs_block_rsv *trans_rsv = &fs_info->trans_block_rsv;
 	struct btrfs_trans_handle *trans;
 	u64 bytes_needed;
 	u64 reclaim_bytes = 0;
@@ -688,6 +689,11 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
 	spin_lock(&delayed_refs_rsv->lock);
 	reclaim_bytes += delayed_refs_rsv->reserved;
 	spin_unlock(&delayed_refs_rsv->lock);
+
+	spin_lock(&trans_rsv->lock);
+	reclaim_bytes += trans_rsv->reserved;
+	spin_unlock(&trans_rsv->lock);
+
 	if (reclaim_bytes >= bytes_needed)
 		goto commit;
 	bytes_needed -= reclaim_bytes;
-- 
2.25.1

