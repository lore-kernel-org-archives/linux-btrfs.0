Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58999 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab2LMWkA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Dec 2012 17:40:00 -0500
Date: Thu, 13 Dec 2012 22:39:54 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: merc1984@f-m.fm
Cc: Sander <sander@humilis.net>, cwillu <cwillu@cwillu.com>,
        Mitch Harder <mitch.harder@sabayonlinux.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: Encryption
Message-ID: <20121213223954.GG19051@carfax.org.uk>
References: <1354896969.6088.140661163160337.103F13F1@webmail.messagingengine.com>
 <1355332339.17999.140661165184497.5BC0F72B@webmail.messagingengine.com>
 <CAKcLGm8gH09DgouymqLL1MKi49kZvHx36M=X1yk5gCWD+iOhQQ@mail.gmail.com>
 <1355337523.8384.140661165218221.778EBD55@webmail.messagingengine.com>
 <CAE5mzvjrGZVU7p9dTWiJ1pNZUe_Xj5m78FJte4Enb1od=iqVTA@mail.gmail.com>
 <1355342784.940.140661165251717.298B576B@webmail.messagingengine.com>
 <20121213091714.GA14965@panda>
 <1355419385.18873.140661165650889.7FA54762@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V32M1hWVjliPHW+c"
In-Reply-To: <1355419385.18873.140661165650889.7FA54762@webmail.messagingengine.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--V32M1hWVjliPHW+c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 13, 2012 at 09:23:05AM -0800, merc1984@f-m.fm wrote:
> 
> On Thu, Dec 13, 2012, at 1:17, Sander wrote:
> Forbids? That is just plain wrong.
> I have one btrfs filesystem on top of two encrypted devices. Works just
> fine.
> 
> That's dynamite Sander.
> 
> But I am not going to contravene the instructions, then have problems,
> only to come back here and have fingers wagged in my face telling me
> this is all EXPERIMENTAL!

   Well, I'm afraid that applies to the information on the wiki, too
-- that's also experimental, to a degree. The notes on the wiki about
behaviour of encryption layers weren't added by any of the core
developers. Nobody's published concrete tests *either* way yet, and
those comments are one person's opinion, as far as I'm aware (and note
that they don't actually quote sources, results, or even personal
experience).

   YMMV.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
        --- Great oxymorons of the world, no. 2: Common Sense ---        

--V32M1hWVjliPHW+c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUMpZOr9z9OVl50rAAQLNEw//cSdeJFIZta9NWIG8Np9FnMEb0Trx0bF4
YPwfV812DSLff2d7+VfYR4H/Ciwz7kDVt1ejolizjCrwUX9PfgvHDuI3AbxRIkzT
G6MgVk6xlsKud7UVm9F+5EUqyDf+cWX+pQ7LSDTZAATtdj47WiFy/ep77Oj6pk++
ngpQ21snPXMg2NodTcVAmX0bOxnUWMnFBZRVE5QRdIXcym+TAkv8OyD3gfUffbDe
fliaea2FQoch3x5qDo4ubGcpXHXZedSxOSb9D0IwSczHnqqT26thSQ9E3mgBRVEZ
emYvBqkD8VC8vFQpUlNdTUfuP7YaWLyHOZMkW5gYUyqbO7bd8ELXVIJthdvVl/jG
SI0uv1PBuGWg/W0Laa8UJbzMbPa7Lr07WRW+lY96AZeu+7Ihwcdnrl7IKub76qh5
QsLg4R97Q0/8lsOTz8mMG5/SzRU2GoUG2IoHYKMokfDr6XesD9DF17GrCBTrHWf8
hmkIRgWRH2ZaLROrmR8cNEHc7ZCoPKtej22B8LE34ADwuCJJVhrCRjpkA+PmywBF
7MXEjcV4z9iIRYr/MLoAgu/XatlGEviHyYgvch2RSgMkWw5msE/KIoOvMFFJBovi
TqwD9DnFlINSnkI5UP/HU2AGzOdhaKM2uLrhczE1NBhDruwBdY3bl3aArlXO1+P4
FJK3EAYMgxk=
=bJOF
-----END PGP SIGNATURE-----

--V32M1hWVjliPHW+c--
