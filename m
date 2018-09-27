Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CD4C04E87
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16104215F0
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:18:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="VbtSIMXj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16104215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbeI1Ahl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:37:41 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44994 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728359AbeI1Ahk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:37:40 -0400
Received: by mail-pg1-f193.google.com with SMTP id g2-v6so2527149pgu.11
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 11:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ocSFXP7O1JUc5iJPcip80IbqCw8dHalc06/sU/WM7Ns=;
        b=VbtSIMXjOIJxw3zIp5D2Jbe/ciMod9y1Cw+jsDmd9QOitaT+GkvgeA00kJgaJ15bWW
         kczqRYZ2YX2NudovKmwam+l+3J/zolw7IhIBzmklG3MJwW9ad23JrzPvm+F5M+M6NJ6Q
         0Mhm+s+OCT7VLAPr3iuag8vgt5xNLTji+eMS5ATZGvGqn4/LX/VL1dQVwTChz92VQHWs
         fXAX8lXozUtoS77Jijm0k0Wrs4XygxP/yXjRo88G6NqexA8hLdmLFHZX9mmxNhRV1B/l
         NnPNG1rrr94agLkOb5mV1+oaDDGsUVwN9LKZnTyyjweXlVcd6OjgZkkwLeYWu0+hlPb7
         ug2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ocSFXP7O1JUc5iJPcip80IbqCw8dHalc06/sU/WM7Ns=;
        b=im346q+NUGuASKfnPXOHyOrHb2KKaxBpd2+recTNU/05eKujnKbE+5NrJKOtN00gA7
         FhhnnXWsllnErjpOu1aytfIaDafPMVE30a7TcqAVuD9X8pfshrOw0Z7q51ypwE+u/quJ
         oFN2RwUymkAXRW6zleOY3ZKTyNuQLIxTxEso6/ka934HwmGt6FN+yFBq1gPYHNm7LHzM
         TaebZbOUV6z7Pw/fUer9DA7FayXiaIp12yi7pvNX+2D7+kkCb0ntKZGO8/hUAuyWOQCn
         BGllJGgXy2PrJ3gH72++zZCmEvkBWtCY7XdtU427d6902tUCauCbotVOtlmoFJMx6Hrm
         liaw==
X-Gm-Message-State: ABuFfogOtrkGxja7Q03X7e1VuWgx1Et1DRnVHu/9iPEz+FsgeJPhJ2C8
        x+2dds8OZsEDqmkD0XWXvwh8pIZwAbc=
X-Google-Smtp-Source: ACcGV62I52V4bUXBdNvnT4sH4FX9jm0Yga4su74IE1PYyAotxg6MJaZ7uJ+a1QxKzbcshOmLiZzI0w==
X-Received: by 2002:a17:902:1ab:: with SMTP id b40-v6mr93392plb.82.1538072289745;
        Thu, 27 Sep 2018 11:18:09 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:200::5:3e64])
        by smtp.gmail.com with ESMTPSA id p19-v6sm4086614pgh.60.2018.09.27.11.18.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 11:18:09 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com, David Sterba <dsterba@suse.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH v9 2/6] mm: export add_swap_extent()
Date:   Thu, 27 Sep 2018 11:17:34 -0700
Message-Id: <56d08bc182becd35eaa4605c970936caca312cae.1538072009.git.osandov@fb.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1538072009.git.osandov@fb.com>
References: <cover.1538072009.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

Btrfs currently does not support swap files because swap's use of bmap
does not work with copy-on-write and multiple devices. See commit
35054394c4b3 ("Btrfs: stop providing a bmap operation to avoid swapfile
corruptions"). However, the swap code has a mechanism for the filesystem
to manually add swap extents using add_swap_extent() from the
->swap_activate() aop. iomap has done this since commit 67482129cdab
("iomap: add a swapfile activation function"). Btrfs will do the same in
a later patch, so export add_swap_extent().

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 mm/swapfile.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index d3f95833d12e..51cb30de17bc 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2365,6 +2365,7 @@ add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
 	list_add_tail(&new_se->list, &sis->first_swap_extent.list);
 	return 1;
 }
+EXPORT_SYMBOL_GPL(add_swap_extent);
 
 /*
  * A `swap extent' is a simple thing which maps a contiguous range of pages
-- 
2.19.0

