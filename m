Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:49951 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758422Ab2JKLlw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 07:41:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Subject: Re: [PATCH 0/3] Update LZO compression
Date: Thu, 11 Oct 2012 11:41:27 +0000
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Johannes Stezenbach <js@sig21.net>,
        "richard -rw- weinberger" <richard.weinberger@gmail.com>,
        linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <cover.1349621096.git.markus@oberhumer.com> <20121009122614.569b9535.akpm@linux-foundation.org> <50748113.80408@oberhumer.com>
In-Reply-To: <50748113.80408@oberhumer.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210111141.27270.arnd@arndb.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday 09 October 2012, Markus F.X.J. Oberhumer wrote:
> > 
> > : This commit updates the kernel LZO code to the current upsteam version
> > : which features a significant speed improvement - benchmarking the Calgary
> > : and Silesia test corpora typically shows a doubled performance in
> > : both compression and decompression on modern i386/x86_64/powerpc machines.
> > 
> > There are significant clients of the LZO library - crypto, btrfs,
> > jffs2, ubifs, squashfs and zcache.  So let's give all those people a cc
> > and ask that they test the LZO changes once they land in linux-next. 
> > For correctness and performance, please.
> 
> The core compression and decompression code has been thoroughly tested, so I
> do not expect major problems.
> 
> Good testing after the merge and feedback about build or performance issues
> (and improvements!) is highly appreciated.

The addition of the lzo tree to linux-next caused this problem for ARM
imx_v6_v7_defconfig:

In file included from /home/arnd/linux-arm/arch/arm/boot/compressed/decompress.c:40:0:
/home/arnd/linux-arm/arch/arm/boot/compressed/../../../../lib/decompress_unlzo.c:34:34: fatal error: lzo/lzo1x_decompress.c: No such file or directory

Since the file was renamed, anything including it needs to be updated to the
new file name.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/lib/decompress_unlzo.c b/lib/decompress_unlzo.c
index 4531294..960183d 100644
--- a/lib/decompress_unlzo.c
+++ b/lib/decompress_unlzo.c
@@ -31,7 +31,7 @@
  */
 
 #ifdef STATIC
-#include "lzo/lzo1x_decompress.c"
+#include "lzo/lzo1x_decompress_safe.c"
 #else
 #include <linux/decompress/unlzo.h>
 #endif
