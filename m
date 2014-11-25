Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:39073 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaKYHms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 02:42:48 -0500
Received: by mail-pa0-f43.google.com with SMTP id kx10so49680pab.16
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 23:42:48 -0800 (PST)
Received: from [192.168.1.100] ([112.23.171.71])
        by mx.google.com with ESMTPSA id fl2sm662561pab.0.2014.11.24.23.42.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 24 Nov 2014 23:42:47 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: [PATCH] Btrfs: deal with all 'subvol=xxx' options once
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1416900194-17495-1-git-send-email-wangshilong1991@gmail.com>
Date: Tue, 25 Nov 2014 15:42:41 +0800
Message-Id: <6E61D1BE-32CB-4F05-B200-20FE5A36DCFF@gmail.com>
References: <1416900194-17495-1-git-send-email-wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> 
> Steps to reproduce:
> # mkfs.btrfs -f /dev/sdb
> # mount -t btrfs /dev/sdb /mnt
> # btrfs sub create /mnt/dir
> # mount -t btrfs /dev/sdb /mnt -o subvol=dir,subvol=dir
> 
> It fails with:
> mount: mount(2) failed: No such file or directory
> 
> Btrfs deal with subvolume mounting in a recursive way,
> to avoid looping, it will stripe out 'subvol=xxxx' string,
> then next loop will stop.Problem here is it only deal one
> string once, if users specify mount option multiple times.
> It will loop several times which is not good, and above
> reproducing steps will also return confusing results.
> 
> Fix this problem by striping out all 'subvol=xxx' options,
> only last is valid.
> 
> Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
> ---
> fs/btrfs/super.c | 20 +++++++++++++++++++-
> 1 file changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 54bd91e..2b2fa4b 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -1115,7 +1115,7 @@ static inline int is_subvolume_inode(struct inode *inode)
>  * subvolid=0 to make sure we get the actual tree root for path walking to the
>  * subvol we want.
>  */
> -static char *setup_root_args(char *args)
> +static char *__setup_root_args(char *args)
> {
> 	unsigned len = strlen(args) + 2 + 1;
> 	char *src, *dst, *buf;
> @@ -1161,6 +1161,24 @@ static char *setup_root_args(char *args)
> 	return buf;
> }
> 
> +static char *setup_root_args(char *args)
> +{
> +	char *p, *new_args;
> +
> +	p = new_args = __setup_root_args(args);
> +	/* in case users specify subvol=xxx option multiple times */
> +	while (p) {
> +		p = __setup_root_args(new_args);

Oh, i missed error handling here, will update it..



> +		if (p) {
> +			kfree(new_args);
> +			new_args = p;
> +		} else {
> +			break;
> +		}
> +	}
> +	return new_args;
> +}
> +
> static struct dentry *mount_subvol(const char *subvol_name, int flags,
> 				   const char *device_name, char *data)
> {
> -- 
> 1.7.12.4
> 

Best Regards,
Wang Shilong

