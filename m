From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: [patch] error handling of ERR_PTR() returns
Date: Tue, 7 Apr 2009 18:34:53 +0400
Message-ID: <2a31deca0904070734y3f4c3366h5772c032381b38cc@mail.gmail.com>
References: <alpine.DEB.2.00.0904071632560.1465@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0904071632560.1465@bicker>
List-ID: <linux-btrfs.vger.kernel.org>

Since both NULL ptr and IS_ERR(ptr) are treated as error, why not
redefine IS_ERR to handle both, simplifying caller's life?

Regards,
Andrey



On Tue, Apr 7, 2009 at 5:38 PM, Dan Carpenter <error27@gmail.com> wrote=
:
> There are a couple functions which return ERR_PTR as well as NULL. =C2=
=A0The
> caller needs to handle both.
>
> Smatch also complains about the handling of alloc_extent_map() but as=
 far
> as I can see that doesn't actually return an ERR_PTR.
>
> Compile tested on 2.6.29.
>
> regards,
> dan carpenter
>
> --- orig/fs/btrfs/disk-io.c =C2=A0 =C2=A0 2009-04-07 16:15:36.0000000=
00 +0300
> +++ devel/fs/btrfs/disk-io.c =C2=A0 =C2=A02009-04-07 16:23:33.0000000=
00 +0300
> @@ -123,7 +123,7 @@
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock(&em_tree->lock);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0em =3D lookup_extent_mapping(em_tree, star=
t, len);
> - =C2=A0 =C2=A0 =C2=A0 if (em) {
> + =C2=A0 =C2=A0 =C2=A0 if (!IS_ERR(em) && em) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0em->bdev =3D
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock(&e=
m_tree->lock);
> @@ -1216,8 +1216,8 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int ret;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0root =3D btrfs_read_fs_root_no_name(fs_inf=
o, location);
> - =C2=A0 =C2=A0 =C2=A0 if (!root)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
> + =C2=A0 =C2=A0 =C2=A0 if (!root || IS_ERR(root))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return root;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (root->in_sysfs)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return root;
> @@ -1324,7 +1324,7 @@
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock(&em_tree->lock);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0em =3D lookup_extent_mapping(em_tree, offs=
et, PAGE_CACHE_SIZE);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock(&em_tree->lock);
> - =C2=A0 =C2=A0 =C2=A0 if (!em) {
> + =C2=A0 =C2=A0 =C2=A0 if (!em || IS_ERR(em)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0__unplug_io_fn=
(bdi, page);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
