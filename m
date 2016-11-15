Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54722 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965661AbcKOCIT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 21:08:19 -0500
Subject: Re: [PATCH 1/2] btrfs: remove old tree_root dirent processing in
 btrfs_real_readdir()
To: Omar Sandoval <osandov@osandov.com>
References: <1478366795-27009-1-git-send-email-jeffm@suse.com>
 <20161111160545.GA17158@vader>
Cc: linux-btrfs@vger.kernel.org
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <5953d956-1ff1-6635-f593-12da1c31b36e@suse.com>
Date: Mon, 14 Nov 2016 21:08:14 -0500
MIME-Version: 1.0
In-Reply-To: <20161111160545.GA17158@vader>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QL27TSN9smTPin6pT4HTwX2g4AEuIene9"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QL27TSN9smTPin6pT4HTwX2g4AEuIene9
Content-Type: multipart/mixed; boundary="5tWWEV4LXaFnkOpmV28sOtn0E6wLu915o";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <5953d956-1ff1-6635-f593-12da1c31b36e@suse.com>
Subject: Re: [PATCH 1/2] btrfs: remove old tree_root dirent processing in
 btrfs_real_readdir()
References: <1478366795-27009-1-git-send-email-jeffm@suse.com>
 <20161111160545.GA17158@vader>
In-Reply-To: <20161111160545.GA17158@vader>

--5tWWEV4LXaFnkOpmV28sOtn0E6wLu915o
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/11/16 11:05 AM, Omar Sandoval wrote:
> On Sat, Nov 05, 2016 at 01:26:34PM -0400, jeffm@suse.com wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> Commit 3de4586c527 (Btrfs: Allow subvolumes and snapshots anywhere
>> in the directory tree) introduced the current system of placing
>> snapshots in the directory tree.  It also introduced the behavior of
>> creating the snapshot and then creating the directory entries for it.
>>
>> We've kept this code around for compatibility reasons, but it turns
>> out that no file systems with the old tree_root based snapshots can
>> be mounted on newer (>=3D 2009) kernels anyway.  About a month after t=
he
>> above commit, commit 2a7108ad89e (Btrfs: rev the disk format for the
>> inode compat and csum selection changes) landed, changing the superblo=
ck
>> magic number.
>>
>> As a result, we know that we'll never encounter tree_root-based dirent=
s
>> or have to deal with skipping our own snapshot dirents.  Since that
>> also means that we're now only iterating over DIR_INDEX items, which o=
nly
>> contain one directory entry per leaf item, we don't need to loop over
>> the leaf item contents anymore either.
>>
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>=20
> Hi, Jeff,

Hi Omar -

