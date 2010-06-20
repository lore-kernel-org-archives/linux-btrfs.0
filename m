From: Zhang JieJing <kzjeef@gmail.com>
Subject: Re: [PATCH] Btrfs: handle kmalloc() failure in btrfs_file_aio_write()
Date: Sun, 20 Jun 2010 12:56:02 +0800
Message-ID: <AANLkTinv_7JGRhI8PtnmPUY3yqcPJBV7-ENPsCfYJPkb@mail.gmail.com>
References: <1276971194-24572-1-git-send-email-kzjeef@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1276971194-24572-1-git-send-email-kzjeef@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2010/6/20 JieJing.Zhang <kzjeef@gmail.com>
>
> set errno to -ENOMEM and goto out
>
> Signed-off-by: JieJing.Zhang <kzjeef@gmail.com>
> ---
> =A0fs/btrfs/file.c | =A0 =A04 ++++
> =A01 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index e354c33..e0fcb6c 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -926,6 +926,10 @@ static ssize_t btrfs_file_aio_write(struct kiocb=
 *iocb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 PAGE_CACHE_SIZE, PAGE_CACHE_S=
IZE /
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (sizeof(struct page *)));
> =A0 =A0 =A0 =A0pages =3D kmalloc(nrptrs * sizeof(struct page *), GFP_=
KERNEL);
I think this gfp should changed to GFP_NOFS to avoid deadlock, right ?
like this commit: 33818bbb84cd371b63ed8849cc5264d24c8b3aa2
> + =A0 =A0 =A0 if (!pages) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0/* generic_write_checks can change our pos */
> =A0 =A0 =A0 =A0start_pos =3D pos;
> --
> 1.7.0.4
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
