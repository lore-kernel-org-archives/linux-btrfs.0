Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:52071 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751533AbeENGgf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 02:36:35 -0400
Subject: Re: "decompress failed" in 1-2 files always causes kernel oops,
 check/scrub pass
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: james harvey <jamespharvey20@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CA+X5Wn7kouUS=UrvyxfFVEA12NAoh5NrtCLGT6HY6VKq7Bss7Q@mail.gmail.com>
 <a6c35859-0cc3-2261-d717-5fdd9f3911ab@gmx.com>
 <CA+X5Wn5J4TBx-Fa3WLrBPULRiGNa7m_4U9YS6LDvUyVT1TVhqg@mail.gmail.com>
 <d7c78e64-0659-6552-8e7a-8dbbc9b4df72@gmx.com>
Message-ID: <c9feaa61-4362-f2ea-c619-56fdc4a87248@gmx.com>
Date: Mon, 14 May 2018 14:36:29 +0800
MIME-Version: 1.0
In-Reply-To: <d7c78e64-0659-6552-8e7a-8dbbc9b4df72@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wOXQeShV6JpAp7myC4bphUjNCTeY3dSLb"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wOXQeShV6JpAp7myC4bphUjNCTeY3dSLb
Content-Type: multipart/mixed; boundary="svxAFJUt9O4AvRDpzIbbaxvgwvqUe3unQ";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: james harvey <jamespharvey20@gmail.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <c9feaa61-4362-f2ea-c619-56fdc4a87248@gmx.com>
Subject: Re: "decompress failed" in 1-2 files always causes kernel oops,
 check/scrub pass
References: <CA+X5Wn7kouUS=UrvyxfFVEA12NAoh5NrtCLGT6HY6VKq7Bss7Q@mail.gmail.com>
 <a6c35859-0cc3-2261-d717-5fdd9f3911ab@gmx.com>
 <CA+X5Wn5J4TBx-Fa3WLrBPULRiGNa7m_4U9YS6LDvUyVT1TVhqg@mail.gmail.com>
 <d7c78e64-0659-6552-8e7a-8dbbc9b4df72@gmx.com>
In-Reply-To: <d7c78e64-0659-6552-8e7a-8dbbc9b4df72@gmx.com>

--svxAFJUt9O4AvRDpzIbbaxvgwvqUe3unQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8814=E6=97=A5 13:30, Qu Wenruo wrote:
>=20
>=20
> On 2018=E5=B9=B405=E6=9C=8814=E6=97=A5 12:41, james harvey wrote:
>> On Sun, May 13, 2018 at 10:08 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> w=
rote:
>>> On 2018=E5=B9=B405=E6=9C=8812=E6=97=A5 13:08, james harvey wrote:
>>>> Hardware is fine.  Passes memtest86+ in SMP mode.  Works fine on all=

>>>> other files.
>>>>
>>>>
>>>>
>>>> [  381.869940] BUG: unable to handle kernel paging request at 000000=
0000390e50
>>>> [  381.870881] BTRFS: decompress failed
>>>> [  381.891775] IP: rebalance_domains+0x8a/0x2c0
>>>
>>> The interesting part here is, btrfs is not showing up the call trace,=

>>> not even lzo code.
>>> (Despite of the "decompress failed" message).
>>> Maybe some corrupted data is screwing up some random kernel memory?
>>
>> I've been surprised by this too.  I've seen a few "styles" of crashes =
from this.
>>
>> The fuller version of the one I posted in original post:
>> https://bugzilla.kernel.org/attachment.cgi?id=3D275949
>>
>> One that starts with a "general protection fault":
>> https://bugzilla.kernel.org/attachment.cgi?id=3D275951
>>
>> And my most recent version, starts with "BTRFS: decompress failed"
>> then "BUG: unable to handle kernel NULL pointer dereference at
>> 0000000000000001":
>> https://bugzilla.kernel.org/attachment.cgi?id=3D275961
>>
>> This latest one does have a call trace including btrfs.  The top of
>> the call trace is "end_compressed_bio_read+0x34e/0x3d0 [btrfs]", and
>> although it includes the word compressed, I'm not sure that's actually=

>> having to do with lzo compression.  The call stack doesn't scream that=

>> to me.
>>
>> It seems like when the invalid decompression happens, that code itself=

>> doesn't give any kernel errors, but the rest of the kernel starts
>> spazzing.
>=20
> Yep, even the last case it still looks like that it's kernel memory get=

