Return-Path: <SRS0=2F5/=2C=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0182C43603
	for <linux-btrfs@archiver.kernel.org>; Thu, 12 Dec 2019 11:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FD0D2077B
	for <linux-btrfs@archiver.kernel.org>; Thu, 12 Dec 2019 11:01:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L6Sre3Bo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbfLLLBh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 06:01:37 -0500
Received: from mail-pf1-f179.google.com ([209.85.210.179]:36590 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728871AbfLLLBh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Dec 2019 06:01:37 -0500
Received: by mail-pf1-f179.google.com with SMTP id x184so579054pfb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Dec 2019 03:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TCwIi7r7Dm35C7/iIwNw46KNyU4JU8vydOZk862Md70=;
        b=L6Sre3BoLfGEYYCSkAl3KyqMRj9DdlHzoPuQGl487rrH28p5xxgCQFD2Ys5Nv9U4xo
         vbGZmc+WeZFfmYoQ89uxHWrjUVOG0ImlR7eOBLQWRXDI5qS+sSXlXssGs0DHqzjc2ZEn
         FsvSHye8kGnrkrICnc1Tz44/31k5uLtjq5ena248TGzTscTzGAKXspbioAF8Bx0KR3m7
         y71xOC2W1lgRnjD0Tx28ps4WzPYowDbJiM1i4UcK+KN/sj2yyFpYx959nY+3yUMBvcje
         FXbkaQtoQNx35qts7bNm+p4jtOD2rg2BH8NGfEGFza//zebwWaYyHQs4eY2JDXSaEmQw
         eNnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TCwIi7r7Dm35C7/iIwNw46KNyU4JU8vydOZk862Md70=;
        b=G/fmELusEGYNqtjw+YZg3Fmcpkto9mpXLzqrttX/YrnE2yeoNvGBMSg/WwtOsbpeAV
         l2pc1QwmVGDVSh4n4EIkFgRZeRKQpsrjFMwDIXObBADSOcs9PlEfBSuDK9GfqcQpiJRi
         QUTmdEUu9bkgCdNnPQVl5eNALvoHrR5jSjZ7nY6m9fnR7Nq9m6LoJG9/RD94J9g5jlkI
         qyFN6H6gn3EWSgzfKDSe1o+RJRWjB0te+Xi2LnvbXMUaA4Mq7cZxZeGwaUH/gOrfC8md
         EoteAQOPrTac8fIeeJtyxDC1He9BVUfDULJ1KzgdHYCtyIEvVPHcMjPWzlP9CnvK2IsU
         1tyg==
X-Gm-Message-State: APjAAAXGQS/AUQOAJjof8nan2ZLSn6DiAW33i1HMmk/aE5UGcBpVwclA
        zudI/GNlFnfcNn66AfwF1BDmpwerLSI=
X-Google-Smtp-Source: APXvYqwh8KDvs7VZjJk2TBoleKgBQoHjcOL0RxFe9z48YKk/zZDW3MjCu9tLRMGvJQ4nih8rEvluJw==
X-Received: by 2002:a63:1d1a:: with SMTP id d26mr9236862pgd.98.1576148496671;
        Thu, 12 Dec 2019 03:01:36 -0800 (PST)
Received: from p.lan ([45.58.38.246])
        by smtp.gmail.com with ESMTPSA id w11sm6682387pfn.4.2019.12.12.03.01.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Dec 2019 03:01:36 -0800 (PST)
From:   damenly.su@gmail.com
X-Google-Original-From: Damenly_Su@gmx.com
To:     linux-btrfs@vger.kernel.org
Cc:     Su Yue <Damenly_Su@gmx.com>
Subject: [PATCH 0/6] btrfs: metadata uuid fixes and enhancements
Date:   Thu, 12 Dec 2019 19:01:26 +0800
Message-Id: <20191212110132.11063-1-Damenly_Su@gmx.com>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yue <Damenly_Su@gmx.com>

This patchset fixes one reproducible bug and add two split-brain
cases ignored.

The origin code thinks the final state of successful synced device is
always has INCOMPAT_METADATA_UUID feature. However, a device without
the feature flag can be the one pull into disk. This is what handled
in the patchset. Test images are added in btrfs-progs part.

Patch[1] fixes a bug about wrong fsid copy.
Patch[2] is for the later patches.
Patch[3-5] add the forgotten cases.
Patch[6] just does simple code movement for grace.

The set passes xfstests-dev without regressions.

Su Yue (6):
  btrfs: metadata_uuid: fix failed assertion due to unsuccessful device
    scan
  btrfs: metadata_uuid: move split-brain handling from fs_id() to new
    function
  btrfs: split-brain case for scanned changing device with
    INCOMPAT_METADATA_UUID
  btrfs: split-brain case for scanned changed device without
    INCOMPAT_METADATA_UUID
  btrfs: copy fsid and metadata_uuid for pulled disk without
    INCOMPAT_METADATA_UUID
  btrfs: metadata_uuid: move partly logic into find_fsid_inprogress()

 fs/btrfs/volumes.c | 193 +++++++++++++++++++++++++++++----------------
 1 file changed, 125 insertions(+), 68 deletions(-)

-- 
2.24.0

