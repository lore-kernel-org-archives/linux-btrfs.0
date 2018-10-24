Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03CEC004D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 12:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3119F20824
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 12:24:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3119F20824
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbeJXUwL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 16:52:11 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:30356 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726812AbeJXUwL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 16:52:11 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46658919"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 24 Oct 2018 20:24:15 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 3B2D34B714A4
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 20:24:11 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 24 Oct
 2018 20:24:16 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/3] fix pinned underflow in generic/475
Date:   Wed, 24 Oct 2018 20:24:00 +0800
Message-ID: <20181024122403.17418-1-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 3B2D34B714A4.A6BE5
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When running generic/475, pinned underflow may occur. This patch will
fix this problem, but there are still other warnings need to addressed in
this case.

Patch 1-2 introduce a macro and wrappers to help detect underflow
Patch 3	the fix patch of pinned underflow

Lu Fengqi (2):
  btrfs: extent-tree: Detect bytes_pinned underflow earlier
  btrfs: fix pinned underflow after transaction aborted

Qu Wenruo (1):
  btrfs: extent-tree: Detect bytes_may_use underflow earlier

 fs/btrfs/disk-io.c     | 12 +++++++++-
 fs/btrfs/extent-tree.c | 53 ++++++++++++++++++++++++++----------------
 2 files changed, 44 insertions(+), 21 deletions(-)

-- 
2.19.1



