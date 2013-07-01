Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kmu-office.ch ([178.209.48.102]:47580 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab3GASnl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 14:43:41 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.kmu-office.ch (Postfix) with ESMTP id 9BC4E33556B
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jul 2013 20:32:54 +0200 (CEST)
Received: from mail.kmu-office.ch ([127.0.0.1])
	by localhost (mail.kmu-office.ch [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CtpAF0cUWMj2 for <linux-btrfs@vger.kernel.org>;
	Mon,  1 Jul 2013 20:32:54 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mail.kmu-office.ch (Postfix) with ESMTP id 58A3D3357A4
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jul 2013 20:32:54 +0200 (CEST)
Received: from webmail.kmu-office.ch (unknown [178.209.48.103])
	(Authenticated sender: stefan@agner.ch)
	by mail.kmu-office.ch (Postfix) with ESMTPSA id 3F13933556B
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jul 2013 20:32:54 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 01 Jul 2013 20:33:39 +0200
From: Stefan Agner <stefan@agner.ch>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: return -1 when lzo compression makes data bigger
Message-ID: <ee94bd82a8a03550596ada76ce4cca29@agner.ch>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With this fix the lzo code behaves like the zlib code by returning an 
error
code when compression does not help reduce the size of the file.
This is currently not a bug since the compressed size is checked again 
in
the calling method compress_file_range.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
  fs/btrfs/lzo.c | 4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index f93151a..b6a6f07 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -207,8 +207,10 @@ static int lzo_compress_pages(struct list_head *ws,
  		}

  		/* we're making it bigger, give up */
-		if (tot_in > 8192 && tot_in < tot_out)
+		if (tot_in > 8192 && tot_in < tot_out) {
+			ret = -1;
  			goto out;
+		}

  		/* we're all done */
  		if (tot_in >= len)
-- 
1.8.3.1


