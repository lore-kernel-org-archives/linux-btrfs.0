Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:43994 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759592Ab3BYVzS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 16:55:18 -0500
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 17/17] btrfs-progs: replace strtok_r with strsep
Date: Mon, 25 Feb 2013 16:54:50 -0600
Message-Id: <1361832890-40921-18-git-send-email-sandeen@redhat.com>
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The coverity had a false positive complaining that save_ptr
is uninitialized in the call to strtok_r.

We could initialize it, but Zach points out that just using
strsep is a lot simpler if there's only one delimiter,
so just switch to that.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 cmds-balance.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index b671e1d..e8b9d90 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -67,11 +67,9 @@ static int parse_one_profile(const char *profile, u64 *flags)
 static int parse_profiles(char *profiles, u64 *flags)
 {
 	char *this_char;
-	char *save_ptr;
 
-	for (this_char = strtok_r(profiles, "|", &save_ptr);
-	     this_char != NULL;
-	     this_char = strtok_r(NULL, "|", &save_ptr)) {
+	while ((this_char = strsep(&profiles, "|"))) {
+		printf("got profile %s\n", this_char);
 		if (parse_one_profile(this_char, flags))
 			return 1;
 	}
@@ -136,14 +134,12 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
 {
 	char *this_char;
 	char *value;
-	char *save_ptr;
 
 	if (!filters)
 		return 0;
 
-	for (this_char = strtok_r(filters, ",", &save_ptr);
-	     this_char != NULL;
-	     this_char = strtok_r(NULL, ",", &save_ptr)) {
+	while ((this_char = strsep(&filters , ","))) {
+		printf("got %s\n", this_char);
 		if ((value = strchr(this_char, '=')) != NULL)
 			*value++ = 0;
 		if (!strcmp(this_char, "profiles")) {
-- 
1.7.1

