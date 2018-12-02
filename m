Return-Path: <SRS0=5FUL=OL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DATE_IN_FUTURE_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A1CC04EB8
	for <linux-btrfs@archiver.kernel.org>; Sun,  2 Dec 2018 06:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 810EF2080A
	for <linux-btrfs@archiver.kernel.org>; Sun,  2 Dec 2018 06:39:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FqZt5kQ4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 810EF2080A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbeLBGjO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 2 Dec 2018 01:39:14 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44061 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbeLBGjO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Dec 2018 01:39:14 -0500
Received: by mail-pf1-f196.google.com with SMTP id u6so4784380pfh.11
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Dec 2018 22:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Ob9CUzmD8sAzSSAwjo4IWvZOovBlakf1kDH8eNSei8=;
        b=FqZt5kQ4IVN0+yROM5STYs0GDZ6rK4xr5ktSk7JnJGDLuVU6xnA9b2srmdW6F16sJx
         Q9kTWwYowVSE4PbFxNCIHXzJlQaHA6U/6DY+Od7y+Cde2kLIz16SErvIhg8pBGencaMV
         WynofQbHlp0tbPT05vInvw7kb+dS035KhfWzrTu5c+ibkdE2x0aQlI5lGT6tEBDJWIkD
         HAqfdYzfclivIZw/8lXSJ/aBmOBkQvi3zahNbURc+yNg4hk7iTYbO6EO3I1b1O8Vq9Y2
         rLDEglPbWkq4lH6kTnV5EBNk59/S4ekByxhfQmKrKLT09c2D3g7zgSPN2kXyIAFNntrj
         fu/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Ob9CUzmD8sAzSSAwjo4IWvZOovBlakf1kDH8eNSei8=;
        b=jSd4a26aw4VK/cKE51JWg37xGwOmDjBv8VEejkFB0ij18pvvftPoVogtNJOdyiB/pR
         TfXP4TjY2reQABYKi+9GtRxIrLSQOaUS9/DzsbEiE7tRat5c/MJ6BtIXJsjIsE7M8Reg
         dF4thN2WofScefv19pltKIaZ6bIevMxrdg9RJ5owxGmwljKgQp/nm0AEUDuvzV0vVGgR
         46EBCF76UwRcrh+OMKBDPf6Lkc7dl1xHZ8FUHa1O5BVFGjDmRcY+Ypd8kr7NTqx91wcY
         wR2r4b8WPvJrZzCsCxiIk5wWjSnpYo1WEirjDNC5W3c1duEcc+YN/IcvIvc6Yzs8c98g
         E5yg==
X-Gm-Message-State: AA+aEWYAzQmU6+MuOYbdalLrADoSVJ+fezE0de4mCuyzJ8BQ3cGNP4jL
        7ubz+CHlFDr3SWsq3DzV/49njWRs
X-Google-Smtp-Source: AFSGD/XcGgS5bkQwDGFCVgCmmgz+hWRBhVOpaGhgRfnSn3pqJrBzPjEZV+2/oSNv4y2L3Vb2ea6ilw==
X-Received: by 2002:a63:d846:: with SMTP id k6mr8634464pgj.251.1543732752336;
        Sat, 01 Dec 2018 22:39:12 -0800 (PST)
Received: from cat-arch.lan ([173.82.208.113])
        by smtp.gmail.com with ESMTPSA id v191sm11584264pgb.77.2018.12.01.22.39.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Dec 2018 22:39:11 -0800 (PST)
From:   damenly.su@gmail.com
X-Google-Original-From: suy.fnst@cn.fujitsu.com
To:     linux-btrfs@vger.kernel.org
Cc:     suy.fnst@cn.fujitsu.com
Subject: [PATCH v2 02/13] btrfs-progs: lowmem: move nbytes check before isize check
Date:   Sun,  2 Dec 2018 14:38:55 +0000
Message-Id: <20181202143855.15533-1-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181023094147.7906-3-suy.fnst@cn.fujitsu.com>
References: <20181023094147.7906-3-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Su Yue <suy.fnst@cn.fujitsu.com>

For files, lowmem repair will try to check nbytes and isize,
but isize check depends nbytes.

Once bytes has been repaired, then isize should be checked and
repaired.
So move nbytes check before isize check. Also set nbytes to
extent_size once repaired successfully.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
Changelog:
v2
  Remove one unrelated change.
  
---
 check/mode-lowmem.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 3dce4d3b5fc1..58f8f6fabed7 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2541,28 +2541,31 @@ out:
 			}
 		}
 
-		if (!nbytes && !no_holes && extent_end < isize) {
-			if (repair)
-				ret = punch_extent_hole(root, path, inode_id,
-						extent_end, isize - extent_end);
+		if (nbytes != extent_size) {
+			if (repair) {
+				ret = repair_inode_nbytes_lowmem(root, path,
+							 inode_id, extent_size);
+				if (!ret)
+					nbytes = extent_size;
+			}
 			if (!repair || ret) {
 				err |= NBYTES_ERROR;
 				error(
-	"root %llu INODE[%llu] size %llu should have a file extent hole",
-				      root->objectid, inode_id, isize);
+	"root %llu INODE[%llu] nbytes %llu not equal to extent_size %llu",
+				      root->objectid, inode_id, nbytes,
+				      extent_size);
 			}
 		}
 
-		if (nbytes != extent_size) {
+		if (!nbytes && !no_holes && extent_end < isize) {
 			if (repair)
-				ret = repair_inode_nbytes_lowmem(root, path,
-							 inode_id, extent_size);
+				ret = punch_extent_hole(root, path, inode_id,
+						extent_end, isize - extent_end);
 			if (!repair || ret) {
 				err |= NBYTES_ERROR;
 				error(
-	"root %llu INODE[%llu] nbytes %llu not equal to extent_size %llu",
-				      root->objectid, inode_id, nbytes,
-				      extent_size);
+	"root %llu INODE[%llu] size %llu should have a file extent hole",
+				      root->objectid, inode_id, isize);
 			}
 		}
 	}
-- 
2.19.1

