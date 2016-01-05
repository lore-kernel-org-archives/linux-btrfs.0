Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbcAEOOr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Jan 2016 09:14:47 -0500
Date: Tue, 5 Jan 2016 15:12:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix output of compression message in
 btrfs_parse_options()
Message-ID: <20160105141225.GB4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201512160257.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201512160257.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 16, 2015 at 11:57:38AM +0900, Tsutomu Itoh wrote:
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 974be09..dcc1f15 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2709,7 +2709,7 @@ int open_ctree(struct super_block *sb,
>  	 * In the long term, we'll store the compression type in the super
>  	 * block, and it'll be used for per file compression control.
>  	 */
> -	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
> +	fs_info->compress_type = BTRFS_COMPRESS_NONE;

This would change the default compression type, eg. when the compression
is turned on via chattr +c . This would break the applications out
there, the fix has to avoid changing that.