> One comment below.
>=20
>> ---
>>  fs/btrfs/inode.c | 118 +++++++++++++++++-----------------------------=
---------
>>  1 file changed, 37 insertions(+), 81 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 2b790bd..c52239d 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -5805,20 +5805,13 @@ static int btrfs_real_readdir(struct file *fil=
e, struct dir_context *ctx)
>>  	int slot;
>>  	unsigned char d_type;
>>  	int over =3D 0;
>> -	u32 di_cur;
>> -	u32 di_total;
>> -	u32 di_len;
>> -	int key_type =3D BTRFS_DIR_INDEX_KEY;
>>  	char tmp_name[32];
>>  	char *name_ptr;
>>  	int name_len;
>>  	int is_curr =3D 0;	/* ctx->pos points to the current index? */
>>  	bool emitted;
>>  	bool put =3D false;
>> -
>> -	/* FIXME, use a real flag for deciding about the key type */
>> -	if (root->fs_info->tree_root =3D=3D root)
>> -		key_type =3D BTRFS_DIR_ITEM_KEY;
>> +	struct btrfs_key location;
>> =20
>>  	if (!dir_emit_dots(file, ctx))
>>  		return 0;
>> @@ -5829,14 +5822,11 @@ static int btrfs_real_readdir(struct file *fil=
e, struct dir_context *ctx)
>> =20
>>  	path->reada =3D READA_FORWARD;
>> =20
>> -	if (key_type =3D=3D BTRFS_DIR_INDEX_KEY) {
>> -		INIT_LIST_HEAD(&ins_list);
>> -		INIT_LIST_HEAD(&del_list);
>> -		put =3D btrfs_readdir_get_delayed_items(inode, &ins_list,
>> -						      &del_list);
>> -	}
>> +	INIT_LIST_HEAD(&ins_list);
>> +	INIT_LIST_HEAD(&del_list);
>> +	put =3D btrfs_readdir_get_delayed_items(inode, &ins_list, &del_list)=
;
>> =20
>> -	key.type =3D key_type;
>> +	key.type =3D BTRFS_DIR_INDEX_KEY;
>>  	key.offset =3D ctx->pos;
>>  	key.objectid =3D btrfs_ino(inode);
>> =20
>> @@ -5862,85 +5852,53 @@ static int btrfs_real_readdir(struct file *fil=
e, struct dir_context *ctx)
>> =20
>>  		if (found_key.objectid !=3D key.objectid)
>>  			break;
>> -		if (found_key.type !=3D key_type)
>> +		if (found_key.type !=3D BTRFS_DIR_INDEX_KEY)
>>  			break;
>>  		if (found_key.offset < ctx->pos)
>>  			goto next;
>> -		if (key_type =3D=3D BTRFS_DIR_INDEX_KEY &&
>> -		    btrfs_should_delete_dir_index(&del_list,
>> -						  found_key.offset))
>> +		if (btrfs_should_delete_dir_index(&del_list, found_key.offset))
>>  			goto next;
>> =20
>>  		ctx->pos =3D found_key.offset;
>>  		is_curr =3D 1;
>> =20
>>  		di =3D btrfs_item_ptr(leaf, slot, struct btrfs_dir_item);
>> -		di_cur =3D 0;
>> -		di_total =3D btrfs_item_size(leaf, item);
>> -
>> -		while (di_cur < di_total) {
>> -			struct btrfs_key location;
>> -
>> -			if (verify_dir_item(root, leaf, di))
>> -				break;
>> +		if (verify_dir_item(root, leaf, di))
>> +			goto next;
>> =20
>> -			name_len =3D btrfs_dir_name_len(leaf, di);
>> -			if (name_len <=3D sizeof(tmp_name)) {
>> -				name_ptr =3D tmp_name;
>> -			} else {
>> -				name_ptr =3D kmalloc(name_len, GFP_KERNEL);
>> -				if (!name_ptr) {
>> -					ret =3D -ENOMEM;
>> -					goto err;
>> -				}
>> +		name_len =3D btrfs_dir_name_len(leaf, di);
>> +		if (name_len <=3D sizeof(tmp_name)) {
>> +			name_ptr =3D tmp_name;
>> +		} else {
>> +			name_ptr =3D kmalloc(name_len, GFP_KERNEL);
>> +			if (!name_ptr) {
>> +				ret =3D -ENOMEM;
>> +				goto err;
>>  			}
>> -			read_extent_buffer(leaf, name_ptr,
>> -					   (unsigned long)(di + 1), name_len);
>> -
>> -			d_type =3D btrfs_filetype_table[btrfs_dir_type(leaf, di)];
>> -			btrfs_dir_item_key_to_cpu(leaf, di, &location);
>> +		}
>> +		read_extent_buffer(leaf, name_ptr, (unsigned long)(di + 1),
>> +				   name_len);
>> =20
>> +		d_type =3D btrfs_filetype_table[btrfs_dir_type(leaf, di)];
>> +		btrfs_dir_item_key_to_cpu(leaf, di, &location);
>> =20
>> -			/* is this a reference to our own snapshot? If so
>> -			 * skip it.
>> -			 *
>> -			 * In contrast to old kernels, we insert the snapshot's
>> -			 * dir item and dir index after it has been created, so
>> -			 * we won't find a reference to our own snapshot. We
>> -			 * still keep the following code for backward
>> -			 * compatibility.
>> -			 */
>> -			if (location.type =3D=3D BTRFS_ROOT_ITEM_KEY &&
>> -			    location.objectid =3D=3D root->root_key.objectid) {
>> -				over =3D 0;
>> -				goto skip;
>> -			}
>> -			over =3D !dir_emit(ctx, name_ptr, name_len,
>> -				       location.objectid, d_type);
>> +		over =3D !dir_emit(ctx, name_ptr, name_len, location.objectid,
>> +				 d_type);
>> =20
>> -skip:
>> -			if (name_ptr !=3D tmp_name)
>> -				kfree(name_ptr);
>> +		if (name_ptr !=3D tmp_name)
>> +			kfree(name_ptr);
>> =20
>> -			if (over)
>> -				goto nopos;
>> -			emitted =3D true;
>=20
> Shouldn't this line (getting rid of emitted) be in the next patch?

Yep.  Good catch.

Thanks,

-Jeff


>> -			di_len =3D btrfs_dir_name_len(leaf, di) +
>> -				 btrfs_dir_data_len(leaf, di) + sizeof(*di);
>> -			di_cur +=3D di_len;
>> -			di =3D (struct btrfs_dir_item *)((char *)di + di_len);
>> -		}
>> +		if (over)
>> +			goto nopos;
>>  next:
>>  		path->slots[0]++;
>>  	}
>> =20
>> -	if (key_type =3D=3D BTRFS_DIR_INDEX_KEY) {
>> -		if (is_curr)
>> -			ctx->pos++;
>> -		ret =3D btrfs_readdir_delayed_dir_index(ctx, &ins_list, &emitted);
>> -		if (ret)
>> -			goto nopos;
>> -	}
>> +	if (is_curr)
>> +		ctx->pos++;
>> +	ret =3D btrfs_readdir_delayed_dir_index(ctx, &ins_list, &emitted);
>> +	if (ret)
>> +		goto nopos;
>> =20
>>  	/*
>>  	 * If we haven't emitted any dir entry, we must not touch ctx->pos a=
s
>> @@ -5971,12 +5929,10 @@ static int btrfs_real_readdir(struct file *fil=
e, struct dir_context *ctx)
>>  	 * last entry requires it because doing so has broken 32bit apps
>>  	 * in the past.
>>  	 */
>> -	if (key_type =3D=3D BTRFS_DIR_INDEX_KEY) {
>> -		if (ctx->pos >=3D INT_MAX)
>> -			ctx->pos =3D LLONG_MAX;
>> -		else
>> -			ctx->pos =3D INT_MAX;
>> -	}
>> +	if (ctx->pos >=3D INT_MAX)
>> +		ctx->pos =3D LLONG_MAX;
>> +	else
>> +		ctx->pos =3D INT_MAX;
>>  nopos:
>>  	ret =3D 0;
>>  err:
>> --=20
>> 2.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Jeff Mahoney
SUSE Labs


