Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2F5C43612
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C6FA20827
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 19:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546977087;
	bh=4AI3cYNAOEQ9fNIgynvtpYAmBJJtusqf+A0dARY8tR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=NEF10hrjT0x83ejOMi4G15CPDduuAwD/h588iLC3moB28GbTos3fRCRliCAs0K+dp
	 2aWlg+wI1iU6vg/BroOiWLGNJezJTm8L+R/10eYyvlBjVYBzc0qz5gNr0wubxUUFDL
	 ENbTP4keeHo+PYTKsdHA9yGpObwRbbGvMpKCc/Ts=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732618AbfAHTv0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:51:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:39496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731035AbfAHTbZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 14:31:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7DF320665;
        Tue,  8 Jan 2019 19:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546975883;
        bh=4AI3cYNAOEQ9fNIgynvtpYAmBJJtusqf+A0dARY8tR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tqxN7Bjqp3D+2125j86EArHcjCp1oDz/0HhkO80eP0sJsMombYAFcYD0Xt44X3iqf
         ZyrzeTXxMZbK1n21dz7cwdQYzMAWkxtT3KtO7rXpujeWPI9N6QoPbyy6oeY6goy8Ka
         wXo5kxWFbWBJugQZPVVdsZKOJvW8xgUNAWg8sr0c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 60/97] Btrfs: fix access to available allocation bits when starting balance
Date:   Tue,  8 Jan 2019 14:29:09 -0500
Message-Id: <20190108192949.122407-60-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190108192949.122407-1-sashal@kernel.org>
References: <20190108192949.122407-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 5a8067c0d17feb7579db0476191417b441a8996e ]

The available allocation bits members from struct btrfs_fs_info are
protected by a sequence lock, and when starting balance we access them
incorrectly in two different ways:

1) In the read sequence lock loop at btrfs_balance() we use the values we
   read from fs_info->avail_*_alloc_bits and we can immediately do actions
   that have side effects and can not be undone (printing a message and
   jumping to a label). This is wrong because a retry might be needed, so
   our actions must not have side effects and must be repeatable as long
   as read_seqretry() returns a non-zero value. In other words, we were
   essentially ignoring the sequence lock;

2) Right below the read sequence lock loop, we were reading the values
   from avail_metadata_alloc_bits and avail_data_alloc_bits without any
   protection from concurrent writers, that is, reading them outside of
   the read sequence lock critical section.

So fix this by making sure we only read the available allocation bits
while in a read sequence lock critical section and that what we do in the
critical section is repeatable (has nothing that can not be undone) so
that any eventual retry that is needed is handled properly.

Fixes: de98ced9e743 ("Btrfs: use seqlock to protect fs_info->avail_{data, metadata, system}_alloc_bits")
Fixes: 14506127979a ("btrfs: fix a bogus warning when converting only data or metadata")
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 064e86c069ec..0ee1cd4b56fb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3712,6 +3712,7 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 	int ret;
 	u64 num_devices;
 	unsigned seq;
+	bool reducing_integrity;
 
 	if (btrfs_fs_closing(fs_info) ||
 	    atomic_read(&fs_info->balance_pause_req) ||
@@ -3796,24 +3797,30 @@ int btrfs_balance(struct btrfs_fs_info *fs_info,
 		     !(bctl->sys.target & allowed)) ||
 		    ((bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
 		     (fs_info->avail_metadata_alloc_bits & allowed) &&
-		     !(bctl->meta.target & allowed))) {
-			if (bctl->flags & BTRFS_BALANCE_FORCE) {
-				btrfs_info(fs_info,
-				"balance: force reducing metadata integrity");
-			} else {
-				btrfs_err(fs_info,
-	"balance: reduces metadata integrity, use --force if you want this");
-				ret = -EINVAL;
-				goto out;
-			}
-		}
+		     !(bctl->meta.target & allowed)))
+			reducing_integrity = true;
+		else
+			reducing_integrity = false;
+
+		/* if we're not converting, the target field is uninitialized */
+		meta_target = (bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) ?
+			bctl->meta.target : fs_info->avail_metadata_alloc_bits;
+		data_target = (bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) ?
+			bctl->data.target : fs_info->avail_data_alloc_bits;
 	} while (read_seqretry(&fs_info->profiles_lock, seq));
 
-	/* if we're not converting, the target field is uninitialized */
-	meta_target = (bctl->meta.flags & BTRFS_BALANCE_ARGS_CONVERT) ?
-		bctl->meta.target : fs_info->avail_metadata_alloc_bits;
-	data_target = (bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) ?
-		bctl->data.target : fs_info->avail_data_alloc_bits;
+	if (reducing_integrity) {
+		if (bctl->flags & BTRFS_BALANCE_FORCE) {
+			btrfs_info(fs_info,
+				   "balance: force reducing metadata integrity");
+		} else {
+			btrfs_err(fs_info,
+	  "balance: reduces metadata integrity, use --force if you want this");
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
 	if (btrfs_get_num_tolerated_disk_barrier_failures(meta_target) <
 		btrfs_get_num_tolerated_disk_barrier_failures(data_target)) {
 		int meta_index = btrfs_bg_flags_to_raid_index(meta_target);
-- 
2.19.1

