Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40614 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489Ab2KWDDg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Nov 2012 22:03:36 -0500
Message-ID: <50AEE772.7000008@gmail.com>
Date: Fri, 23 Nov 2012 11:03:14 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: chris.mason@fusionio.com, Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Btrfs: do not warn_on  io_ctl->cur in io_ctl_map_page
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

io_ctl_map_page is called by many functions in free-space-cache.
In most scenarios, the ->cur is not null, e.g. io_ctl_add_entry.
I think we'd better remove the warn_on here.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/btrfs/free-space-cache.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 1027b85..31fcf24 100644
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
1.7.5.4
