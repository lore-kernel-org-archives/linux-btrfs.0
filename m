Return-Path: <SRS0=ZmOe=WQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B75C3A589
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Aug 2019 16:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E045922DD3
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Aug 2019 16:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbfHTQQ6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 12:16:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:57520 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725971AbfHTQQ5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Aug 2019 12:16:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B0A24AD2B
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2019 16:16:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 12A96DA7DA; Tue, 20 Aug 2019 18:17:22 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH v2 0/2] Compression level API cleanups
Date:   Tue, 20 Aug 2019 18:17:22 +0200
Message-Id: <cover.1566313756.git.dsterba@suse.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Remove the callback indirection.

v2:
* switch to unsigned int and use min()

David Sterba (2):
  btrfs: define compression levels statically
  btrfs: compression: replace set_level callbacks by a common helper

 fs/btrfs/compression.c | 20 ++++++++++++++++++--
 fs/btrfs/compression.h | 11 +++++------
 fs/btrfs/lzo.c         |  8 ++------
 fs/btrfs/zlib.c        | 11 ++---------
 fs/btrfs/zstd.c        | 11 ++---------
 5 files changed, 29 insertions(+), 32 deletions(-)

-- 
2.22.0

