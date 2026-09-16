Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEB948C3E8
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 22:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789597038; cv=none; b=Ze7cjYl+zz89xGNt4MLEFWrWM/yBTf+BxM9anaYwNboHXGcJlZn2NePzD8rcGp/N1NpY7QtVpJ0IXp7GYpqHdQOamP5/iHpf/p8lFoqXE6J9HISaLvIPFJp84Hi9fYcQrEsLeGoUry2KbmQ/6RPcwkJ1Um+EQSvnfBEhM6QTyyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789597038; c=relaxed/simple;
	bh=cqfLXN6Bngqa7SLASc4gazdteicYwOZWRcl5EYRlEFU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=U6U8TwN/z3GNtdsMfcSbKvFLjCT5N7IQLOsaHyKLVVuMZFj9tm/Es8HFLdeBqmnJUxHnA7d0JlhhSOwFVW/st201sWekqUugC7T5/C6kbcL+F4xsLuOaktwrEgpU0RMg+BCpTkbanFfLcui+b78rsR5jUS2Fiym0mSqhg1B1eyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=iEidL4zU; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GY9ma5SP; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="iEidL4zU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GY9ma5SP"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id AADC0EC0620;
	Wed, 16 Sep 2026 18:17:09 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 16 Sep 2026 18:17:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1789597029; x=1789683429; bh=GjpK7R071f96hDMLBQPtX
	WgWn9tsDFTEhLsPTPnks10=; b=iEidL4zUb2JalTBAlqVGjchNxACgnkAKcBOya
	a3jsyOa8W+V7NxuJp/3XRtv1olnJRPtmFxkgNkwDO/ZYEkbiM4dWWX6WvZNY74ZV
	Fw7k3zjSCcnQIzdrhT3In+yFFu7NZQxxx3hc77b1wD1XHonfoGygZ/mqIm7MKSim
	pwpuc2Ha1tEkl7Ki6nLaoo2cWTpinkBZGUeh/rHuSn72RWANbxsDA8VYxRRVZj6M
	Tqw0Trr0MVMHmo3J+86KJ7OAwL3uUxtpGt2OQwSgDOGb1L76naZe9ffkF4IWsUE8
	TRL/TkgYDqdYmBS/3/zigEad9zS4Nghn2PhK4yg2jZFEN7nbA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:message-id:mime-version:reply-to:subject:subject:to:to
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789597029; x=1789683429; bh=GjpK7R071f96hDMLBQPtXWgWn9tsDFTEhLs
	PTPnks10=; b=GY9ma5SPCnNG6+Zmf+NgkQb1r0gEADLBcsEo+UrCMhM+XZVsCpe
	DK62Hau+9YdzsSvLRv4LIKcMVsnOzlWJLr01yFv/vYpGRbXXe9I6nAvLby4sbjTL
	87YWSJvYou4yKBvXx/tb+CxfB1NjlSlefbUHvQIDlOpHZ1O5SPArsQzw7h/n4nzI
	UBQMffyvVIWW4Rh3lwyzX0nXJeVgGAWa0VoFXIjxFHaGdlvWgaLoqIH43u5lSIwZ
	Ik3lriXuUoJdGonFljFc6pEn0rlxxuNAubfDocD5vo2EcGo0dg2P8dlynjrqf4Mm
	WIsH3swinUGKhJp0PdOfjcryiMF8feP1kew==
X-ME-Sender: <xms:ZRWrakjm5GIX7PWyZ8ZnZnGYYXbQPm1yeKJvRNR5rWNaMaPy7KnM_g>
    <xme:ZRWrajBcTlX6N-lc1Fe5rh5y65yf2-QKu0WqnVKZI6eeRIRL60Zg64s7-ubSgDaas
    BUnRspb-6bkWHPFvpUbMRKaszGSL8n3mra2IXmJRyJ1yEC25b9YBhHX>
