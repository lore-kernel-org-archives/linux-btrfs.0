From: Hubert Kario <kario@wit.edu.pl>
Subject: Re: TRIM support
Date: Sun, 3 Jul 2011 16:46:51 +0200
Message-ID: <201107031646.51411.kario@wit.edu.pl>
References: <CAAeznTr5FMOqyJA9JfP2H-h1rJjasfxUJAeNNnNKhiHCTV03mA@mail.gmail.com> <201107031420.45718.hka@qbs.com.pl> <CAAeznTpCXWz+dth4PiMneV23NiLyr8c+usiw07Gkn6=AvaVM9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-15
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
	linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAeznTpCXWz+dth4PiMneV23NiLyr8c+usiw07Gkn6=AvaVM9g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 03 of July 2011 14:56:40 Leonidas Spyropoulos wrote:
> On Sun, Jul 3, 2011 at 1:20 PM, Hubert Kario <hka@qbs.com.pl> wrote:
> > On Sunday 03 of July 2011 00:40:46 Leonidas Spyropoulos wrote:
> >> On Sat, Jul 2, 2011 at 11:39 PM, Leonidas Spyropoulos
> >>=20
> >> <artafinde@gmail.com> wrote:
> >> > On Sat, Jul 2, 2011 at 8:45 PM, Calvin Walton
> >> > <calvin.walton@kepstin.ca>
> >=20
> > wrote:
> >> >> On Sat, 2011-07-02 at 19:08 +0100, Leonidas Spyropoulos wrote:
> >> >>> Hello,
> >> >>>=20
> >> >>> I just installed an archlinux with btrfs root partition and wo=
uld
> >> >>> like to set the correct mount properties
> >> >>> Following this:
> >> >>> https://wiki.archlinux.org/index.php/Solid_State_Drives
> >> >>> it says there that I should use the discard mount parameter to
> >> >>> enable TRIM.
> >> >>>=20
> >> >>> I would like to ask by using ssd mount parameter would TRIM be
> >> >>> enabled? The SSD is Intel 320 Series 120Gb
> >> >>=20
> >> >> No, the "ssd" mount parameter has nothing to do with TRIM.
> >> >>=20
> >> >> The "ssd" mount parameter adjusts a couple of tuning parameters=
 where
> >> >> the default setting is designed to improve performance on spinn=
ing
> >> >> HDD, and instead tunes for the random-access ability of an SSD.
> >> >>=20
> >> >> The ssd option is automatically enabled if the kernel detects t=
hat
> >> >> your drive is an SSD (you can check with 'cat /proc/mounts').
> >> >>=20
> >> >> The discard option is not currently automatically enabled; I th=
ink
> >> >> there may have been some performance issues in certain cases wi=
th
> >> >> drives that have slow trim implementations. But feel free to gi=
ve it
> >> >> a try.
> >> >>=20
> >> >> --
> >> >> Calvin Walton <calvin.walton@kepstin.ca>
> >>=20
> >> On the same system when I try to compile the btrfs-tools I get an =
error.
> >> Since on the wiki you mention only the packages for Fedora and Deb=
ian,
> >>=20
> >> Which are the requirements for the btrfs tools?
> >>=20
> >> PS: AUR package is broken as well.
> >=20
> > the AUR package is OK, problem is that the sources don't compile wi=
th new
> > gcc.
> >=20
> > Download Hugo's integration branch
> > http://git.darksatanic.net/repo/btrfs-progs-unstable.git/
> > integration-20110630
>=20
> I download the files:
>=20
> git clone  http://git.darksatanic.net/repo/btrfs-progs-unstable.git/
> integration-20110630
>=20
> > and apply my patch to it:
> > http://www.spinics.net/lists/linux-btrfs/msg10965.html
>=20
> Then I tried to apply the patch you mentioned:
>=20
> patch < rem.diff
>=20
> but it's failing:
> The rem.diff is the file attached
>=20
> > --
> > Hubert Kario
> > QBS - Quality Business Software
> > 02-656 Warszawa, ul. Ksawer=F3w 30/85
> > tel. +48 (22) 646-61-51, 646-74-24
> > www.qbs.com.pl
>=20
> Here is the error I am getting:
> patching file mkfs.c
> Hunk #1 FAILED at 1060.
> Hunk #2 FAILED at 1070.
> 2 out of 2 hunks FAILED -- saving rejects to file mkfs.c.rej
> patching file volumes.c
> Hunk #1 FAILED at 868.
> Hunk #2 FAILED at 920.
> 2 out of 2 hunks FAILED -- saving rejects to file volumes.c.rej
>=20
> I think the file I created is wrong.
> What is the accepted format for the patch command?

sorry, looks like I changed tabs to spaces while posting.
=46ollowing one should apply cleanly

try this:

git clone  http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ in=
tegration-20110630
cd integration-20110630
git checkout integration-20110630
git apply path/to/patch

Subject: [PATCH] remove unused variables

fixes compilation warnings with gcc 4.6.0 20110429

Signed-off-by: Hubert Kario <kario@wit.edu.pl>
---
 mkfs.c    |    3 ---
 volumes.c |    2 --
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 3a49bab..152b9da 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1060,7 +1060,6 @@ static int make_image(char *source_dir, struct bt=
rfs_root *root, int out_fd)
 	struct btrfs_trans_handle *trans;
=20
 	struct stat root_st;
-	int root_len;
=20
 	struct directory_name_entry dir_head;
=20
@@ -1070,8 +1069,6 @@ static int make_image(char *source_dir, struct bt=
rfs_root *root, int out_fd)
 		goto fail;
 	}
=20
-	root_len =3D strlen(source_dir);
-
 	INIT_LIST_HEAD(&dir_head.list);
=20
 	trans =3D btrfs_start_transaction(root, 1);
diff --git a/volumes.c b/volumes.c
index 31779b7..f5f752b 100644
--- a/volumes.c
+++ b/volumes.c
@@ -888,7 +888,6 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handl=
e *trans,
 	struct list_head *dev_list =3D &extent_root->fs_info->fs_devices->dev=
ices;
 	struct list_head *cur;
 	struct map_lookup *map;
-	u64 physical;
 	u64 calc_size =3D 8 * 1024 * 1024;
 	int num_stripes =3D 1;
 	int sub_stripes =3D 0;
@@ -940,7 +939,6 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handl=
e *trans,
 		btrfs_set_stack_stripe_devid(stripe, device->devid);
 		btrfs_set_stack_stripe_offset(stripe, dev_offset);
 		memcpy(stripe->dev_uuid, device->uuid, BTRFS_UUID_SIZE);
-		physical =3D dev_offset;
 		index++;
 	}
=20
--=20
1.7.5.1


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
