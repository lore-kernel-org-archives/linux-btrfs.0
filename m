Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:38242 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbdIQXwj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 19:52:39 -0400
Received: by mail-qt0-f195.google.com with SMTP id f24so4720057qte.5
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 16:52:39 -0700 (PDT)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nicholas D Steeves <nsteeves@gmail.com>
Subject: [PATCH 2/2] Remove misleading BCP 78 boilerplate
Date: Sun, 17 Sep 2017 19:52:27 -0400
Message-Id: <20170917235227.6452-3-nsteeves@gmail.com>
In-Reply-To: <20170917235227.6452-1-nsteeves@gmail.com>
References: <20170917235227.6452-1-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BCP 78 applies to RFC 6234, but sha224-256.c is Simplified BSD.

This causes the following lintian error when building on Debian and
Debian derivatives:

    E: btrfs-progs source: license-problem-non-free-RFC-BCP78
       tests/sha224-256.c

Please consult the following email from debian-legal@lists.debian.org
for more information:

https://lists.debian.org/debian-legal/2017/08/msg00004.html
Signed-off-by: Nicholas D Steeves <nsteeves@gmail.com>
---
 tests/sha224-256.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/tests/sha224-256.c b/tests/sha224-256.c
index 2d963e65..82124a03 100644
--- a/tests/sha224-256.c
+++ b/tests/sha224-256.c
@@ -1,23 +1,3 @@
-/*
-RFC 6234                SHAs, HMAC-SHAs, and HKDF               May 2011
-
-
-Copyright Notice
-
-   Copyright (c) 2011 IETF Trust and the persons identified as the
-   document authors.  All rights reserved.
-
-   This document is subject to BCP 78 and the IETF Trust's Legal
-   Provisions Relating to IETF Documents
-   (http://trustee.ietf.org/license-info) in effect on the date of
-   publication of this document.  Please review these documents
-   carefully, as they describe your rights and restrictions with respect
-   to this document.  Code Components extracted from this document must
-   include Simplified BSD License text as described in Section 4.e of
-   the Trust Legal Provisions and are provided without warranty as
-   described in the Simplified BSD License.
-*/
-
 /************************* sha224-256.c ************************/
 /***************** See RFC 6234 for details. *******************/
 /* Copyright (c) 2011 IETF Trust and the persons identified as */
-- 
2.11.0

