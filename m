Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51345 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752013AbeBIAXr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Feb 2018 19:23:47 -0500
Subject: Re: [PATCH RFC] Btrfs: expose bad chunks in sysfs
To: bo.li.liu@oracle.com, kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org
References: <20180205231502.12900-1-bo.li.liu@oracle.com>
 <cfd107b0-e08d-775d-9b46-3cc49e587242@libero.it>
 <20180208190714.GC9008@lim.localdomain>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <c9127086-8c3c-4447-763b-f762c1ca1fee@gmx.com>
Date: Fri, 9 Feb 2018 08:23:37 +0800
MIME-Version: 1.0
In-Reply-To: <20180208190714.GC9008@lim.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2Jmkg0DjplQObbXJf2WUicID6hon5wYtK"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2Jmkg0DjplQObbXJf2WUicID6hon5wYtK
Content-Type: multipart/mixed; boundary="HJzXKBsodjAElT8bRrR4Z6jvuSwEi7ZGO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: bo.li.liu@oracle.com, kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org
Message-ID: <c9127086-8c3c-4447-763b-f762c1ca1fee@gmx.com>
Subject: Re: [PATCH RFC] Btrfs: expose bad chunks in sysfs
References: <20180205231502.12900-1-bo.li.liu@oracle.com>
 <cfd107b0-e08d-775d-9b46-3cc49e587242@libero.it>
 <20180208190714.GC9008@lim.localdomain>
In-Reply-To: <20180208190714.GC9008@lim.localdomain>

--HJzXKBsodjAElT8bRrR4Z6jvuSwEi7ZGO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B402=E6=9C=8809=E6=97=A5 03:07, Liu Bo wrote:
> On Thu, Feb 08, 2018 at 07:52:05PM +0100, Goffredo Baroncelli wrote:
>> On 02/06/2018 12:15 AM, Liu Bo wrote:
>> [...]
>>> One way to mitigate the data loss pain is to expose 'bad chunks',
>>> i.e. degraded chunks, to users, so that they can use 'btrfs balance'
>>> to relocate the whole chunk and get the full raid6 protection again
>>> (if the relocation works).
>>
>> [...]
>> [...]
>>
>>> +
>>> +	/* read lock please */
>>> +	do {
>>> +		seq =3D read_seqbegin(&fs_info->bc_lock);
>>> +		list_for_each_entry(bc, &fs_info->bad_chunks, list) {
>>> +			len +=3D snprintf(buf + len, PAGE_SIZE - len, "%llu\n",
>>> +					bc->chunk_offset);
>>> +			/* chunk offset is u64 */
>>> +			if (len >=3D PAGE_SIZE)
>>> +				break;
>>> +		}
>>> +	} while (read_seqretry(&fs_info->bc_lock, seq));
>>
>> Using this interface, how many chunks can you list ? If I read the cod=
e correctly, only up to fill a kernel page.
>>
>> If my math are correctly (PAGE_SIZE=3D4k, a u64 could require up to 19=
 bytes) it is possible to list only few hundred of chunks (~200). Not mor=
e; and the last one could be even listed incomplete.
>>
>=20
> That's true.
>=20
>> IIRC a chunk size is max 1GB; If you lost a 500GB of disks, the chunks=
 to list could be more than 200.
>>
>> My first suggestion is to limit the number of chunks to show to 200 (a=
 page should be big enough to contains all these chunks offset). If the c=
hunks number are greater, ends the list with a marker (something like '[.=
=2E.]\n').
>> This would solve the ambiguity about the fact that the list chunks are=
 complete or not. Anyway you cannot list all the chunks.
>>
>=20
> Good point, and I need to add one more field to each record to specify
> it's metadata or data.
>=20
> So what I have in my mind is that this kind of error is rare and
> reflects bad sectors on disk, but if there are really that many
> errors, I think we need to replace the disk without hesitation.
>=20
>> However, my second suggestions is to ... change completely the interfa=
ce. What about adding a directory in sysfs, where each entry is a chunk ?=

>>
>> Something like:
>>
>> /sys/fs/btrfs/<FS-UUID>/chunks/<chunks-offset>/type		# data/metadata/s=
ys
>> /sys/fs/btrfs/<FS-UUID>/chunks/<chunks-offset>/profile		# dup/linear..=
=2E.
>> /sys/fs/btrfs/<FS-UUID>/chunks/<chunks-offset>/size		# size
>> /sys/fs/btrfs/<FS-UUID>/chunks/<chunks-offset>/devs		# chunks devs=20

What about netlink interface?

Although it may needs an extra daemon to listen to it, and some guys
won't be happy about the abuse of daemon.

Thanks,
Qu

>>
>> And so on.=20
>>
>> Checking  "[...]<chunks-offset>/devs", it would be easy understand if =
the chunk is in "degraded" mode or not.
>=20
> I'm afraid we cannot do that as it'll occupy too much memory for large
> filesystems given a typical chunk size is 1GB.
>=20
>>
>> However I have to admit that I don't know how feasible is iterate over=
 a sysfs directory which is a map of a kernel objects list.
>>
>> I think that if these interface would be good enough, we could get rid=
 of a lot of ioctl(TREE_SEARCH) from btrfs-progs.=20
>>
>=20
> TREE_SEARCH is faster than iterating sysfs (if we could), isn't it?
>=20
> thanks,
> -liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--HJzXKBsodjAElT8bRrR4Z6jvuSwEi7ZGO--

--2Jmkg0DjplQObbXJf2WUicID6hon5wYtK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlp86gkXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiRaQgAo9RBW1UCgnRy4zBksxYJ+puf
uUqFqAYrwOCYvhSxjL5qrnbMknqdI0ZhdgoloNuPbBPlCezwn8mtYj0sSrF0zuzA
HusOTQiNR3pmZ6X7+9iMGK6sDTu1P193HsoTD10Fm50Ex75UEJYambDSmRg2Xh+r
YdDlaUS2ddG8Y7TEHy7Ukb456BzUsBOekVkpzFDMdYOfwziuBtMIe+/UIn0Xn0Ma
vepb23Z59aiSjPZzG3B/gyJ1wiUc3IHrfjHrHVrSyRWQNqHwlnK56ZuJvBD954pj
HCFRE4clRbHNC8Zf82s4QkXeNI5Rm4jasp/niDIWyg2NiT2UjQsG3iSbgavFBw==
=r3Zg
-----END PGP SIGNATURE-----

--2Jmkg0DjplQObbXJf2WUicID6hon5wYtK--