> corrupted.
>=20
>>
>> I've replicated this probably about 15 times now.  Only happens on
>> these files that have inconsistent mirrored data.
>=20
> From the thread, since you have already located the corrupted mirror,
> would you please provide the corrupted dump along with correct one?
>=20
> It would help a lot for us to under stand what's going on.
>=20
>>
>>
>>
>>> Would you please get the inode number of that corrupted files, and th=
row
>>> it through btrfs-debug-tree?
>>>
>>> # btrfs-debug-tree -t <subvol_id> <device> | grep -A 50 \(<INO>
>>>
>>> This is the preferred method as it would provide all the details we
>>> need. But since it could contain sensitive info like filename, please=

>>> double check before posting it.
>>
>> # ls -i system@00fa3c0596e64d2e84096520ca46f008-0000000000000001-00053=
cd2c1756577.journal
>> 291489 system@00fa3c0596e64d2e84096520ca46f008-0000000000000001-00053c=
d2c1756577.journal
>>
>> # ls -i user-1000@b70add0ef010457d933fec23a2afa48a-0000000000000495-00=
053b6b6e65e9cf.journal
>> 72267 user-1000@b70add0ef010457d933fec23a2afa48a-0000000000000495-0005=
3b6b6e65e9cf.journal
>>
>> # btrfs-debug-tree -t 5 /dev/lvm/newMain1 | grep -A 50 \(291489 >
>> debug.tree.291489
>> Available at: http://termbin.com/kegj
>>
>> # btrfs-debug-tree -t 5 /dev/lvm/newMain1 | grep -A 50 \(72267 >
>> debug.tree.72267
>> Available at: http://termbin.com/xhdc
>=20
> The dump indicates the same conclusion you reached.
> The inode has NODATACOW NODATASUM flag, which means it should not has
> csum nor has data compressed.
> While in fact we have tons of compressed extents.
>=20
> But the following fiemap result also shows that these extents get
> shared. This could happen when there is a snapshot.
>=20
> So there is something wrong that btrfs allows compressed data to be
> generated for such file.
> (Could not reproduce the same behavior with 4.16 kernel, could such
> problem happens in older kernels? Or just get fixed recently?)

OK, I could reproduce it now.

Just mount with -o nodatasum, then create a file.
Remount with compress-force=3Dlzo, then write something.

So at least btrfs should disallow such thing.

Thanks,
Qu

>=20
> Then some corruption screwed up the compressed data, and when we
> decompress, the kernel is screwed up.
>=20
>=20
> To pindown the lzo decompress corruption, kasan would be a nice try.
> However this means you need to enable it at compile time, and recompile=

> a kernel.
> Not to mention kasan has a great impact on performance.
>=20
> But it should provide more info before memory get corrupted.
>=20
> Thanks,
> Qu
>=20
>>
>>
>>
>>> Or fiemap of that file could also help:
>>>
>>> # xfs_io -c "fiemap -v" <corrupted_file>
>>>
>>> This is completely safe, but I'm not 100% sure about if the info is e=
nough.
>>
>> # xfs_io -c "fiemap -v"
>> system@00fa3c0596e64d2e84096520ca46f008-0000000000000001-00053cd2c1756=
577.journal
>> Available at: http://termbin.com/nsej
>>
>> # xfs_io -c "fiemap -v"
>> system@00fa3c0596e64d2e84096520ca46f008-0000000000000001-00053cd2c1756=
577.journal
>> Available at: http://termbin.com/4fiz
>=20
>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20


--svxAFJUt9O4AvRDpzIbbaxvgwvqUe3unQ--

--wOXQeShV6JpAp7myC4bphUjNCTeY3dSLb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr5Lm0ACgkQwj2R86El
/qhwDwf/bdKktTQ3zjuD+hCgTSdjaMCsXcr7cz9CKb3XyqImf0oaMK7tKiT/koaY
LBSUw7GhH3g1lPdVXaL/4q5vbQF2XszLlTBV+zKJmBYR05XzGPW7YTg3iTfS8QVk
c3qhx66uM4zT2g9mn0S3eR/73Z7+iH/iHfKNbJl7u3jhfgomajE6YXbNZKAeux5U
Y/hqO2cxoQBLkDNZJzyhFN2A/8sSs6iPCzxXGfVs90EaJ1b11GuM/nyM/yxWbRGQ
E8ex7IVZ4Vqv5nL2ctPaVUX44ADsMTQqfWaBspS0IbVZlVlxkhrGsQso6ngnsB9G
M7UirDY+jDiFcXp47XdcYAoUp7rkUg==
=FD/V
-----END PGP SIGNATURE-----

--wOXQeShV6JpAp7myC4bphUjNCTeY3dSLb--
