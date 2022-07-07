Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 695A9C43334
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Jul 2022 19:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbiGGTHk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 15:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbiGGTHj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2022 15:07:39 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575CE57230
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Jul 2022 12:07:36 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 17CD91FDC6;
        Thu,  7 Jul 2022 19:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657220855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=mlT5NY+Di5OzJY96QG40yw6KVQh2qO4NCvSV4SAerq0=;
        b=N8RUpT0qgh4uWHTamg6oFr7c4qWb85oDs7HUV0O4uZHyxQiHrnB53Qp6LhhUAplekW8YJv
        oYxHgmy8Xfv0KaNuCytUKXmWPh99JNjqF7PApD3o5d/6b2m61+DtaPPG/QZVwSGFwyVzVs
        QQxNs0IN7cqhblUIQw+a2sipokkoXzI=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 104672C141;
        Thu,  7 Jul 2022 19:07:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7248DDA83C; Thu,  7 Jul 2022 21:02:49 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH v2 0/3] Cleanup short int types in block group reserve
Date:   Thu,  7 Jul 2022 21:02:49 +0200
Message-Id: <cover.1657220460.git.dsterba@suse.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Using the short type in btrfs_block_rsv is not needed for bool
indicators and we can make the structure smaller.

v2:
- fix true/false typo in first patch
- use named enum for block group type

David Sterba (3):
  btrfs: switch btrfs_block_rsv::full to bool
  btrfs: switch btrfs_block_rsv::failfast to bool
  btrfs: use enum for btrfs_block_rsv::type

 fs/btrfs/block-rsv.c   | 21 +++++++++------------
 fs/btrfs/block-rsv.h   | 15 ++++++++-------
 fs/btrfs/delayed-ref.c |  4 ++--
 fs/btrfs/file.c        |  2 +-
 fs/btrfs/inode.c       |  4 ++--
 5 files changed, 22 insertions(+), 24 deletions(-)

-- 
2.36.1

