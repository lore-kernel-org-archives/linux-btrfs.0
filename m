Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NORMAL_HTTP_TO_IP,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0232BC7112C
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3F7120665
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:34:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3F7120665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbeJWR5V (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 13:57:21 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:18632 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728603AbeJWR5V (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 13:57:21 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46602838"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 23 Oct 2018 17:34:43 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 3042B4B710E8
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2018 17:34:43 +0800 (CST)
Received: from archlinux.g08.fujitsu.local (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 23 Oct 2018 17:34:49 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH 12/13] btrfs-progs: tests: add case for inode lose one file extent
Date:   Tue, 23 Oct 2018 17:41:46 +0800
Message-ID: <20181023094147.7906-13-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: 3042B4B710E8.A81C2
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

The missing extent will lead to the existence of the gap between adjacent
extents. The fsck should can detect the gap correctly and repair by punch
a hole.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 .../.lowmem_repairable                           |   0
 .../038-missing-one-file-extent/default_case.img | Bin 0 -> 3072 bytes
 2 files changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests/038-missing-one-file-extent/.lowmem_repairable
 create mode 100644 tests/fsck-tests/038-missing-one-file-extent/default_case.img

diff --git a/tests/fsck-tests/038-missing-one-file-extent/.lowmem_repairable b/tests/fsck-tests/038-missing-one-file-extent/.lowmem_repairable
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/fsck-tests/038-missing-one-file-extent/default_case.img b/tests/fsck-tests/038-missing-one-file-extent/default_case.img
new file mode 100644
index 0000000000000000000000000000000000000000..7cc2cd403977a805a58c61f007d517f24412800c
GIT binary patch
literal 3072
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

literal 0
HcmV?d00001

-- 
2.19.1



