From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: [PATCH] Btrfs: check items for correctness as we search V3
Date: Thu, 17 Mar 2011 22:12:32 +0300
Message-ID: <AANLkTingDAF7XfLNEUGVDzLd5XYV9J23A3t=qB-Modj2@mail.gmail.com>
References: <1300305863-2609-1-git-send-email-josef@redhat.com> <1300385915-3317-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1300385915-3317-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 17, 2011 at 9:18 PM, Josef Bacik <josef@redhat.com> wrote:
> Currently if we have corrupted items things will blow up in spectacul=
ar ways.
> So as we read in blocks and they are leaves, check the entire leaf to=
 make sure
> all of the items are correct and point to valid parts in the leaf for=
 the item
> data the are responsible for. =C2=A0If the item is corrupt we will ki=
ck back EIO and
> not read any of the copies since they are likely to not be correct ei=
ther. =C2=A0This
> will catch generic corruptions, it will be up to the individual calle=
rs of
> btrfs_search_slot to make sure their items are right. =C2=A0Thanks,
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 495b1ac..9f31e11 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -323,6 +323,7 @@ static int btree_read_extent_buffer_pages(struct =
btrfs_root *root,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int num_copies =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0int mirror_num =3D 0;
>
> + =C2=A0 =C2=A0 =C2=A0 clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0io_tree =3D &BTRFS_I(root->fs_info->btree_=
inode)->io_tree;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0while (1) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D read_e=
xtent_buffer_pages(io_tree, eb, start, 1,
> @@ -331,6 +332,14 @@ static int btree_read_extent_buffer_pages(struct=
 btrfs_root *root,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
!verify_parent_transid(io_tree, eb, parent_transid))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return ret;
>
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* This buffe=
r's crc is fine, but its contents are corrupted, so
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* there is n=
o reason to read the other copies, they won't be
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* any less w=
rong.
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/

This sounds like an overstatement to me. You may be dealing with an
error pattern CRC faled to catch, so giving up reading a mirror at
this point seems premature.

Regards,
Andrey
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
