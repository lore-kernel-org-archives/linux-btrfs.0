Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:39472 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778Ab3BHAlA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Feb 2013 19:41:00 -0500
Received: from twilight.demius.net (c-297271d5.013-195-6c756e10.cust.bredbandsbolaget.se [213.113.114.41])
	by nitrogen.vapor.com (Postfix) with ESMTPSA id C696B40C715
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Feb 2013 01:40:52 +0100 (CET)
From: Ian Kumlien <pomac@demius.net>
To: linux-btrfs@vger.kernel.org
Cc: Ian Kumlien <pomac@demius.net>
Subject: [PATCH 5/6] Btrfs-progs: restore.c -> cmds-restore.c
Date: Fri,  8 Feb 2013 01:37:01 +0100
Message-Id: <1360283822-23452-6-git-send-email-pomac@demius.net>
In-Reply-To: <1360283822-23452-1-git-send-email-pomac@demius.net>
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs-restore functionality will be integrated in
btrs as "btrfs restore"

Signed-off-by: Ian Kumlien <pomac@demius.net>
---
 restore.c => cmds-restore.c | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename restore.c => cmds-restore.c (100%)

diff --git a/restore.c b/cmds-restore.c
similarity index 100%
rename from restore.c
rename to cmds-restore.c
-- 
1.8.1.2

