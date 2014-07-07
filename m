Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39592 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752757AbaGGCAe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jul 2014 22:00:34 -0400
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs-progs: update manpage with new option -f for btrfstune
Date: Mon, 7 Jul 2014 09:54:53 +0800
Message-ID: <1404698093-4149-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1404698093-4149-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <20140703165145.GG1553@twin.jikos.cz>
 <1404698093-4149-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The new option -f will force to do dangerous changes.
e.g. clear the seeding flag.
---
changelog
	v1->v2: use -f instead of -y
---
 Documentation/btrfstune.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/btrfstune.txt b/Documentation/btrfstune.txt
index bf44bdf..85a7165 100644
--- a/Documentation/btrfstune.txt
+++ b/Documentation/btrfstune.txt
@@ -24,7 +24,8 @@ Enable seeding forces a fs readonly so that you can use it to build other filesy
 Enable extended inode refs.
 -x::
 Enable skinny metadata extent refs.
-
+-f::
+Allow dangerous changes, e.g. clear the seeding flag
 
 EXIT STATUS
 -----------
-- 
1.8.1.4

