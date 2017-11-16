Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:64447 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753775AbdKPAuc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 19:50:32 -0500
Subject: Re: [PATCH 1/2] btrfs: Fix wild memory access in compression level
 parser
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        lakshmipathi.g@gmail.com
References: <20171106024319.32584-1-wqu@suse.com>
 <20171115151103.GN28899@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <825b7a24-7cf6-1c0d-fc96-544cf0830fdc@gmx.com>
Date: Thu, 16 Nov 2017 08:49:47 +0800
MIME-Version: 1.0
In-Reply-To: <20171115151103.GN28899@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iC39aUPU8eIdwcS4wWVO1SHpug1vQ8As4"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iC39aUPU8eIdwcS4wWVO1SHpug1vQ8As4
Content-Type: multipart/mixed; boundary="m5Qw3kerriDe2tK0E3B7n956je8q9Faec";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 lakshmipathi.g@gmail.com
Message-ID: <825b7a24-7cf6-1c0d-fc96-544cf0830fdc@gmx.com>
Subject: Re: [PATCH 1/2] btrfs: Fix wild memory access in compression level
 parser
References: <20171106024319.32584-1-wqu@suse.com>
 <20171115151103.GN28899@twin.jikos.cz>
In-Reply-To: <20171115151103.GN28899@twin.jikos.cz>

--m5Qw3kerriDe2tK0E3B7n956je8q9Faec
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8815=E6=97=A5 23:11, David Sterba wrote:
> On Mon, Nov 06, 2017 at 10:43:18AM +0800, Qu Wenruo wrote:
>> [BUG]
>> Kernel panic when mounting with "-o compress" mount option.
>> KASAN will report like:
>> ------
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KASAN: wild-memory-access in strncmp+0x31/0xc0
>> Read of size 1 at addr d86735fce994f800 by task mount/662
>> ...
>> Call Trace:
>>  dump_stack+0xe3/0x175
>>  kasan_report+0x163/0x370
>>  __asan_load1+0x47/0x50
>>  strncmp+0x31/0xc0
>>  btrfs_compress_str2level+0x20/0x70 [btrfs]
>>  btrfs_parse_options+0xff4/0x1870 [btrfs]
>>  open_ctree+0x2679/0x49f0 [btrfs]
>>  btrfs_mount+0x1b7f/0x1d30 [btrfs]
>>  mount_fs+0x49/0x190
>>  vfs_kern_mount.part.29+0xba/0x280
>>  vfs_kern_mount+0x13/0x20
>>  btrfs_mount+0x31e/0x1d30 [btrfs]
>>  mount_fs+0x49/0x190
>>  vfs_kern_mount.part.29+0xba/0x280
>>  do_mount+0xaad/0x1a00
>>  SyS_mount+0x98/0xe0
>>  entry_SYSCALL_64_fastpath+0x1f/0xbe
>> ------
>>
>> [Cause]
>> For 'compress' and 'compress_force' options, its token doesn't expect
>> any parameter so its args[0] contains uninitialized data.
>> Accessing args[0] will cause above wild memory access.
>>
>> [Fix]
>> For Opt_compress and Opt_compress_force, set compression level to
>> Z_DEFAULT_COMPRESSION manually.
>>
>> NOTE: Don't set zlib compression level to 0 by default, which means no=

>> compression.
>=20
> But we never set the level to 0 at the point the compression actually
> happens. See zlib.c:zlib_set_level, if level is 0 then the level
> passed to zlib is 3. Z_DEFAULT_COMPRESSION is upstream zlib level 6,
> which is slower, we need zlib to stay in the real-time numbers.

Right, I missed that.

So should I still use 0, or use separate macro like
BTRFS_DEFAULT_ZLIB_LEVEL?

Thanks,
Qu

>=20
>> @@ -507,8 +508,19 @@ int btrfs_parse_options(struct btrfs_fs_info *inf=
o, char *options,
>>  			    token =3D=3D Opt_compress_force ||
>>  			    strncmp(args[0].from, "zlib", 4) =3D=3D 0) {
>>  				compress_type =3D "zlib";
>> +
>>  				info->compress_type =3D BTRFS_COMPRESS_ZLIB;
>> -				info->compress_level =3D
>> +				/*
>> +				 * args[0] contains uninitialized data since
>> +				 * for these tokens we don't expect any
>> +				 * parameter.
>> +				 */
>> +				if (token =3D=3D Opt_compress ||
>> +				    token =3D=3D Opt_compress_force)
>> +					info->compress_level =3D
>> +						Z_DEFAULT_COMPRESSION;
>> +				else
>> +					info->compress_level =3D
>>  					btrfs_compress_str2level(args[0].from);
>=20
> At least this will not screw up the levels, anything that's not
> recognized will become the default.
>=20
>>  				btrfs_set_opt(info->mount_opt, COMPRESS);
>>  				btrfs_clear_opt(info->mount_opt, NODATACOW);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--m5Qw3kerriDe2tK0E3B7n956je8q9Faec--

--iC39aUPU8eIdwcS4wWVO1SHpug1vQ8As4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloM4KsXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qga6gf+N5wk7JvuAj7txPw8HGWez7uf
p+y1aIiMTb3GVaqiERlqHOzXF/lRzBch3Pj92SpPPcpGLpQPpzXZQbh+ENpE0P/4
2nDtvNS8z0cOY0LWrkC+SUoWwkjEXwTj2YNpFRqTVb7limvCb6ZbSTpbW5sn5Z/f
ssJAN3AG0ub0C++lc9DbCjdsejDIsFsc0fMIyAZJ16UalvSw6nqtJQNtPM+U6vUP
7fGdmHaIsl+CeiUqYIdZ5LW/OZt4TJcRe/9MmA/mwj/ZIwwNneUl6dpwLc+bSJO4
/PXZ56q4iX+XL3IiNc1wUF6xfjumzGMk5g/la964i+MOuWxoqiqTcPnrTUhp4g==
=le37
-----END PGP SIGNATURE-----

--iC39aUPU8eIdwcS4wWVO1SHpug1vQ8As4--
