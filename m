Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56777 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754406AbeEWHfj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 May 2018 03:35:39 -0400
Subject: Re: [PATCH v2 2/4] btrfs: lzo: Add comment about the how btrfs
 records its lzo compressed data
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180521051927.3715-1-wqu@suse.com>
 <20180521051927.3715-3-wqu@suse.com> <20180522140005.GL6649@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <e9a930a1-b0c4-0bf5-b758-e2182beb327f@gmx.com>
Date: Wed, 23 May 2018 15:35:22 +0800
MIME-Version: 1.0
In-Reply-To: <20180522140005.GL6649@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NtDlZtkhLNv4CWSsDfiIVn5TwpGwiSFMX"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NtDlZtkhLNv4CWSsDfiIVn5TwpGwiSFMX
Content-Type: multipart/mixed; boundary="dHxw1oJRJY18MG5VcT4Dx0edMcCNbg8dS";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <e9a930a1-b0c4-0bf5-b758-e2182beb327f@gmx.com>
Subject: Re: [PATCH v2 2/4] btrfs: lzo: Add comment about the how btrfs
 records its lzo compressed data
References: <20180521051927.3715-1-wqu@suse.com>
 <20180521051927.3715-3-wqu@suse.com> <20180522140005.GL6649@twin.jikos.cz>
In-Reply-To: <20180522140005.GL6649@twin.jikos.cz>

--dHxw1oJRJY18MG5VcT4Dx0edMcCNbg8dS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8822=E6=97=A5 22:00, David Sterba wrote:
> On Mon, May 21, 2018 at 01:19:25PM +0800, Qu Wenruo wrote:
>> Although it's not that complex, but such comment could still save
>> several minutes for newer reader/reviewer.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  fs/btrfs/lzo.c | 23 +++++++++++++++++++++++
>>  1 file changed, 23 insertions(+)
>>
>> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
>> index 0667ea07f766..d0c6789ff78f 100644
>> --- a/fs/btrfs/lzo.c
>> +++ b/fs/btrfs/lzo.c
>> @@ -17,6 +17,29 @@
>> =20
>>  #define LZO_LEN	4
>> =20
>> +/*
>> + * Btrfs LZO compression format
>> + *
>> + * Regular LZO compressed data extent consists of:
>> + * 1.  Header
>> + *     Fixed size. LZO_LEN (4) bytes long, LE32.
>> + *     Records the total size (*includes* the header) of real compres=
sed data.
>> + *
>> + * 2.  Segment(s)
>> + *     Variable size. Includes one segment header, and then data payl=
oad.
>> + *     One regular LZO compressed extent can have one or more segment=
s.
>> + *
>> + * 2.1 Segment header
>> + *     Fixed size. LZO_LEN (4) bytes long, LE32.
>> + *     Records the total size of the segment (*excludes* the header).=

>> + *
>> + * 2.2 Data Payload
>> + *     Variable size. Size up limit should be lzo1x_worst_compress(PA=
GE_SIZE).
>> + *
>> + * While for inlined LZO compressed data extent, it doesn't have Head=
er, just
>> + * *ONE* Segment.
>=20
> It does have header that has the same value as the 1st segment header s=
o
> it's skipped.

Indeed, I just missed the first "data_in +=3D LZO_LEN;" line.

And in that case, the header should also be checked.

>=20
> There's also one catch in the format that if there's a less then 4 byte=
s
> left to the page size, the new segment starts on the new page.

I'll also update the patch to reflect this.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--dHxw1oJRJY18MG5VcT4Dx0edMcCNbg8dS--

--NtDlZtkhLNv4CWSsDfiIVn5TwpGwiSFMX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlsFGboACgkQwj2R86El
/qhkaQgAi6z8utBy9BT2Q8AcgIKGgFKxYppcAOZkFXOAq3fuf2tcfZNCMHiZPwPI
03TxYHnHOXqDg8X+B7dNplwVmPwIzL7wMQIjPT1q8htRyZYyZ+4k5MnocXwVWeCQ
69bRpT6Ud7m+pptkHvHl7gprJSvAdu7wyLfxMaijnF+EvbBF3btJFzQAt6Dt+qgC
miJ1jWuP1lELHI/ji/dOX1ThDX4gDMfjy3g0CtXLqRv3qo9OK8r1hpElj1kKXQOj
h+xTYF7pMZHvyhh4uY4eqDFVPItKPI15+5zQvb8AMCnr1gaI8JUdr38ItW5sSVwU
+aR55Zkhvb1V5WEnjK/VSgzTmZZW/g==
=/6N8
-----END PGP SIGNATURE-----

--NtDlZtkhLNv4CWSsDfiIVn5TwpGwiSFMX--
