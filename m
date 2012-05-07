From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Mon, 07 May 2012 20:53:41 +0800
Message-ID: <4FA7C5D5.60306@cn.fujitsu.com>
References: <C8PBkd9uCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8PBkd9uCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/07/2012 06:46 PM, Helmut Hullen wrote:

> btrfs: error reading free space cache
> BUG: unable to handle kernel NULL pointer dereference at 00000001
> IP: [<c1295c36>] io_ctl_drop_pages+0x26/0x50
> *pdpt = 0000000029712001 *pde = 0000000000000000
> Oops: 0002 [#1]



Could you please try this and show us the results?

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 202008e..ae514ad 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -296,7 +296,9 @@ static void io_ctl_free(struct io_ctl *io_ctl)
 static void io_ctl_unmap_page(struct io_ctl *io_ctl)
 {
 	if (io_ctl->cur) {
-		kunmap(io_ctl->page);
+		WARN_ON(!io_ctl->page);
+		if (io_ctl->page)
+			kunmap(io_ctl->page);
 		io_ctl->cur = NULL;
 		io_ctl->orig = NULL;
 	}
