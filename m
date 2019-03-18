Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D8C0C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4929420854
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 16:48:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfCRQsw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 12:48:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:55836 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726719AbfCRQsv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 12:48:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B6458AD3A
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2019 16:48:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B9833DA8A7; Mon, 18 Mar 2019 17:50:05 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 00/22] Self test cleanups, error handling fixes
Date:   Mon, 18 Mar 2019 17:50:04 +0100
Message-Id: <cover.1552927639.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add missing error handling, unify test structure and error messages.

David Sterba (22):
  btrfs: tests: handle fs_info allocation failure in extent_io tests
  btrfs: tests: don't leak fs_info in extent_io bitmap tests
  btrfs: tests: print file:line for error messages
  btrfs: tests: add table of most common errors
  btrfs: tests: use standard error message after fs_info allocation
    failure
  btrfs: tests: use standard error message after root allocation failure
  btrfs: tests: use standard error message after extent buffer
    allocation failure
  btrfs: tests: use standard error message after path allocation failure
  btrfs: tests: use standard error message after inode allocation
    failure
  btrfs: tests: use standard error message after block group allocation
    failure
  btrfs: tests: properly initialize fs_info of extent buffer
  btrfs: tests: return errors from extent map tests
  btrfs: tests: return errors from extent map test case 1
  btrfs: tests: return errors from extent map test case 2
  btrfs: tests: return errors from extent map test case 3
  btrfs: tests: return errors from extent map test case 4
  btrfs: tests: return error from all extent map test cases
  btrfs: tests: use standard error message after extent map allocation
    failure
  btrfs: tests: use SZ_ constants everywhere
  btrfs: tests: fix comments about tested extent map ranges
  btrfs: tests: drop messages when some tests finish
  btrfs: tests: unify messages when tests start

 fs/btrfs/tests/btrfs-tests.c           |  10 ++
 fs/btrfs/tests/btrfs-tests.h           |  17 +-
 fs/btrfs/tests/extent-buffer-tests.c   |   8 +-
 fs/btrfs/tests/extent-io-tests.c       |  29 ++--
 fs/btrfs/tests/extent-map-tests.c      | 213 +++++++++++++++++--------
 fs/btrfs/tests/free-space-tests.c      |  11 +-
 fs/btrfs/tests/free-space-tree-tests.c |  10 +-
 fs/btrfs/tests/inode-tests.c           |  33 ++--
 fs/btrfs/tests/qgroup-tests.c          |  20 +--
 9 files changed, 237 insertions(+), 114 deletions(-)

-- 
2.21.0

