Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36699 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaFMVen (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Jun 2014 17:34:43 -0400
Received: by mail-pd0-f177.google.com with SMTP id y10so1023724pdj.8
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jun 2014 14:34:43 -0700 (PDT)
From: Adam Buchbinder <abuchbinder@google.com>
To: linux-btrfs@vger.kernel.org
Cc: dave@jikos.cz, Adam Buchbinder <abuchbinder@google.com>
Subject: [PATCH 1/2] Remove extra 'const' modifiers; they don't do anything.
Date: Fri, 13 Jun 2014 14:34:35 -0700
Message-Id: <1402695276-28104-1-git-send-email-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'const int const *x' means the same thing as 'const int *x' or
'int const *x'; the intent was probably 'const int * const x'.
However, this won't work for the 'suffix' variable, as it has
to be assigned, and making the static tables into const pointers
to const chars leads to a mismatch there.

This was found with clang's duplicate-decl-specifier warning.

Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
---
 utils.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/utils.c b/utils.c
index d29de94..91a7111 100644
--- a/utils.c
+++ b/utils.c
@@ -1295,9 +1295,9 @@ out:
 	return ret;
 }
 
-static const char const *unit_suffix_binary[] =
+static const char* unit_suffix_binary[] =
 	{ "B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"};
-static const char const *unit_suffix_decimal[] =
+static const char* unit_suffix_decimal[] =
 	{ "B", "KB", "MB", "GB", "TB", "PB", "EB"};
 
 int pretty_size_snprintf(u64 size, char *str, size_t str_size, int unit_mode)
@@ -1305,7 +1305,7 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_size, int unit_mode)
 	int num_divs;
 	float fraction;
 	int base = 0;
-	const char const **suffix = NULL;
+	const char** suffix = NULL;
 	u64 last_size;
 
 	if (str_size == 0)
-- 
2.0.0.526.g5318336

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
