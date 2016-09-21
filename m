Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47029 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754381AbcIUPre (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Sep 2016 11:47:34 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 392D1ABDB
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Sep 2016 15:47:06 +0000 (UTC)
Subject: Re: [PATCH] btrfs: silence compiler warning when fs_info is not used
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <1474380303-25995-1-git-send-email-jeffm@suse.com>
 <1474472599-11278-1-git-send-email-dsterba@suse.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <7a1f023d-d9c4-82ac-88d7-d123118f524a@suse.com>
Date: Wed, 21 Sep 2016 11:47:00 -0400
MIME-Version: 1.0
In-Reply-To: <1474472599-11278-1-git-send-email-dsterba@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="FHPm95gkcr8Fn6AxmNr6FPJOqsb6DlRQ0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FHPm95gkcr8Fn6AxmNr6FPJOqsb6DlRQ0
Content-Type: multipart/mixed; boundary="Nkdb3dXmorgTsFQF44baCaw8eGBTN4x6q";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <7a1f023d-d9c4-82ac-88d7-d123118f524a@suse.com>
Subject: Re: [PATCH] btrfs: silence compiler warning when fs_info is not used
References: <1474380303-25995-1-git-send-email-jeffm@suse.com>
 <1474472599-11278-1-git-send-email-dsterba@suse.com>
In-Reply-To: <1474472599-11278-1-git-send-email-dsterba@suse.com>

--Nkdb3dXmorgTsFQF44baCaw8eGBTN4x6q
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/21/16 11:43 AM, David Sterba wrote:
> Some functions introduced a local fs_info pointer for the message
> helpers. If btrfs_debug results to an empty macro, the fs_info pointer
> is reported to be unused. Splitting the variable declaration and settin=
g
> will silence the warning, without any functional change.

I'm investigating fixing this differently.  I'd like the no-call version
to silence the warning and let gcc optimize it out behind the seems if
possible.

-Jeff

> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/extent_io.c |  4 +++-
>  fs/btrfs/send.c      | 33 ++++++++++++++++++++++-----------
>  2 files changed, 25 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index dac448f056ae..e9364f2cff11 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2188,7 +2188,7 @@ void btrfs_free_io_failure_record(struct inode *i=
node, u64 start, u64 end)
>  int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 en=
d,
>  		struct io_failure_record **failrec_ret)
>  {
> -	struct btrfs_fs_info *fs_info =3D btrfs_sb(inode->i_sb);
> +	struct btrfs_fs_info *fs_info;
>  	struct io_failure_record *failrec;
>  	struct extent_map *em;
>  	struct extent_io_tree *failure_tree =3D &BTRFS_I(inode)->io_failure_t=
ree;
> @@ -2197,6 +2197,8 @@ int btrfs_get_io_failure_record(struct inode *ino=
de, u64 start, u64 end,
>  	int ret;
>  	u64 logical;
> =20
> +	fs_info =3D btrfs_sb(inode->i_sb);
> +
>  	ret =3D get_state_failrec(failure_tree, start, &failrec);
>  	if (ret) {
>  		failrec =3D kzalloc(sizeof(*failrec), GFP_NOFS);
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index 978796865bfc..596dbab0618d 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -723,9 +723,10 @@ static int send_cmd(struct send_ctx *sctx)
>  static int send_rename(struct send_ctx *sctx,
>  		     struct fs_path *from, struct fs_path *to)
>  {
> -	struct btrfs_fs_info *fs_info =3D sctx->send_root->fs_info;
> +	struct btrfs_fs_info *fs_info;
>  	int ret;
> =20
> +	fs_info =3D sctx->send_root->fs_info;
>  	btrfs_debug(fs_info, "send_rename %s -> %s", from->start, to->start);=

> =20
>  	ret =3D begin_cmd(sctx, BTRFS_SEND_C_RENAME);
> @@ -748,9 +749,10 @@ static int send_rename(struct send_ctx *sctx,
>  static int send_link(struct send_ctx *sctx,
>  		     struct fs_path *path, struct fs_path *lnk)
>  {
> -	struct btrfs_fs_info *fs_info =3D sctx->send_root->fs_info;
> +	struct btrfs_fs_info *fs_info;
>  	int ret;
> =20
> +	fs_info =3D sctx->send_root->fs_info;
>  	btrfs_debug(fs_info, "send_link %s -> %s", path->start, lnk->start);
> =20
>  	ret =3D begin_cmd(sctx, BTRFS_SEND_C_LINK);
> @@ -772,9 +774,10 @@ static int send_link(struct send_ctx *sctx,
>   */
>  static int send_unlink(struct send_ctx *sctx, struct fs_path *path)
>  {
> -	struct btrfs_fs_info *fs_info =3D sctx->send_root->fs_info;
> +	struct btrfs_fs_info *fs_info;
>  	int ret;
> =20
> +	fs_info =3D sctx->send_root->fs_info;
>  	btrfs_debug(fs_info, "send_unlink %s", path->start);
> =20
>  	ret =3D begin_cmd(sctx, BTRFS_SEND_C_UNLINK);
> @@ -795,9 +798,10 @@ static int send_unlink(struct send_ctx *sctx, stru=
ct fs_path *path)
>   */
>  static int send_rmdir(struct send_ctx *sctx, struct fs_path *path)
>  {
> -	struct btrfs_fs_info *fs_info =3D sctx->send_root->fs_info;
> +	struct btrfs_fs_info *fs_info;
>  	int ret;
> =20
> +	fs_info =3D sctx->send_root->fs_info;
>  	btrfs_debug(fs_info, "send_rmdir %s", path->start);
> =20
>  	ret =3D begin_cmd(sctx, BTRFS_SEND_C_RMDIR);
> @@ -2422,10 +2426,11 @@ static int send_subvol_begin(struct send_ctx *s=
ctx)
> =20
>  static int send_truncate(struct send_ctx *sctx, u64 ino, u64 gen, u64 =
size)
>  {
> -	struct btrfs_fs_info *fs_info =3D sctx->send_root->fs_info;
> +	struct btrfs_fs_info *fs_info;
>  	int ret =3D 0;
>  	struct fs_path *p;
> =20
> +	fs_info =3D sctx->send_root->fs_info;
>  	btrfs_debug(fs_info, "send_truncate %llu size=3D%llu", ino, size);
> =20
>  	p =3D fs_path_alloc();
> @@ -2452,10 +2457,11 @@ static int send_truncate(struct send_ctx *sctx,=
 u64 ino, u64 gen, u64 size)
> =20
>  static int send_chmod(struct send_ctx *sctx, u64 ino, u64 gen, u64 mod=
e)
>  {
> -	struct btrfs_fs_info *fs_info =3D sctx->send_root->fs_info;
> +	struct btrfs_fs_info *fs_info;
>  	int ret =3D 0;
>  	struct fs_path *p;
> =20
> +	fs_info =3D sctx->send_root->fs_info;
>  	btrfs_debug(fs_info, "send_chmod %llu mode=3D%llu", ino, mode);
> =20
>  	p =3D fs_path_alloc();
> @@ -2482,10 +2488,11 @@ static int send_chmod(struct send_ctx *sctx, u6=
4 ino, u64 gen, u64 mode)
> =20
>  static int send_chown(struct send_ctx *sctx, u64 ino, u64 gen, u64 uid=
, u64 gid)
>  {
> -	struct btrfs_fs_info *fs_info =3D sctx->send_root->fs_info;
> +	struct btrfs_fs_info *fs_info;
>  	int ret =3D 0;
>  	struct fs_path *p;
> =20
> +	fs_info =3D sctx->send_root->fs_info;
>  	btrfs_debug(fs_info, "send_chown %llu uid=3D%llu, gid=3D%llu",
>  		    ino, uid, gid);
> =20
> @@ -2514,7 +2521,7 @@ static int send_chown(struct send_ctx *sctx, u64 =
ino, u64 gen, u64 uid, u64 gid)
> =20
>  static int send_utimes(struct send_ctx *sctx, u64 ino, u64 gen)
>  {
> -	struct btrfs_fs_info *fs_info =3D sctx->send_root->fs_info;
> +	struct btrfs_fs_info *fs_info;
>  	int ret =3D 0;
>  	struct fs_path *p =3D NULL;
>  	struct btrfs_inode_item *ii;
> @@ -2523,6 +2530,7 @@ static int send_utimes(struct send_ctx *sctx, u64=
 ino, u64 gen)
>  	struct btrfs_key key;
>  	int slot;
> =20
> +	fs_info =3D sctx->send_root->fs_info;
>  	btrfs_debug(fs_info, "send_utimes %llu", ino);
> =20
>  	p =3D fs_path_alloc();
> @@ -2577,7 +2585,7 @@ static int send_utimes(struct send_ctx *sctx, u64=
 ino, u64 gen)
>   */
>  static int send_create_inode(struct send_ctx *sctx, u64 ino)
>  {
> -	struct btrfs_fs_info *fs_info =3D sctx->send_root->fs_info;
> +	struct btrfs_fs_info *fs_info;
>  	int ret =3D 0;
>  	struct fs_path *p;
>  	int cmd;
> @@ -2585,6 +2593,7 @@ static int send_create_inode(struct send_ctx *sct=
x, u64 ino)
>  	u64 mode;
>  	u64 rdev;
> =20
> +	fs_info =3D sctx->send_root->fs_info;
>  	btrfs_debug(fs_info, "send_create_inode %llu", ino);
> =20
>  	p =3D fs_path_alloc();
> @@ -3643,7 +3652,7 @@ static int wait_for_parent_move(struct send_ctx *=
sctx,
>   */
>  static int process_recorded_refs(struct send_ctx *sctx, int *pending_m=
ove)
>  {
> -	struct btrfs_fs_info *fs_info =3D sctx->send_root->fs_info;
> +	struct btrfs_fs_info *fs_info;
>  	int ret =3D 0;
>  	struct recorded_ref *cur;
>  	struct recorded_ref *cur2;
> @@ -3656,6 +3665,7 @@ static int process_recorded_refs(struct send_ctx =
*sctx, int *pending_move)
>  	u64 last_dir_ino_rm =3D 0;
>  	bool can_rename =3D true;
> =20
> +	fs_info =3D sctx->send_root->fs_info;
>  	btrfs_debug(fs_info, "process_recorded_refs %llu", sctx->cur_ino);
> =20
>  	/*
> @@ -4666,7 +4676,7 @@ static ssize_t fill_read_buf(struct send_ctx *sct=
x, u64 offset, u32 len)
>   */
>  static int send_write(struct send_ctx *sctx, u64 offset, u32 len)
>  {
> -	struct btrfs_fs_info *fs_info =3D sctx->send_root->fs_info;
> +	struct btrfs_fs_info *fs_info;
>  	int ret =3D 0;
>  	struct fs_path *p;
>  	ssize_t num_read =3D 0;
> @@ -4675,6 +4685,7 @@ static int send_write(struct send_ctx *sctx, u64 =
offset, u32 len)
>  	if (!p)
>  		return -ENOMEM;
> =20
> +	fs_info =3D sctx->send_root->fs_info;
>  	btrfs_debug(fs_info, "send_write offset=3D%llu, len=3D%d", offset, le=
n);
> =20
>  	num_read =3D fill_read_buf(sctx, offset, len);
>=20


--=20
Jeff Mahoney
SUSE Labs


--Nkdb3dXmorgTsFQF44baCaw8eGBTN4x6q--

--FHPm95gkcr8Fn6AxmNr6FPJOqsb6DlRQ0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJX4qt0AAoJEB57S2MheeWyR5IQAJygwgrGp3NYnX+yrFm+e8bV
MXtxOYI7qMc8tEL53v/l58kwNi7W9dy3j8RAG0stgeWueig5R1gbgXKEo/AsmeBo
QDTj0ytrq1LkZkQyoFCmQykVq7TwUmbJcJgilPF69BdnDl+w+opayYIWl3B4mUz+
GUcD7dZY4sV0RaFKnmi3P170g0yv472qCAyrIqp/XVPYbndW5v2UsyNmV8XVu2lD
Eij7TzmKUygffuoagy9BPdRu6MuqEyaLtV01CyXtx+26DjtnmbBi7TOoH9Ew6Pj5
Qvzt9yyFI+FJfojcijPOg7z4iw1n2aVPR4UpAjgyu7IBZbHF/i2MUGx1GnqNclcC
mDR3IzhZbDS0FmmhCcmCBFCLrW+NX+G+3qsmJa3nJx4ZR2A0wz4WXp5u2wyHCOAX
qMNq+akLmPkny/QdCKAjzwZ2eqnpTwjFUVGpsD+jiAVCyab54s92uZ+QaWC9GN98
P+aRXjdIH6LR30jA/M6Z3XCI30GszOi693iHvioeM99Pl9F4It6SkgB0OVsXvOlO
LN591f2PHG2/0Cmbr6DF8+EmeOjuoZLkUfeelkyA+5EBaSLpWn06lwM8RwAqBoFL
6nq8dHQWZLVIsJ9F9i+qW+dkIGLactJ/tyOT7gaClAnM33ScqPkCoUYWINu5WTyP
UgNCQ0vaaI9BLyWB3y6k
=D+jI
-----END PGP SIGNATURE-----

--FHPm95gkcr8Fn6AxmNr6FPJOqsb6DlRQ0--
