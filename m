Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.gocept.net ([195.62.125.19]:33528 "EHLO mail.gocept.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752776AbdC0Nua (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 09:50:30 -0400
From: Christian Theune <ct@flyingcircus.io>
Message-Id: <D3C6181C-2485-4CBC-AD13-A367DD6665F2@flyingcircus.io>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_046A3552-9F14-42E4-B450-9E5851491598";
 protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Subject: Re: Shrinking a device - performance?
Date: Mon, 27 Mar 2017 15:50:01 +0200
In-Reply-To: <c2b19e0a-b345-5d72-2a60-ff86cde7cfca@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
 <20170327130730.GN11714@carfax.org.uk>
 <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
 <20170327132404.GO11714@carfax.org.uk>
 <c2b19e0a-b345-5d72-2a60-ff86cde7cfca@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_046A3552-9F14-42E4-B450-9E5851491598
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi,

> On Mar 27, 2017, at 3:46 PM, Austin S. Hemmelgarn =
<ahferroin7@gmail.com> wrote:
>>=20
>>> Something I=E2=80=99d like to verify: does having traffic on the =
volume have
>>> the potential to delay this infinitely? I.e. does the system write
>>> to any segments that we=E2=80=99re trying to free so it may have to =
work on
>>> the same chunk over and over again? If not, then this means it=E2=80=99=
s
>>> just slow and we=E2=80=99re looking forward to about 2 months worth =
of time
>>> shrinking this volume. (And then again on the next bigger server
>>> probably about 3-4 months).
>>=20
>>   I don't know. I would hope not, but I simply don't know enough
>> about the internal algorithms for that. Maybe someone else can =
confirm?
> I'm not 100% certain, but I believe that while it can delay things, it =
can't do so infinitely.  AFAICT from looking at the code (disclaimer: I =
am not a C programmer by profession), it looks like writes to chunks =
that are being compacted or moved will go to the new location, not the =
old one, but writes to chunks which aren't being touched by the resize =
currently will just go to where the chunk is currently.  Based on this, =
lowering the amount of traffic to the FS could probably speed things up =
a bit, but it likely won't help much.

I hoped that this is the strategy implemented, otherwise it would end up =
in an infinite cat-and-mouse game. ;)

>>> (Background info: we=E2=80=99re migrating large volumes from btrfs =
to xfs
>>> and can only do this step by step: copying some data, shrinking the
>>> btrfs volume, extending the xfs volume, rinse repeat. If someone
>>> should have any suggestions to speed this up and not having to think
>>> in terms of _months_ then I=E2=80=99m all ears.)
>>=20
>>   All I can suggest is to move some unused data off the volume and do
>> it in fewer larger steps. Sorry.
> Same.
>=20
> The other option though is to just schedule a maintenance window, nuke =
the old FS, and restore from a backup.  If you can afford to take the =
system off-line temporarily, this will almost certainly go faster =
(assuming you have a reasonably fast means of restoring backups).

Well. This is the backup. ;)

Thanks,
Christian

--
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 http://flyingcircus.io
Forsterstra=C3=9Fe 29 =C2=B7 06112 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian. =
Theune, Christian. Zagrodnick


--Apple-Mail=_046A3552-9F14-42E4-B450-9E5851491598
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQEcBAEBCgAGBQJY2RiJAAoJEKuh8lKpfGLOyiIH/iC6x9EZe9cl38N41ijnR9/d
6ivXIYVxE0mTZD9zmEVWBWf7YmpZXRvoOh9ZW/UehYklQo2Jg/pl8wwVHM2sOofn
ZnYen+KCzBNajDutSF1fBERTLb5y5GHD6z3VHyGD24HIvLM5h9cCqTI8PcV6PB1y
nMYGMmkxu7nm/4QwX7jp5mhViZVFSsX6SRNNhTO3gxSZU9n0IDR/Cb27Neu0D5TE
VGNxxHoyJSgD69aKqLXInC/78f3cFe+D6J3QDlTidGDQsw4wd8lAlV08JDLurhp0
/I+rZ632hprIVNciPw/oYvgdPDCaniciFDu6M1ygRKfQ/nGM70xvCBAJCja1HPg=
=ocAX
-----END PGP SIGNATURE-----

--Apple-Mail=_046A3552-9F14-42E4-B450-9E5851491598--
