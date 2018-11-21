Return-Path: <SRS0=CLOi=OA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1200FC04EBA
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA4092151B
	for <linux-btrfs@archiver.kernel.org>; Wed, 21 Nov 2018 19:09:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="BVjMPRzw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA4092151B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388414AbeKVFo7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 00:44:59 -0500
Received: from mail-yw1-f50.google.com ([209.85.161.50]:38446 "EHLO
        mail-yw1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729345AbeKVFo5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 00:44:57 -0500
Received: by mail-yw1-f50.google.com with SMTP id i20so2682359ywc.5
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 11:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id;
        bh=X6Gbv5tsZt+MPTQuEvbbYi8vVeiQI/cuP9VjojUyGhk=;
        b=BVjMPRzw8vr+TeQoWSwIHxRGFYdGEs8eH2QWRhUtFnmOXfE1H1S2qWMHE0Yi7Knckz
         NKawIJ1uEOmsL/ZerK6t1DmCZ4ipfZ1Gnf255hbuz7NcOCwkRCnUxp3EKmAvwXm3P8m8
         gOT52ySvWYJs5yspqCqkfZhJEkvE/RA+KZSEuRVCRAEHv5on9zmxybuhOGPY+nxXLzou
         utuRcWzeCD+qlxEt/o5qwzfsVg6X5I7MyBVEQRX488WqN/i/c2op9ERyriLTeorakFDv
         g9zeh0shCu7+T8c+/264D86jeKnCmOfS/00qltqpHDdLgUxIzC1yh4/H3W+4W8oKhChE
         uiuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=X6Gbv5tsZt+MPTQuEvbbYi8vVeiQI/cuP9VjojUyGhk=;
        b=EojZzJR8GLtu/PnQYaKTbRPbAYyg+tTrxlL3v1nx60N+rvRsp1XOeSR4YT2SMFEHpm
         oUjRYg41n3YOooKa/Bisoy+LvEupw1TuOPNye3kOZcul218iIr1tcQ4ES9PzfUpJaMpX
         9TOcbhwBCACBMPl67M9Igov2oLNgvKiXJefApVtfJ3Uwq0LFaAyzkDlYDo+5e6JlaYqx
         L4b3+Q8pqEiM1B2M2eG/nXOXaCjpZUyN23AucsSMC9lIgY4mvV12eaMjl5svFOzHSW9k
         XCH8+wBn0ad88q9uiXuoJvM2EGntomZ8l/8Ra7eP4NIR23uhmvERdZRLWXmKai3xiyIM
         KISQ==
X-Gm-Message-State: AGRZ1gJjf010J4WIgsMdwweF/EKZDqs7Qm2rlm0IwLzoy31aeI6heDGH
        WpzMmlKBeuYPDVNsmYNtkndhwLV033k=
X-Google-Smtp-Source: AJdET5cNSXd4HqhZ7oLnxmTuR5wE1JUgujUyQIA7nUpGUE/x7eFvzoZlYBM+aGg7CwH5lxrpH279Xg==
X-Received: by 2002:a81:3757:: with SMTP id e84mr7921805ywa.380.1542827364094;
        Wed, 21 Nov 2018 11:09:24 -0800 (PST)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id m126sm5977415ywd.39.2018.11.21.11.09.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Nov 2018 11:09:23 -0800 (PST)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 0/3] Delayed iput fixes
Date:   Wed, 21 Nov 2018 14:09:19 -0500
Message-Id: <20181121190922.25038-1-josef@toxicpanda.com>
X-Mailer: git-send-email 2.14.3
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here are some delayed iput fixes.  Delayed iputs can hold reservations for a
while and there's no real good way to make sure they were gone for good, which
means we could early enospc when in reality if we had just waited for the iput
we would have had plenty of space.  So fix this up by making us wait for delayed
iputs when deciding if we need to commit for enospc flushing, and then cleanup
and rework how we run delayed iputs to make it more straightforward to wait on
them and make sure we're all done using them.  Thanks,

Josef
