From: Piotr Szymaniak <szarpaj@grubelek.pl>
Subject: Re: [PATCH] btrfs file write debugging patch
Date: Tue, 1 Mar 2011 22:56:45 +0100
Message-ID: <20110301215645.GH26836@wloczykij>
References: <1298857223-sup-5612@think>
 <201102281114.00018.johannes.hirte@fem.tu-ilmenau.de>
 <20110228161056.GA2769@localhost.localdomain>
 <1298911556.11118.8.camel@mainframe>
 <AANLkTin_Hjr3StjWUGrwCHBzhk_kwj-G2WqxZM6=CqN2@mail.gmail.com>
 <AANLkTikex7g4+dc9qiPdL_xRk5SoFxE3TCfN7dg3kaR2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4PT7esnm3N7vhCZl"
Cc: Josef Bacik <josef@redhat.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	Chris Mason <chris.mason@oracle.com>,
	"Zhong, Xin" <xin.zhong@intel.com>, linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikex7g4+dc9qiPdL_xRk5SoFxE3TCfN7dg3kaR2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


--4PT7esnm3N7vhCZl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 28, 2011 at 02:20:22PM -0600, Mitch Harder wrote:
> As promised, I'm put together a modified file.c with many trace_printk
> debugging statements to augment the ftrace.
> *snip*

Just my few cents. I've applied the patch from Chris Mason (Sun, 27 Feb
2011 20:46:05 -0500) and this one from Mitch (Mon, 28 Feb 2011 14:20:22
-0600) on top of vanilla 2.6.38-rc6 and it seems that it resolves my
issues with hanging `svn info' during libgcrypt emerge.

Piotr Szymaniak.
--=20
 - (...) Nie wyobrazam sobie, co ta gora miesa moglaby ci dac, czego ja
nie   moglbym   ofiarowac.  Oczywiscie  poza  piecdziesiecioma  funtami
rozrosnietych miesni.
 - Moze mnie wlasnie pociagaja rozrosniete miesnie. (...) W koncu wielu
mezczyzn pociaga rozrosnieta tkanka tluszczowa piersi.
  -- Graham Masterton, "The Wells of Hell"

--4PT7esnm3N7vhCZl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk1ta50ACgkQ9xNbxaeWTTzEBQCfWsHcb+l8rhZCjzmnXwT3gIO1
sOIAoIu4WnrPlwM0tdRmU+zarIhNbPBo
=rWfy
-----END PGP SIGNATURE-----

--4PT7esnm3N7vhCZl--
