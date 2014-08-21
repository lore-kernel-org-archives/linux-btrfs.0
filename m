Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41419 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbaHUMID (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 08:08:03 -0400
Received: by mail-pd0-f175.google.com with SMTP id r10so13501613pdi.6
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Aug 2014 05:08:02 -0700 (PDT)
Received: from ako (pl398.nas931.p-kanagawa.nttpc.ne.jp. [219.102.77.142])
        by mx.google.com with ESMTPSA id dn3sm25317494pbc.79.2014.08.21.05.08.01
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Thu, 21 Aug 2014 05:08:01 -0700 (PDT)
From: Naohiro Aota <naota@elisp.net>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: Do not free dirty extent buffer
Date: Thu, 21 Aug 2014 21:07:58 +0900
Message-ID: <87mway82qp.fsf@elisp.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

free_some_buffer() should not free dirty extent buffers. They should be
left for later commit.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extent_io.c b/extent_io.c
index a127e54..8a668be 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -552,7 +552,7 @@ static int free_some_buffers(struct extent_io_tree *tree)
 
 	list_for_each_safe(node, next, &tree->lru) {
 		eb = list_entry(node, struct extent_buffer, lru);
-		if (eb->refs == 1) {
+		if (eb->refs == 1 && !(eb->flags && EXTENT_DIRTY)) {
 			free_extent_buffer(eb);
 			if (tree->cache_size < cache_hard_max)
 				break;
-- 
2.0.4
