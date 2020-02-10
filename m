Return-Path: <SRS0=GNeA=36=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3EBC352A4
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Feb 2020 09:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76AA52080C
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Feb 2020 09:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbgBJJCZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Feb 2020 04:02:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:60428 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbgBJJCZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Feb 2020 04:02:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A6915AD3A;
        Mon, 10 Feb 2020 09:02:23 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Doc: Fix the wrong doc about `btrfs filesystem sync`
Date:   Mon, 10 Feb 2020 17:02:01 +0800
Message-Id: <20200210090201.29979-1-wqu@suse.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since commit ecd4bb607f35 ("btrfs-progs: docs: enhance btrfs-filesystem
manual page"), the man page of `btrfs filesystem` shows `sync`
subcommand will wait for all existing orphan subvolumes to be dropped.

That's not true, even at that commit, `btrfs fi sync` only calls
BTRFS_IOC_SYNC ioctl, which is not that much different from vanilla
sync.
It doesn't wait for orphan subvolumes to be dropped from the very
beginning.

It's `btrfs subvolume sync` doing the wait work.

Reported-by: Nikolay Borisov <nborisov@suse.com>
Fixes: ecd4bb607f35 ("btrfs-progs: docs: enhance btrfs-filesystem manual page")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/btrfs-filesystem.asciidoc | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/btrfs-filesystem.asciidoc b/Documentation/btrfs-filesystem.asciidoc
index 84efaa1a8f8f..3f62a3608cb1 100644
--- a/Documentation/btrfs-filesystem.asciidoc
+++ b/Documentation/btrfs-filesystem.asciidoc
@@ -253,9 +253,8 @@ show sizes in GiB, or GB with --si
 show sizes in TiB, or TB with --si
 
 *sync* <path>::
-Force a sync of the filesystem at 'path'. This is done via a special ioctl and
-will also trigger cleaning of deleted subvolumes. Besides that it's equivalent
-to the `sync`(1) command.
+Force a sync of the filesystem at 'path'. This should be the same as vanilla
+'sync' command, but only for specified btrfs.
 
 *usage* [options] <path> [<path>...]::
 Show detailed information about internal filesystem usage. This is supposed to
-- 
2.25.0

