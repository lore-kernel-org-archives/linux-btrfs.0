Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42512 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751625AbcISRL4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Sep 2016 13:11:56 -0400
Date: Mon, 19 Sep 2016 19:10:00 +0200
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH]btrfs-progs: btrfs-convert.c : check source file system
 state
Message-ID: <20160919171000.GM16983@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160915120852.GA22577@fedori>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160915120852.GA22577@fedori>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 15, 2016 at 02:08:52PM +0200, Lakshmipathi.G wrote:
> Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
> ---
>  btrfs-convert.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/btrfs-convert.c b/btrfs-convert.c
> index c10dc17..27da9ce 100644
> --- a/btrfs-convert.c
> +++ b/btrfs-convert.c
> @@ -2171,6 +2171,17 @@ static void ext2_copy_inode_item(struct btrfs_inode_item *dst,
>  	}
>  	memset(&dst->reserved, 0, sizeof(dst->reserved));
>  }
> +static int check_filesystem_state(struct btrfs_convert_context *cctx)
> +{
> +	ext2_filsys fs = cctx->fs_data;
> +
> +        if (!(fs->super->s_state & EXT2_VALID_FS))
> +		return 1;
> +	else if (fs->super->s_state & EXT2_ERROR_FS)
> +		return 1;
> +	else
> +		return 0;
> +}
>  
>  /*
>   * copy a single inode. do all the required works, such as cloning
> @@ -2340,6 +2351,10 @@ static int do_convert(const char *devname, int datacsum, int packing,
>  	ret = convert_open_fs(devname, &cctx);
>  	if (ret)
>  		goto fail;
> +	ret = check_filesystem_state(&cctx);
> +	if (ret) 
> +		warning("Source Filesystem is not clean, \
> +			 running e2fsck is recommended.");

I'm wondering if this should be a hard error or not, I'll leave it as a
warning for now.
