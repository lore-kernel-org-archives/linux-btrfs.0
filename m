Return-Path: <SRS0=6jfg=QB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2111C282C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 11:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95F14218E2
	for <linux-btrfs@archiver.kernel.org>; Fri, 25 Jan 2019 11:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548416791;
	bh=hEmHoTgAGwbr3lOvWOYczS/wFWn9ysTCj5jIcsJTKbc=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=RS1+F/J4vpBQWj5xD0tNYXMROCvS8NoH+t2GqroOCAQSBn8+v4CnEYJ4wowimeHKs
	 NlW52NSq0QhI30I3IGbKYGa72+Yyc5iH81P22DrIVJyxxjWpGLhO3pvPMWiFNh+iJ/
	 26r68JZZcy4gTratsc3+Ojo+KdMCZytVs7SvqzQc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbfAYLqb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 25 Jan 2019 06:46:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbfAYLqa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Jan 2019 06:46:30 -0500
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45F33218CD;
        Fri, 25 Jan 2019 11:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548416790;
        bh=hEmHoTgAGwbr3lOvWOYczS/wFWn9ysTCj5jIcsJTKbc=;
        h=From:To:Cc:Subject:Date:From;
        b=TeJ35SaoblVHn5LVgZRs1u4rwSRNhHWK0tTH+idJy4pgZed5/hR2rAeKcovkH2tBp
         oMH6FBAJyeQKx3TteTgr4JWaURgUylOFUbaByl7SAZZKvwFpeNv12XYklRdvwGFzqj
         +gSRWuloAIHek2Sd2+OjgXKXByAMg2PjA12RocH4=
From:   fdmanana@kernel.org
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/2] fstests: btrfs/081, fix killing of reader loop subshell
Date:   Fri, 25 Jan 2019 11:46:24 +0000
Message-Id: <20190125114624.4004-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The test creates a subshell that keeps running the 'cat' command against a
test file in an infinite loop, and after it kills the subshell it unmounts
the filesystem, after which point any 'cat' subcommand that runs after or
at that time will fail resulting in an unexpected golden output:

  $ ./check btrfs/081
  btrfs/081 3s ... - output mismatch (see /home/fdmanana/git/hub/xfstests/results//btrfs/081.out.bad)
      --- tests/btrfs/081.out	2018-09-16 21:30:48.501104179 +0100
      +++ /home/fdmanana/git/hub/xfstests/results//btrfs/081.out.bad	2019-01-24 20:36:18.989746185 +0000
      @@ -206,5 +206,6 @@
       Verifying file digests after cloning
       14968c092c68e32fa35e776392d14523  SCRATCH_MNT/foo
       14968c092c68e32fa35e776392d14523  SCRATCH_MNT/bar
      +cat: /mnt/scratch/bar: No such file or directory
       Verifying target file digest after umount + mount
       14968c092c68e32fa35e776392d14523  SCRATCH_MNT/bar
      ...
      (Run 'diff -u /home/fdmanana/git/hub/xfstests/tests/btrfs/081.out /home/fdmanana/git/hub/xfstests/results//btrfs/081.out.bad'  to see the entire diff)
  Ran: btrfs/081
  Failures: btrfs/081
  Failed 1 of 1 tests

Fix that by adding a proper trap to the reader loop function so that the
subshell waits for executed 'cat' commands when it receives SIGTERM.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/081 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tests/btrfs/081 b/tests/btrfs/081
index 7e83525f..726a370f 100755
--- a/tests/btrfs/081
+++ b/tests/btrfs/081
@@ -69,6 +69,12 @@ create_target_file()
 
 reader_loop()
 {
+	# Wait for any running 'cat' subcommand before exitting so that after
+	# the test kills the reader loop subshell it does not fail with an
+	# error message from a 'cat' subcommand due to the test file being
+	# temporarily unavailable due to the scratch fs unmount operation.
+	trap "wait; exit" SIGTERM
+
 	local name=$1
 
 	while true; do
-- 
2.11.0

