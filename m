Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:39467 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab3BHAk7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Feb 2013 19:40:59 -0500
Received: from twilight.demius.net (c-297271d5.013-195-6c756e10.cust.bredbandsbolaget.se [213.113.114.41])
	by nitrogen.vapor.com (Postfix) with ESMTPSA id 466D040C593
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Feb 2013 01:40:50 +0100 (CET)
From: Ian Kumlien <pomac@demius.net>
To: linux-btrfs@vger.kernel.org
Cc: Ian Kumlien <pomac@demius.net>
Subject: [PATCH 1/6] Btrfs-progs: Rename btrfsck.c -> cmds-check.c
Date: Fri,  8 Feb 2013 01:36:57 +0100
Message-Id: <1360283822-23452-2-git-send-email-pomac@demius.net>
In-Reply-To: <1360283822-23452-1-git-send-email-pomac@demius.net>
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In preparation for merging btrfsck functionality in to btrfs.

Signed-off-by: Ian Kumlien <pomac@demius.net>
---
 btrfsck.c => cmds-check.c | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename btrfsck.c => cmds-check.c (100%)

diff --git a/btrfsck.c b/cmds-check.c
similarity index 100%
rename from btrfsck.c
rename to cmds-check.c
-- 
1.8.1.2

