Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:52211 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab3ABLvI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Jan 2013 06:51:08 -0500
Message-ID: <50E41D80.6020005@jan-o-sch.net>
Date: Wed, 02 Jan 2013 12:44:00 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>
CC: chris.mason@fusionio.com, ablock84@googlemail.com,
        Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC] btrfs send without data updates?
References: <20121231213307.GC12558@wotan.suse.de>
In-Reply-To: <20121231213307.GC12558@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mark,

I like your approach in general. Two comments on the patch below.

On Mon, December 31, 2012 at 22:33 (+0100), Mark Fasheh wrote:
> Hi Chris! Hi Alexander!
> 
> I'm working on the kernel side of a feature request we have from the snapper
> developers. Snapper can be used (in conjunction) with btrfs on openSUSE to
> roll back system changes made via YaST and zypper.
> 
> If you want to know more, you can see the following page:
> 
> http://doc.opensuse.org/documentation/html/openSUSE/opensuse-reference/cha.snapper.html
> 
> Right now snapper does this by running 'find' and 'diff' against snapshots
> it has taken. This is obviously expensive and we're looking at something
> like the btrfs send ioctl to reduce the overhead during this operation.
> 
> In fact, send works quite nicely except that it always reads changed file
> data from disk and puts it in the stream - snapper doesn't want this
> overhead and would prefer to produce the changed data itself. Knowing that
> there *was* a data update however is still critical.
> 
> So I have a conceptually simple patch which passes a flag to modify this
> behavior. The patch is included below however I will quote the description
> here: 
> 
>  "This patch adds the flag, BTRFS_SEND_FLAG_NO_FILE_DATA to the btrfs send
>   ioctl code. When this flag is set, the btrfs send code will never write file
>   data into the stream (thus also avoiding expensive reads of that data in the
>   first place). BTRFS_SEND_C_UPDATE_EXTENT commands will be sent (instead of
>   BTRFS_SEND_C_WRITE) with an offset, length pair indicating the extent in
>   question.
> 
>   This patch does not affect the operation of BTRFS_SEND_C_CLONE commands -
>   they will continue to be sent when a search finds an appropriate extent to
>   clone from."
> 
> 
> What do you all think of this approach? Is it too ugly to put a conditional
> command in the stream? Do we want to just add another ioctl? I'm loathe to
> go in *that* direction because I fear I'd be replicating most of the send
> code _anyway_ (well, it could just be a wrapper ioctl()).
> 
> Thanks in advance for looking at this.
> 	--Mark
> 
> --
> Mark Fasheh
> 
> 
> From: Mark Fasheh <mfasheh@suse.de>
> 
> btrfs: add "no file data" flag to btrfs send ioctl
> 
> This patch adds the flag, BTRFS_SEND_FLAG_NO_FILE_DATA to the btrfs send
> ioctl code. When this flag is set, the btrfs send code will never write file
> data into the stream (thus also avoiding expensive reads of that data in the
> first place). BTRFS_SEND_C_UPDATE_EXTENT commands will be sent (instead of
> BTRFS_SEND_C_WRITE) with an offset, length pair indicating the extent in
> question.
> 
> This patch does not affect the operation of BTRFS_SEND_C_CLONE commands -
> they will continue to be sent when a search finds an appropriate extent to
> clone from.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> ---
>  fs/btrfs/ioctl.h |    7 +++++++
>  fs/btrfs/send.c  |   48 ++++++++++++++++++++++++++++++++++++++++++++----
>  fs/btrfs/send.h  |    1 +
>  3 files changed, 52 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index 731e287..1f6cfdd 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -363,6 +363,13 @@ struct btrfs_ioctl_received_subvol_args {
>  	__u64	reserved[16];		/* in */
>  };
>  
> +/*
> + * Caller doesn't want file data in the send stream, even if the
> + * search of clone sources doesn't find an extent. UPDATE_EXTENT
> + * commands will be sent instead of WRITE commands.
> + */
> +#define BTRFS_SEND_FLAG_NO_FILE_DATA     0x1
> +
>  struct btrfs_ioctl_send_args {
>  	__s64 send_fd;			/* in */
>  	__u64 clone_sources_count;	/* in */
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index e78b297..f97b5e6 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -85,6 +85,7 @@ struct send_ctx {
>  	u32 send_max_size;
>  	u64 total_send_size;
>  	u64 cmd_send_size[BTRFS_SEND_C_MAX + 1];
> +	u64 flags;	/* 'flags' member of btrfs_ioctl_send_args is u64 */
>  
>  	struct vfsmount *mnt;
>  
> @@ -3707,6 +3708,42 @@ out:
>  	return ret;
>  }
>  
> +/*
> + * Send an update extent command to user space.
> + */
> +static int send_update_extent(struct send_ctx *sctx,
> +			      u64 offset, u32 len)
> +{
> +	int ret = 0;
> +	struct fs_path *p;
> +
> +verbose_printk("btrfs: send_update_extent offset=%llu, len=%d\n", offset, len);

I know the send code has some of those, too, but it really shouldn't. Please
don't add any new ones. If you think that's useful, please use proper
indentation or even better, pr_debug with proper indentation.

> +
> +	p = fs_path_alloc(sctx);
> +	if (!p)
> +		return -ENOMEM;
> +
> +	ret = begin_cmd(sctx, BTRFS_SEND_C_UPDATE_EXTENT);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
> +	if (ret < 0)
> +		goto out;
> +
> +	TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset);
> +	TLV_PUT_U64(sctx, BTRFS_SEND_A_CLONE_LEN, len);
> +	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
> +	TLV_PUT_U64(sctx, BTRFS_SEND_A_SIZE, len);

Having both CLONE_LEN and SIZE doesn't seem right. The sequence seems a bit odd
here, too, but it's in good company with the rest of send.c.

-Jan

> +
> +	ret = send_cmd(sctx);
> +
> +tlv_put_failure:
> +out:
> +	fs_path_free(sctx, p);
> +	return ret;
> +}
> +
>  static int send_write_or_clone(struct send_ctx *sctx,
>  			       struct btrfs_path *path,
>  			       struct btrfs_key *key,
> @@ -3742,7 +3779,11 @@ static int send_write_or_clone(struct send_ctx *sctx,
>  		goto out;
>  	}
>  
> -	if (!clone_root) {
> +	if (clone_root) {
> +		ret = send_clone(sctx, offset, len, clone_root);
> +	} else if (sctx->flags & BTRFS_SEND_FLAG_NO_FILE_DATA) {
> +		ret = send_update_extent(sctx, offset, len);
> +	} else {
>  		while (pos < len) {
>  			l = len - pos;
>  			if (l > BTRFS_SEND_READ_SIZE)
> @@ -3755,10 +3796,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
>  			pos += ret;
>  		}
>  		ret = 0;
> -	} else {
> -		ret = send_clone(sctx, offset, len, clone_root);
>  	}
> -
>  out:
>  	return ret;
>  }
> @@ -4570,6 +4608,8 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
>  	INIT_RADIX_TREE(&sctx->name_cache, GFP_NOFS);
>  	INIT_LIST_HEAD(&sctx->name_cache_list);
>  
> +	sctx->flags = arg->flags;
> +
>  	sctx->send_filp = fget(arg->send_fd);
>  	if (IS_ERR(sctx->send_filp)) {
>  		ret = PTR_ERR(sctx->send_filp);
> diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
> index 1bf4f32..8bb18f7 100644
> --- a/fs/btrfs/send.h
> +++ b/fs/btrfs/send.h
> @@ -86,6 +86,7 @@ enum btrfs_send_cmd {
>  	BTRFS_SEND_C_UTIMES,
>  
>  	BTRFS_SEND_C_END,
> +	BTRFS_SEND_C_UPDATE_EXTENT,
>  	__BTRFS_SEND_C_MAX,
>  };
>  #define BTRFS_SEND_C_MAX (__BTRFS_SEND_C_MAX - 1)
> 
