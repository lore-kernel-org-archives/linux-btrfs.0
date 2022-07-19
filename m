Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A442CC433EF
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Jul 2022 15:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbiGSP1x (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 11:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239472AbiGSP1i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jul 2022 11:27:38 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33EE50735
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jul 2022 08:27:37 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id n2so10062104qkk.8
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jul 2022 08:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8ZV9gJdU7xP5V2qDZFKJD55uqEiD7bTqFQIZd+Tbgwc=;
        b=Gu+1C6W1L2ZyK1kIQw7o1GBJX95OH33SweVUPYNo70EnUvKcn57jSSxTZfJOA/z78O
         EKOhwM86QbqEqI4RJ/7TD7Wrf3bC4aQvfJkIi5evAJcvebuAYo7JahPbtInRyyWZkA+0
         xqraA7rcRaBR7dxXKfdfVqv76gKgIoUQ1HHuz8MllbeKCNfqbP3hrVLttgSrUGuZoMFD
         Oc0lNxjXkmUCLeaTKOwTCMCqXhCop+obvsx/SXb2bG69pJeAXTH/Tjv259u2PkXolTbk
         b5u9UMcKFlEDcaLkfC+BhVXhoTPDkLhad6CDQ58x91I2XNXLk48tFI9Bf3/FGCjOvdFQ
         ZfTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8ZV9gJdU7xP5V2qDZFKJD55uqEiD7bTqFQIZd+Tbgwc=;
        b=A0w8s1CY23A07DkavRiRGNjxcjN0aaMlppzJii9JTxQ2RkJ7raYwUzXwdngxTh4SbO
         vPv3mTKZa+ED9j0lJ+IaYRng6MX2fGrlDIUMxF7Hd4ZtgE9UI2EozWLgGReaXOVtXYVb
         rCyuHphb+wuljCYeeAXGwlOkhIUjVG+LA6BrxX9A1Ii/GQw/F/zAngbj28381ZtBwtRT
         UhZTRpMu5awU+ds8Dx0i6es/LAMr0Gbcqk4INnJIGwIu/bLe4r+uJn63C9oGFGub5qUY
         V1kaWNwzwy6qPlAEzaVTD0M7PyGSj5jCsPBpdGiOEXeya1QW20RtmedmSeeuNAYx+yeB
         M3gQ==
X-Gm-Message-State: AJIora8BNfOsHLx/d8CLvnMmkRX2FJgUrjyqe1VUvu6HgKYvvP6EAoQe
        BGCGw3i8s88qi1bFVudPxHsKCUxRTXMRjA==
X-Google-Smtp-Source: AGRyM1vEPc1ky9jQ9nUF2b6STIurwizqnUsS3QyJpQBDJCif150sij2Vln1dQG5DHNhbP4LJir/W/g==
X-Received: by 2002:ae9:dc42:0:b0:6a6:7b4b:1636 with SMTP id q63-20020ae9dc42000000b006a67b4b1636mr21424781qkf.111.1658244456765;
        Tue, 19 Jul 2022 08:27:36 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id de17-20020a05620a371100b006b5a12eb838sm5552552qkb.31.2022.07.19.08.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 08:27:36 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] fstests: don't run btrfs/257 if we have compression enabled
Date:   Tue, 19 Jul 2022 11:27:35 -0400
Message-Id: <31a36368502eb7b1ee7bae36f000f4ee1eda3913.1658244445.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This fails on all of our compression config variations because it
depends on specific file extent layout.  Add _require_btrfs_no_compress
so we don't complain about failures that don't apply.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 tests/btrfs/257 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/btrfs/257 b/tests/btrfs/257
index 5c5cdcc3..3092495f 100755
--- a/tests/btrfs/257
+++ b/tests/btrfs/257
@@ -27,6 +27,9 @@ _begin_fstest auto quick defrag prealloc
 _supported_fs btrfs
 _require_scratch
 
+# We rely on specific extent layout, don't run on compress
+_require_btrfs_no_compress
+
 # Needs 4K sectorsize
 _require_btrfs_support_sectorsize 4096
 _require_xfs_io_command "falloc"
-- 
2.26.3

