Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab3GIQiv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Jul 2013 12:38:51 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 3B24FA51FE
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jul 2013 18:38:50 +0200 (CEST)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: fix duplicate __[su]* typedefs on ppc64
Date: Tue,  9 Jul 2013 18:38:46 +0200
Message-Id: <1373387926-30937-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Michal Marek <mmarek@suse.cz>

The <ext2fs/ext2_types.h> header does attempt to avoid conflicts with
<linux/types.h>, but on ppc64, <asm-generic/int-ll64.h> gets somehow
included by other headers.

Include <linux/types.h> explicitly, so that <ext2fs/ext2_types.h>
notices it. The proper fix would be to fix <ext2fs/ext2_types.h> to not
use its own typedefs.

Originally observed in btrfs-convert, put the include into kerncompat.h
to avoid future problems.

Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 kerncompat.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kerncompat.h b/kerncompat.h
index 9c116b4..6584818 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -26,6 +26,7 @@
 #include <endian.h>
 #include <byteswap.h>
 #include <assert.h>
+#include <linux/types.h>
 
 #ifndef READ
 #define READ 0
-- 
1.8.2

