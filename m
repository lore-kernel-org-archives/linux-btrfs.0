Return-Path: <SRS0=w+x4=YH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C70ECE587
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Oct 2019 12:22:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D56FE217D9
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Oct 2019 12:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbfJNMWL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Oct 2019 08:22:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:37256 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727038AbfJNMWL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Oct 2019 08:22:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7E2ADBE31;
        Mon, 14 Oct 2019 12:22:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0E72EDA7E3; Mon, 14 Oct 2019 14:22:21 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 00/15] Remove callback indirections in compression code
Date:   Mon, 14 Oct 2019 14:22:21 +0200
Message-Id: <cover.1571054758.git.dsterba@suse.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The series removes all per-compression algorithm callbacks and replaces
them with a switches. Lots of indirections are simplified and while it
looks nice from design POV, we don't need to over-engineer it as we have
only fixed known number of the users and not public API.

The cost of indirect function calls is also higher with enabled
mitigations of the spectre vulnerability, so they've been incrementally
removed from the whole kernel and from btrfs as well.

David Sterba (15):
  btrfs: export compression and decompression callbacks
  btrfs: switch compression callbacks to direct calls
  btrfs: compression: attach workspace manager to the ops
  btrfs: compression: let workspace manager init take only the type
  btrfs: compression: inline init_workspace_manager
  btrfs: compression: let workspace manager cleanup take only the type
  btrfs: compression: inline cleanup_workspace_manager
  btrfs: compression: export alloc/free/get/put callbacks of all algos
  btrfs: compression: inline get_workspace
  btrfs: compression: inline put_workspace
  btrfs: compression: pass type to btrfs_get_workspace
  btrfs: compression: inline alloc_workspace
  btrfs: compression: pass type to btrfs_put_workspace
  btrfs: compression: inline free_workspace
  btrfs: compression: remove ops pointer from workspace_manager

 fs/btrfs/compression.c | 241 +++++++++++++++++++++++++++++++----------
 fs/btrfs/compression.h |  39 +------
 fs/btrfs/lzo.c         |  53 ++-------
 fs/btrfs/zlib.c        |  52 ++-------
 fs/btrfs/zstd.c        |  47 +++-----
 5 files changed, 227 insertions(+), 205 deletions(-)

-- 
2.23.0

