Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:35116 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752893AbbFQN3W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 09:29:22 -0400
Received: from smtp9.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp9.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 9C5B1380408
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 09:29:21 -0400 (EDT)
Received: from smtp9.relay.ord1c.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp9.relay.ord1c.emailsrvr.com (SMTP Server) with ESMTP id 7C59C3803F6
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 09:29:21 -0400 (EDT)
Received: by smtp9.relay.ord1c.emailsrvr.com (Authenticated sender: vincent-AT-up4.tv) with ESMTPSA id 48359380130
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 09:29:16 -0400 (EDT)
Content-Type: multipart/signed; boundary="Apple-Mail=_1E051B75-4CAE-4FBA-BA8C-5AF101B0FD0A"; protocol="application/pgp-signature"; micalg=pgp-sha512
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Subject: Re: RAID10 Balancing Request for Comments and Advices
From: Vincent Olivier <vincent@up4.com>
In-Reply-To: <20150617132736.GT9850@carfax.org.uk>
Date: Wed, 17 Jun 2015 09:29:06 -0400
Message-Id: <48569892-8E0C-4C28-87B1-60CD562AA9EF@up4.com>
References: <1434456557.89597618@apps.rackspace.com> <20150616122545.GI9850@carfax.org.uk> <61CBE6C4-0D06-4F16-B522-4DBB756FBC31@up4.com> <pan$966fb$92ec2f1c$291706f7$cf1b6c68@cox.net> <CAJCQCtRGxCr4GaVwkA0QpK8dYjhaBS0-rmi=ymPxycQiGUa_fg@mail.gmail.com> <80BA2964-3B67-430B-99BE-62A348C5DBED@up4.com> <20150617132736.GT9850@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Apple-Mail=_1E051B75-4CAE-4FBA-BA8C-5AF101B0FD0A
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Jun 17, 2015, at 9:27 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
>=20
> On Wed, Jun 17, 2015 at 09:13:08AM -0400, Vincent Olivier wrote:
>>=20
>>> On Jun 16, 2015, at 8:14 PM, Chris Murphy <lists@colorremedies.com> =
wrote:
>>>=20
>>> On Tue, Jun 16, 2015 at 5:58 PM, Duncan <1i5t5.duncan@cox.net> =
wrote:
>>>=20
>>>> On a current kernel unlike older ones, btrfs actually automates =
entirely
>>>> empty chunk reclaim, so this problem doesn't occur anything close =
to near
>>>> as often as it used to.  However, it's still possible to have =
mostly but
>>>> not entirely empty chunks that btrfs won't automatically reclaim.  =
A
>>>> balance can be used to rewrite and combine these mostly empty =
chunks,
>>>> reclaiming the space saved.  This is what Hugo was recommending.
>>>=20
>>> Yes, as little as a -dusage=3D5 (data chunks that are 5% or less =
full)
>>> can clear the problem and is very fast, seconds. Possibly a bit
>>> longer, many seconds o single digit minutes is -dusage=3D15. I =
haven't
>>> done a full balance in forever.
>>=20
>>=20
>> Yes, on this 80% full 6x4TB RAID10 -dusage=3D15 took 2 seconds and =
relocated "0 out of 3026 chunks=E2=80=9D.
>>=20
>> Out of curiosity, I had to use -dusage=3D90 to have it relocate only =
1 chunk and it took les than 30 seconds.
>>=20
>> So I put a -dusage=3D25 in the weekly cron just before the scrub.
>=20
>   In most cases, all you need to do is clean up one data chunk to
> give the metadata enough space to work in. Instead of manually
> iterating through several values of usage=3D until you get a useful
> response, you can use limit=3D<n> to stop after <n> successful block
> group relocations.


Nice! Will do that instead! Thanks.

--Apple-Mail=_1E051B75-4CAE-4FBA-BA8C-5AF101B0FD0A
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJVgXYiAAoJEOggPckf4s14TXwP+wW9qUHkbG8l3UvsHWIokEMA
PFXxCJOeyj3ayw8Fe6Ro0u87VY0r8VMl9mpcEZA0gvvN4H9BesM0AKp0H7L2gwpJ
1dH8egLvKnGHU+/Nxujqfk9X2+eB+swHRtzNzytaR07B45QIuuAe2PpX9eY1Jzhd
Y6CMvAiq2AncU6EXBTyvdU78Xt9qdoxQ3NuevL+c0lNNYNGUmFUkIQ8E/PY3+CqG
DhV8pDnxXVoPlZRuxRQ0CxPXxqk9nabwdUdUmjLsQGZksIzCxFtmRDHOvEO81qBh
K4oY6RejufwchNsAskRm8xdMhq1K7aDARUmeWeNnaHowvFe6UcGQqdFqikehLPip
vWu5QkEa4kG9I8Idm7cQZTRAB0FaZXElvv8wwiJJn1vkjRZXnPV2xMLQrkSs/WRJ
xtfIhn5u4Dot61IZGE1QjyRMTvB7rKyEjqDfcFHr7/ZOK9y5a+gAVOX0I5gxHbWD
YK9ouFIlwKsY5mPZwrvmhtTIvWxgjvXuWeje+iecUnoTHWXo8vPVVQr81S6hYwb5
pmzATXpNYr1hk2mTphsv273Si/7fodol8IviKBv4AJuTSWffZeyu/Ef1GWJgzEoa
x4bdlr+MG6R1nOLAxyco/KD0NMMX9ywGIAConDrsdAnw6Z0BA2/rbYgiv+oC8GMS
zc0/Vobju6eDPMa0oJ8a
=17sm
-----END PGP SIGNATURE-----

--Apple-Mail=_1E051B75-4CAE-4FBA-BA8C-5AF101B0FD0A--
