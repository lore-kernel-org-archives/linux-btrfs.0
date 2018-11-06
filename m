Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B73BC46465
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E3B72081D
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 06:42:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E3B72081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387636AbeKFQFy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 11:05:54 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44359 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387491AbeKFQFy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Nov 2018 11:05:54 -0500
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="47417739"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 06 Nov 2018 14:42:10 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 8E5FD4B6ED56
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Nov 2018 14:42:05 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 6 Nov
 2018 14:42:09 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [PATCH v10.6 0/5] In-band de-duplication for btrfs-progs
Date:   Tue, 6 Nov 2018 14:41:53 +0800
Message-ID: <20181106064158.6356-1-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 8E5FD4B6ED56.AB60C
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Patchset can be fetched from github:
https://github.com/littleroad/btrfs-progs.git dedupe_latest

Inband dedupe(in-memory backend only) ioctl support for btrfs-progs.

v7 changes:
   Update ctree.h to follow kernel structure change
   Update print-tree to follow kernel structure change
V8 changes:
   Move dedup props and on-disk backend support out of the patchset
   Change command group name to "dedupe-inband", to avoid confusion with
   possible out-of-band dedupe. Suggested by Mark.
   Rebase to latest devel branch.
V9 changes:
   Follow kernels ioctl change to support FORCE flag, new reconf ioctl,
   and more precious error reporting.
v10 changes:
   Rebase to v4.10.
   Add BUILD_ASSERT for btrfs_ioctl_dedupe_args
v10.1 changes:
   Rebase to v4.14.
v10.2 changes:
   Rebase to v4.16.1.
v10.3 changes:
   Rebase to v4.17.
v10.4 changes:
   Deal with offline reviews from Misono Tomohiro.
   1. s/btrfs-dedupe/btrfs-dedupe-inband
   2. Replace strerror(errno) with %m
   3. Use SZ_* instead of intermedia number
   4. update btrfs-completion for reconfigure subcommand
v10.5 changes:
   Rebase to v4.17.1.
v10.6 changes:
   Rebase to v4.19.

Qu Wenruo (5):
  btrfs-progs: Basic framework for dedupe-inband command group
  btrfs-progs: dedupe: Add enable command for dedupe command group
  btrfs-progs: dedupe: Add disable support for inband dedupelication
  btrfs-progs: dedupe: Add status subcommand
  btrfs-progs: dedupe: introduce reconfigure subcommand

 Documentation/Makefile.in                  |   1 +
 Documentation/btrfs-dedupe-inband.asciidoc | 167 ++++++++
 Documentation/btrfs.asciidoc               |   4 +
 Makefile                                   |   3 +-
 btrfs-completion                           |   6 +-
 btrfs.c                                    |   2 +
 cmds-dedupe-ib.c                           | 437 +++++++++++++++++++++
 commands.h                                 |   2 +
 dedupe-ib.h                                |  28 ++
 ioctl.h                                    |  38 ++
 10 files changed, 686 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/btrfs-dedupe-inband.asciidoc
 create mode 100644 cmds-dedupe-ib.c
 create mode 100644 dedupe-ib.h

-- 
2.19.1



