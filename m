Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:41948 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbcFYQjc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 12:39:32 -0400
Subject: Re: Trying to rescue my data :(
To: Chris Murphy <lists@colorremedies.com>
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <4e1bff4c-3cfc-4391-d093-8293bf29e795@crc.id.au>
 <CAN05THTxMBrP-JV7atjdskfDYybwmEAV61EDkWRW_Yk70Cfdjg@mail.gmail.com>
 <dd7fd123-c3a2-7ad0-bf22-a67a1b1a97d7@crc.id.au>
 <d00790ae-bf8d-ee18-06a9-d0c5f6010129@gmail.com>
 <47f587fd-b553-5ed7-ac38-202bf7297350@crc.id.au>
 <f0fb8364-de4b-e85f-a8ff-87892c1e3a79@gmail.com>
 <c87e2f76-6cd6-46a4-21ca-dc5f66898d59@crc.id.au>
 <CAJCQCtRrF-KZOo3HOzNWHwhWcDxFem-tcpGh5ScXoQM2Brosag@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Steven Haigh <netwiz@crc.id.au>
Message-ID: <b578050f-1425-134b-9655-7ad36dd4b7ab@crc.id.au>
Date: Sun, 26 Jun 2016 02:39:23 +1000
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRrF-KZOo3HOzNWHwhWcDxFem-tcpGh5ScXoQM2Brosag@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="uqT9RQmagGUnEI9n8o0rQ5LsQldf17TgO"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uqT9RQmagGUnEI9n8o0rQ5LsQldf17TgO
Content-Type: multipart/mixed; boundary="IDGrUCBrLVgfXrrIAiBoK2vDALaN9LI2N"
From: Steven Haigh <netwiz@crc.id.au>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <b578050f-1425-134b-9655-7ad36dd4b7ab@crc.id.au>
Subject: Re: Trying to rescue my data :(
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <4e1bff4c-3cfc-4391-d093-8293bf29e795@crc.id.au>
 <CAN05THTxMBrP-JV7atjdskfDYybwmEAV61EDkWRW_Yk70Cfdjg@mail.gmail.com>
 <dd7fd123-c3a2-7ad0-bf22-a67a1b1a97d7@crc.id.au>
 <d00790ae-bf8d-ee18-06a9-d0c5f6010129@gmail.com>
 <47f587fd-b553-5ed7-ac38-202bf7297350@crc.id.au>
 <f0fb8364-de4b-e85f-a8ff-87892c1e3a79@gmail.com>
 <c87e2f76-6cd6-46a4-21ca-dc5f66898d59@crc.id.au>
 <CAJCQCtRrF-KZOo3HOzNWHwhWcDxFem-tcpGh5ScXoQM2Brosag@mail.gmail.com>
In-Reply-To: <CAJCQCtRrF-KZOo3HOzNWHwhWcDxFem-tcpGh5ScXoQM2Brosag@mail.gmail.com>

--IDGrUCBrLVgfXrrIAiBoK2vDALaN9LI2N
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 26/06/16 02:25, Chris Murphy wrote:
> On Fri, Jun 24, 2016 at 10:19 PM, Steven Haigh <netwiz@crc.id.au> wrote=
:
>=20
>>
>> Interesting though that EVERY crash references:
>>         kernel BUG at fs/btrfs/extent_io.c:2401!
>=20
> Yeah because you're mounted ro, and if this is 4.4.13 unmodified btrfs
> from kernel.org then that's the 3rd line:
>=20
> if (head->is_data) {
>     ret =3D btrfs_del_csums(trans, root,
>        node->bytenr,
>        node->num_bytes);
>=20
> So why/what is it cleaning up if it's mounted ro? Anyway, once you're
> no longer making forward progress you could try something newer,
> although it's a coin toss what to try. There are some issues with
> 4.6.0-4.6.2 but there have been a lot of changes in btrfs/extent_io.c
> and btrfs/raid56.c between 4.4.13 that you're using and 4.6.2, so you
> could try that or even build 4.7.rc4 or rc5 by tomorrowish and see how
> that fairs. It sounds like there's just too much (mostly metadata)
> corruption for the degraded state to deal with so it may not matter.
> I'm really skeptical of btrfsck on degraded fs's so I don't think
> that'll help.

Well, I did end up recovering the data that I cared about. I'm not
really keen to ride the BTRFS RAID6 train again any time soon :\

I now have the same as I've had for years - md RAID6 with XFS on top of
it. I'm still copying data back to the array from the various sources I
had to copy it to so I had enough space to do so.

What I find interesting is that the patterns of corruption in the BTRFS
RAID6 is quite clustered. I have ~80Gb of MP3s ripped over the years -
of that, the corruption would take out 3-4 songs in a row, then the next
10 albums or so were intact. What made recovery VERY hard, is that it
got to several situations that just caused a complete system hang.

I tried it on bare metal - just in case it was a Xen thing, but it hard
hung the entire machine then. In every case, it was a flurry of csum
error messages, then instant death. I would have been much happier if
the file had been skipped or returned as unavailable instead of having
the entire machine crash.

I ended up putting the bit of script that I posted earlier in
/etc/rc.local - then just kept doing:
	xl destroy myvm && xl create /etc/xen/myvm -c

Wait for the crash, run the above again.

All in all, it took me about 350 boots with an average uptime of about 3
minutes to get the data out that I decided to keep. While not a BTRFS
loss, I did decide with how long it was going to take to not bother
recovering ~3.5Tb of other data that is easily available in other places
on the internet. If I really need the Fedora 24 KDE Spin ISO, or the
CentOS 6 Install DVD, etc etc I can download it again.

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897


--IDGrUCBrLVgfXrrIAiBoK2vDALaN9LI2N--

--uqT9RQmagGUnEI9n8o0rQ5LsQldf17TgO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXbrO7AAoJEEGvNdV6fTHcCMsP/1nd6KmBh8bfmtCV8LMbYWWz
1OrFSwZj9fwFnEcyIQXB2Hkg0mFdOLtMVSNarjlb/v+MUzOJXysKeDJfsfDtc66F
aNgM4qwfOR6hDB8S5O8eFgcCbYRT0w71ikIlpM0CChcNAUUn+by8eQkeCEV4jCCO
tFsUMXXffF2Hq7yA8Dsp1B94TQztv1/3lpiBiFHjzz/KRPYFsSLUBrBl33+UQREU
ZcYFOJCd2QzjYlx/sNgnsLkmLRF+LEVsKweKVMgTuZNfCVttthSfEQo8/s+Rhbje
iuC/9q73NydY2GcstQv4cbCVBfDOpvU0sg9/GBm9AqELw1YY9zFbH+uwQrd82r35
acvsO7q4W2H+gBhSKvOzosa54ra2rmSlTqUwP/4O/hMbCJn1M+55rDvtfjhrEdC8
x1KqFHLf2bBW/Cha95G1uiNz4/YqHh+drpDOYdAxEAVCW3HE0Rl6imYRa1ECgCJl
lKUYriv4tW6ptZqCV2DV6Lku7JqAI0oa/EfRJPG7ZJ3zDJD+nZTkQ+fqxkD6N7L6
KmYU59Wi8DGT/MuEcLP5Dr+0779wXLgLaxrrawvCpfhke6Y7Khft+qejsLNV1e/q
d669ZHw0XtBLbT52ViujmecbA71F4S2WAGhHxYyeIZoWzqZtwbjep3EVF5JthXS9
EIcT/mqtezhTzK/+KvSn
=ul8P
-----END PGP SIGNATURE-----

--uqT9RQmagGUnEI9n8o0rQ5LsQldf17TgO--
