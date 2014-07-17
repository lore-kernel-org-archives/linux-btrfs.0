Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19237 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaGQKqq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jul 2014 06:46:46 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
Subject: [PATCH] Btrfs: fix wrong manpage of defrag command
Date: Thu, 17 Jul 2014 18:46:01 +0800
Message-Id: <1405593961-10423-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'btrfs filesystem defrag' has an option '-t', whose manpage says

"Any extent bigger than threshold given by -t option, will be
considered already defragged. Use 0 to take the kernel default, and
use 1 to say every single extent must be rewritten."

Here 'use 0' still works, it refers to the default value(256K), however,
'use 1' is an obvious typo, it should be -1, which means the largest value
it can be.

Right now, we use parse_size() which no more allow value '-1', so in
order to keep the manpage correct, this updates it to only keep value '0'.

If you want to make sure every single extent is rewritten, please use a fairly
large size, say 1G.

Reported-by: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 Documentation/btrfs-filesystem.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/btrfs-filesystem.txt b/Documentation/btrfs-filesystem.txt
index 0ee79cb..c9c0b00 100644
--- a/Documentation/btrfs-filesystem.txt
+++ b/Documentation/btrfs-filesystem.txt
@@ -41,8 +41,7 @@ The start position and the number of bytes to defragment can be specified by
 start and len using '-s' and '-l' options below.
 Any extent bigger than threshold given by '-t' option, will be considered
 already defragged.
-Use 0 to take the kernel default, and use 1 to
-say every single extent must be rewritten.
+Use 0 to take the kernel default.
 You can also turn on compression in defragment operations.
 +
 `Options`
-- 
1.8.1.4

