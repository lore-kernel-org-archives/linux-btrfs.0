Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41378 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726412AbeHFIHo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Aug 2018 04:07:44 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4E320AE1A
        for <linux-btrfs@vger.kernel.org>; Mon,  6 Aug 2018 06:00:15 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: qgroup: make --rescan as the default behavior for assign
Date: Mon,  6 Aug 2018 14:00:07 +0800
Message-Id: <20180806060008.9556-3-wqu@suse.com>
In-Reply-To: <20180806060008.9556-1-wqu@suse.com>
References: <20180806060008.9556-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Even though we have --rescan option, it still needs user to manually
specify it.

However even some developer is not aware of the option, it makes even
less sense for end-user.

So make it the default behavior.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 Documentation/btrfs-qgroup.asciidoc | 4 ++--
 cmds-qgroup.c                       | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/btrfs-qgroup.asciidoc b/Documentation/btrfs-qgroup.asciidoc
index 3108457cc8e1..fee173860000 100644
--- a/Documentation/btrfs-qgroup.asciidoc
+++ b/Documentation/btrfs-qgroup.asciidoc
@@ -47,8 +47,8 @@ identified by <path>.
 `Options`
 +
 --rescan::::
-Automatically schedule quota rescan if the new qgroup assignment leads to
-quota inconsistency.
+(Default) Automatically schedule quota rescan if the new qgroup assignment
+leads to quota inconsistency.
 --no-rescan::::
 Explicitly ask not to do a rescan.
 
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 7a505443d271..094e5174fd7f 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -40,7 +40,7 @@ static int _cmd_qgroup_assign(int assign, int argc, char **argv,
 {
 	int ret = 0;
 	int fd;
-	bool rescan = false;
+	bool rescan = true;
 	char *path;
 	struct btrfs_ioctl_qgroup_assign_args args;
 	DIR *dirstream = NULL;
-- 
2.18.0

