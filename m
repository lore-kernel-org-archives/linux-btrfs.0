Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:52763 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752491AbeAQOYE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 09:24:04 -0500
Subject: Re: [PATCH 2/3] btrfs-progs: dir-item: Allow dir item and dir index
 lookup to ignore found problem
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20180117051710.16853-1-wqu@suse.com>
 <20180117051710.16853-3-wqu@suse.com>
 <091f7f35-5ac1-810d-46f0-b375ce96203a@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <156ff191-29a7-271a-11be-e611557edb79@gmx.com>
Date: Wed, 17 Jan 2018 22:23:17 +0800
MIME-Version: 1.0
In-Reply-To: <091f7f35-5ac1-810d-46f0-b375ce96203a@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="xgSeuDUUVSthYEkeoNR732RZtuKUcz6gQ"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--xgSeuDUUVSthYEkeoNR732RZtuKUcz6gQ
Content-Type: multipart/mixed; boundary="v9xsxd5FnrNefhgpmar6KI5SGtH22Ycm3";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
 linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <156ff191-29a7-271a-11be-e611557edb79@gmx.com>
Subject: Re: [PATCH 2/3] btrfs-progs: dir-item: Allow dir item and dir index
 lookup to ignore found problem
References: <20180117051710.16853-1-wqu@suse.com>
 <20180117051710.16853-3-wqu@suse.com>
 <091f7f35-5ac1-810d-46f0-b375ce96203a@suse.com>
In-Reply-To: <091f7f35-5ac1-810d-46f0-b375ce96203a@suse.com>

--v9xsxd5FnrNefhgpmar6KI5SGtH22Ycm3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8817=E6=97=A5 21:13, Nikolay Borisov wrote:
>=20
>=20
> On 17.01.2018 07:17, Qu Wenruo wrote:
>> For functions btrfs_lookup_dir_index() and btrfs_lookup_dir_item(), th=
ey
>> will check if the dir item/index is valid before doing further check.
>>
>> The behavior is pretty good for healthy fs, but calling them on
>> corrupted fs with incorrect dir item/index will also return NULL, maki=
ng
>> repair code unable to reuse them.
>>
>> This patch add a new parameter @verify to address the problem.
>> For normal operation, @verify should be set to true to keep the old
>> behavior.
>>
>> While for some functions used in repair, like btrfs_unlink(), they can=

