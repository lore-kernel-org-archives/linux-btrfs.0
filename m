From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: (Little) Patch about null dereference with acl and posix.
Date: Fri, 11 Dec 2009 23:21:08 +0100
Message-ID: <200912112321.09143.johannes.hirte@fem.tu-ilmenau.de>
References: <61bf8f4f0911181328y794436ackb82acca35d578f46@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <61bf8f4f0911181328y794436ackb82acca35d578f46@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch 18 November 2009 22:28:27 schrieb briaeros007:
> Hello,
> For some days, i've got oops on my system and i've investigate it a bit.
> The trouble was with  "posix_acl_equiv_mode" , and for some reason
> (corrupted metadata ?) btrfs sometimes call it with "acl"==NULL
> This function doesn't like it.
> So in my patch I've first put a little error protection around the
> call, and then avoid to call btrfs_set_acl with acl=NULL.
> 
> I'm not sure if it's ok with best practice, but i've done the test
> which produce the oops, and know it doesn't (but some csum failed.
> Well if my btrfs is corrupted, it's comprehensible).
> 
> The patch is the following.
> 
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index 3616042..f8ade24 100644
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -111,7 +111,8 @@ static int btrfs_set_acl(struct inode *inode,
> struct posix_acl *acl, int type)
>         switch (type) {
>         case ACL_TYPE_ACCESS:
>                 mode = inode->i_mode;
> -               ret = posix_acl_equiv_mode(acl, &mode);
> +               if (acl && mode)
> +                       ret = posix_acl_equiv_mode(acl, &mode);
>                 if (ret < 0)
>                         return ret;
>                 ret = 0;
> @@ -165,12 +166,13 @@ static int btrfs_xattr_set_acl(struct inode
> *inode, int type,
>                 } else if (IS_ERR(acl)) {
>                         return PTR_ERR(acl);
>                 }
> +               else
> +               {
> +                       ret = btrfs_set_acl(inode, acl, type);
> +                       posix_acl_release(acl);
> +               }
>         }
> 
> -       ret = btrfs_set_acl(inode, acl, type);
> -
> -       posix_acl_release(acl);
> -
>         return ret;
>  }

Shouldn't this go upstream and into stable review?