X-ME-Received: <xmr:ZRWraptWuYkX9ElDNoNrPs5poisIA2roun0sbTJmBRpueFW7NQQlLZM>
X-ME-Proxy-Cause: dmFkZTFueY60BnuT4C3o7CF0/L47g/w/6cVPkLgLjrqB6trOF3JGV2bltPYPiTP6OutwDT
    ovZj0Nhr6VkFPubfx24HkVlcB4fDXvTck5VwyXhEIKb2WKMBXQC3Y+qPKA00HLpgfuVJsX
    xm19UynJ48VeGLR50FFrqrMZgrE0MF1PLQGCjExuW+MYs0QlgXR7jvesQ8HwsPJ3zShGMq
    2rOfBwzJlmEHCjKoLG0rsnE8pZdj7CLmuCKmE1lnF7INwvuqcsMCCrmduYxYAdO4X6wdKV
    XV52jj21rKA8lIR6kJNq7JvoXSNTYy54wBLyIVh6XiehdHhM/fJazQErB4dOpjsBayheiU
    igNaoH4RN7JId+WW/TRDE21fNlbaMoSMhN/Onfpr0216uJ9Ecm1o17cyp9gXCKdg+Dl+EY
    Dqu3bCgyiGkka8hRiktghXIIoidZH1osEjTCz/mJ+X3TaHu66xvSLNVhrLhZ3d6RdIOg04
    leBRMPCYyX7yvTphFfHSVpF9pgprbRa6tWL9/C1nWJ2U6ypcZeDp+Z9pWes8O5Om9RWJcE
    K9uGltb3c6CDLa90/kv5CHJcNz6WgI6T6QYBRo+m4ViDTTykP9/SL08wwNJ+LUOZpKEi/S
    zPjnGA6NJ9sGrebZfe/QziGjVTdJoPZXGOFlJRfU3KfrxxmTPbvFlnEl0q6g
X-ME-Proxy: <xmx:ZRWragZrd5BDgjQvJKN6RqivMXpx84VzHJjjAtPComGWERG_BxIEBg>
    <xmx:ZRWrakVzTpTpxkJfQ350CIsMl7LzDtdQb_Lyeg3RxYt6Rgn0-rV6ow>
    <xmx:ZRWras79KlgJKibyWAok9Lx_Kn410bzKYz1ECLLffvWArPWwnYJm0w>
    <xmx:ZRWranjX0aPuuALUYAzecaQyeZ7aPBaSQHCqnvG40dOGTZsAX1zSMw>
    <xmx:ZRWramgRfXky73qNo7cjLEArVDZDQvw3EJHjEY6y2SXvGMErCMOh_sra>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 18:17:08 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH] btrfs: keep unused block groups queued when a pass fails
Date: Wed, 16 Sep 2026 15:17:24 -0700
Message-ID: <455009bf67d45ccb8df8c2a0aec270a16db80510.1789597031.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Once any block_group sets ret!=0 in the main loop of
btrfs_delete_unused_bgs(), the check
  if (ret || btrfs_mixed_space_info(space_info)) {
          btrfs_put_block_group(block_group);
          continue;
  }
skips the rest of the unused bgs while unlinking them from
fs_info->unused_bgs. There is no "level triggered" re-queueing of empty
block groups onto fs_info->unused_bgs so it is possible to leak quite a
bit of space this way and unless we happen to get a balance or
re-use/re-empty one of these bgs, they are leaked for good, which can
lead to a spurious enospc later.

While I have observed such leaked blocked groups that are empty but not
on the unused_bgs list on production systems, I have not observed that
it is definitely due to this issue. I also reproduced this behavior by
injecting an ENOSPC error from btrfs_start_trans_remove_block_group
which can also fail with ENOMEM, so this feels like a legitimate
injection point.

To fix it, instead of checking ret in the loop, just break out of the
loop when ret != 0. Also, link the bg to the retry list at the
individual failure sites so that the failing bg is not leaked.

Assisted-by: LLM (reproducer/error injection)
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/block-group.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index ee182369254c..2eb09c9901c9 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1612,7 +1612,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 
 		space_info = block_group->space_info;
 
-		if (ret || btrfs_mixed_space_info(space_info)) {
+		if (btrfs_mixed_space_info(space_info)) {
 			btrfs_put_block_group(block_group);
 			continue;
 		}
@@ -1727,6 +1727,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		ret = inc_block_group_ro(block_group, false);
 		up_write(&space_info->groups_sem);
 		if (ret < 0) {
+			btrfs_link_bg_list(block_group, &retry_list);
 			ret = 0;
 			goto next;
 		}
@@ -1749,6 +1750,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 						     block_group->start);
 		if (IS_ERR(trans)) {
 			btrfs_dec_block_group_ro(block_group);
+			btrfs_link_bg_list(block_group, &retry_list);
 			ret = PTR_ERR(trans);
 			goto next;
 		}
@@ -1759,6 +1761,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		 */
 		if (!clean_pinned_extents(trans, block_group)) {
 			btrfs_dec_block_group_ro(block_group);
+			btrfs_link_bg_list(block_group, &retry_list);
 			goto end_trans;
 		}
 
@@ -1845,6 +1848,8 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 next:
 		btrfs_put_block_group(block_group);
 		spin_lock(&fs_info->unused_bgs_lock);
+		if (ret)
+			break;
 	}
 	list_splice_tail(&retry_list, &fs_info->unused_bgs);
 	spin_unlock(&fs_info->unused_bgs_lock);
-- 
2.55.0

