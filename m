Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:53563 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab3LMADF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 19:03:05 -0500
Received: by mail-pb0-f50.google.com with SMTP id rr13so1452515pbb.9
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Dec 2013 16:03:04 -0800 (PST)
Content-Type: multipart/signed; boundary="Apple-Mail=_5B773B2F-9B4B-46E0-80E9-EC85E4A7A4CC"; protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCH 2/4 v3] fiemap: add EXTENT_DATA_COMPRESSED flag
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20131212232443.GL31386@dastard>
Date: Thu, 12 Dec 2013 17:02:57 -0700
Cc: David Sterba <dsterba@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-nilfs@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
        xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
        "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Message-Id: <9520AB36-B728-423A-8EA1-FDD22B79AE90@dilger.ca>
References: <cover.1386778302.git.dsterba@suse.cz> <4f8d5dc5b51a43efaf16c39398c23a6276e40a30.1386778303.git.dsterba@suse.cz> <20131212232443.GL31386@dastard>
To: Dave Chinner <david@fromorbit.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_5B773B2F-9B4B-46E0-80E9-EC85E4A7A4CC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Dec 12, 2013, at 4:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Dec 12, 2013 at 04:25:59PM +0100, David Sterba wrote:
>> This flag was not accepted when fiemap was proposed [2] due to lack =
of
>> in-kernel users. Btrfs has compression for a long time and we'd like =
to
>> see that an extent is compressed in the output of 'filefrag' utility
>> once it's taught about it.
>>=20
>> For that purpose, a reserved field from fiemap_extent is used to let =
the
>> filesystem store along the physcial extent length when the flag is =
set.
>> This keeps compatibility with applications that use FIEMAP.
>=20
> I'd prefer to just see the new physical length field always filled
> out, regardless of whether it is a compressed extent or not. In
> terms of backwards compatibility to userspace, it makes no
> difference because the value of reserved/unused fields is undefined
> by the API. Yes, the implementation zeros them, but there's nothing
> in the documentation that says "reserved fields must be zero".
> Hence I think we should just set it for every extent.

I'd actually thought the same thing while reading the patch, but I =
figured
people would object because it implies that old kernels will return a
physical length of 0 bytes (which might be valid) and badly-written =
tools
will not work correctly on older kernels.  That said, applications =
_should_
be checking the FIEMAP_EXTENT_DATA_COMPRESSED flag, and I suspect in the
future fewer developers will be confused if fe_phys_length =3D=3D =
fe_length
going forward.

If the initial tools get it right (in particular filefrag), then =
hopefully
others will get it correct also.

> =46rom the point of view of the kernel API (fiemap_fill_next_extent),
> passing the physical extent size in the "len" parameter for normal
> extents, then passing 0 for the "physical length" makes absolutely
> no sense.
>=20
> IOWs, what you have created is a distinction between the extent's
> "logical length" and it's "physical length". For uncompressed
> extents, they are both equal and they should both be passed to
> fiemap_fill_next_extent as the same value. Extents where they are
> different (i.e.  encoded extents) is when they can be different.
> Perhaps fiemap_fill_next_extent() should check and warn about
> mismatches when they differ and the relevant flags are not set...

Seems reasonable to have a WARN_ONCE() in that case.  That would catch =
bugs
in the filesystem, code as well:

	WARN_ONCE(phys_len !=3D lgcl_len &&
		  !(flags & FIEMAP_EXTENT_DATA_COMPRESSED),
		  "physical len %llu !=3D logical length %llu without =
DATA_COMPRESSED\n",
		  phys_len, logical_len, phys_len, logical_len);

