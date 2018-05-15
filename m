Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:45697 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752060AbeEOBfq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 21:35:46 -0400
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW
 set
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180514070210.27047-1-wqu@suse.com>
 <20180514165205.GP6649@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <9a66b208-f458-73d0-0e61-a74ed7fabde2@gmx.com>
Date: Tue, 15 May 2018 09:35:32 +0800
MIME-Version: 1.0
In-Reply-To: <20180514165205.GP6649@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Jzq4OpDNwbxo5204jdgOEsYmIeLhCN586"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Jzq4OpDNwbxo5204jdgOEsYmIeLhCN586
Content-Type: multipart/mixed; boundary="uIGqB9i36tG7EC8qbWNXNsUAGJROgHvZM";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <9a66b208-f458-73d0-0e61-a74ed7fabde2@gmx.com>
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW
 set
References: <20180514070210.27047-1-wqu@suse.com>
 <20180514165205.GP6649@twin.jikos.cz>
In-Reply-To: <20180514165205.GP6649@twin.jikos.cz>

--uIGqB9i36tG7EC8qbWNXNsUAGJROgHvZM
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8815=E6=97=A5 00:52, David Sterba wrote:
> On Mon, May 14, 2018 at 03:02:10PM +0800, Qu Wenruo wrote:
>> As btrfs(5) specified:
>>
>> 	Note
>> 	If nodatacow or nodatasum are enabled, compression is disabled.
>>
>> If NODATASUM or NODATACOW set, we should not compress the extent.
>>
>> And in fact, we have bug report about corrupted compressed extent
>> leading to memory corruption in mail list.
>=20
> Link please.
>=20
>> Although it's mostly buggy lzo implementation causing the problem, btr=
fs
>> still needs to be fixed to meet the specification.
>=20
> That's very vague, what's the LZO bug? If the input is garbage and lzo
> decompression cannot decompress it, it's not a lzo bug.

Still digging.
Would update this content in next version.

>=20
>> Reported-by: James Harvey <jamespharvey20@gmail.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/inode.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index d241285a0d2a..dbef3f404559 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -396,6 +396,14 @@ static inline int inode_need_compress(struct inod=
e *inode, u64 start, u64 end)
>>  {
>>  	struct btrfs_fs_info *fs_info =3D btrfs_sb(inode->i_sb);
>> =20
>> +	/*
>> +	 * Btrfs doesn't support compression without csum or CoW.
>> +	 * This should have the highest priority.
>> +	 */
>> +	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW ||
>> +	    BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
>> +		return 0;
>=20
> This is also the wrong place to fix that, NODATASUM or NODATACOW inode
> should never make it to compress_file_range (that calls
> inode_need_compress).

Nope, in run_delalloc_range(), we calls inode_need_compress() to
determine if we goes to normal cow routine or goes to async routine
(compression).

So inode_need_compress() looks like a pretty valid location.

Just mount with nodatasum and create an inode, then remount to
datasum,compress, write something to that inode, you could hit the behavi=
or.

Thanks,
Qu

>=20
>> +
>>  	/* force compress */
>>  	if (btrfs_test_opt(fs_info, FORCE_COMPRESS))
>>  		return 1;
>> --=20
>> 2.17.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--uIGqB9i36tG7EC8qbWNXNsUAGJROgHvZM--

--Jzq4OpDNwbxo5204jdgOEsYmIeLhCN586
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr6OWQACgkQwj2R86El
/qg4Wwf/Sh/qM20olFWDldzMMM66jqpkGNijMHBWhkN6YxoCquxtLwTtZ4vRODrG
C+8vaHUWJn++eIfJ1+/ID5ZL24oINfzpMh0xD5LDwK7dGK+my7WEDW3DFaPZTHKi
1H+9gwXlXdeskokahFKEbLLk5vAkCGopzJV7L6e8RyAEdDZWRh07rbuoGAOp66AX
yNAGwuN6XcFzeV0hkKce3a0IGkUQfNtsdUg3GD6Vq+Gpjei/CUSAJtDoUQHZTouV
x5iAG46Lpc+5F/wDvYLqTATLy0Hx9Bpj/OlWJzz9E6zN6aibryBq9R5Hi0XoGZhU
OFsk8M+GyIuTEAfnScVOcGVM/crdUw==
=LJ3u
-----END PGP SIGNATURE-----

--Jzq4OpDNwbxo5204jdgOEsYmIeLhCN586--
