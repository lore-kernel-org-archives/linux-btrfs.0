Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34171 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933999AbbI2RLO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 13:11:14 -0400
Received: by wicfx3 with SMTP id fx3so160631239wic.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2015 10:11:13 -0700 (PDT)
From: Silvio Fricke <silvio.fricke@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Silvio Fricke <silvio.fricke@gmail.com>
Subject: [PATCH 11/11] btrfs-progs: check: fix memset range
Date: Tue, 29 Sep 2015 19:10:46 +0200
Message-Id: <59828e2191068753dd166a5341ccf4d43a8a0370.1443546001.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1443546000.git.silvio.fricke@gmail.com>
References: <cover.1443546000.git.silvio.fricke@gmail.com>
In-Reply-To: <cover.1443546000.git.silvio.fricke@gmail.com>
References: <cover.1443459879.git.silvio.fricke@gmail.com> <cover.1443546000.git.silvio.fricke@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Silvio Fricke <silvio.fricke@gmail.com>
---
 cmds-check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 2923d05..2c32ff3 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3021,7 +3021,7 @@ static struct root_backref *get_root_backref(struct root_record *rec,
 	}
 
 	backref = malloc(sizeof(*backref) + namelen + 1);
-	memset(backref, 0, sizeof(*backref));
+	memset(backref, 0, sizeof(*backref) + namelen + 1);
 	backref->ref_root = ref_root;
 	backref->dir = dir;
 	backref->index = index;
-- 
2.5.3

