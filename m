Return-Path: <SRS0=VYXz=XT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 907CAC432C1
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 09:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D1FB214D9
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Sep 2019 09:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569318549;
	bh=y2LY6V2/z6HBlnZcH+Fs8J3fOlPE9OiduKroTdQ8i/s=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=zJlO5OjkXY8vKv7D0+sVIe+/l2pmE7rwzLD29F7M5tMUGeS+cuB/mPOM3yw/feBjv
	 Al3qJgL/+spAIS2reDVp7JgarqZh1RCgywcCIxseiETUkydrM0fa3A/9wjG3kjLVCp
	 UY7V1DqXyQvuYpf5wHt+AUDC+lkLxWj/aehllCTg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395316AbfIXJtI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 05:49:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392592AbfIXJtI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Sep 2019 05:49:08 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7BEE20872;
        Tue, 24 Sep 2019 09:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569318547;
        bh=y2LY6V2/z6HBlnZcH+Fs8J3fOlPE9OiduKroTdQ8i/s=;
        h=From:To:Cc:Subject:Date:From;
        b=h5hfsuinCrH10X/CeuFy3GMXuLfR34OT33q2kyNMVQyXiYpvrRLYbPy/+fbAPJimu
         GFFlVPBynLTDS3dSpItMUpr/gckPaqgIpiRQ9alsgDr3G24cby5VFs8g83cM9Zoaq3
         KkbbuQl+Z9KGLwtXRX5DRWtIMMQGxJV9DOgSEJ7g=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] btrfs/036: fix sporadic failures when unmounting scratch filesystem
Date:   Tue, 24 Sep 2019 10:49:02 +0100
Message-Id: <20190924094902.1243-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Often this test can fail on unmount because a 'btrfs subvolume snapshot'
command is still running and using the scratch the mount point:

  btrfs/036 168s ... umount: /home/fdmanana/btrfs-tests/scratch_1: target is busy
          (In some cases useful info about processes that
           use the device is found by lsof(8) or fuser(1).)
  _check_btrfs_filesystem: filesystem on /dev/sdc is inconsistent
  (see /home/fdmanana/git/hub/xfstests/results//btrfs/036.full for details)

This happens because when we kill the process running the do_snapshots()
function we only kill the subshell and don't wait for any processes it
has spawned to finish before the subshell exits. Fix this by setting a
trap in the do_snapshots() function, so that when the subshell receives
a SIGTERM signal it waits for any running 'btrfs subvolume snapshot'
to finish before exitting. We were also not waiting for the subshell
to exit after sending it the SIGTERM signal, so fix that as well by
calling the 'wait' command after calling 'kill' to send that signal.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/036 | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tests/btrfs/036 b/tests/btrfs/036
index cb578569..4280a84f 100755
--- a/tests/btrfs/036
+++ b/tests/btrfs/036
@@ -20,12 +20,19 @@ _cleanup()
 	# kill backgroud snapshots
 	if [ $snapshots_pid -ne 0 ] && ps -p $snapshots_pid | grep -q $snapshots_pid; then
 		kill -TERM $snapshots_pid 2> /dev/null
+		wait $snapshots_pid
 	fi
 	rm -f $tmp.*
 }
 
 do_snapshots()
 {
+	# Wait for any running 'btrfs subvolume snapshot' subcommand before
+	# exitting so that after the test kills the subshell running this
+	# function, it does not fail with EBUSY when unmounting the scratch
+	# device.
+	trap "wait; exit" SIGTERM
+
 	i=2
 	while [ 1 ]
 	do
-- 
2.11.0

