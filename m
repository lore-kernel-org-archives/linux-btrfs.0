Return-Path: <SRS0=jJu9=25=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8469AC282DD
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Jan 2020 17:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FFD320705
	for <linux-btrfs@archiver.kernel.org>; Wed,  8 Jan 2020 17:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578505537;
	bh=/3AHcDnyzqBvJryLFnkqmX0q+58zLvlJ0N5HH/xT7zo=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=npjWWxDKpk2F6Qi3xZg5V/6i8wcTvhi+M2ZwSiJUoU/dfirwxeRBsldN7hjSKVWvT
	 z7K5XxputBviIVKZJbIzE7Y7CWdYY/EuH+CYVAUBFY3Fg2laJbBhTvwqBmJnwAw47g
	 NySu/Q9cgjgXdwD3C020MkYILdz26mg+1gRi4iOM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgAHRpg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 8 Jan 2020 12:45:36 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43845 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbgAHRpg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jan 2020 12:45:36 -0500
Received: by mail-wr1-f68.google.com with SMTP id d16so4297583wre.10;
        Wed, 08 Jan 2020 09:45:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=v5LveUQBQcDfQvLghpre8J/xh4zJ+Dsh9fxrgvihujs=;
        b=Yw6FbKe3HKrF5ZkySaR3QTmVaX8DxizU68HLPo4ARZ2/vzlmFqys9Ok0sbQEtL8JSB
         VGOMBNDJPnO+yPLhbh72app1vuhp616Ccnzrs3Bg5lkX8GEEkpVLiEjZPkFrrA6tJpjb
         1AYJH0wQqj8hiKLsS7nSjYsrGk/YgKKG6FdxK1Ve3QbHZS4ToJzKv3tcTi1nqtgHT8H6
         8Ba2qUlyzdzgCfOgPrZnj+g6sKnOgw7LNshdapDMACWx6xdqOpkTYxNHKvtUrb7Q8pb2
         eV2LxMKQpztNNtMDWd30KEJm8h4K/c4bznwUPi2vLKdHYrxZqS6EqHn6PQRBQD0MYwlY
         G8zQ==
X-Gm-Message-State: APjAAAXWHH6spqLbn9+cvpqvNBMIYIQzohBlw2kudLcsvgg/ZQzz5ZoL
        gPwCjt4k1dqWarxvLwIRnUQ=
X-Google-Smtp-Source: APXvYqwsDyXrAGQi82E1YQJs9eM3wPGGmSzx9R60bM9AcfmtgHCz4KgE+bEDtj6XKLg8WiNlbfi5Kg==
X-Received: by 2002:adf:fd07:: with SMTP id e7mr5784865wrr.21.1578505534466;
        Wed, 08 Jan 2020 09:45:34 -0800 (PST)
Received: from linux-t19r.fritz.box (ppp-46-244-195-226.dynamic.mnet-online.de. [46.244.195.226])
        by smtp.gmail.com with ESMTPSA id x14sm4392695wmj.42.2020.01.08.09.45.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jan 2020 09:45:33 -0800 (PST)
From:   Johannes Thumshirn <jth@kernel.org>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] btrfs/202: fix golden output
Date:   Wed,  8 Jan 2020 18:45:10 +0100
Message-Id: <20200108174510.6261-1-jth@kernel.org>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

The golden output of btrfs/202 contains the sequence number 201 instead of
202, fix this.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 tests/btrfs/202.out | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/btrfs/202.out b/tests/btrfs/202.out
index 938870cf..7f33d49f 100644
--- a/tests/btrfs/202.out
+++ b/tests/btrfs/202.out
@@ -1,4 +1,4 @@
-QA output created by 201
+QA output created by 202
 Create subvolume 'SCRATCH_MNT/a'
 Create subvolume 'SCRATCH_MNT/a/b'
 Create a snapshot of 'SCRATCH_MNT/a' in 'SCRATCH_MNT/c'
-- 
2.16.4

