From: "Marco L. Crociani" <marco.crociani@gmail.com>
Subject: Re: [PATCH] Btrfs: fix crash in scrub repair code when device is missing
Date: Thu, 3 May 2012 21:33:04 +0200
Message-ID: <CADy=jfUJeVGaMvfyPXF903nJjqJv0MktB_PKVTHaonppBg7a+g@mail.gmail.com>
References: <1336037482-16199-1-git-send-email-sbehrens@giantdisaster.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Stefan Behrens <sbehrens@giantdisaster.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1336037482-16199-1-git-send-email-sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 3, 2012 at 11:31 AM, Stefan Behrens
<sbehrens@giantdisaster.de> wrote:
> Fix that when scrub tries to repair an I/O or checksum error and one =
of
> the devices containing the mirror is missing, it crashes in bio_add_p=
age
> because the bdev is a NULL pointer for missing devices.
>
> Reported-by: Marco L. Crociani <marco.crociani@gmail.com>
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
> =C2=A0fs/btrfs/scrub.c | =C2=A0 =C2=A07 +++++++
> =C2=A01 file changed, 7 insertions(+)
>
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index b679bf6..7e487be 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -998,6 +998,7 @@ static int scrub_setup_recheck_block(struct scrub=
_dev *sdev,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0page =3D sblock->pagev + page_index;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0page->logical =3D logical;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0page->physical =3D bbio->stripes[mirror_index].physical;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 /* for missing devices, bdev is NULL */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0page->bdev =3D bbio->stripes[mirror_index].dev->bdev;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0page->mirror_num =3D mirror_index + 1;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0page->page =3D alloc_page(GFP_NOFS);
> @@ -1042,6 +1043,12 @@ static int scrub_recheck_block(struct btrfs_fs=
_info *fs_info,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct scrub_p=
age *page =3D sblock->pagev + page_num;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DECLARE_COMPLE=
TION_ONSTACK(complete);
>
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (page->bdev =3D=
=3D NULL) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 page->io_error =3D 1;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 sblock->no_io_error_seen =3D 0;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 continue;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BUG_ON(!page->=
page);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bio =3D bio_al=
loc(GFP_NOFS, 1);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!bio)
> --
> 1.7.10.1.362.g242cab3
>

May  3 18:53:08 evo kernel: [ 5270.759254] btrfs: checksum error at
logical 756637261824 on dev /dev/sda3, sector 881151024, root 259,
inode 1821286, offset 325373952, length 4096, links 1 (path: [...])
May  3 18:53:08 evo kernel: [ 5270.759286] btrfs: unable to fixup
(regular) error at logical 756637261824 on dev /dev/sda3


scrub device /dev/sda3 (id 1) status
	scrub started at Thu May  3 17:30:35 2012, running for 6594 seconds
	total bytes scrubbed: 568.65GB with 1 errors
	error details: csum=3D1
	corrected errors: 0, uncorrectable errors: 1, unverified errors: 0
scrub device  (id 2) history
	scrub started at Thu May  3 17:30:35 2012 and finished after 0 seconds
	total bytes scrubbed: 0.00 with 0 errors
scrub device /dev/sdb3 (id 3) status
	scrub started at Thu May  3 17:30:35 2012, running for 6594 seconds
	total bytes scrubbed: 536.66GB with 0 errors

May  3 20:07:51 evo kernel: [ 9752.940360] btrfs: checksum error at
logical 1284041527296 on dev /dev/sda3, sector 1907567464, root 259,
inode 1327815, offset 1691832320, length 4096, links 1 (path: [...])
May  3 20:07:51 evo kernel: [ 9752.940392] btrfs: unable to fixup
(regular) error at logical 1284041527296 on dev /dev/sda3
May  3 20:25:45 evo kernel: [10826.760001] btrfs: checksum error at
logical 1378644791296 on dev /dev/sda3, sector 2092339464, root 259,
inode 1759403, offset 767893504, length 4096, links 1 (path: [...])
May  3 20:25:45 evo kernel: [10826.760025] btrfs: unable to fixup
(regular) error at logical 1378644791296 on dev /dev/sda3
May  3 20:27:04 evo kernel: [10905.612849] btrfs: checksum error at
logical 1386199773184 on dev /dev/sda3, sector 2107095288, root 259,
inode 1580366, offset 1526546432, length 4096, links 1 (path: [...])
May  3 20:27:04 evo kernel: [10905.612881] btrfs: unable to fixup
(regular) error at logical 1386199773184 on dev /dev/sda3
May  3 20:29:46 evo kernel: [11067.396252] btrfs: checksum error at
logical 1401913339904 on dev /dev/sda3, sector 2137785848, root 259,
inode 1851460, offset 515543040, length 4096, links 1 (path: [...])
May  3 20:29:46 evo kernel: [11067.408660] btrfs: unable to fixup
(regular) error at logical 1401913339904 on dev /dev/sda3

That patch worked for me.
Thanks!

--=20
Marco Lorenzo Crociani,
marco.crociani@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
