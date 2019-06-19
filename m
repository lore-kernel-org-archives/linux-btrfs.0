Return-Path: <SRS0=qrcf=US=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390C5C31E49
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jun 2019 14:04:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D590208CA
	for <linux-btrfs@archiver.kernel.org>; Wed, 19 Jun 2019 14:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730283AbfFSOEo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 19 Jun 2019 10:04:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:42864 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726047AbfFSOEn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Jun 2019 10:04:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 66241AC0C
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Jun 2019 14:04:42 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 0/4] Spring cleaning
Date:   Wed, 19 Jun 2019 17:04:36 +0300
Message-Id: <20190619140440.5550-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Just a couple of patches that remove unneeded code. The first one does away 
with an always true if construct and the rest remove code which has been #if 0
for quite some time.

Nikolay Borisov (4):
  btrfs-progs: Remove redundant if
  btrfs-progs: Remove commented code
  btrfs: Remove old send implementation
  btrfs-progs: check: Remove duplicated and commented functions

 check/main.c  |  69 -------------
 cmds-send.c   |  61 ------------
 extent-tree.c | 270 +-------------------------------------------------
 3 files changed, 5 insertions(+), 395 deletions(-)

-- 
2.17.1

