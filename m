Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from edanaher.xen.prgmr.com ([71.19.155.118]:49315 "EHLO
        gahlpo.edanaher.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751648AbdDKASl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 20:18:41 -0400
Received: from chileh.lan (c-50-176-252-71.hsd1.ma.comcast.net [50.176.252.71])
        by gahlpo.edanaher.net (Postfix) with ESMTPSA id 81B645C791
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Apr 2017 17:09:06 -0700 (PDT)
Received: from edanaher by chileh.lan with local (Exim 4.89)
        (envelope-from <github@edanaher.net>)
        id 1cxjMm-0008On-VO
        for linux-btrfs@vger.kernel.org; Tue, 11 Apr 2017 00:09:04 +0000
Date: Mon, 10 Apr 2017 20:09:04 -0400
From: Evan Danaher <github@edanaher.net>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: send-dump: always print a space after path
Message-ID: <20170411000904.GF2455@edanaher.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was shocked to discover that 'btrfs receive --dump' doesn't print a
space after long filenames, so it runs together into the metadata; for
example:

truncate        ./20-00-03/this-name-is-32-characters-longsize=0

This is a trivial patch to add a single space unconditionally, so the
result is the following:

truncate        ./20-00-03/this-name-is-32-characters-long size=0

I suppose this is technically a breaking change, but it seems unlikely
to me that anyone would depend on the existing behavior given how
unfriendly it is.


Signed-off-by: Evan Danaher <github@edanaher.net>
---
diff --git a/send-dump.c b/send-dump.c
index 67f7977..493389f 100644
--- a/send-dump.c
+++ b/send-dump.c
@@ -116,9 +116,10 @@ static int __print_dump(int subvol, void *user, const char *path,
                putchar('\n');
                return 0;
        }
-       /* Short paths ale aligned to 32 chars */
-       while (ret++ < 32)
+       /* Short paths are aligned to 32 chars; longer paths get a single space */
+       do {
                putchar(' ');
+       } while (ret++ < 32);
        va_start(args, fmt);
        /* Operation specified ones */
        vprintf(fmt, args);
---
