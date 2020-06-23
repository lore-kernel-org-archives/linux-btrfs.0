Return-Path: <SRS0=qk6s=AE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E92C433E1
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Jun 2020 14:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A111B20706
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Jun 2020 14:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592921451;
	bh=8Ri5c4guQ5YL9ZRSvFFB+S8kQg1w+lrqLfYLIxHYx8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=r+YaQayxnvMFXRp6gW62y7cIb7f7fjj8Z4oSmAE3PNdLoIm3K3tDrXs7n7N50GJDT
	 B8luManQDYGcddPlOzfi6TX5/N4cfAmj885xEQonLsv31keQE6ZUnuLf1FmMZ0ReSb
	 V8zke1otNMZlxSlsjjTVBK3n//tjn1eRJPyWAihc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732789AbgFWOKt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 10:10:49 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37211 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732698AbgFWOKs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jun 2020 10:10:48 -0400
Received: by mail-wr1-f66.google.com with SMTP id a6so18727058wrm.4
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2020 07:10:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QmcKcZAjsn3+F4CzWeBv+oaA/7LF00tvvPTLk7owBR0=;
        b=MVhVwTtaXrWioOwOEk9/dTNoTlGWEG2u5aCqmeYjWHpTT+0P9++iJCgooawBM8SzVU
         wLZk0sUZ6Tln+PkMSETBzHmYtsu31RdzGTLl2AyXI3zc5XApleaVjDRv67RBKxd/EfcW
         J3ZwC4toCNEzY819mU1W/qinaQuLwzj5YX+8piiDT0ZedEUO/c2rZbO+iyGfjbbvmvHD
         GBkrtvQB0C710U8QjK38Gk0i6CuO4MaNa568ERi2OrJupqu40D/nJor6Ipjhpe99e76D
         PcXTe0BudgQ6rLU3McnclhC3+KqZg96dFTVebpgUZ42uqrVKVi3xHhwfsj0acE+qDcbl
         Moqw==
X-Gm-Message-State: AOAM532eWq70f7g24tHhRzhr6GzqN8FcHlJaNeMk71Mq6cg6guwnZfo0
        td3IH9OzBsZuvYwq2qG9Sw/XU+u/
X-Google-Smtp-Source: ABdhPJzoeYLCjlajl2DD7v7/hLzNzEIqI5bOwJJZjDoZ4kv6+wwBmYDdlcnfqlaT2jeyCUGW0t/how==
X-Received: by 2002:adf:ec01:: with SMTP id x1mr4093309wrn.59.1592921446521;
        Tue, 23 Jun 2020 07:10:46 -0700 (PDT)
Received: from NUC.fritz.box ([2001:a62:1515:bd01:f64d:30ff:fe6c:acb5])
        by smtp.gmail.com with ESMTPSA id n1sm22529497wrp.10.2020.06.23.07.10.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jun 2020 07:10:46 -0700 (PDT)
From:   Johannes Thumshirn <jth@kernel.org>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 2/4] btrfs-progs: use minimal number of stripes from btrfs_raid_attr
Date:   Tue, 23 Jun 2020 16:10:17 +0200
Message-Id: <20200623141019.23991-3-jth@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623141019.23991-1-jth@kernel.org>
References: <20200623141019.23991-1-jth@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Both btrfs_raid_attr and btrfs_raid_profile define the minimal number of
stripes for each raid profile.

The difference is in btrfs_raid_attr the number of stripes is called
devs_min and in btrfs_raid_profile its called min_stripes.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 volumes.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/volumes.c b/volumes.c
index 9d0eeed5..82d7a872 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1001,52 +1001,42 @@ error:
 static const struct btrfs_raid_profile {
 	int	num_stripes;
 	int	max_stripes;
-	int	min_stripes;
 } btrfs_raid_profile_table[BTRFS_NR_RAID_TYPES] = {
 	[BTRFS_RAID_RAID10] = {
 		.num_stripes = 0,
 		.max_stripes = 0,
-		.min_stripes = 4,
 	},
 	[BTRFS_RAID_RAID1] = {
 		.num_stripes = 0,
 		.max_stripes = 0,
-		.min_stripes = 2,
 	},
 	[BTRFS_RAID_RAID1C3] = {
 		.num_stripes = 0,
 		.max_stripes = 0,
-		.min_stripes = 3,
 	},
 	[BTRFS_RAID_RAID1C4] = {
 		.num_stripes = 0,
 		.max_stripes = 0,
-		.min_stripes = 4,
 	},
 	[BTRFS_RAID_DUP] = {
 		.num_stripes = 2,
 		.max_stripes = 0,
-		.min_stripes = 2,
 	},
 	[BTRFS_RAID_RAID0] = {
 		.num_stripes = 0,
 		.max_stripes = 0,
-		.min_stripes = 2,
 	},
 	[BTRFS_RAID_SINGLE] = {
 		.num_stripes = 1,
 		.max_stripes = 0,
-		.min_stripes = 1,
 	},
 	[BTRFS_RAID_RAID5] = {
 		.num_stripes = 0,
 		.max_stripes = 0,
-		.min_stripes = 2,
 	},
 	[BTRFS_RAID_RAID6] = {
 		.num_stripes = 0,
 		.max_stripes = 0,
-		.min_stripes = 3,
 	},
 };
 
@@ -1056,11 +1046,14 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_info *info,
 	int type = ctl->type;
 
 	ctl->num_stripes = btrfs_raid_profile_table[type].num_stripes;
-	ctl->min_stripes = btrfs_raid_profile_table[type].min_stripes;
+	ctl->min_stripes = btrfs_raid_array[type].devs_min;
 	ctl->sub_stripes = btrfs_raid_array[type].sub_stripes;
 	ctl->stripe_len = BTRFS_STRIPE_LEN;
 
 	switch (type) {
+	case BTRFS_RAID_DUP:
+		ctl->min_stripes = 2;
+		break;
 	case BTRFS_RAID_RAID1:
 	case BTRFS_RAID_RAID1C3:
 	case BTRFS_RAID_RAID1C4:
-- 
2.26.2

