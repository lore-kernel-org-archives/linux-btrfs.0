Return-Path: <SRS0=qk6s=AE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EAEC433E1
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Jun 2020 14:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 683D120706
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Jun 2020 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592921449;
	bh=Cl6q/60CHd+iH3lwFAFRQYBmIwnQpT2sGcXYkx9o9jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=eLHTjvJlxJoEi5tHXtwkSxX3GPQJ2Txrdr1Li7HcMmPFQY/kqZi/litAmcVK+R1+W
	 S8Dg9Wng5vs0sHAIM50YyE8ddTfRWg3QAT2lBvg/Xgb7ewAB7ljUSJSs4hLpIv++FX
	 1gGoVEDemB2MHetBo0XPwZetfYBSPfzr7VFLhGt4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732758AbgFWOKs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Jun 2020 10:10:48 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35432 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732720AbgFWOKr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jun 2020 10:10:47 -0400
Received: by mail-wr1-f65.google.com with SMTP id g18so11639379wrm.2
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2020 07:10:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sV5CUIQ0FPCCH8t1O/qsA5k7l2axPb+0+551WKHTkO8=;
        b=tbUa/l95gdsfCEwn9IrviYBJtK9X/GLlZijY8L6YOGkpO1Zemyw5XZrfna3Dxj9q6/
         On9Rm9tsuSgKyYVvoEFuKunIP6VRJoUjIcAUoX7u3aK/UEpr9PbZU9ohzQ9tedSs4kxv
         mV6Yu+E5EZsplKDe40EwAYKrj5MNi8x4uppfARy1YCe/8utMgB4ynUX7K/7ORbCurGl1
         Gdm08ivPu59UFm4RWvHkd/aAh+A3oujngzKXs5pKtQTSTfPLDn8LNc3WN7DTOfLZGuRK
         EMryShad5inzyffTrGJR8+EwOXWkhfU/Ny46YXsO6q56k5RoROVwCZmNo55ShOSrt894
         jAow==
X-Gm-Message-State: AOAM533raZOP5allHBaUtfVzQec0KTqTSuZCrozq1VHA/GBL+hVNKsuq
        HPT9R4N2frwuxMwVWZVa7Zg=
X-Google-Smtp-Source: ABdhPJz2LUwEnVU9emqf/9kckrBFfgSx4j4Vebp41wJgiDn05JQxBYmvV5DmUM/ejLoe1D5nwybjAw==
X-Received: by 2002:adf:ef4a:: with SMTP id c10mr24476057wrp.32.1592921445696;
        Tue, 23 Jun 2020 07:10:45 -0700 (PDT)
Received: from NUC.fritz.box ([2001:a62:1515:bd01:f64d:30ff:fe6c:acb5])
        by smtp.gmail.com with ESMTPSA id n1sm22529497wrp.10.2020.06.23.07.10.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jun 2020 07:10:45 -0700 (PDT)
From:   Johannes Thumshirn <jth@kernel.org>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 1/4] btrfs-progs: use sub_stripes property from btrfs_raid_attr
Date:   Tue, 23 Jun 2020 16:10:16 +0200
Message-Id: <20200623141019.23991-2-jth@kernel.org>
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

Both btrfs_raid_attr and btrfs_raid_profile define the number of
sub_stripes a raid type has.

Use the one from btrfs_raid_attr and get rid of the field in
btrfs_raid_profile.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 volumes.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/volumes.c b/volumes.c
index 7c57d6cb..9d0eeed5 100644
--- a/volumes.c
+++ b/volumes.c
@@ -1002,61 +1002,51 @@ static const struct btrfs_raid_profile {
 	int	num_stripes;
 	int	max_stripes;
 	int	min_stripes;
-	int	sub_stripes;
 } btrfs_raid_profile_table[BTRFS_NR_RAID_TYPES] = {
 	[BTRFS_RAID_RAID10] = {
 		.num_stripes = 0,
 		.max_stripes = 0,
 		.min_stripes = 4,
-		.sub_stripes = 2,
 	},
 	[BTRFS_RAID_RAID1] = {
 		.num_stripes = 0,
 		.max_stripes = 0,
 		.min_stripes = 2,
-		.sub_stripes = 1,
 	},
 	[BTRFS_RAID_RAID1C3] = {
 		.num_stripes = 0,
 		.max_stripes = 0,
 		.min_stripes = 3,
-		.sub_stripes = 1,
 	},
 	[BTRFS_RAID_RAID1C4] = {
 		.num_stripes = 0,
 		.max_stripes = 0,
 		.min_stripes = 4,
-		.sub_stripes = 1,
 	},
 	[BTRFS_RAID_DUP] = {
 		.num_stripes = 2,
 		.max_stripes = 0,
 		.min_stripes = 2,
-		.sub_stripes = 1,
 	},
 	[BTRFS_RAID_RAID0] = {
 		.num_stripes = 0,
 		.max_stripes = 0,
 		.min_stripes = 2,
-		.sub_stripes = 1,
 	},
 	[BTRFS_RAID_SINGLE] = {
 		.num_stripes = 1,
 		.max_stripes = 0,
 		.min_stripes = 1,
-		.sub_stripes = 1,
 	},
 	[BTRFS_RAID_RAID5] = {
 		.num_stripes = 0,
 		.max_stripes = 0,
 		.min_stripes = 2,
-		.sub_stripes = 1,
 	},
 	[BTRFS_RAID_RAID6] = {
 		.num_stripes = 0,
 		.max_stripes = 0,
 		.min_stripes = 3,
-		.sub_stripes = 1,
 	},
 };
 
@@ -1067,7 +1057,7 @@ static void init_alloc_chunk_ctl(struct btrfs_fs_info *info,
 
 	ctl->num_stripes = btrfs_raid_profile_table[type].num_stripes;
 	ctl->min_stripes = btrfs_raid_profile_table[type].min_stripes;
-	ctl->sub_stripes = btrfs_raid_profile_table[type].sub_stripes;
+	ctl->sub_stripes = btrfs_raid_array[type].sub_stripes;
 	ctl->stripe_len = BTRFS_STRIPE_LEN;
 
 	switch (type) {
-- 
2.26.2

