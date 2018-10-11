Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BEDAC46463
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 05:40:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 408FE2085B
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 05:40:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 408FE2085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbeJKNGd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 09:06:33 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:38796 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728000AbeJKNGb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 09:06:31 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="45913759"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 11 Oct 2018 13:40:47 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1E1AE4B6ED8C
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 13:40:46 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 11 Oct
 2018 13:40:50 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [PATCH 0/6] Some trivail cleanup about dealyed-refs
Date:   Thu, 11 Oct 2018 13:40:32 +0800
Message-ID: <20181011054038.5428-1-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 1E1AE4B6ED8C.AB3E2
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is no functional change. Just improve readablity.

PATCH 1-4 parameter cleanup patches
PATCH 5 cleanup about btrfs_select_ref_head
PATCH 6 switch int to bool; add some comment

Lu Fengqi (6):
  btrfs: delayed-ref: pass delayed_refs directly to
    btrfs_select_ref_head()
  btrfs: delayed-ref: pass delayed_refs directly to
    btrfs_delayed_ref_lock()
  btrfs: remove fs_info from btrfs_check_space_for_delayed_refs
  btrfs: remove fs_info from btrfs_should_throttle_delayed_refs
  btrfs: simplify btrfs_select_ref_head and cleanup some local variables
  btrfs: switch return_bigger to bool in find_ref_head

 fs/btrfs/ctree.h       |  6 ++----
 fs/btrfs/delayed-ref.c | 35 ++++++++++-------------------------
 fs/btrfs/delayed-ref.h |  4 ++--
 fs/btrfs/extent-tree.c | 15 +++++++--------
 fs/btrfs/inode.c       |  7 +++----
 fs/btrfs/transaction.c |  4 ++--
 6 files changed, 26 insertions(+), 45 deletions(-)

-- 
2.19.1



