Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51477 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab3IPSNS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 14:13:18 -0400
Message-ID: <52374A37.60402@suse.com>
Date: Mon, 16 Sep 2013 14:13:11 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clmason@fusionio.com
Subject: Re: [patch 1/7] [PATCH] btrfs: add ability to query/change feature
 bits online
References: <20130910042408.335071038@suse.com> <20130910043007.438505775@suse.com> <20130916172651.GV6810@twin.jikos.cz>
In-Reply-To: <20130916172651.GV6810@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="83t0F9Q3MPIgkWFa4OOg8SQhMCEx1Ndxf"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--83t0F9Q3MPIgkWFa4OOg8SQhMCEx1Ndxf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 9/16/13 1:26 PM, David Sterba wrote:
> On Tue, Sep 10, 2013 at 12:24:09AM -0400, Jeff Mahoney wrote:
>> +static int btrfs_ioctl_set_features(struct file *file, void __user *a=
rg)
>> +{
>> +	struct btrfs_root *root =3D BTRFS_I(file_inode(file))->root;
>> +	struct btrfs_super_block *super_block =3D root->fs_info->super_copy;=

>> +	struct btrfs_ioctl_feature_flags flags[2];
>> +	struct btrfs_trans_handle *trans;
>> +	u64 newflags;
>> +	int ret;
>> +
>> +	if (!capable(CAP_SYS_ADMIN))
>> +		return -EPERM;
>> +
>> +	if (copy_from_user(flags, arg, sizeof(flags)))
>> +		return -EFAULT;
>> +
>> +	/* Nothing to do */
>> +	if (!flags[0].compat_flags && !flags[0].compat_ro_flags &&
>> +	    !flags[0].incompat_flags)
>> +		return 0;
>> +
>> +	ret =3D check_feature(root, flags[0].compat_flags,
>> +			    flags[1].compat_flags, COMPAT);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret =3D check_feature(root, flags[0].compat_ro_flags,
>> +			    flags[1].compat_ro_flags, COMPAT_RO);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret =3D check_feature(root, flags[0].incompat_flags,
>> +			    flags[1].incompat_flags, INCOMPAT);
>> +	if (ret)
>> +		return ret;
>> +
>> +	trans =3D btrfs_start_transaction(root, 1);
>=20
> It's ok to use 0 here, it's a superblock change and not related the the=

> metadata (similar to changing the label).
>=20
>> +	if (IS_ERR(trans))
>> +		return PTR_ERR(trans);
>> +
>> +	spin_lock(&root->fs_info->super_lock);
>> +	newflags =3D btrfs_super_compat_flags(super_block);
>> +	newflags |=3D flags[0].compat_flags & flags[1].compat_flags;
>> +	newflags &=3D ~(flags[0].compat_flags & ~flags[1].compat_flags);
>> +	btrfs_set_super_compat_flags(super_block, newflags);
>> +
>> +	newflags =3D btrfs_super_compat_ro_flags(super_block);
>> +	newflags |=3D flags[0].compat_ro_flags & flags[1].compat_ro_flags;
>> +	newflags &=3D ~(flags[0].compat_ro_flags & ~flags[1].compat_ro_flags=
);
>> +	btrfs_set_super_compat_ro_flags(super_block, newflags);
>> +
>> +	newflags =3D btrfs_super_incompat_flags(super_block);
>> +	newflags |=3D flags[0].incompat_flags & flags[1].incompat_flags;
>> +	newflags &=3D ~(flags[0].incompat_flags & ~flags[1].incompat_flags);=

>> +	btrfs_set_super_incompat_flags(super_block, newflags);
>> +	spin_unlock(&root->fs_info->super_lock);
>> +
>> +	return btrfs_end_transaction(trans, root);
>=20
> I think it's better to use btrfs_commit_transaction. The ioctl is about=

> to do a permanent change, any crash between ioctl and full commit will
> revert to previous state of the features. This is not IMO desirable fro=
m
> administrators POV.
>=20
> (Sidenote, IOC_SET_FSLABEL needs the same update.)

Done, and I have a patch to fix the setlabel case as well.

>> +}
>> +
>> --- a/include/uapi/linux/btrfs.h	2013-09-09 17:49:10.808003254 -0400
>> +++ b/include/uapi/linux/btrfs.h	2013-09-09 17:49:12.483979430 -0400
>> @@ -184,6 +184,12 @@ struct btrfs_ioctl_fs_info_args {
>>  	__u64 reserved[124];			/* pad to 1k */
>>  };
>> =20
>> +struct btrfs_ioctl_feature_flags {
>> +	__u64 compat_flags;
>> +	__u64 compat_ro_flags;
>> +	__u64 incompat_flags;
>=20
> I wonder if it makes sense to add spare bytes here, but does not seem
> necessary.

We could double the size to allow for expansion, but I think it'd
probably make more sense to add another ioctl later if we end up getting
up to 64 features in a field.

>> +};
>> @@ -579,4 +585,10 @@ static inline char *btrfs_err_str(enum b
>> +#define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 54, \
>> +				   struct btrfs_ioctl_feature_flags)
>> +#define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 54, \
>> +				   struct btrfs_ioctl_feature_flags[2])
>> +#define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 54, =
\
>> +				   struct btrfs_ioctl_feature_flags[3])
>=20
> The ioctl number 54 clashes with the OOB dedup merged into 3.12, 55 is
> for the in-bound dedup and Anand has claimed 56. I've allocated 57 for
> you and updated th wiki page:
>=20
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#Development_notes=
=2E2C_please_read
>=20
> Stefan's trick to reuse the same number is really neat.

Thanks, changed.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--83t0F9Q3MPIgkWFa4OOg8SQhMCEx1Ndxf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSN0o5AAoJEB57S2MheeWyqtwP/iehk+0shQOIgPp17dJv3qwJ
3fEvRxECG2EHvPqovP2AL99rGuc4k+dZklDHHjQnSUv4hBbGMwSPUMhQRHAAUXvd
CGgWk6Yf4PvxS8YpqOzHscAq3fqu2nBku7suWhabRAgd8Yp71YVScHzewuC7d/EB
XMdCyUgBtuGqKf93P6PztX1rhatHNfcTndRyhd956v7P8YhLWAtcoxyNbSzvrdRR
tSMbpQH/snZmpxNsVBUMNMESNSLi+KUYIeIQ5hN/bjZteaJpiX7Y5mjREGSzhU4N
Is7hq2pQjqWnv5fgOMbRZm3O6xpwPixk9HRsNa04ukSA4PF0wmYbhvOhyv2sGWWe
c8mHywJ9mtyWF8mwYwG+7jRELdOwiZIFG+lOsOc7bk+ixtF1zH/fbOUiipDZ/PA2
ki31HY2/Ytn3cRRFMAfqumNYHDOkXqLxGVlwYcsoG59GuEMP9gPKc6caxWosNPcb
6thiKGKRw1yGelUZ7m0KBvuJcJxBIHoC17IXXiKAuKLuuthW7bCqFeT04WKAQaOc
FIxBHAO9AAxdH7qTYmAWzN+sH67v0WVgFRWxCW6QN7T/knIH0qsud7RlyPk26Q4I
t/NADnG+s9DnAPVUsz7vxduopEqjRQUY9cE5SGaZYQPH8enEIiam7yoih3OsITiB
fhxOjBB+esIV+MqjHu1a
=RdR7
-----END PGP SIGNATURE-----

--83t0F9Q3MPIgkWFa4OOg8SQhMCEx1Ndxf--
