Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B763C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 08:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C51772184C
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 08:13:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="kS2EueFz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfCNINO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 04:13:14 -0400
Received: from mta-p6.oit.umn.edu ([134.84.196.206]:41988 "EHLO
        mta-p6.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbfCNINN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 04:13:13 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p6.oit.umn.edu (Postfix) with ESMTP id B280BB5B
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 08:13:12 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p6.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p6.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cvJ4IBae2pq1 for <linux-btrfs@vger.kernel.org>;
        Thu, 14 Mar 2019 03:13:12 -0500 (CDT)
Received: from mail-it1-f198.google.com (mail-it1-f198.google.com [209.85.166.198])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p6.oit.umn.edu (Postfix) with ESMTPS id 7936593E
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 03:13:12 -0500 (CDT)
Received: by mail-it1-f198.google.com with SMTP id a184so4860424itc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2019 01:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SElI6m5e00A1NPP8AKqKf6Qas4qlMROeovLlOxjk3bo=;
        b=kS2EueFzs0+HOgcKzlHjWWi1Pat6HCleHqp6JS6om9IatI15wFbvKv/9Tbh7RFRd5D
         IZSk27mlIf9+t+QI4jHvUpnyfs8zDikj4WRqpOqBhAdUJa6e80JrKeJB5poNFm8cxwQM
         pcKFwkaN/Y7sFD7C2F+XyLa6qC2U35wgrbiFJSHTaJkebRlQO5yOdGsdWq/k+hmtf61E
         ntXZGUmbAKmmUKo1xPJkWGrbuUKwMl7u94ZEklhEwRVUUyv1aBoRVDFj1cKsa877Mj/V
         E4GwaWioVZvRSF7Hy/kUcmi1OMON+8Ymnpfu0H2AJKXBfNmX8mXF5q2c1EZHSccUMIEt
         C8OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SElI6m5e00A1NPP8AKqKf6Qas4qlMROeovLlOxjk3bo=;
        b=uViZTmboFdhbCaeDC8yMvCy68RchkZrrxH5EuhxqXXniWtE8kb8Y0NfT7ZzJpFecFp
         d2Ew93XEt+5wSQ+Rglb73yz4XH3pG8RgWRur/41yy3+2raSzl7aSoWwz3A2UzJgq9Tel
         xhrQNGxAogNdfGbn14oSB5eh+08DuN/na7cldnqMlrATZAfTrNYN30VdV1dplg8pNKu9
         r/fFE7RprnB3Tb6LKS+bZsPemQR2bPwHiJZAb7+m5Aqt3GzZmCdgHL5nkPVjmjWeO9Cx
         7MVfePW7nvWDfvD5IArrPb8B4rrH0iamgF/damtXYUS3OqCOEF+QFCKeFLwmxqN5XA2W
         ZkPg==
X-Gm-Message-State: APjAAAWqUTClDvRmW9wEsc4Z3NOq81dRseIH2+90ryLQq0mTpZ3GrLb4
        m6iSY6vGuG++9A4sLwqp64UZABUcJn10KI11uVu44QcHxgbhrqlb75BSU7f9m9RIYQ6lPMVxq2B
        Y7Xem50gx9SzpUkVhMlefGYZOFYQ=
X-Received: by 2002:a24:2a88:: with SMTP id w130mr1226295itw.95.1552551192047;
        Thu, 14 Mar 2019 01:13:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwL0NZSm/Pb5W3j99/lYGM73qdZBwKCtLfcEIeEGTHRNTDZytsRp5yJQfL21Zo7QkYGkxEWGA==
X-Received: by 2002:a24:2a88:: with SMTP id w130mr1226285itw.95.1552551191811;
        Thu, 14 Mar 2019 01:13:11 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id x25sm6272745ion.78.2019.03.14.01.13.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 01:13:11 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] btrfs: fix a NULL pointer dereference
Date:   Thu, 14 Mar 2019 03:13:04 -0500
Message-Id: <20190314081304.469-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <fcdf722f-d128-03c0-99fb-a220f680193c@suse.com>
References: <fcdf722f-d128-03c0-99fb-a220f680193c@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

btrfs_lookup_block_group may fail and return NULL. The fix uses
assert to ensure cache is not NULL.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>

---
V2: use assert as suggested by Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 994f0cc41799..80d7c272d282 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7303,6 +7303,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 
 		pin = 0;
 		cache = btrfs_lookup_block_group(fs_info, buf->start);
+		ASSERT(cache);
 
 		if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
 			pin_down_extent(fs_info, cache, buf->start,
-- 
2.17.1

