Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.crc.id.au ([203.56.246.92]:42920 "EHLO mail.crc.id.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbcFZDNO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 23:13:14 -0400
Received: from [IPv6:2407:e400:b000:201:348e:62d0:e85c:c4a0] (unknown [IPv6:2407:e400:b000:201:348e:62d0:e85c:c4a0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.crc.id.au (Postfix) with ESMTPSA id 192BC3A005D
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Jun 2016 13:13:09 +1000 (AEST)
Subject: Re: Trying to rescue my data :(
To: linux-btrfs@vger.kernel.org
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <4e1bff4c-3cfc-4391-d093-8293bf29e795@crc.id.au>
 <CAN05THTxMBrP-JV7atjdskfDYybwmEAV61EDkWRW_Yk70Cfdjg@mail.gmail.com>
 <dd7fd123-c3a2-7ad0-bf22-a67a1b1a97d7@crc.id.au>
 <d00790ae-bf8d-ee18-06a9-d0c5f6010129@gmail.com>
 <47f587fd-b553-5ed7-ac38-202bf7297350@crc.id.au>
 <f0fb8364-de4b-e85f-a8ff-87892c1e3a79@gmail.com>
 <c87e2f76-6cd6-46a4-21ca-dc5f66898d59@crc.id.au>
 <CAJCQCtRrF-KZOo3HOzNWHwhWcDxFem-tcpGh5ScXoQM2Brosag@mail.gmail.com>
 <b578050f-1425-134b-9655-7ad36dd4b7ab@crc.id.au>
 <pan$e8a2$15460093$3bb59e30$70ebaf89@cox.net>
From: Steven Haigh <netwiz@crc.id.au>
Message-ID: <21b8852b-fba6-6f8f-feed-7bbfa12312d2@crc.id.au>
Date: Sun, 26 Jun 2016 13:13:04 +1000
MIME-Version: 1.0
In-Reply-To: <pan$e8a2$15460093$3bb59e30$70ebaf89@cox.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1HJ34ffQKiQswE8Q4Iarkv3KlLAaFnhaa"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1HJ34ffQKiQswE8Q4Iarkv3KlLAaFnhaa
Content-Type: multipart/mixed; boundary="T7TS4e0DOlw6RwplRhm7pBgpn4mhc2Fu0"
From: Steven Haigh <netwiz@crc.id.au>
To: linux-btrfs@vger.kernel.org
Message-ID: <21b8852b-fba6-6f8f-feed-7bbfa12312d2@crc.id.au>
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
 <b578050f-1425-134b-9655-7ad36dd4b7ab@crc.id.au>
 <pan$e8a2$15460093$3bb59e30$70ebaf89@cox.net>
In-Reply-To: <pan$e8a2$15460093$3bb59e30$70ebaf89@cox.net>

--T7TS4e0DOlw6RwplRhm7pBgpn4mhc2Fu0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 26/06/16 12:30, Duncan wrote:
> Steven Haigh posted on Sun, 26 Jun 2016 02:39:23 +1000 as excerpted:
>=20
>> In every case, it was a flurry of csum error messages, then instant
>> death.
>=20
> This is very possibly a known bug in btrfs, that occurs even in raid1=20
> where a later scrub repairs all csum errors.  While in theory btrfs rai=
d1=20
> should simply pull from the mirrored copy if its first try fails checks=
um=20
> (assuming the second one passes, of course), and it seems to do this ju=
st=20
> fine if there's only an occasional csum error, if it gets too many at=20
> once, it *does* unfortunately crash, despite the second copy being=20
> available and being just fine as later demonstrated by the scrub fixing=
=20
> the bad copy from the good one.
>=20
> I'm used to dealing with that here any time I have a bad shutdown (and =

> I'm running live-git kde, which currently has a bug that triggers a=20
> system crash if I let it idle and shut off the monitors, so I've been=20
> getting crash shutdowns and having to deal with this unfortunately ofte=
n,=20
> recently).  Fortunately I keep my root, with all system executables, et=
c,=20
> mounted read-only by default, so it's not affected and I can /almost/=20
> boot normally after such a crash.  The problem is /var/log and /home=20
> (which has some parts of /var that need to be writable symlinked into /=

> home/var, so / can stay read-only).  Something in the normal after-cras=
h=20
> boot triggers enough csum errors there that I often crash again.
>=20
> So I have to boot to emergency mode and manually mount the filesystems =
in=20
> question, so nothing's trying to access them until I run the scrub and =

> fix the csum errors.  Scrub itself doesn't trigger the crash, thankfull=
y,=20
> and once it has repaired all the csum errors due to partial writes on o=
ne=20
> mirror that either were never made or were properly completed on the=20
> other mirror, I can exit emergency mode and complete the normal boot (t=
o=20
> the multi-user default target).  As there's no more csum errors then=20
> because scrub fixed them all, the boot doesn't crash due to too many su=
ch=20
> errors, and I'm back in business.
>=20
>=20
> Tho I believe at least the csum bug that affects me may only trigger if=
=20
> compression is (or perhaps has been in the past) enabled.  Since I run =

> compress=3Dlzo everywhere, that would certainly affect me.  It would al=
so=20
> explain why the bug has remained around for quite some time as well,=20
> since presumably the devs don't run with compression on enough for this=
=20
> to have become a personal itch they needed to scratch, thus its remaini=
ng=20
> untraced and unfixed.
>=20
> So if you weren't using the compress option, your bug is probably=20
> different, but either way, the whole thing about too many csum errors a=
t=20
> once triggering a system crash sure does sound familiar, here.

Yes, I was running the compress=3Dlzo option as well... Maybe here lays a=

common problem?

--=20
Steven Haigh

Email: netwiz@crc.id.au
Web: https://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897


--T7TS4e0DOlw6RwplRhm7pBgpn4mhc2Fu0--

--1HJ34ffQKiQswE8Q4Iarkv3KlLAaFnhaa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXb0hEAAoJEEGvNdV6fTHcoogP/RO1vS4OF1Mb8tnDTZWkHG9m
WczPsOU3tbFokz6PyZQySLrtYkVskVrzQebiFPvjKqcVUjZbUBilPINbeAfXB5/y
1Un7SNWR+SlbWHEEohFfJLG1bnooo4OG3PH7WsfK00rgxfW71/FhTc2mZoBWLKWv
Gj+Usd5B/NdsSVWFWjuve915syvHPbNNVXIRJA5DduyhPkXEBky3V9Rz/xfUzt0i
+2in49myDPzMCMunk1V+dHrPBaEUqUaeoLyXt17n2BAYjVL15BkSNpJkANNuTp5e
eqNyziZe93ZftDPXbYbdIkcQNGFcXTl5Gxo5vimcBMg+/Czma+5GRfsrtNPRTz8U
8FF5jAoeS5Nr9GOyqwfEnKKTaE7DAD80bfJToseZS87/L9ZatfDHMf5lwRpWjymY
7bBvvgxX/X+dAIe8xZv3LZi93JUz4+2nL/vc79idqKkQRU5KSGdBSrUCVP3F4sPO
4z26GwIlbM+F3qiy6/5NDcuvAjRnuFVcw904eMJyvFKUTBrgGcOVgN8wV9LlVOjr
jZUXUKIbFS4tqftasFg0ZT6bh78jzho85G/jJO0lgU2ssU8j5J0t3yiG0vabkkuU
TjurFo8rgBLVpfHZUmtPjQJ74wDBF9kwpka6JXDC5Ns/2865S0D3NPd0saTaGWbI
OC9zAehaV3+R1/luHkah
=iOqS
-----END PGP SIGNATURE-----

--1HJ34ffQKiQswE8Q4Iarkv3KlLAaFnhaa--
