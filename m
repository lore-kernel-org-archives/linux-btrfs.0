Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33313 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751570AbdLEIjy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 03:39:54 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3D52DABFA
        for <linux-btrfs@vger.kernel.org>; Tue,  5 Dec 2017 08:39:53 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/7] btrfs-progs: Explictly state test.sh must be executable
Date: Tue,  5 Dec 2017 10:39:43 +0200
Message-Id: <1512463189-24724-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1512463189-24724-1-git-send-email-nborisov@suse.com>
References: <1512463189-24724-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 tests/README.md | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/README.md b/tests/README.md
index 04d2ce2ab40d..c456018554cc 100644
--- a/tests/README.md
+++ b/tests/README.md
@@ -164,7 +164,9 @@ how to do mkfs, mount, unmount, check, etc.
 and join by dashes `-`. This will become the directory name, eg. `012-subvolume-sync-must-wait`.
 
 3. Write a short description of the bug and how it's tested to the comment at the
-begining of `test.sh`. You don't need to add the file to git yet.
+begining of `test.sh`. You don't need to add the file to git yet. Don't forget
+to make the file executable, otherwise it's not going to be executed by the
+infrastructure.
 
 4. Write the test commands, comment anything that's not obvious.
 
-- 
2.7.4

