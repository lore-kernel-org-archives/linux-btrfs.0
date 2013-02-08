Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:39471 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908Ab3BHAk7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Feb 2013 19:40:59 -0500
Received: from twilight.demius.net (c-297271d5.013-195-6c756e10.cust.bredbandsbolaget.se [213.113.114.41])
	by nitrogen.vapor.com (Postfix) with ESMTPSA id 5683140C6C8
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Feb 2013 01:40:52 +0100 (CET)
From: Ian Kumlien <pomac@demius.net>
To: linux-btrfs@vger.kernel.org
Cc: Ian Kumlien <pomac@demius.net>
Subject: [PATCH 4/6] Btrfs-progs: move debug-tree.c -> cmds-rescue-debug-tree.c
Date: Fri,  8 Feb 2013 01:37:00 +0100
Message-Id: <1360283822-23452-5-git-send-email-pomac@demius.net>
In-Reply-To: <1360283822-23452-1-git-send-email-pomac@demius.net>
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs-debug-tree functionality will be integrated
in to btrfs as "btrfs rescue debug-tree"

Signed-off-by: Ian Kumlien <pomac@demius.net>
---
 debug-tree.c => cmds-rescue-debug-tree.c | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename debug-tree.c => cmds-rescue-debug-tree.c (100%)

diff --git a/debug-tree.c b/cmds-rescue-debug-tree.c
similarity index 100%
rename from debug-tree.c
rename to cmds-rescue-debug-tree.c
-- 
1.8.1.2