>> set @verify to false, so repair code can locate corrupted dir index/it=
em
>> and do what they should do (either repair or just delete).
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> I'm not satisfied with the approach taken. A boolean parameter is
> sprinkled around the code just so that we decide whether we invoke
> verify_dir_item or not. My idea (which dunno how sensible it is for thi=
s
> patch series) is to have 2 sets of public API functions:
>=20
> 1. Augmented checking ones (equivalent to the boolean parameter set to
> true i.e. btrfs_lookup_dir_index_verify or somesuch). The idea is they
> should be used in contexts where we want extended validation and it
> should be explicit we require this. Likely we'd use them during the
> check phase
>=20
> 2. Same api but without the _verify (or whatever suffix, I don't mind)
>=20
> The two sets of apis should be really slim and implemented from
> composable low-level/private functions. To put things concretely I
> believe btrfs_match_dir_item_name in this case to be the
> "low-level/private" function and the above 2 version to consist of the
> private version + additional code necessary to satisfy their interfaces=
=2E
>=20
> This comment should really be considered in the broader context of your=

> lowmem/original mode refactoring work, not necessarily for this patch
> set. But in the long term we should really strive to avoid horrendous
> function interface where we add a parameter for tweaking every little
> bit of behavior.

Yes, when writing the patch I'm also not satisfied with the bool
parameter, but had no better solution.

(My alternative was change bool to something like #define VERIFY 1, but
that's either satisfying)

Your idea is much better than any of my alternatives, but I'm not really
sure if this is expendable enough.

One of the biggest challenge here is, if later we need another parameter
to, for example skip another check, we need 4 definitions, and 8 for
another.

I'm OK with current _verify suffix, but I'm really not sure what the
situation will be in the future.

Thanks,
Qu


>=20
>> ---
>>  cmds-check.c   |  2 +-
>>  convert/main.c |  2 +-
>>  ctree.h        |  4 ++--
>>  dir-item.c     | 34 ++++++++++++++++++++++++++--------
>>  inode.c        | 14 +++++++-------
>>  5 files changed, 37 insertions(+), 19 deletions(-)
>>
>> diff --git a/cmds-check.c b/cmds-check.c
>> index f302724dd840..59575506c83e 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -3074,7 +3074,7 @@ static int delete_dir_index(struct btrfs_root *r=
oot,
>>  	btrfs_init_path(&path);
>>  	di =3D btrfs_lookup_dir_index(trans, root, &path, backref->dir,
>>  				    backref->name, backref->namelen,
>> -				    backref->index, -1);
>> +				    backref->index, -1, false);
>>  	if (IS_ERR(di)) {
>>  		ret =3D PTR_ERR(di);
>>  		btrfs_release_path(&path);
>> diff --git a/convert/main.c b/convert/main.c
>> index 89f9261172ca..102ba4fc5ae2 100644
>> --- a/convert/main.c
>> +++ b/convert/main.c
>> @@ -1580,7 +1580,7 @@ static int do_rollback(const char *devname)
>>  	/* Search the image file */
>>  	root_dir =3D btrfs_root_dirid(&image_root->root_item);
>>  	dir =3D btrfs_lookup_dir_item(NULL, image_root, &path, root_dir,
>> -			image_name, strlen(image_name), 0);
>> +			image_name, strlen(image_name), 0, true);
>> =20
>>  	if (!dir || IS_ERR(dir)) {
>>  		btrfs_release_path(&path);
>> diff --git a/ctree.h b/ctree.h
>> index ef422ea60031..02529f4cb021 100644
>> --- a/ctree.h
>> +++ b/ctree.h
>> @@ -2679,12 +2679,12 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(s=
truct btrfs_trans_handle *trans,
>>  					     struct btrfs_root *root,
>>  					     struct btrfs_path *path, u64 dir,
>>  					     const char *name, int name_len,
>> -					     int mod);
>> +					     int mod, bool verify);
>>  struct btrfs_dir_item *btrfs_lookup_dir_index(struct btrfs_trans_hand=
le *trans,
>>  					      struct btrfs_root *root,
>>  					      struct btrfs_path *path, u64 dir,
>>  					      const char *name, int name_len,
>> -					      u64 index, int mod);
>> +					      u64 index, int mod, bool verify);
>>  int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
>>  			      struct btrfs_root *root,
>>  			      struct btrfs_path *path,
>> diff --git a/dir-item.c b/dir-item.c
>> index 462546c0eaf4..31ad1eca29d5 100644
>> --- a/dir-item.c
>> +++ b/dir-item.c
>> @@ -24,7 +24,7 @@
>> =20
>>  static struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_=
root *root,
>>  			      struct btrfs_path *path,
>> -			      const char *name, int name_len);
>> +			      const char *name, int name_len, bool verify);
>> =20
>>  static struct btrfs_dir_item *insert_with_overflow(struct btrfs_trans=
_handle
>>  						   *trans,
>> @@ -43,7 +43,8 @@ static struct btrfs_dir_item *insert_with_overflow(s=
truct btrfs_trans_handle
>>  	ret =3D btrfs_insert_empty_item(trans, root, path, cpu_key, data_siz=
e);
>>  	if (ret =3D=3D -EEXIST) {
>>  		struct btrfs_dir_item *di;
>> -		di =3D btrfs_match_dir_item_name(root, path, name, name_len);
>> +		di =3D btrfs_match_dir_item_name(root, path, name, name_len,
>> +					       true);
>>  		if (di)
>>  			return ERR_PTR(-EEXIST);
>>  		ret =3D btrfs_extend_item(root, path, data_size);
>> @@ -196,7 +197,7 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struc=
t btrfs_trans_handle *trans,
>>  					     struct btrfs_root *root,
>>  					     struct btrfs_path *path, u64 dir,
>>  					     const char *name, int name_len,
>> -					     int mod)
>> +					     int mod, bool verify)
>>  {
>>  	int ret;
>>  	struct btrfs_key key;
>> @@ -227,14 +228,31 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(str=
uct btrfs_trans_handle *trans,
>>  	    found_key.offset !=3D key.offset)
>>  		return NULL;
>> =20
>> -	return btrfs_match_dir_item_name(root, path, name, name_len);
>> +	return btrfs_match_dir_item_name(root, path, name, name_len, verify)=
;
>>  }
>> =20
>> +/*
>> + * Lookup dir index
>> + *=20
>> + * @dir:	dir inode number
>> + * @name:	the filename we're looking for
>> + * @name_len:	name length
>> + * @index:	dir index
>> + *
>> + * Normally (@root, @dir, @index) should be enough to locate a dir in=
dex in a
>> + * *healthy* fs.
>> + * But with @name and @name_len, we can even handle corrupted fs with=

>> + * duplicated DIR_INDEX.
>=20
> Put this description text after you documented the members.
>=20
>> + *
>> + * @mod:	if we're going to modify the dir_index, needs @trans
>> + * @verify:	if we need to verify the dir_item before search
>> + * 		useful for check to delet corrupted dir index.
>> + */
>>  struct btrfs_dir_item *btrfs_lookup_dir_index(struct btrfs_trans_hand=
le *trans,
>>  					      struct btrfs_root *root,
>>  					      struct btrfs_path *path, u64 dir,
>>  					      const char *name, int name_len,
>> -					      u64 index, int mod)
>> +					      u64 index, int mod, bool verify)
>>  {
>>  	int ret;
>>  	struct btrfs_key key;
>> @@ -251,7 +269,7 @@ struct btrfs_dir_item *btrfs_lookup_dir_index(stru=
ct btrfs_trans_handle *trans,
>>  	if (ret > 0)
>>  		return ERR_PTR(-ENOENT);
>> =20
>> -	return btrfs_match_dir_item_name(root, path, name, name_len);
>> +	return btrfs_match_dir_item_name(root, path, name, name_len, verify)=
;
>>  }
>> =20
>>  /*
>> @@ -323,7 +341,7 @@ static int verify_dir_item(struct btrfs_root *root=
,
>> =20
>>  static struct btrfs_dir_item *btrfs_match_dir_item_name(struct btrfs_=
root *root,
>>  			      struct btrfs_path *path,
>> -			      const char *name, int name_len)
>> +			      const char *name, int name_len, bool verify)
>>  {
>>  	struct btrfs_dir_item *dir_item;
>>  	unsigned long name_ptr;
>> @@ -335,7 +353,7 @@ static struct btrfs_dir_item *btrfs_match_dir_item=
_name(struct btrfs_root *root,
>>  	leaf =3D path->nodes[0];
>>  	dir_item =3D btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_i=
tem);
>>  	total_len =3D btrfs_item_size_nr(leaf, path->slots[0]);
>> -	if (verify_dir_item(root, leaf, dir_item))
>> +	if (verify && verify_dir_item(root, leaf, dir_item))
>>  		return NULL;
>> =20
>>  	while(cur < total_len) {
>> diff --git a/inode.c b/inode.c
>> index 2398bca4a109..7b9a40062bb3 100644
>> --- a/inode.c
>> +++ b/inode.c
>> @@ -123,7 +123,7 @@ int check_dir_conflict(struct btrfs_root *root, ch=
ar *name, int namelen,
>> =20
>>  	/* Name conflicting? */
>>  	dir_item =3D btrfs_lookup_dir_item(NULL, root, path, dir, name,
>> -					 namelen, 0);
>> +					 namelen, 0, true);
>>  	if (IS_ERR(dir_item)) {
>>  		ret =3D PTR_ERR(dir_item);
>>  		goto out;
>> @@ -136,7 +136,7 @@ int check_dir_conflict(struct btrfs_root *root, ch=
ar *name, int namelen,
>> =20
>>  	/* Index conflicting? */
>>  	dir_item =3D btrfs_lookup_dir_index(NULL, root, path, dir, name,
>> -					  namelen, index, 0);
>> +					  namelen, index, 0, true);
>>  	if (IS_ERR(dir_item) && PTR_ERR(dir_item) =3D=3D -ENOENT)
>>  		dir_item =3D NULL;
>>  	if (IS_ERR(dir_item)) {
>> @@ -301,7 +301,7 @@ int btrfs_unlink(struct btrfs_trans_handle *trans,=
 struct btrfs_root *root,
>>  	btrfs_release_path(path);
>> =20
>>  	dir_item =3D btrfs_lookup_dir_item(NULL, root, path, parent_ino,
>> -					 name, namelen, 0);
>> +					 name, namelen, 0, false);
>>  	if (IS_ERR(dir_item)) {
>>  		ret =3D PTR_ERR(dir_item);
>>  		goto out;
>> @@ -311,7 +311,7 @@ int btrfs_unlink(struct btrfs_trans_handle *trans,=
 struct btrfs_root *root,
>>  	btrfs_release_path(path);
>> =20
>>  	dir_item =3D btrfs_lookup_dir_index(NULL, root, path, parent_ino,
>> -					  name, namelen, index, 0);
>> +					  name, namelen, index, 0, false);
>>  	/*
>>  	 * Since lookup_dir_index() will return -ENOENT when not found,
>>  	 * we need to do extra check.
>> @@ -370,7 +370,7 @@ int btrfs_unlink(struct btrfs_trans_handle *trans,=
 struct btrfs_root *root,
>>  	if (del_dir_index) {
>>  		dir_item =3D btrfs_lookup_dir_index(trans, root, path,
>>  						  parent_ino, name, namelen,
>> -						  index, -1);
>> +						  index, -1, false);
>>  		if (IS_ERR(dir_item)) {
>>  			ret =3D PTR_ERR(dir_item);
>>  			goto out;
>> @@ -403,7 +403,7 @@ int btrfs_unlink(struct btrfs_trans_handle *trans,=
 struct btrfs_root *root,
>> =20
>>  	if (del_dir_item) {
>>  		dir_item =3D btrfs_lookup_dir_item(trans, root, path, parent_ino,
>> -						 name, namelen, -1);
>> +						 name, namelen, -1, false);
>>  		if (IS_ERR(dir_item)) {
>>  			ret =3D PTR_ERR(dir_item);
>>  			goto out;
>> @@ -532,7 +532,7 @@ int btrfs_mkdir(struct btrfs_trans_handle *trans, =
struct btrfs_root *root,
>>  		ret_ino =3D *ino;
>> =20
>>  	dir_item =3D btrfs_lookup_dir_item(NULL, root, path, parent_ino,
>> -					 name, namelen, 0);
>> +					 name, namelen, 0, true);
>>  	if (IS_ERR(dir_item)) {
>>  		ret =3D PTR_ERR(dir_item);
>>  		goto out;
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--v9xsxd5FnrNefhgpmar6KI5SGtH22Ycm3--

--xgSeuDUUVSthYEkeoNR732RZtuKUcz6gQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlpfXFUXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgAZgf/U43vE7s9biJMnMwcbTZXBlhW
lPAOO4CItlQbDvRMvuUN0ZTzw7CxCOIm5nWy95SpQgI7LLflEtNZNOX+oq2bMuh0
nZ7FLd6C2e4yXVkNfTeZbYdKHzDTdCHdK/jtSkrDC0q+KQsmgSaQenXHHqZVFay4
BhGhqH+cEf03jIjcA2urKhqj5PVxSQORb9ZG3OFp1fM2fDKrWIiyl2XaKgvypMrN
NmWvgcQfI0e5cvMPw3lnvKeDTjg5PcWaPrtSYfTWatCyDhtVeGyYeajZTdIOwlc1
XSmHjPAnRkNtGad/StEz3d4k6BFkVIFR5yf8ucwyIH2XXLvoUkVy8PBpvNgD6g==
=c6bp
-----END PGP SIGNATURE-----

--xgSeuDUUVSthYEkeoNR732RZtuKUcz6gQ--
