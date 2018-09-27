Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE1AC43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:18:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19D54215F0
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 18:18:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="iRcBmGe2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19D54215F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbeI1Aho (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 20:37:44 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45001 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728401AbeI1Ahn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 20:37:43 -0400
Received: by mail-pg1-f196.google.com with SMTP id g2-v6so2527204pgu.11
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 11:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pB4cjWu7kIoSAPGh3rcF+ODQvk/IUq3VExz60hmyk9c=;
        b=iRcBmGe2iOyXaPiMWvLgRrEGh+QqWaFC0SXLrEChkiiVJ2SYONu+OGRC9CE2krWwm3
         SFI+iDm5JXO7ytk0cdjfABEIMDy4mI4MTxaA69jfNYSsB83ZyQ1jIvXND3F7q7RG+lrF
         FT/c+TBQ0UBukd+v6rq+Cpz0Ctk0PaGJEOmeI6AtgqIrWwxkGwz0dgsPZV22iOjlul1z
         Zb8c29ozRtkdq5QqVDEqqNkX4XIAH+C1W1ixwQLbtQoNyH66nGEv5361zSw0K+P6bllZ
         aJ3M7TvnyIikAt9c8IJFgc6zPwFIC1Lmv/8GmxjzaFEhb5lbBG/qD+LpKztjcj1rwqd0
         RnYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pB4cjWu7kIoSAPGh3rcF+ODQvk/IUq3VExz60hmyk9c=;
        b=AlSNkSBv5lcNVJlRpVwss8fD+EXC1QrxUTV1D23vz6b4L6W85Lc0lxDVIkom6FDFiQ
         787BpM8u46cHnPtwFeFMO8tS8SpPlfIwEgFhPdR76RqWlz4ziTceyAkzzPPBVfAd+z0I
         GJ3ZLRf0mk2JAD2oFob4ZdGYQRgHV8LJuaNoFd0ctg507JTTrRGcayX8D6nVXXcnkYM4
         9JZ6HsPfj2Wn+OZXX8GSOrL3ajXSQeyd+JGAVrBWSWin7HAu4DL5cHVFJUmdNmt+JpG0
         AIUIS6BZ4riiLOndLUag54jMFzckPfH7eFPt3Vb84Fl14qKRnu/dSjgonmRfb4nkB0Z2
         cQhQ==
X-Gm-Message-State: ABuFfohp8lFyhIqpBEFZsI59iXOoTjOn5npRdmUwwIt+l9tXovdxVO4m
        nX9ZpB1XXTL4LoL7WEnmjMrJw/2CJVw=
X-Google-Smtp-Source: ACcGV612aO4ToB/YjCcbARk3DH6sdoMScF3+ZHfByjDMyiZZ7dFcziLBbwS1aG3/zLbIXllhaGMD1Q==
X-Received: by 2002:a17:902:1681:: with SMTP id h1-v6mr12185624plh.262.1538072291599;
        Thu, 27 Sep 2018 11:18:11 -0700 (PDT)
Received: from vader.thefacebook.com ([2620:10d:c090:200::5:3e64])
        by smtp.gmail.com with ESMTPSA id p19-v6sm4086614pgh.60.2018.09.27.11.18.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 11:18:11 -0700 (PDT)
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-btrfs@vger.kernel.org
Cc:     kernel-team@fb.com, David Sterba <dsterba@suse.com>,
        linux-fsdevel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v9 3/6] vfs: update swap_{,de}activate documentation
Date:   Thu, 27 Sep 2018 11:17:35 -0700
Message-Id: <79f71cb15a9008c000ae3eb77118d32cb88948ba.1538072009.git.osandov@fb.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1538072009.git.osandov@fb.com>
References: <cover.1538072009.git.osandov@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Omar Sandoval <osandov@fb.com>

The documentation for these functions is wrong in several ways:

- swap_activate() is called with the inode locked
- swap_activate() takes a swap_info_struct * and a sector_t *
- swap_activate() can also return a positive number of extents it added
  itself
- swap_deactivate() does not return anything

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Hi, Jon, Al, could I get an ack on this patch? Thanks!

 Documentation/filesystems/Locking | 17 +++++++----------
 Documentation/filesystems/vfs.txt | 12 ++++++++----
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index efea228ccd8a..b970c8c2ee22 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -210,8 +210,9 @@ prototypes:
 	int (*launder_page)(struct page *);
 	int (*is_partially_uptodate)(struct page *, unsigned long, unsigned long);
 	int (*error_remove_page)(struct address_space *, struct page *);
-	int (*swap_activate)(struct file *);
-	int (*swap_deactivate)(struct file *);
+	int (*swap_activate)(struct swap_info_struct *, struct file *,
+			     sector_t *);
+	void (*swap_deactivate)(struct file *);
 
 locking rules:
 	All except set_page_dirty and freepage may block
@@ -235,8 +236,8 @@ putback_page:		yes
 launder_page:		yes
 is_partially_uptodate:	yes
 error_remove_page:	yes
-swap_activate:		no
-swap_deactivate:	no
+swap_activate:					yes
+swap_deactivate:				no
 
 	->write_begin(), ->write_end() and ->readpage() may be called from
 the request handler (/dev/loop).
@@ -333,14 +334,10 @@ cleaned, or an error value if not. Note that in order to prevent the page
 getting mapped back in and redirtied, it needs to be kept locked
 across the entire operation.
 
-	->swap_activate will be called with a non-zero argument on
-files backing (non block device backed) swapfiles. A return value
-of zero indicates success, in which case this file can be used for
-backing swapspace. The swapspace operations will be proxied to the
-address space operations.
+	->swap_activate is called from sys_swapon() with the inode locked.
 
 	->swap_deactivate() will be called in the sys_swapoff()
-path after ->swap_activate() returned success.
+path after ->swap_activate() returned success. The inode is not locked.
 
 ----------------------- file_lock_operations ------------------------------
 prototypes:
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index a6c6a8af48a2..6e14db053eaa 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -652,8 +652,9 @@ struct address_space_operations {
 					unsigned long);
 	void (*is_dirty_writeback) (struct page *, bool *, bool *);
 	int (*error_remove_page) (struct mapping *mapping, struct page *page);
-	int (*swap_activate)(struct file *);
-	int (*swap_deactivate)(struct file *);
+	int (*swap_activate)(struct swap_info_struct *, struct file *,
+			     sector_t *);
+	void (*swap_deactivate)(struct file *);
 };
 
   writepage: called by the VM to write a dirty page to backing store.
@@ -830,8 +831,11 @@ struct address_space_operations {
 
   swap_activate: Called when swapon is used on a file to allocate
 	space if necessary and pin the block lookup information in
-	memory. A return value of zero indicates success,
-	in which case this file can be used to back swapspace.
+	memory. If this returns zero, the swap system will call the address
+	space operations ->readpage() and ->direct_IO(). Alternatively, this
+	may call add_swap_extent() and return the number of extents added, in
+	which case the swap system will use the provided blocks directly
+	instead of going through the filesystem.
 
   swap_deactivate: Called during swapoff on files where swap_activate
 	was successful.
-- 
2.19.0

