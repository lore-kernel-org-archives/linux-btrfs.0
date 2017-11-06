Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:9583 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932478AbdKFJx0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 04:53:26 -0500
Date: Mon, 6 Nov 2017 17:52:35 +0800
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: Qu Wenruo <wqu@suse.com>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>,
        <lakshmipathi.g@gmail.com>
Subject: Re: [PATCH 1/2] btrfs: Fix wild memory access in compression level
 parser
Message-ID: <20171106095235.GA30275@fnst.localdomain>
References: <20171106024319.32584-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20171106024319.32584-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 06, 2017 at 10:43:18AM +0800, Qu Wenruo wrote:
>[BUG]
>Kernel panic when mounting with "-o compress" mount option.
>KASAN will report like:
>------
>==================================================================
>BUG: KASAN: wild-memory-access in strncmp+0x31/0xc0
>Read of size 1 at addr d86735fce994f800 by task mount/662
>...
>Call Trace:
> dump_stack+0xe3/0x175
> kasan_report+0x163/0x370
> __asan_load1+0x47/0x50
> strncmp+0x31/0xc0
> btrfs_compress_str2level+0x20/0x70 [btrfs]
> btrfs_parse_options+0xff4/0x1870 [btrfs]
> open_ctree+0x2679/0x49f0 [btrfs]
> btrfs_mount+0x1b7f/0x1d30 [btrfs]
> mount_fs+0x49/0x190
> vfs_kern_mount.part.29+0xba/0x280
> vfs_kern_mount+0x13/0x20
> btrfs_mount+0x31e/0x1d30 [btrfs]
> mount_fs+0x49/0x190
> vfs_kern_mount.part.29+0xba/0x280
> do_mount+0xaad/0x1a00
> SyS_mount+0x98/0xe0
> entry_SYSCALL_64_fastpath+0x1f/0xbe
>------
>
>[Cause]
>For 'compress' and 'compress_force' options, its token doesn't expect
>any parameter so its args[0] contains uninitialized data.
>Accessing args[0] will cause above wild memory access.
>
>[Fix]
>For Opt_compress and Opt_compress_force, set compression level to
>Z_DEFAULT_COMPRESSION manually.
>
>NOTE: Don't set zlib compression level to 0 by default, which means no
>compression.
>
>Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

-- 
Thanks,
Lu

>---
> fs/btrfs/super.c | 14 +++++++++++++-
> 1 file changed, 13 insertions(+), 1 deletion(-)
>
>diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>index 65af029559b5..14258671da84 100644
>--- a/fs/btrfs/super.c
>+++ b/fs/btrfs/super.c
>@@ -42,6 +42,7 @@
> #include <linux/cleancache.h>
> #include <linux/ratelimit.h>
> #include <linux/btrfs.h>
>+#include <linux/zlib.h>
> #include "delayed-inode.h"
> #include "ctree.h"
> #include "disk-io.h"
>@@ -507,8 +508,19 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
> 			    token == Opt_compress_force ||
> 			    strncmp(args[0].from, "zlib", 4) == 0) {
> 				compress_type = "zlib";
>+
> 				info->compress_type = BTRFS_COMPRESS_ZLIB;
>-				info->compress_level =
>+				/*
>+				 * args[0] contains uninitialized data since
>+				 * for these tokens we don't expect any
>+				 * parameter.
>+				 */
>+				if (token == Opt_compress ||
>+				    token == Opt_compress_force)
>+					info->compress_level =
>+						Z_DEFAULT_COMPRESSION;
>+				else
>+					info->compress_level =
> 					btrfs_compress_str2level(args[0].from);
> 				btrfs_set_opt(info->mount_opt, COMPRESS);
> 				btrfs_clear_opt(info->mount_opt, NODATACOW);
>-- 
>2.14.3
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


