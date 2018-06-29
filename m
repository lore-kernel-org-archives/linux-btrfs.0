Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:46715 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932853AbeF2FsZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 01:48:25 -0400
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
Date: Fri, 29 Jun 2018 13:48:17 +0800
MIME-Version: 1.0
In-Reply-To: <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nhd9QO0exge3kWmOTSm0PsRxvYt2eSaTc"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nhd9QO0exge3kWmOTSm0PsRxvYt2eSaTc
Content-Type: multipart/mixed; boundary="TeBuYA1vf42a2kZGSj3JreznE7MDCdpZF";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
In-Reply-To: <20180629052825.tifg2aw7oy3qyyvw@merlins.org>

--TeBuYA1vf42a2kZGSj3JreznE7MDCdpZF
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B406=E6=9C=8829=E6=97=A5 13:28, Marc MERLIN wrote:
> On Fri, Jun 29, 2018 at 01:07:20PM +0800, Qu Wenruo wrote:
>>> lowmem repair seems to be going still, but it's been days and -p seem=
s
>>> to do absolutely nothing.
>>
>> I'm a afraid you hit a bug in lowmem repair code.
>> By all means, --repair shouldn't really be used unless you're pretty
>> sure the problem is something btrfs check can handle.
>>
>> That's also why --repair is still marked as dangerous.
>> Especially when it's combined with experimental lowmem mode.
>=20
> Understood, but btrfs got corrupted (by itself or not, I don't know)
> I cannot mount the filesystem read/write
> I cannot btrfs check --repair it since that code will kill my machine
> What do I have left?

Just normal btrfs check, and post the output.
If normal check eats up all your memory, btrfs check --mode=3Dlowmem.

--repair should be considered as the last method.

>=20
>>> My filesystem is "only" 10TB or so, albeit with a lot of files.
>>
>> Unless you have tons of snapshots and reflinked (deduped) files, it
>> shouldn't take so long.
>=20
> I may have a fair amount.
> gargamel:~# btrfs check --mode=3Dlowmem --repair -p /dev/mapper/dshelf2=
=20
> enabling repair mode
> WARNING: low-memory mode repair support is only partial
> Checking filesystem on /dev/mapper/dshelf2
> UUID: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d
> Fixed 0 roots.
> ERROR: extent[84302495744, 69632] referencer count mismatch (root: 2187=
2, owner: 374857, offset: 3407872) wanted: 3, have: 4
> Created new chunk [18457780224000 1073741824]
> Delete backref in extent [84302495744 69632]
> ERROR: extent[84302495744, 69632] referencer count mismatch (root: 2291=
1, owner: 374857, offset: 3407872) wanted: 3, have: 4
> Delete backref in extent [84302495744 69632]
> ERROR: extent[125712527360, 12214272] referencer count mismatch (root: =
21872, owner: 374857, offset: 114540544) wanted: 181, have: 240
> Delete backref in extent [125712527360 12214272]
> ERROR: extent[125730848768, 5111808] referencer count mismatch (root: 2=
1872, owner: 374857, offset: 126754816) wanted: 68, have: 115
> Delete backref in extent [125730848768 5111808]
> ERROR: extent[125730848768, 5111808] referencer count mismatch (root: 2=
2911, owner: 374857, offset: 126754816) wanted: 68, have: 115
> Delete backref in extent [125730848768 5111808]
> ERROR: extent[125736914944, 6037504] referencer count mismatch (root: 2=
1872, owner: 374857, offset: 131866624) wanted: 115, have: 143
> Delete backref in extent [125736914944 6037504]
> ERROR: extent[125736914944, 6037504] referencer count mismatch (root: 2=
2911, owner: 374857, offset: 131866624) wanted: 115, have: 143
> Delete backref in extent [125736914944 6037504]
> ERROR: extent[129952120832, 20242432] referencer count mismatch (root: =
21872, owner: 374857, offset: 148234240) wanted: 302, have: 431
> Delete backref in extent [129952120832 20242432]
> ERROR: extent[129952120832, 20242432] referencer count mismatch (root: =
22911, owner: 374857, offset: 148234240) wanted: 356, have: 433
> Delete backref in extent [129952120832 20242432]
> ERROR: extent[134925357056, 11829248] referencer count mismatch (root: =
21872, owner: 374857, offset: 180371456) wanted: 161, have: 240
> Delete backref in extent [134925357056 11829248]
> ERROR: extent[134925357056, 11829248] referencer count mismatch (root: =
22911, owner: 374857, offset: 180371456) wanted: 162, have: 240
> Delete backref in extent [134925357056 11829248]
> ERROR: extent[147895111680, 12345344] referencer count mismatch (root: =
21872, owner: 374857, offset: 192200704) wanted: 170, have: 249
> Delete backref in extent [147895111680 12345344]
> ERROR: extent[147895111680, 12345344] referencer count mismatch (root: =
22911, owner: 374857, offset: 192200704) wanted: 172, have: 251
> Delete backref in extent [147895111680 12345344]
> ERROR: extent[150850146304, 17522688] referencer count mismatch (root: =
21872, owner: 374857, offset: 217653248) wanted: 348, have: 418
> Delete backref in extent [150850146304 17522688]
> ERROR: extent[156909494272, 55320576] referencer count mismatch (root: =
22911, owner: 374857, offset: 235175936) wanted: 555, have: 1449
> Deleted root 2 item[156909494272, 178, 5476627808561673095]
> ERROR: extent[156909494272, 55320576] referencer count mismatch (root: =
21872, owner: 374857, offset: 235175936) wanted: 556, have: 1452
> Deleted root 2 item[156909494272, 178, 7338474132555182983]
> ERROR: file extent[374857 235184128] root 21872 owner 21872 backref los=
t
> Add one extent data backref [156909494272 55320576]
> ERROR: file extent[374857 235184128] root 22911 owner 22911 backref los=
t
> Add one extent data backref [156909494272 55320576]
>=20
> The last two ERROR lines took over a day to get generated, so I'm not s=
ure if it's still working, but just slowly.

OK, that explains something.

One extent is referred hundreds times, no wonder it will take a long time=
=2E

Just one tip here, there are really too many snapshots/reflinked files.
It's highly recommended to keep the number of snapshots to a reasonable
number (lower two digits).
Although btrfs snapshot is super fast, it puts a lot of pressure on its
extent tree, so there is no free lunch here.

> For what it's worth non lowmem check used to take 12 to 24H on that fil=
esystem back when it still worked.
>=20
>>> 2 things that come to mind
>>> 1) can lowmem have some progress working so that I know if I'm lookin=
g
>>> at days, weeks, or even months before it will be done?
>>
>> It's hard to estimate, especially when every cross check involves a lo=
t
>> of disk IO.
>> But at least, we could add such indicator to show we're doing somethin=
g.
>=20
> Yes, anything to show that I should still wait is still good :)
>=20
>>> 2) non lowmem is more efficient obviously when it doesn't completely
>>> crash your machine, but could lowmem be given an amount of memory to =
use
>>> for caching, or maybe use some heuristics based on RAM free so that i=
t's
>>> not so excrutiatingly slow?
>>
>> IIRC recent commit has added the ability.
>> a5ce5d219822 ("btrfs-progs: extent-cache: actually cache extent buffer=
s")
> =20
> Oh, good.
>=20
>> That's already included in btrfs-progs v4.13.2.
>> So it should be a dead loop which lowmem repair code can't handle.
>=20
> I see. Is there any reasonably easy way to check on this running proces=
s?

GDB attach would be good.
Interrupt and check the inode number if it's checking fs tree.
Check the extent bytenr number if it's checking extent tree.

But considering how many snapshots there are, it's really hard to determi=
ne.

In this case, the super large extent tree is causing a lot of problem,
maybe it's a good idea to allow btrfs check to skip extent tree check?

>=20
> Both top and iotop show that it's working, but of course I can't tell i=
f
> it's looping, or not.
>=20
> Then again, maybe it already fixed enough that I can mount my filesyste=
m again.

This needs the initial btrfs check report and the kernel messages how it
fails to mount.

>=20
> But back to the main point, it's sad that after so many years, the
> repair situation is still so suboptimal, especially when it's apparentl=
y
> pretty easy for btrfs to get damaged (through its own fault or not, har=
d
> to say).

Unfortunately, yes.
Especially the extent tree is pretty fragile and hard to repair.

Thanks,
Qu

>=20
> Thanks,
> Marc
>=20


--TeBuYA1vf42a2kZGSj3JreznE7MDCdpZF--

--nhd9QO0exge3kWmOTSm0PsRxvYt2eSaTc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAls1yCEACgkQwj2R86El
/qheAwgAgrOwElR+S+sC+qAoi12vtZnfrJZmvCzT402TWCF9pJV5K1WPWz986Kog
EFvincHbu5vnt/5j8aKBzRgnX14vX6pREdXz6OtYcLIm+tWA8EhQEAWu2VvJQd27
+AQgxKxU0c1dMEOXcuGI5DHyhx79sSP76OCWz5fcs7ui/YMEqMfO948Wfz3nx9bh
r3mSCFNfMWDgp6UZg2dMgwG94iD4iIQKQWAmOPiddPHr9RrnXnCJ5QzACCLrtUyA
bv8XQeNMkOb8oNgiaJUjq+ckSeUv8XU/DEsNxKPn32NoeBwuRWZ8iiqSQXakAdRX
F8WnQQSVNGlIjGgSObUB0bRmwbyFFw==
=L8Nc
-----END PGP SIGNATURE-----

--nhd9QO0exge3kWmOTSm0PsRxvYt2eSaTc--