>> diff --git a/include/uapi/linux/fiemap.h =
b/include/uapi/linux/fiemap.h
>> index 93abfcd..0e32cae 100644
>> --- a/include/uapi/linux/fiemap.h
>> +++ b/include/uapi/linux/fiemap.h
>> @@ -19,7 +19,9 @@ struct fiemap_extent {
>> 	__u64 fe_physical; /* physical offset in bytes for the start
>> 			    * of the extent from the beginning of the =
disk */
>> 	__u64 fe_length;   /* length in bytes for this extent */
>> -	__u64 fe_reserved64[2];
>> +	__u64 fe_phys_length; /* physical length in bytes, undefined if
>> +			       * DATA_COMPRESSED not set */
>> +	__u64 fe_reserved64;
>> 	__u32 fe_flags;    /* FIEMAP_EXTENT_* flags for this extent */
>> 	__u32 fe_reserved[3];
>> };
>=20
> The comment for fe_length needs to change, too, because it needs to
> indicate that it is the logical extent length and that it may be
> different to the fe_phys_length depending on the flags that are set
> on the extent.

Would it make sense to rename fe_length to fe_logi_length (or something,
I'm open to suggestions), and have a compat macro:

#define fe_length fe_logi_length

around for older applications?  That way, new developers would start to
use the new name, old applications would still compile for both newer =
and
older interfaces, and it doesn't affect the ABI at all.

> And, FWIW, I wouldn't mention specific flags in the comment here,
> but do it at the definition of the flags that indicate there is
> a difference between physical and logical extent lengths....

Actually, I was thinking just the opposite for this field.  It seems =
useful
that the requirement for DATA_COMPRESSED being set is beside =
fe_phys_length
so that anyone using this field sees the correlation clearly.  I don't =
expect
everyone would read and understand the meaning of all the flags when =
looking
at the data structure.

Cheers, Andreas

>> @@ -50,6 +52,8 @@ struct fiemap {
>> 						    * Sets =
EXTENT_UNKNOWN. */
>> #define FIEMAP_EXTENT_ENCODED		0x00000008 /* Data can =
not be read
>> 						    * while fs is =
unmounted */
>> +#define FIEMAP_EXTENT_DATA_COMPRESSED	0x00000040 /* Data is =
compressed by fs.
>> +						    * Sets =
EXTENT_ENCODED */
>=20
> i.e. here.
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com


Cheers, Andreas






--Apple-Mail=_5B773B2F-9B4B-46E0-80E9-EC85E4A7A4CC
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBUqpOsXKl2rkXzB/gAQLHdQ/9HzjsfX711V4fx07kX4E76Eoaj9IHq/a6
1Hu7H9NoH8Ku41/T5Utu84X/uqRyijQq7FAatkU7eqYIkWAMN7LoZZyNOCK5Pk3j
P2CZmDXp2NLxv7MMD6lpzX/RMVqdCJwdrNPUBUu0bJc17bcauMWrE658drvKc9Zk
ZVKJQIdaij/B2qsxeqe55vhqK7AVgpDWjckSHg6png940LkNz12P4VPeic6q2Gmo
VmgJiDvM2LEEEZRqWDMkDuHRq0qd/Hr0ZGMckpDZVWjJI5pI0wYo3RHNmpDH3RHx
PooMk4uwR6Q7+82wwemzrIlii5vfg8Ee3S7Uhtoc656c7PhBeYFtTeyh/wVgQe1M
w9+VPKXgj51miHkpgxvXYGTcmZyVFqNnlFjSUf5hh8DBUy5ivUlOmQex4RI6hMrz
t0jrO/fkgIEIDMbIwUfdC04+xPVAoHubJ5PnB52I9dDjZAi+mxBacpdNFVngxgcO
Hpgzr8TVOewwo/wyjy3x3cGPU1X3m8ZpUMKBAHT7k6p2BajZHfrq7A/YcjPhjkJK
x3PUzIYRu2ZBVgJffMkeE/rhR0ebla5OuueZ+/Bl3LgcPLI8gzDaktP+yCwAsmDr
f1Gt9Nar1nViZk4WjS0LJtZeMtq+EbNjK8PyYrA0ZUnmDpigXjIj8PKlblex9oCp
Ix2xkpnlaTw=
=Vb5V
-----END PGP SIGNATURE-----

--Apple-Mail=_5B773B2F-9B4B-46E0-80E9-EC85E4A7A4CC--
