Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933385Ab3HNXRW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 19:17:22 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7ENHMZv014645
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:22 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r7ENHKSp017824
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 19:17:21 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/15] btrfs-print: define void function args
Date: Wed, 14 Aug 2013 16:16:36 -0700
Message-Id: <1376522205-16992-7-git-send-email-zab@redhat.com>
In-Reply-To: <1376522205-16992-1-git-send-email-zab@redhat.com>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This silences (reasonable) sparse warnings of the form:

	warning: non-ANSI function declaration of ..

Signed-off-by: Zach Brown <zab@redhat.com>
---
 btrfs-find-root.c | 2 +-
 btrfs-list.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/btrfs-find-root.c b/btrfs-find-root.c
index 1a7a80c..b48c800 100644
--- a/btrfs-find-root.c
+++ b/btrfs-find-root.c
@@ -40,7 +40,7 @@ static u64 search_objectid = BTRFS_ROOT_TREE_OBJECTID;
 static u64 search_generation = 0;
 static unsigned long search_level = 0;
 
-static void usage()
+static void usage(void)
 {
 	fprintf(stderr, "Usage: find-roots [-o search_objectid] "
 		"[ -g search_generation ] [ -l search_level ] <device>\n");
diff --git a/btrfs-list.c b/btrfs-list.c
index 214cb45..55508d2 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1418,7 +1418,7 @@ static void print_single_volume_info_default(struct root_info *subv)
 	printf("\n");
 }
 
-static void print_all_volume_info_tab_head()
+static void print_all_volume_info_tab_head(void)
 {
 	int i;
 	int len;
-- 
1.7.11.7

