Return-Path: <SRS0=y5XK=V5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48FBC19759
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Aug 2019 12:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B350B20665
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Aug 2019 12:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731373AbfHAMtz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Aug 2019 08:49:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:34444 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726422AbfHAMtz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Aug 2019 08:49:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B3DF3ADF1
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Aug 2019 12:49:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A0067DA7D9; Thu,  1 Aug 2019 14:50:28 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 0/3] Define/enum conversions
Date:   Thu,  1 Aug 2019 14:50:28 +0200
Message-Id: <cover.1564663765.git.dsterba@suse.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

David Sterba (3):
  btrfs: tree-log: convert defines to enums
  btrsf: async-thread: convert defines to enums
  btrfs: tree-log: use symbolic name for first replay stage

 fs/btrfs/async-thread.c |  8 +++++---
 fs/btrfs/tree-log.c     | 22 +++++++++++++---------
 2 files changed, 18 insertions(+), 12 deletions(-)

-- 
2.22.0

