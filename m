Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51956 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbcDZPjo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 11:39:44 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 10C2C20166
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 15:39:43 +0000 (UTC)
Received: from debian3.lan (bl12-226-64.dsl.telepac.pt [85.245.226.64])
	(using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id EE5712014A
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Apr 2016 15:39:41 +0000 (UTC)
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] Fix for race in relocation and avoid start and wait for unrelated IO
Date: Tue, 26 Apr 2016 16:39:37 +0100
Message-Id: <1461685179-3957-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

The following patches fix a hard to hit race and unecessary flushing of
delalloc regions and waiting for unrelated IO (IO against extents outside
of the block group being relocated).

The race is between relocation and direct IO writes that lead to the
relocation process miss extents and not move them, and later makes us hit
a BUG_ON() if we attempt to read the extents.

Patch 1 just avoids waiting for unrelated ordered extents to complete
while patch 2 fixes the race and avoids flushing delalloc.

Thanks.

V2: Removed the first patch in the v1 series, it was meant for a false
    positive.

Filipe Manana (2):
  Btrfs: don't wait for unrelated IO to finish before relocation
  Btrfs: don't do unnecessary delalloc flushes when relocating

 fs/btrfs/ctree.h        | 14 ++++++++++
 fs/btrfs/dev-replace.c  |  4 +--
 fs/btrfs/extent-tree.c  | 69 ++++++++++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/inode.c        |  8 ++++++
 fs/btrfs/ioctl.c        |  2 +-
 fs/btrfs/ordered-data.c | 26 ++++++++++++++-----
 fs/btrfs/ordered-data.h |  6 +++--
 fs/btrfs/relocation.c   | 10 +++----
 fs/btrfs/super.c        |  2 +-
 fs/btrfs/transaction.c  |  2 +-
 10 files changed, 117 insertions(+), 26 deletions(-)

-- 
2.7.0.rc3

