Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.138]:26411 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab3DKQWK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 12:22:10 -0400
Received: from pizpot.store ([192.168.43.236])
	by josoe.store (josoe xp3) (RZmta 31.26 OK)
	with ESMTP id p028b3p3BDBwyR for <linux-btrfs@vger.kernel.org>;
	Thu, 11 Apr 2013 18:22:08 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/4] Btrfs-progs: cleanup in btrfs-list.c
Date: Thu, 11 Apr 2013 18:22:05 +0200
Message-Id: <4e2f2a9be577bf8d141a3111c113f28a86fce29b.1365696891.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365696891.git.sbehrens@giantdisaster.de>
References: <cover.1365696891.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1365696891.git.sbehrens@giantdisaster.de>
References: <cover.1365696891.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since someone modified the code to initialize all need_print with zero,
these lines can be removed entirely.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 btrfs-list.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index 1246a25..a5d6e9b 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -46,7 +46,7 @@ struct root_lookup {
 	struct rb_root root;
 };
 
-struct {
+static struct {
 	char	*name;
 	char	*column_name;
 	int	need_print;
@@ -54,52 +54,42 @@ struct {
 	{
 		.name		= "ID",
 		.column_name	= "ID",
-		.need_print	= 0,
 	},
 	{
 		.name		= "gen",
 		.column_name	= "Gen",
-		.need_print	= 0,
 	},
 	{
 		.name		= "cgen",
 		.column_name	= "CGen",
-		.need_print	= 0,
 	},
 	{
 		.name		= "parent",
 		.column_name	= "Parent",
-		.need_print	= 0,
 	},
 	{
 		.name		= "top level",
 		.column_name	= "Top Level",
-		.need_print	= 0,
 	},
 	{
 		.name		= "otime",
 		.column_name	= "OTime",
-		.need_print	= 0,
 	},
 	{
 		.name		= "parent_uuid",
 		.column_name	= "Parent UUID",
-		.need_print	= 0,
 	},
 	{
 		.name		= "uuid",
 		.column_name	= "UUID",
-		.need_print	= 0,
 	},
 	{
 		.name		= "path",
 		.column_name	= "Path",
-		.need_print	= 0,
 	},
 	{
 		.name		= NULL,
 		.column_name	= NULL,
-		.need_print	= 0,
 	},
 };
 
-- 
1.8.2.1

