Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34787 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751473AbdIQXwi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 17 Sep 2017 19:52:38 -0400
Received: by mail-qk0-f196.google.com with SMTP id d70so4578189qkc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Sep 2017 16:52:38 -0700 (PDT)
From: Nicholas D Steeves <nsteeves@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nicholas D Steeves <nsteeves@gmail.com>
Subject: [PATCH 1/2] Add required IETF Trust copyright
Date: Sun, 17 Sep 2017 19:52:26 -0400
Message-Id: <20170917235227.6452-2-nsteeves@gmail.com>
In-Reply-To: <20170917235227.6452-1-nsteeves@gmail.com>
References: <20170917235227.6452-1-nsteeves@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nicholas D Steeves <nsteeves@gmail.com>
---
 tests/sha-private.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/sha-private.h b/tests/sha-private.h
index 6e9c4520..d94d4374 100644
--- a/tests/sha-private.h
+++ b/tests/sha-private.h
@@ -1,5 +1,9 @@
 /************************ sha-private.h ************************/
 /***************** See RFC 6234 for details. *******************/
+/* Copyright (c) 2011 IETF Trust and the persons identified as */
+/* authors of the code.  All rights reserved.                  */
+/* See sha.h for terms of use and redistribution.              */
+
 #ifndef _SHA_PRIVATE__H
 #define _SHA_PRIVATE__H
 /*
-- 
2.11.0

