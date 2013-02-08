Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:39470 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab3BHAk7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Feb 2013 19:40:59 -0500
Received: from twilight.demius.net (c-297271d5.013-195-6c756e10.cust.bredbandsbolaget.se [213.113.114.41])
	by nitrogen.vapor.com (Postfix) with ESMTPSA id D448040C6A8
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Feb 2013 01:40:51 +0100 (CET)
From: Ian Kumlien <pomac@demius.net>
To: linux-btrfs@vger.kernel.org
Cc: Ian Kumlien <pomac@demius.net>
Subject: [PATCH 3/6] Btrfs-progs: move btrfs-select-super.c
Date: Fri,  8 Feb 2013 01:36:59 +0100
Message-Id: <1360283822-23452-4-git-send-email-pomac@demius.net>
In-Reply-To: <1360283822-23452-1-git-send-email-pomac@demius.net>
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch moves
	btrfs-select-super.c -> cmds-rescue-super-ops.c

This is done in preparation to merge the select-super
functionality to btrfs.

The naming is because we will also merge
btrfs-dump-super.c from Josef Bacik

Signed-off-by: Ian Kumlien <pomac@demius.net>
---
 btrfs-select-super.c => cmds-rescue-super-ops.c | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename btrfs-select-super.c => cmds-rescue-super-ops.c (100%)

diff --git a/btrfs-select-super.c b/cmds-rescue-super-ops.c
similarity index 100%
rename from btrfs-select-super.c
rename to cmds-rescue-super-ops.c
-- 
1.8.1.2

