Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:35589 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752828AbdLWU7B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Dec 2017 15:59:01 -0500
Received: from mekker.bofh.hq.mendix.net (mekker.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::21])
        by smtp.dpl.mendix.net (Postfix) with ESMTP id 6BF7B2036E
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Dec 2017 21:52:38 +0100 (CET)
From: Hans van Kranenburg <hans@knorrie.org>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs-progs: Fix build of btrfs-calc-size
Date: Sat, 23 Dec 2017 21:52:38 +0100
Message-Id: <20171223205238.19678-3-hans@knorrie.org>
In-Reply-To: <20171223205238.19678-1-hans@knorrie.org>
References: <20171223205238.19678-1-hans@knorrie.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Build would fail because it couldn't find the usage function.

Signed-off-by: Hans van Kranenburg <hans@knorrie.org>
---
 btrfs-calc-size.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/btrfs-calc-size.c b/btrfs-calc-size.c
index 1ac7c785..d2d68ab2 100644
--- a/btrfs-calc-size.c
+++ b/btrfs-calc-size.c
@@ -19,6 +19,7 @@
 #include "volumes.h"
 #include "utils.h"
 #include "commands.h"
+#include "help.h"
 
 int main(int argc, char **argv)
 {
-- 
2.11.0

