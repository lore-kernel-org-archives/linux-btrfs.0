Return-Path: <SRS0=i+cT=OM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12AD6C04EB9
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDFC220834
	for <linux-btrfs@archiver.kernel.org>; Mon,  3 Dec 2018 15:25:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="OajTh97u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDFC220834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbeLCPZI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 3 Dec 2018 10:25:08 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:35419 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeLCPZH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Dec 2018 10:25:07 -0500
Received: by mail-yw1-f68.google.com with SMTP id h32so5530527ywk.2
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 07:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=SmlpN9F1+q2xkMrPjnZJbzIpYw7l8bDfk05UNYsHm5g=;
        b=OajTh97u2cbPaRa4OxUxePwTwd5GrZR6gXAG1/2d0hMhWLnQk95pKcS8mBv4AlEyxi
         zD28W8WRmkhayoO9CnkQ5D9YZKRxBvmjNJIZJFsideq1TsaB0mbQIGAUGXgQtBTVevx1
         0GQrvfw1wXRhtAixqFQZOcYHEwdr1VU722mN6xtpCwlHVATD1P7moTLQavSVY2QM8PfB
         l7ygxujEWfqHlmBWQtclea1ZhfuiAyFjzf23KfapqPDo0USc0m4GUk3DZ/FjsaG4zM5X
         eWBVUEjSyfzqBcf4G3PkrDlFSFJL/Rv7IJKKzAu1k8uOiyEZhxUYX/cI/k1QCTwSvu7G
         VMyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=SmlpN9F1+q2xkMrPjnZJbzIpYw7l8bDfk05UNYsHm5g=;
        b=LGQ8pQD3tm2QiMlM8Mmt1c4x8jXc185ONyflAol15YLs4YYqvqcPp1juihRrkLdDmr
         htaGFEQn/fT9fend+HuXWR3vrVTXdaebkRkoJHuAaI5bQIJevPIhvhwHckddJ8Re27+y
         WUt9ZmWDKUTg1BwKCOohclE3IDlqK0y1IQGNUi6CiQGpIr9+Fgh5P6BJLc5GTpM1xusu
         nB/6etJgIVJLt0oxAs3Hb7yCqzYnNwJBaSnHaT9YqdNrK+5TmOhHNcoeN+j2WcV8CHxh
         b/Akq/7uxkoEHxIr9LQby8sznBrmFxukRo7SvjtT71aLuk0Ry249SP5+qXUKnSkJFa0e
         NXag==
X-Gm-Message-State: AA+aEWaHmYBeysu57IzBNZzfW6Dciyv454RExqCNu9uuNJSQbTWEd/Xl
        fX5JP4gzF9wFYk+1Ka8+D2q1fhFhDWA=
X-Google-Smtp-Source: AFSGD/VDacxTKHSn9t1iM84p7/d9gqm/d3YBTZlOW5c0RFH8zbox9SHXd7CTKu7Bnz7WsvUSATCKIg==
X-Received: by 2002:a81:b342:: with SMTP id r63mr15943833ywh.475.1543850705234;
        Mon, 03 Dec 2018 07:25:05 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id a71sm4508506ywe.66.2018.12.03.07.25.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Dec 2018 07:25:04 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 2/8] btrfs: dump block_rsv whe dumping space info
Date:   Mon,  3 Dec 2018 10:24:53 -0500
Message-Id: <20181203152459.21630-3-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20181203152459.21630-1-josef@toxicpanda.com>
References: <20181203152459.21630-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For enospc_debug having the block rsvs is super helpful to see if we've
done something wrong.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent-tree.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 755eb226d32d..204b35434056 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8063,6 +8063,15 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+#define DUMP_BLOCK_RSV(fs_info, rsv_name)				\
+do {									\
+	struct btrfs_block_rsv *__rsv = &(fs_info)->rsv_name;		\
+	spin_lock(&__rsv->lock);					\
+	btrfs_info(fs_info, #rsv_name ": size %llu reserved %llu",	\
+		   __rsv->size, __rsv->reserved);			\
+	spin_unlock(&__rsv->lock);					\
+} while (0)
+
 static void dump_space_info(struct btrfs_fs_info *fs_info,
 			    struct btrfs_space_info *info, u64 bytes,
 			    int dump_block_groups)
@@ -8082,6 +8091,12 @@ static void dump_space_info(struct btrfs_fs_info *fs_info,
 		info->bytes_readonly);
 	spin_unlock(&info->lock);
 
+	DUMP_BLOCK_RSV(fs_info, global_block_rsv);
+	DUMP_BLOCK_RSV(fs_info, trans_block_rsv);
+	DUMP_BLOCK_RSV(fs_info, chunk_block_rsv);
+	DUMP_BLOCK_RSV(fs_info, delayed_block_rsv);
+	DUMP_BLOCK_RSV(fs_info, delayed_refs_rsv);
+
 	if (!dump_block_groups)
 		return;
 
-- 
2.14.3

