Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58068 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758254AbdKOPM7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 10:12:59 -0500
Date: Wed, 15 Nov 2017 16:11:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, lakshmipathi.g@gmail.com
Subject: Re: [PATCH 1/2] btrfs: Fix wild memory access in compression level
 parser
Message-ID: <20171115151103.GN28899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171106024319.32584-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171106024319.32584-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 06, 2017 at 10:43:18AM +0800, Qu Wenruo wrote:
> [BUG]
> Kernel panic when mounting with "-o compress" mount option.
> KASAN will report like:
> ------
> ==================================================================
> BUG: KASAN: wild-memory-access in strncmp+0x31/0xc0
> Read of size 1 at addr d86735fce994f800 by task mount/662
> ...
> Call Trace:
>  dump_stack+0xe3/0x175
>  kasan_report+0x163/0x370
>  __asan_load1+0x47/0x50
>  strncmp+0x31/0xc0
>  btrfs_compress_str2level+0x20/0x70 [btrfs]
>  btrfs_parse_options+0xff4/0x1870 [btrfs]
>  open_ctree+0x2679/0x49f0 [btrfs]
>  btrfs_mount+0x1b7f/0x1d30 [btrfs]
>  mount_fs+0x49/0x190
>  vfs_kern_mount.part.29+0xba/0x280
>  vfs_kern_mount+0x13/0x20
>  btrfs_mount+0x31e/0x1d30 [btrfs]
>  mount_fs+0x49/0x190
>  vfs_kern_mount.part.29+0xba/0x280
>  do_mount+0xaad/0x1a00
>  SyS_mount+0x98/0xe0
>  entry_SYSCALL_64_fastpath+0x1f/0xbe
> ------
> 
> [Cause]
> For 'compress' and 'compress_force' options, its token doesn't expect
> any parameter so its args[0] contains uninitialized data.
> Accessing args[0] will cause above wild memory access.
> 
> [Fix]
> For Opt_compress and Opt_compress_force, set compression level to
> Z_DEFAULT_COMPRESSION manually.
> 
> NOTE: Don't set zlib compression level to 0 by default, which means no
> compression.

But we never set the level to 0 at the point the compression actually
happens. See zlib.c:zlib_set_level, if level is 0 then the level
passed to zlib is 3. Z_DEFAULT_COMPRESSION is upstream zlib level 6,
which is slower, we need zlib to stay in the real-time numbers.

> @@ -507,8 +508,19 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
>  			    token == Opt_compress_force ||
>  			    strncmp(args[0].from, "zlib", 4) == 0) {
>  				compress_type = "zlib";
> +
>  				info->compress_type = BTRFS_COMPRESS_ZLIB;
> -				info->compress_level =
> +				/*
> +				 * args[0] contains uninitialized data since
> +				 * for these tokens we don't expect any
> +				 * parameter.
> +				 */
> +				if (token == Opt_compress ||
> +				    token == Opt_compress_force)
> +					info->compress_level =
> +						Z_DEFAULT_COMPRESSION;
> +				else
> +					info->compress_level =
>  					btrfs_compress_str2level(args[0].from);

At least this will not screw up the levels, anything that's not
recognized will become the default.

>  				btrfs_set_opt(info->mount_opt, COMPRESS);
>  				btrfs_clear_opt(info->mount_opt, NODATACOW);
