Return-Path: <SRS0=dUzf=XF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21512C4740A
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Sep 2019 14:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA99320872
	for <linux-btrfs@archiver.kernel.org>; Tue, 10 Sep 2019 14:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568125568;
	bh=sedSIO1rGbODcL7FwFUnJX3tByeWXLqBjFtJbOMZoCA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=iemRFt6SomMuqNYzqU1rXiKVfJfHMTNnx9KXimXBVUtbGcLOmOuKeCTGV+y3t1x0Y
	 Fkwn2WXDmsp+5IuSYlsqS71H0LSu/j4xpD6iDYSF6DEKxTaYg9WuIyHIz4mSLutWQr
	 ruR4bgDqz3gs0IMJBxiimNqvdR5C0NKC0HJsCNZY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387433AbfIJO0I (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 10 Sep 2019 10:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726132AbfIJO0I (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Sep 2019 10:26:08 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7C6620863;
        Tue, 10 Sep 2019 14:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568125567;
        bh=sedSIO1rGbODcL7FwFUnJX3tByeWXLqBjFtJbOMZoCA=;
        h=From:To:Cc:Subject:Date:From;
        b=cUgNOLmfvkoQToHA/ZxRyyygrMwpALeNpC34rKiCs5OxcZk37Jp6qbgZP6C1blKnx
         hhsGcvh3fQPp4e3ahZVqbgq3MffexGMRngwjg4FS+m8WCqlfnN/6Ah3lZbVRjN4IFq
         vmfrH1+M/Zb3PILm759Yw7NV9vYtbFLqkFXN/6jE=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs/079: fix failure to umount scratch fs due to running filefrag process
Date:   Tue, 10 Sep 2019 15:26:01 +0100
Message-Id: <20190910142601.19752-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The test fails sporadically when trying to unmount the scratch filesystem
because a filefrag process is still running against a file that exists on
the scrach filesystem. This is because killing the subshell running the
fiemap_work() function does not wait for any filefrag process to complete
first. We need to set a trap for the SIGTERM signal on the subshell so
that it waits for any filefrag process before exitting.

The failure resulted in error messages like the following:

  btrfs/079 57s ... umount: /home/fdmanana/btrfs-tests/scratch_1: target is busy
          (In some cases useful info about processes that
           use the device is found by lsof(8) or fuser(1).)
  _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent
  (see /home/fdmanana/git/hub/xfstests/results//btrfs/079.full for details)

Fix this by adding a trap for SIGTERM.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/079 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tests/btrfs/079 b/tests/btrfs/079
index e848a261..1e9411be 100755
--- a/tests/btrfs/079
+++ b/tests/btrfs/079
@@ -77,6 +77,12 @@ _filter_error() {
 }
 
 fiemap_work() {
+	# Wait for any running 'filefrag' subcommand before exitting so that
+	# after the test kills the subshell running this function, it does not
+	# fail with EBUSY when unmounting the scratch device because the filefrag
+	# subcommand is still running with an open file on the scratch fs.
+	trap "wait; exit" SIGTERM
+
 	filename=$1
 	while true; do
 		$FILEFRAG_PROG $filename 2> $tmp.output 1> /dev/null
-- 
2.11.0