--5tWWEV4LXaFnkOpmV28sOtn0E6wLu915o--

--QL27TSN9smTPin6pT4HTwX2g4AEuIene9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJYKm4PAAoJEB57S2MheeWys1YP/R29AgpI4pnlFToWQSHFwyZF
v0uVOtNBEuun1TT8yjaZVA4x1BPvw7VZ//3JJVqGHoYTU7D+IyAJRc8+04VJK14b
eHy+JBHn/FqxSGfZ1F1rcwQuohaOEtlmOwHuWZTC+1kjnARn/RLyX9dt8FkmimY0
qoBEuYFIsmznG6Mqb9eeKGidjg47TbzaWBHqCVfGV888V+W5I3g6Sm2RUmEEVtSJ
dsx1VxoEO8FHLCLfopk6nGiJL9Eki0X54TMQNh7VaK6hAprnp+I53SU8QBmAvJpl
4vxnMRnNkKWslFULooaKzm1WgOVILDWBvKm2e0WX4c1VAXpmGZyBaobrJcwZTcFc
/x627V+TxrDJlyL5YSqrWqds0EnXTjTjiz2TbvPdLqyBmsaiAmBTws3tIiP0XuAa
k2HAUlgCKREqxS+ELlWJUQ7F84XhA1eIJCJk7pOZbqPslplFGbcdjBpA/Jwz4zAi
A9cSl1b9UkUfL45qiW5FW0LnubGMIhpcvxSx3FysUNtI9wHHSyba8nWDHuN+f1ak
Vbjp45l661y3AHzPd/UJDCQ/i7Doun5Mk75zztEBfA3km1ndMfutLzRvY7cN2dyt
iIuwh0yZ7C3cCCxZvhTE4r/vVOaqrxbiCVQH78nTPgx1QnbLiRFJGnLS1H+Om1fe
snt+PrYXX/zRH6TnrRrV
=r8dy
-----END PGP SIGNATURE-----

--QL27TSN9smTPin6pT4HTwX2g4AEuIene9--
