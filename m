Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:41154 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbeEPSZr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 14:25:47 -0400
Received: by mail-pl0-f65.google.com with SMTP id az12-v6so907370plb.8
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 11:25:47 -0700 (PDT)
Date: Wed, 16 May 2018 11:25:45 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Howard McLauchlan <linux@hmclauchlan.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        Howard McLauchlan <hmclauchlan@fb.com>
Subject: Re: [RFC PATCH 1/6] btrfs: send, bump stream version
Message-ID: <20180516182545.GB29231@vader>
References: <20180509020651.7946-1-linux@hmclauchlan.com>
 <20180509020651.7946-2-linux@hmclauchlan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180509020651.7946-2-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 08, 2018 at 10:06:46PM -0400, Howard McLauchlan wrote:
> From: Filipe David Borba Manana <fdmanana@gmail.com>
> 
> This increases the send stream version from version 1 to version 2, adding
> new commands:
> 
> 1) total data size - used to tell the receiver how much file data the stream
>    will add or update;
> 
> 2) fallocate - used to pre-allocate space for files and to punch holes in files;
> 
> 3) inode set flags;
> 
> 4) set inode otime.
> 
> This is preparation work for subsequent changes that implement the new features.
> 
> A version 2 stream is only produced if the send ioctl caller passes in one of the
> new flags (BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE | BTRFS_SEND_FLAG_STREAM_V2), meaning
> old clients are unaffected.
> 
> [Howard: rebased on 4.17-rc4]
> Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
> ---
>  fs/btrfs/send.c            |  7 ++++++-
>  fs/btrfs/send.h            | 21 ++++++++++++++++++++-
>  include/uapi/linux/btrfs.h | 21 ++++++++++++++++++++-
>  3 files changed, 46 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index c0074d2d7d6d..eccd69387065 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -649,7 +649,10 @@ static int send_header(struct send_ctx *sctx)
>  	struct btrfs_stream_header hdr;
>  
>  	strcpy(hdr.magic, BTRFS_SEND_STREAM_MAGIC);
> -	hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION);
> +	if (sctx->flags & BTRFS_SEND_FLAG_STREAM_V2)
> +		hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION_2);
> +	else
> +		hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION_1);
>  
>  	return write_buf(sctx->send_filp, &hdr, sizeof(hdr),
>  					&sctx->send_off);
> @@ -6535,6 +6538,8 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
>  	INIT_LIST_HEAD(&sctx->name_cache_list);
>  
>  	sctx->flags = arg->flags;
> +	if (sctx->flags & BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE)
> +		sctx->flags |= BTRFS_SEND_FLAG_STREAM_V2;
>  
>  	sctx->send_filp = fget(arg->send_fd);
>  	if (!sctx->send_filp) {
> diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
> index ead397f7034f..a9b5489d690e 100644
> --- a/fs/btrfs/send.h
> +++ b/fs/btrfs/send.h
> @@ -10,7 +10,8 @@
>  #include "ctree.h"
>  
>  #define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
> -#define BTRFS_SEND_STREAM_VERSION 1
> +#define BTRFS_SEND_STREAM_VERSION_1 1
> +#define BTRFS_SEND_STREAM_VERSION_2 2
>  
>  #define BTRFS_SEND_BUF_SIZE SZ_64K
>  #define BTRFS_SEND_READ_SIZE (48 * SZ_1K)
> @@ -77,6 +78,15 @@ enum btrfs_send_cmd {
>  
>  	BTRFS_SEND_C_END,
>  	BTRFS_SEND_C_UPDATE_EXTENT,
> +
> +	/*
> +	 * The following commands were added in stream version 2.
> +	 */
> +	BTRFS_SEND_C_TOTAL_DATA_SIZE,
> +	BTRFS_SEND_C_FALLOCATE,
> +	BTRFS_SEND_C_INODE_SET_FLAGS,
> +	BTRFS_SEND_C_UTIMES2, /* Same as UTIMES, but it includes OTIME too. */

I've had feature requests for the ability to send compressed data
without decompressing it on the send side or the receive side. Could you
add a placeholder BTRFS_SEND_C_WRITE_COMPRESSED here? This way when I
get around to implementing it I won't have to do a v3.

Other than that,

Reviewed-by: Omar Sandoval <osandov@fb.com>
