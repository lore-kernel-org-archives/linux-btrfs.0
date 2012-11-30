Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36328 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab2K3GDO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Nov 2012 01:03:14 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so157198ieb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2012 22:03:13 -0800 (PST)
From: shhuiw@gmail.com
To: chris.mason@fusionio.com, jbacik@fusionio.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove warning check in io_ctl_map_page
Date: Fri, 30 Nov 2012 14:02:26 +0800
Message-Id: <50b84c20.a657320a.776a.fffff16d@mx.google.com>
In-Reply-To: <1354255348-5011-1-git-send-email-y>
References: <n>
 <1354255348-5011-1-git-send-email-y>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Sheng-Hui <shhuiw@gmail.com>

io_ctl_map_page is called by many functions in free-space-cache.
In some scenarios, the ->cur is not null, e.g. io_ctl_add_entry.
Remove the check here.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/free-space-cache.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index c3318cb..4ea66d4 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -307,7 +307,6 @@ static void io_ctl_unmap_page(struct io_ctl *io_ctl)
 
 static void io_ctl_map_page(struct io_ctl *io_ctl, int clear)
 {
-	WARN_ON(io_ctl->cur);
 	BUG_ON(io_ctl->index >= io_ctl->num_pages);
 	io_ctl->page = io_ctl->pages[io_ctl->index++];
 	io_ctl->cur = kmap(io_ctl->page);
-- 
1.6.0.2

