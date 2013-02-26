Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab3BZVu0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 16:50:26 -0500
Message-ID: <512D2E1E.40102@redhat.com>
Date: Tue, 26 Feb 2013 15:50:22 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: kreijack@inwind.it, Goffredo Baroncelli <kreijack@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 17/17 V3] btrfs-progs: initialize save_ptr prior to strtok_r
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com> <1361832890-40921-18-git-send-email-sandeen@redhat.com> <512D0325.5050308@gmail.com> <512D190E.2050002@redhat.com> <20130226204040.GA1993@zambezi.lan> <512D1F26.7020804@redhat.com> <20130226210742.GB1993@zambezi.lan>
In-Reply-To: <20130226210742.GB1993@zambezi.lan>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The coverity runs had a false positive complaining that
save_ptr is uninitialized in the call to strtok_r.

Turns out that under the covers glibc was doing enough
to confuse the checker about what was being called.

Just to keep the noise down, do a harmless initialization,
with a comment as to why.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V3: Keep strtok_r for old compat, and just init the var.

diff --git a/cmds-balance.c b/cmds-balance.c
index b671e1d..f5dc317 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -67,7 +67,7 @@ static int parse_one_profile(const char *profile, u64 *flags)
 static int parse_profiles(char *profiles, u64 *flags)
 {
 	char *this_char;
-	char *save_ptr;
+	char *save_ptr = NULL; /* Satisfy static checkers */
 
 	for (this_char = strtok_r(profiles, "|", &save_ptr);
 	     this_char != NULL;
@@ -136,7 +136,7 @@ static int parse_filters(char *filters, struct btrfs_balance_args *args)
 {
 	char *this_char;
 	char *value;
-	char *save_ptr;
+	char *save_ptr = NULL; /* Satisfy static checkers */
 
 	if (!filters)
 		return 0;


