Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:46985 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaA3M26 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 07:28:58 -0500
Received: by mail-ve0-f178.google.com with SMTP id oy12so2150716veb.9
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jan 2014 04:28:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391041651-15689-6-git-send-email-Gerhard@Heift.Name>
References: <1391041651-15689-1-git-send-email-Gerhard@Heift.Name>
	<1391041651-15689-6-git-send-email-Gerhard@Heift.Name>
Date: Thu, 30 Jan 2014 13:28:57 +0100
Message-ID: <CACeaM89gx+5ymh5CU5SWwEEhp1Ugy=-utDnsrtMrHrORg8-KGQ@mail.gmail.com>
Subject: Re: [PATCH RFCv3 5/6] btrfs: search_ioctl: direct copy to userspace
From: Gerhard Heift <gerhard@heift.name>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-01-30 Gerhard Heift <gerhard@heift.name>:
> By copying each found item seperatly to userspace, we do not need extra
> memory in the kernel. This allows to run a large search inside of a single call.
>
> Signed-off-by: Gerhard Heift <Gerhard@Heift.Name>
> ---
>  fs/btrfs/ioctl.c | 52 ++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 36 insertions(+), 16 deletions(-)
>
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 10b9931..6daf23b 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1855,7 +1855,7 @@ static noinline int copy_to_sk(struct btrfs_root *root,
>                                struct btrfs_key *key,
>                                struct btrfs_ioctl_search_key *sk,
>                                size_t *buf_size,
> -                              char *buf,
> +                              char __user *buf,
>                                unsigned long *sk_offset,
>                                int *num_found)
>  {
> @@ -1890,7 +1890,7 @@ static noinline int copy_to_sk(struct btrfs_root *root,
>                 if (sizeof(sh) + item_len > *buf_size) {
>                         if (*num_found) {
>                                 ret = 1;
> -                               goto overflow;
> +                               goto err;
>                         }
>
>                         /*
> @@ -1905,7 +1905,7 @@ static noinline int copy_to_sk(struct btrfs_root *root,
>
>                 if (sizeof(sh) + item_len + *sk_offset > *buf_size) {
>                         ret = 1;
> -                       goto overflow;
> +                       goto err;
>                 }
>
>                 sh.objectid = key->objectid;
> @@ -1915,20 +1915,28 @@ static noinline int copy_to_sk(struct btrfs_root *root,
>                 sh.transid = found_transid;
>
>                 /* copy search result header */
> -               memcpy(buf + *sk_offset, &sh, sizeof(sh));
> +               if (copy_to_user(buf + *sk_offset, &sh, sizeof(sh))) {
> +                       ret = -EFAULT;
> +                       goto err;
> +               }
> +
>                 *sk_offset += sizeof(sh);
>
>                 if (item_len) {
> -                       char *p = buf + *sk_offset;
> +                       char __user *p = buf + *sk_offset;
>                         /* copy the item */
> -                       read_extent_buffer(leaf, p,
> -                                          item_off, item_len);
> +                       if (read_extent_buffer_to_user(leaf, p,
> +                                                      item_off, item_len)) {
> +                               ret = -EFAULT;
> +                               goto err;
> +                       }
> +
>                         *sk_offset += item_len;
>                 }
>                 (*num_found)++;
>
>                 if (ret) /* -EOVERFLOW from above */
> -                       goto overflow;
> +                       goto err;
>
>                 if (*num_found >= sk->nr_items)
>                         break;
> @@ -1946,14 +1954,24 @@ advance_key:
>                 key->objectid++;
>         } else
>                 ret = 1;
> -overflow:
> +err:
> +       /*
> +        *  0: all items from this leaf copied, continue with next
> +        *  1: * more items can be copied, but unused buffer is too small
> +        *     * all items were found
> +        *     Either way, it will stops the loop which iterates to the next
> +        *     leaf
> +        *  -EOVERFLOW: item was to large for buffer
> +        *  -EFAULT: could not copy extent buffer back to userspace
> +        */
> +
>         return ret;
>  }
>
>  static noinline int search_ioctl(struct inode *inode,
>                                  struct btrfs_ioctl_search_key *sk,
>                                  size_t *buf_size,
> -                                char *buf)
> +                                char __user *buf)
>  {
>         struct btrfs_root *root;
>         struct btrfs_key key;
> @@ -2004,6 +2022,7 @@ static noinline int search_ioctl(struct inode *inode,
>                 ret = copy_to_sk(root, path, &key, sk, buf_size, buf,
>                                  &sk_offset, &num_found);
>                 btrfs_release_path(path);
> +
>                 if (ret || num_found >= sk->nr_items)
>                         break;
>
> @@ -2019,7 +2038,8 @@ err:
>  static noinline int btrfs_ioctl_tree_search(struct file *file,
>                                            void __user *argp)
>  {
> -       struct btrfs_ioctl_search_args *args;
> +       struct btrfs_ioctl_search_args __user *args;
> +       struct btrfs_ioctl_search_key sk;
>         struct inode *inode;
>         int ret;
>         size_t buf_size;
> @@ -2027,14 +2047,15 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
>         if (!capable(CAP_SYS_ADMIN))
>                 return -EPERM;
>
> -       args = memdup_user(argp, sizeof(*args));
> -       if (IS_ERR(args))
> -               return PTR_ERR(args);
> +       args = (struct btrfs_ioctl_search_args __user *)argp;
> +
> +       if (copy_from_user(&sk, &args->key, sizeof(sk)))
> +               return -EFAULT;
>
>         buf_size = sizeof(args->buf);
>
>         inode = file_inode(file);
> -       ret = search_ioctl(inode, &args->key, &buf_size, args->buf);
> +       ret = search_ioctl(inode, &sk, &buf_size, args->buf);
>
>         /*
>          * In the origin implementation an overflow is handled by returning a
> @@ -2045,7 +2066,6 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
>
>         if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))

Here I forgot to replace the full copy with only copying the search
key. The correct copy looks like this:

copy_to_user(&args->key, &sk, sizeof(sk))

I will post another version.

>                 ret = -EFAULT;
> -       kfree(args);
>         return ret;
>  }
>
> --
> 1.8.5.3
>
