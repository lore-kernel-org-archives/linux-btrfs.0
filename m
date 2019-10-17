Return-Path: <SRS0=AqV7=YK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E27DDECE599
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Oct 2019 02:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C03BE2053B
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Oct 2019 02:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387605AbfJQCin (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Oct 2019 22:38:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:59848 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727233AbfJQCim (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Oct 2019 22:38:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DDBFBB1EE
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Oct 2019 02:38:41 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs: qgroup: Bug fixes for trace events
Date:   Thu, 17 Oct 2019 10:38:35 +0800
Message-Id: <20191017023837.32264-1-wqu@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Several stupid bugs exposed for qgroup related trace events.
Fix them.

Changelog:
v2:
- Split patches

Qu Wenruo (2):
  btrfs: qgroup: Fix wrong parameter order for trace events
  btrfs: qgroup: Fix bad entry members of qgroup trace events

 fs/btrfs/qgroup.c            | 4 ++--
 include/trace/events/btrfs.h | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

-- 
2.23.0

