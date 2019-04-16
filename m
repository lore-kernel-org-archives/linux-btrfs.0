Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33406C10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 10:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DD0F206BA
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 10:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbfDPKVu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 06:21:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:50668 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728625AbfDPKVu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 06:21:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 92198AFD4
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 10:21:49 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: Metadata preallocation enhancement
Date:   Tue, 16 Apr 2019 18:21:42 +0800
Message-Id: <20190416102144.12173-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patchset will address the github issue #123 to make btrfs-convert
less possible to report false ENOSPC.

The first patch will try to avoid the nested chunk/extent tree
modification in a more explicit way.

The 2nd patch will address the ENOSPC problem, by adding CSUM tree to
the metadata preallocate list.

The 2nd patch is not as aggressive as 7a12d8470e5f ("btrfs-progs:
Do metadata preallocation as long as we're not modifying extent tree").
Even we have the 1st patch I still prefer to make less modification to
avoid possible bugs.

Qu Wenruo (2):
  btrfs-progs: Avoid nested chunk allocation call
  btrfs-progs: Do metadata preallocation for fs trees and csum tree

 check/main.c  |  2 +-
 extent-tree.c | 20 +++++++++++++++++++-
 transaction.c |  3 ++-
 transaction.h |  3 ++-
 4 files changed, 24 insertions(+), 4 deletions(-)

-- 
2.21.0

