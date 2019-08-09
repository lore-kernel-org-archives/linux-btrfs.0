Return-Path: <SRS0=8AUe=WF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A2AC433FF
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Aug 2019 06:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE443208C3
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Aug 2019 06:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405611AbfHIGxc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Aug 2019 02:53:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:38116 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728823AbfHIGxc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Aug 2019 02:53:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 268FBB03B
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Aug 2019 06:53:31 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs-progs: Check and repair invalid root item generation
Date:   Fri,  9 Aug 2019 14:53:17 +0800
Message-Id: <20190809065320.22702-1-wqu@suse.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Kernel is going to reject invalid root generation.

Consider the existing checks are causing some error reports, we should
handle such problem in advance, so that's the patchset is going to do,
check and repair such invalid root generation.

Qu Wenruo (3):
  btrfs-progs: check/lowmem: Check and repair root generation
  btrfs-progs: check/original: Check and repair root item geneartion
  btrfs-progs: fsck-tests: Add test case for invalid root generation

 check/main.c                                  |  20 ++++++++++++
 check/mode-common.c                           |  29 ++++++++++++++++++
 check/mode-common.h                           |   1 +
 check/mode-lowmem.c                           |  16 ++++++++++
 check/mode-lowmem.h                           |   1 +
 .../default_case.img                          | Bin 0 -> 3072 bytes
 6 files changed, 67 insertions(+)
 create mode 100644 tests/fsck-tests/041-invalid-root-generation/default_case.img

-- 
2.22.0

