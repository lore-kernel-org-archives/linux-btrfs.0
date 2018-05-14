Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:38547 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752064AbeENLFZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 07:05:25 -0400
Subject: Re: "decompress failed" in 1-2 files always causes kernel oops,
 check/scrub pass
To: james harvey <jamespharvey20@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CA+X5Wn7kouUS=UrvyxfFVEA12NAoh5NrtCLGT6HY6VKq7Bss7Q@mail.gmail.com>
 <a6c35859-0cc3-2261-d717-5fdd9f3911ab@gmx.com>
 <CA+X5Wn5J4TBx-Fa3WLrBPULRiGNa7m_4U9YS6LDvUyVT1TVhqg@mail.gmail.com>
 <d7c78e64-0659-6552-8e7a-8dbbc9b4df72@gmx.com>
 <CA+X5Wn6853b0O164U-fLP4CeXii62HpTLUkMrW_-b2U2iBM5Yw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5546f724-b56a-dc8a-857f-08c466d9c9c0@gmx.com>
Date: Mon, 14 May 2018 19:05:10 +0800
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn6853b0O164U-fLP4CeXii62HpTLUkMrW_-b2U2iBM5Yw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FtM3rbJCUX0q51Lj2jJGH5wMHfEGpCMnA"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FtM3rbJCUX0q51Lj2jJGH5wMHfEGpCMnA
Content-Type: multipart/mixed; boundary="o8V0s7aiq8fJ5ov6duSREhCla3xLREO9t";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: james harvey <jamespharvey20@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <5546f724-b56a-dc8a-857f-08c466d9c9c0@gmx.com>
Subject: Re: "decompress failed" in 1-2 files always causes kernel oops,
 check/scrub pass
References: <CA+X5Wn7kouUS=UrvyxfFVEA12NAoh5NrtCLGT6HY6VKq7Bss7Q@mail.gmail.com>
 <a6c35859-0cc3-2261-d717-5fdd9f3911ab@gmx.com>
 <CA+X5Wn5J4TBx-Fa3WLrBPULRiGNa7m_4U9YS6LDvUyVT1TVhqg@mail.gmail.com>
 <d7c78e64-0659-6552-8e7a-8dbbc9b4df72@gmx.com>
 <CA+X5Wn6853b0O164U-fLP4CeXii62HpTLUkMrW_-b2U2iBM5Yw@mail.gmail.com>
In-Reply-To: <CA+X5Wn6853b0O164U-fLP4CeXii62HpTLUkMrW_-b2U2iBM5Yw@mail.gmail.com>

--o8V0s7aiq8fJ5ov6duSREhCla3xLREO9t
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B405=E6=9C=8814=E6=97=A5 18:29, james harvey wrote:
> On Mon, May 14, 2018 at 2:36 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>> OK, I could reproduce it now.
>>
>> Just mount with -o nodatasum, then create a file.
>> Remount with compress-force=3Dlzo, then write something.
>>
>> So at least btrfs should disallow such thing.
>>
>> Thanks,
>> Qu
>=20
> Would the corrupted dump and correct one of the file, and kernel with
> kasan output still help?  Or, with what you reproduced, do you have
> what you need?

The dumps are good enough, kasan will be a little over killed.

For my reproduced case, the data is all good, thus unable to reproduce
the wildly corrupted kernel memory.

I could try corrupt them, but I'm not sure if the same symptom can be
reproduced, thus binary good/bad dump still helps.
The heavy lifting kasan can be done in my environment.

>=20
>=20
> On Mon, May 14, 2018 at 1:30 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wro=
te:
>> So there is something wrong that btrfs allows compressed data to be
>> generated for such file.
>> (Could not reproduce the same behavior with 4.16 kernel, could such
>> problem happens in older kernels? Or just get fixed recently?)
>>
>> Then some corruption screwed up the compressed data, and when we
>> decompress, the kernel is screwed up.
>=20
> In this thread, Chris Murphy noted systemd sets the "C" attribute, and
> discussed what sounds to me like what happened here: "Usually nocow
> also means no compression. But in the archives is a thread where I
> found that compression can be forced on nocow if the file is submitted
> for defragmentation

Oh, defrag is making things more complex here.

But at least the kernel patch should also address that case.

> and either the volume is mounted with compression
> or the file has inherited chattr +c (I don't remember which or
> possibly both). And systemd does submit rotated logs for
> defragmentation."
>=20
>=20
>=20
> (If you don't need the dumps and kernel kasan output, you can skip the
> rest of this reply)
>=20
>=20
>=20
>> Yep, even the last case it still looks like that it's kernel memory ge=
t
>> corrupted.
>>
>> From the thread, since you have already located the corrupted mirror,
>> would you please provide the corrupted dump along with correct one?
>>
>> It would help a lot for us to under stand what's going on.
>=20
> Absolutely.  I'm not sure how to best get you that, though.

It's great you'd like to help.
Considering you have experienced btrfs-map-block usage, it should be a
piece of cake.
And considering you're an Arch user, it won't really take you much time.
(Yeah, Arch users rock!)

