Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab3BZUUe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 15:20:34 -0500
Message-ID: <512D190E.2050002@redhat.com>
Date: Tue, 26 Feb 2013 14:20:30 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: Goffredo Baroncelli <kreijack@gmail.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH 17/17 V2] btrfs-progs: replace strtok_r with strsep
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com> <1361832890-40921-18-git-send-email-sandeen@redhat.com> <512D0325.5050308@gmail.com>
In-Reply-To: <512D0325.5050308@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The coverity runs had a false positive complaining that save_ptr
is uninitialized in the call to strtok_r.

We could initialize it, but Zach points out that just using
strsep is a lot simpler if there's only one delimiter,
so just switch to that.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Remove accidentally-added debug printfs, thanks Geoffredo!

diff --git a/cmds-balance.c b/cmds-balance.c
index b671e1d..cfbb8eb 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -67,11 +67,8 @@ static int parse_one_profile(const char *profile, u64 *flags)
 static int parse_profiles(char *profiles, u64 *flags)
 {
 	char *this_char;
-	char *save_ptr;
 
-	for (this_char = strtok_r(profiles, "|", &save_ptr);
-	     this_char != NULL;
-	     this_char = strtok_r(NULL, "|", &save_ptr)) {
+	while ((this_char = strsep(&profiles, "|"))) {
 		if (parse_one_profile(this_char, flags))
 			return 1;
 	}
@@ -136,14 +133,11 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
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
 		if ((value = strchr(this_char, '=')) != NULL)
 			*value++ = 0;
 		if (!strcmp(this_char, "profiles")) {

