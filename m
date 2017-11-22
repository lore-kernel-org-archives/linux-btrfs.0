Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:57736 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751408AbdKVAmt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 19:42:49 -0500
Subject: Re: [PATCH 2/2] btrfs: extent-tree: Ensure btrfs_trim_fs can trim the
 whole fs
To: fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        Chris Murphy <lists@colorremedies.com>
References: <20171121072145.24413-1-wqu@suse.com>
 <20171121072145.24413-2-wqu@suse.com>
 <CAL3q7H7EZj_fBB03+gGoP=xXrRDENbhd4DxTF4t+JZ08y8wSbw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <b01236cf-12ca-6891-e14b-802743e4077a@gmx.com>
Date: Wed, 22 Nov 2017 08:42:03 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7EZj_fBB03+gGoP=xXrRDENbhd4DxTF4t+JZ08y8wSbw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="A8tmaJ8s2QA0MEPXF5sUglNcQoJe4DpOX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A8tmaJ8s2QA0MEPXF5sUglNcQoJe4DpOX
Content-Type: multipart/mixed; boundary="l7jXk4n0UGFpLaHWjFIibMj0EP4ie9CQi";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 "dsterba@suse.cz" <dsterba@suse.cz>, Chris Murphy <lists@colorremedies.com>
Message-ID: <b01236cf-12ca-6891-e14b-802743e4077a@gmx.com>
Subject: Re: [PATCH 2/2] btrfs: extent-tree: Ensure btrfs_trim_fs can trim the
 whole fs
References: <20171121072145.24413-1-wqu@suse.com>
 <20171121072145.24413-2-wqu@suse.com>
 <CAL3q7H7EZj_fBB03+gGoP=xXrRDENbhd4DxTF4t+JZ08y8wSbw@mail.gmail.com>
In-Reply-To: <CAL3q7H7EZj_fBB03+gGoP=xXrRDENbhd4DxTF4t+JZ08y8wSbw@mail.gmail.com>

--l7jXk4n0UGFpLaHWjFIibMj0EP4ie9CQi
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2017=E5=B9=B411=E6=9C=8821=E6=97=A5 23:12, Filipe Manana wrote:
> On Tue, Nov 21, 2017 at 7:21 AM, Qu Wenruo <wqu@suse.com> wrote:
>> [BUG]
>> fstrim on some btrfs only trims the unallocated space, not trimming an=
y
>> space in existing block groups.
>>
>> [CAUSE]
>> fstrim_range passed in by default fstrim will be:
>>
>> range->start =3D 0
>> range->len =3D fs_size (which equals with super->total_bytes)
>> range->min_len =3D 512
>>
>> However btrfs_trim_fs() following above parameter to search block grou=
ps
>> to trim.
>>
>> While it's quite possible that all chunks start beyond
>> super->total_bytes if the fs is balanced several times.
>>
>> In that case, btrfs will skip trimming block groups and only trim the
>> unallocated space of each device.
>>
>> [FIX]
>> For common full fs trimming range passed in, extent its len to (u64)-1=

>> so we will iterate all block groups.
>>
>> And for custom fs trimming range, due to the fact that the range will
>> always be truncated by range [0, super->total_bytes), making custom fs=

>> trimming range useless.
>>
>> Just return -ENOTTY for custom fs trimming range.
>>
>> Reported-by: Chris Murphy <lists@colorremedies.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/extent-tree.c | 29 ++++++++++++++++++++++++-----
>>  1 file changed, 24 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index 3a252d7af158..22bbcc8c4f6c 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -11024,12 +11024,31 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_i=
nfo, struct fstrim_range *range)
>>         int ret =3D 0;
>>
>>         /*
>> -        * try to trim all FS space, our block group may start from no=
n-zero.
>> +        * NOTE: Btrfs uses its own logical address space, where its f=
irst
>> +        * chunk can start anywhere if it wants.
>> +        * If we follow common start =3D 0 and len =3D fs_size from @r=
ange, we
>> +        * can end up without trimming any block groups, since it's hi=
ghly
>> +        * possible all chunks start beyond that range.
>> +        *
>> +        * So if we want to trim the whole fs, extent the len to (u64)=
-1 to trim
>> +        * all block groups.
>> +        *
>> +        * Also, since @range will always be truncated to fs size, man=
ually
>> +        * passing range to trim specified range doesn't make much sen=
se.
>> +        * (No mean to trim any block group whose bytenr starts beyond=

>> +        *  @total_bytes)
>> +        * So in that case, return -ENOTTY directly to prevent any cus=
tom trim
>> +        * request.
>>          */
>> -       if (range->len =3D=3D total_bytes)
>> -               cache =3D btrfs_lookup_first_block_group(fs_info, rang=
e->start);
>> -       else
>> -               cache =3D btrfs_lookup_block_group(fs_info, range->sta=
rt);
>> +       if (range->start =3D=3D 0 && range->len =3D=3D total_bytes) {
>> +               range->len =3D (u64)-1;
>=20
> After the fs_trim program gets the value for the range's length and
> before it invokes the trim ioctl, the value might have changed,
> resulting in returning the enotty error below.
>=20
>> +       } else {
>> +               btrfs_info(fs_info,
>> +               "trimming custom range is not supported due to the lim=
itation of fstrim_range");
>=20
> I can't understand this message, and I doubt the average user/admin can=
=2E
>=20
> To me it seems this can be a lot more simple by ignoring the range,
> that is, always considering [0, (u64)-1[. After all, due to the way
> btrfs organizes space, the range does not make any sense and I doubt
> users/programs will have all the necessary knowledge and willing to
> compute a range that makes sense to btrfs based on the current block
> group layout of the fs...

Yes, just ignoring the range at all is the simplest solution.

Although I'm a little worried about false bug report about wrong trimmed
bytes later.

Current bug is exposed by Chris Murphy who takes extra care about the
trimmed bytes.

If we change the behavior to always trim the whole fs, maybe some other
careful guy trying to trim some strange range will report bug about this.=


Maybe put some note in btrfs(5) and always trim the whole fs will be a
better solution?

Thanks,
Qu

>=20
>> +               return -ENOTTY;
>> +       }
>> +
>> +       cache =3D btrfs_lookup_first_block_group(fs_info, range->start=
);
>>
>>         for (; cache; cache =3D next_block_group(fs_info, cache)) {
>>                 if (cache->key.objectid >=3D (range->start + range->le=
n)) {
>> --
>> 2.15.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
>=20


--l7jXk4n0UGFpLaHWjFIibMj0EP4ie9CQi--

--A8tmaJ8s2QA0MEPXF5sUglNcQoJe4DpOX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloUx9sXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qhGPgf/YSwR3VBBigce4qV6eSNcwQar
IzH61ny1pIMqPv8n20PEh8xOJzZB0w7aXXXGwttBHBVAzf77t1/HKM7yk24EWW3q
9Sy+lrTvtR+AuPJU+pnF/cK8vU+b3j1wwus4+q/6JAFLPwc7GNRe3SGbfeNwJ52v
ruO7fJ/NqGKAWZZQgXCICPYGeAsNB1s0TA5mlE0TENlQ202FuQnluZ0RvAvwbvbB
r4bYG+tU7nWCd7dwcKrgWKn2tEi+Jo0raAbF8gki3EmfWpaD/WSwVw4i6kqMlL7J
SR+6dvw6+HDXP8bOrQV/RgDyXOAcwssgT6f9dQvc6vwi1/Cx7xvsHmHfwtZ2Qw==
=02bC
-----END PGP SIGNATURE-----

--A8tmaJ8s2QA0MEPXF5sUglNcQoJe4DpOX--
