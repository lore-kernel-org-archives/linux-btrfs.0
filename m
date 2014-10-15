Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42455 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaJOXOv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 19:14:51 -0400
Received: by mail-wg0-f45.google.com with SMTP id m15so2429363wgh.28
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 16:14:50 -0700 (PDT)
From: Zach Brown <zab@zabbo.net>
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH 3/4] btrfs-progs: fix show super unknown flag output
Date: Wed, 15 Oct 2014 16:14:20 -0700
Message-Id: <1413414861-28097-4-git-send-email-zab@zabbo.net>
In-Reply-To: <1413414861-28097-1-git-send-email-zab@zabbo.net>
References: <1413414861-28097-1-git-send-email-zab@zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

coverity pointed out that unknown flag printing in show super had some
dead code.  It turns out that first was reset when the first flag was
tested, not when it was output.  We only want to clear it if the first
matching bit is output.  If there are no matching bits then we'll want
to output the unknown flag first.

Signed-off-by: Zach Brown <zab@zabbo.net>
---
 btrfs-show-super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/btrfs-show-super.c b/btrfs-show-super.c
index 456dbd8..2b48f44 100644
--- a/btrfs-show-super.c
+++ b/btrfs-show-super.c
@@ -324,8 +324,8 @@ static void print_readable_incompat_flag(u64 flag)
 				printf("%s ", entry->output);
 			else
 				printf("|\n\t\t\t  %s ", entry->output);
+			first = 0;
 		}
-		first = 0;
 	}
 	flag &= ~BTRFS_FEATURE_INCOMPAT_SUPP;
 	if (flag) {
-- 
1.9.3

