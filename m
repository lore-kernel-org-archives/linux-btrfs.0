Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:59530 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2KTQMR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Nov 2012 11:12:17 -0500
Received: by mail-qa0-f53.google.com with SMTP id k31so880990qat.19
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Nov 2012 08:12:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353403785-3489-2-git-send-email-wenqing.lz@taobao.com>
References: <1353403785-3489-1-git-send-email-wenqing.lz@taobao.com> <1353403785-3489-2-git-send-email-wenqing.lz@taobao.com>
From: Nehemiah Dacres <vivacarlie@gmail.com>
Date: Tue, 20 Nov 2012 10:11:56 -0600
Message-ID: <CAJSBqddd_yubY88qcK7NTep9YMuuR3om_AcFwEzmnR0psKGhxw@mail.gmail.com>
Subject: Re: [PATCH 1/4][RFC] ext4: remove duplicated check from ext4_fallocate
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I wanted to know if any one else is writing a  BTRFS gui other than
the writers of  BTRFS-GUI (http://carfax.org.uk/btrfs-gui) who haven't
updated svn sense 2009  I think. Is there any documentation on
communicating with /dev/btrfs-controle ? a command list? I've looked
at the source of btrfs.c but I don't want to depend on my
understanding of it.

On Tue, Nov 20, 2012 at 3:29 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
>
> Remove a sanity check from ext4_fallocate because vfs has already checked it.
>
> Reported-by: Guo Chao <yan@linux.vnet.ibm.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/ext4/extents.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 7011ac9..c2eb409 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4427,10 +4427,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>         if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
>                 return -EOPNOTSUPP;
>
> -       /* Return error if mode is not supported */
> -       if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> -               return -EOPNOTSUPP;
> -
>         if (mode & FALLOC_FL_PUNCH_HOLE)
>                 return ext4_punch_hole(file, offset, len);
>
> --
> 1.7.12.rc2.18.g61b472e
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
