Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D8AC71123
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B46212087D
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 19:33:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="WQrokF6r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B46212087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbeJMDHr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:07:47 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33546 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbeJMDHr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:07:47 -0400
Received: by mail-qt1-f194.google.com with SMTP id q40-v6so15085066qte.0
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 12:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LRl8jIfrXlaS55TP3QwSq+B/0ZwhXv7LeNXybWqMCSk=;
        b=WQrokF6rvoHdjAd6KhjZlIlOdp2etCYcMktA5FLJW/2pojw/7bgK/bgUuGyeQpKNX7
         wNnh4aiU8H1efyo9Tschab7d8Ekq/E/+BjMPIMX1qZDytMHz+OjnMJunNIkVY9WL13Bo
         hAkn/TgMyLO6/zB+MG2zjOjo3ptwROrymJfG+1ZjdayeyYUXlBmcx//R6gUA/s+jRgWl
         kyDzFT1P6mWMduvxjY0vadhmbx/AhwD6K6n4XKoR9KIGoYK/7sgeAcVEVViBYxrJxbCr
         DqE7pfnAmflcljPRGqnjWoZAfiZ0SVPgCzUW15q2cxwbcrIPZ3nXPh5Im7NZ2qH1nesP
         fTVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LRl8jIfrXlaS55TP3QwSq+B/0ZwhXv7LeNXybWqMCSk=;
        b=LSnd8dcoKbwkT25LqMpZ9niDedfLwK5OFCYP/uIS+CYmwaIFynIDNJ9uUjWnoNnsT5
         cvwWFCUvP9kI9r+KYSTcf25fccm1mDYwO+m1BFl07YhhV9MLqM8MMF1w9hStJljXhxeL
         Ej9bGlf1gUm8FQ70Lav3NRjnCPKYcNmoSL4XGo0c9kf0YfD07cWxetsyqY2Sp23Cksgr
         PLQh2+qHTyThRARLhjwt+VhWn8Wj0aMFEv9zYEjzFehmwlpx9zjJZxDMlcoserxKmNnB
         kYVfPf3m4x+dyzzA6ZNBNI8pPjhSIybeQVuYzVYXoC1210P5grk8mUGRDnBCvtnNTfG1
         9UGg==
X-Gm-Message-State: ABuFfohPZuK2WSe9dCvOJTYSFPjZWEoQVwyhCB2dLQve4voIM/Qo4aR3
        n3LJ25CjeBSlXCorKrl5FyQqbTOi790=
X-Google-Smtp-Source: ACcGV62oTttESlkWFLsLV6Pwy6AIEp3zNM3f4bKdH4ZA6dKPR/2aC9lWkWnP3mETcswie1Am++9Qcg==
X-Received: by 2002:a0c:d6c3:: with SMTP id l3-v6mr7161928qvi.67.1539372826063;
        Fri, 12 Oct 2018 12:33:46 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id v57-v6sm1349454qtk.51.2018.10.12.12.33.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 12:33:44 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
Subject: [PATCH 20/42] btrfs: don't use ctl->free_space for max_extent_size
Date:   Fri, 12 Oct 2018 15:32:34 -0400
Message-Id: <20181012193256.13735-21-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181012193256.13735-1-josef@toxicpanda.com>
References: <20181012193256.13735-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Josef Bacik <jbacik@fb.com>

max_extent_size is supposed to be the largest contiguous range for the
space info, and ctl->free_space is the total free space in the block
group.  We need to keep track of these separately and _only_ use the
max_free_space if we don't have a max_extent_size, as that means our
original request was too large to search any of the block groups for and
therefore wouldn't have a max_extent_size set.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ef852d1911d1..6721698ab8aa 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7496,6 +7496,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	struct btrfs_block_group_cache *block_group = NULL;
 	u64 search_start = 0;
 	u64 max_extent_size = 0;
+	u64 max_free_space = 0;
 	u64 empty_cluster = 0;
 	struct btrfs_space_info *space_info;
 	int loop = 0;
@@ -7791,8 +7792,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 			spin_lock(&ctl->tree_lock);
 			if (ctl->free_space <
 			    num_bytes + empty_cluster + empty_size) {
-				if (ctl->free_space > max_extent_size)
-					max_extent_size = ctl->free_space;
+				max_free_space = max(max_free_space,
+						     ctl->free_space);
 				spin_unlock(&ctl->tree_lock);
 				goto loop;
 			}
@@ -7959,6 +7960,8 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	}
 out:
 	if (ret == -ENOSPC) {
+		if (!max_extent_size)
+			max_extent_size = max_free_space;
 		spin_lock(&space_info->lock);
 		space_info->max_extent_size = max_extent_size;
 		spin_unlock(&space_info->lock);
-- 
2.14.3

