Return-Path: <SRS0=25Zt=3X=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07422C35247
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Feb 2020 20:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF95F21D7E
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Feb 2020 20:50:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="11qIHla8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgBCUuQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Feb 2020 15:50:16 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36507 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgBCUuP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Feb 2020 15:50:15 -0500
Received: by mail-qt1-f194.google.com with SMTP id t13so12603451qto.3
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Feb 2020 12:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bWlcxKv9T4QG+p4PDuWKnx0ob030Db7Qs8YFpZ855OA=;
        b=11qIHla85aqysdfVpFt7QsVH0RnwCLIGEjTTcqDLzogVKXMaTaSPDybW4xfEZ6QW6x
         vOXBOBQT7J/aKnke2Ehmy0BaYbzBw1P7XuzfCercx7CbAlQANjklppSmiRrLgKzn7fPE
         MRlrHM7DdvpeOqOLUUgEBxEpI9OERSirdMcuffq1xjnk0bSDXoqSGYQQo/nJenfpaU1q
         ucnK4Kgma2gjKPKqEDxnk60OcKazwPo3zOuKPytl0G7q00skzQYcqbE3vmXssisrnk7G
         r7Mp5z6v3PGoZLtIX/XC1wCh/DsYd+bB3uDp6SXKMESHgK5SxZc15y8DNjyZld8LFiu8
         RgPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bWlcxKv9T4QG+p4PDuWKnx0ob030Db7Qs8YFpZ855OA=;
        b=qieXe46z7lhozhtO9UVVVKzEPe1Pv66HzoSNucGdsAINxz1/OuT4KVX4+la5a4/i+z
         f/W7VSmsqqFMiWstonpQafJ0s28hcH45WsL36Pp3IRkBJKwkYylhXz07RwrwfGDGCYV2
         svSiHtNsIJBT6u07QNKKtebS9uTK0Rg7KzNuu/5SdL5frf85WltVL6rxffacEPkWJLPm
         CUDjEbLpBOMXUXL/XlVa0aTD+3wU0GfJM71pngmk4MlyhjgZ+lIT+cHA9GSwz1dkoRHD
         7cKBCVoWGXeTmg99LEyvISAnPPWEf1b4Kpcb4jF4obNsn5oygjJtDCkzBc4vFzH+tqin
         vCBA==
X-Gm-Message-State: APjAAAU0GsQvV+aHk2S+uFrIWteXiYV6G8uZDXN3m1r+4szLO5nGMLMz
        2JETFjlLAfdCKDqlVdS3lGIXqJ0M0/yZ7A==
X-Google-Smtp-Source: APXvYqwFUCsaK9V5kEGG9pBzZH3ak0Zo3CzX4uiJSSw4mgloUe4NOOKwp2TrksUZB1UyPvHmKkG4RA==
X-Received: by 2002:ac8:33f8:: with SMTP id d53mr25207700qtb.86.1580763013906;
        Mon, 03 Feb 2020 12:50:13 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id 65sm10741307qtf.95.2020.02.03.12.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 12:50:13 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 12/24] btrfs: add flushing states for handling data reservations
Date:   Mon,  3 Feb 2020 15:49:39 -0500
Message-Id: <20200203204951.517751-13-josef@toxicpanda.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200203204951.517751-1-josef@toxicpanda.com>
References: <20200203204951.517751-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently the way we do data reservations is by seeing if we have enough
space in our space_info.  If we do not and we're a normal inode we'll

1) Attempt to force a chunk allocation until we can't anymore.
2) If that fails we'll flush delalloc, then commit the transaction, then
   run the delayed iputs.

If we are a free space inode we're only allowed to force a chunk
allocation.  In order to use the normal flushing mechanism we need to
encode this into a flush state array for normal inodes.  Since both will
start with allocating chunks until the space info is full there is no
need to add this as a flush state, this will be handled specially.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ctree.h      | 2 ++
 fs/btrfs/space-info.c | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6afa0885a9bb..865b24a1759e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2526,6 +2526,8 @@ enum btrfs_reserve_flush_enum {
 	 */
 	BTRFS_RESERVE_FLUSH_LIMIT,
 	BTRFS_RESERVE_FLUSH_EVICT,
+	BTRFS_RESERVE_FLUSH_DATA,
+	BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE,
 	BTRFS_RESERVE_FLUSH_ALL,
 };
 
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 955f59f4b1d0..e348468489c7 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -802,6 +802,12 @@ static const enum btrfs_flush_state evict_flush_states[] = {
 	COMMIT_TRANS,
 };
 
+static const enum btrfs_flush_state data_flush_states[] = {
+	FLUSH_DELALLOC_WAIT,
+	COMMIT_TRANS,
+	RUN_DELAYED_IPUTS,
+};
+
 static void priority_reclaim_metadata_space(struct btrfs_fs_info *fs_info,
 				struct btrfs_space_info *space_info,
 				struct reserve_ticket *ticket,
-- 
2.24.1

