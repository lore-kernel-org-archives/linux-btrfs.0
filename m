Return-Path: <SRS0=E4Z9=YI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477DFECE588
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Oct 2019 15:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2433A2086A
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Oct 2019 15:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731373AbfJOPmx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 11:42:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:44480 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731093AbfJOPmx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Oct 2019 11:42:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D85C3B4B8;
        Tue, 15 Oct 2019 15:42:51 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/2] Support patches for btrfs backup root rework
Date:   Tue, 15 Oct 2019 18:42:47 +0300
Message-Id: <20191015154249.21615-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Here are two patches which I cooked up while working on the kernel side of backup
root retention code. The first one fixes '-m <bytenr> -f generation' options to 
btrfs-corrupt-block, allowing me to simulate backup root corruption. 

The second patch is a test case which sanity checks the implementation. It suceeds
both before and after my rework of the kernel code. 

Nikolay Borisov (2):
  btrfs-progs: corrupt-block: Refactor tree block corruption code
  btrfs-progs: tests: Test backup root retention logic

 btrfs-corrupt-block.c                              | 108 +++++++++++----------
 .../misc-tests/038-backup-root-corruption/test.sh  |  50 ++++++++++
 2 files changed, 107 insertions(+), 51 deletions(-)
 create mode 100755 tests/misc-tests/038-backup-root-corruption/test.sh

-- 
2.7.4