>=20
> "filefrag -v" on one of the files can be seen here:
> https://bugzilla.kernel.org/attachment.cgi?id=3D275953
>=20
> It lists 58 fragments.

That filefrag output is less useful here, the main problem is it only
provides the uncompressed extent size.
That's why I asked for debug-tree dump.

And now those debug tree dumps would shine.

I'll take the 72267 dump as an example.

------
	item 182 key (72267 EXTENT_DATA *0* ) itemoff 6375 itemsize 53
		generation 41083 type 1 (regular)
		extent data disk byte *2625134592* nr *4096*
		extent data offset 0 nr 131072 ram 131072
		extent compression 2 (lzo)
------
Important numbers are surrounded by '*'.

The "0" means the offset inside the file.
"2625134592" means the logical address that compressed extent lies.
"4096" means the compressed size of that extent.

So to dump it, passing all needed numbers to btrfs-map-logical, ins this
example you just need:

# btrfs-map-logical -l 2625134592 -b 4096 <device>

And would get the result like:
mirror 1 logical 1104150528 physical 9437184 device
/dev/mapper/test-scratch2
mirror 2 logical 1104150528 physical 1095761920 device
/dev/mapper/test-scratch1

Then grab them using dd.

>=20
> filefrag lists the ending offsets and length based on the uncompressed
> sizes.  filefrag doesn't account for the compression.

Now with debug-tree dump, you have the length you need. :)

>=20
> So, in this thread, I compared the first 4k of fragments 0-57 on each
> disk and found all the corruption was on disk 1.  (And the entire
> 207*4096 bytes on fragment 58.)  Grabbing more than 4k of each
> fragment brings in data from other files.

And indeed, they are all 4K sized from the dump.

>  So, I might have compared
> all of the data (fragments 0-57 are 128k uncompressed, and at least
> fragment 0 uncompressed does lzop down to about 2k, so perhaps all the
> other 128k fragments compress to within 4k, but maybe not) but this
> might not have grabbed all the data.

Any bad/good pair is enough.

>=20
> I could give you (56) 128k, (1) 68k, and (1) 828k fragments, but
> they'd include extra data not involved, so you'd have to find a way to
> use them, and without the metadata saying how many bytes of each
> fragment to use, it might not be easy to put together.  (Maybe
> chopping off all the trailing 0's in each fragment would do the
> trick.)  Maybe the first 9 byte header on each fragment encodes the
> length actually used?

No need to worry now. :)

>=20
> If this is useful to you, I'd be happy to provide it, along with the
> correct one.

Any pair which differs would be sufficient.

>=20
> If there's a better way than this, I'd be happy to do that instead.  I
> of course can't just copy the file, so have to do something like dd or
> "btrfs-map-logical -o".  "btrfs-map-logical -o" can't automatically
> grab the proper length, because it needs a size argument, and if not
> given, defaults to the 16k nodesize.
>=20
>> The dump indicates the same conclusion you reached.
>> The inode has NODATACOW NODATASUM flag, which means it should not has
>> csum nor has data compressed.
>> While in fact we have tons of compressed extents.
>>
>> But the following fiemap result also shows that these extents get
>> shared. This could happen when there is a snapshot.
>=20
> I do run snapper.
>=20
>> To pindown the lzo decompress corruption, kasan would be a nice try.
>> However this means you need to enable it at compile time, and recompil=
e
>> a kernel.
>> Not to mention kasan has a great impact on performance.
>>
>> But it should provide more info before memory get corrupted.
>=20
> Sure, it's compiling.  I'll probably be available to run it and send
> results in 14 hours, if needed.

No need to bother.

But it's still a pretty nice and fun learning progress of how to hack
the complex linux kernel. :)

Thanks,
Qu

>=20


--o8V0s7aiq8fJ5ov6duSREhCla3xLREO9t--

--FtM3rbJCUX0q51Lj2jJGH5wMHfEGpCMnA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlr5bWYACgkQwj2R86El
/qgEQAf/fPkgZm579tqfe4dCGEtDdqOtRjDypO6tqwZebmWpqpDRFAnBBgVf2AE7
6Q8lUg6xhR/94a4Rfj7pozp1znenTeg+AN7HZ7gkpVGLNZGqI4yqps4sfmwRw9Ql
yX8W2sQNiTKowtb5wM1PJvl+DpRKDgspm7LQj95ugxfVq6G7S2yS0uoAXfUe0o39
LTsOHmCAH88Y5az0uHYlZVtLo6gaWEfQLv68u+WTZY3mvCBTYbasoL8ZEMVc/bgl
r+FYXZ8Djst+NL+sdlngzMbqNdx91TSw57WBA4ICWygrlZ1aGEUDQwefnIMte1Tt
QDEpMSYr2DclTTFmtA4YO2EP/hVjnw==
=Dyka
-----END PGP SIGNATURE-----

--FtM3rbJCUX0q51Lj2jJGH5wMHfEGpCMnA--
