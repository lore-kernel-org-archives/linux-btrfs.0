From: Piotr Szymaniak <szarpaj@grubelek.pl>
Subject: Re: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped
 buffer of the same page
Date: Fri, 25 Feb 2011 00:35:23 +0100
Message-ID: <20110224233523.GK26836@wloczykij>
References: <1291887014-18447-1-git-send-email-xin.zhong@intel.com>
 <201101280354.36884.johannes.hirte@fem.tu-ilmenau.de>
 <1865303E0DED764181A9D882DEF65FB685DF762B45@shsmsx502.ccr.corp.intel.com>
 <201102020034.43808.johannes.hirte@fem.tu-ilmenau.de>
 <1865303E0DED764181A9D882DEF65FB68621CA7167@shsmsx502.ccr.corp.intel.com>
 <1298028713.11103.13.camel@mainframe>
 <1865303E0DED764181A9D882DEF65FB686421B24FB@shsmsx502.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DCA/C9WSnDtl50zu"
Cc: Maria =?utf-8?B?V2lrc3Ryw7Zt?= <maria@ponstudios.se>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Zhong, Xin" <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1865303E0DED764181A9D882DEF65FB686421B24FB@shsmsx502.ccr.corp.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>


--DCA/C9WSnDtl50zu
Content-Type: multipart/mixed; boundary="IYV9cRr2u6rjcP4B"
Content-Disposition: inline


--IYV9cRr2u6rjcP4B
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 21, 2011 at 09:51:11AM +0800, Zhong, Xin wrote:
> The backtrace in your attachment looks like a known bug of 2.6.37 which h=
ave already been fixed in 2.6.38. I have no idea why latest btrfs still han=
g in your environment if there's no debug info...

Hi list.

I'm watching this list for a while because it seems, that I'm also
affected by this bug. In the archives I found someone with Gentoo system
with freezing `svn info' (thats why I joined). Well, seems that I have=20
same issue here.

Attached latest _rc kernel sysrq+t output (first part when the `svn
info' freezed on libgcrypt, and second after ctrl+c that emerge).

Seems that my backtrace is small compared to Marias. I'm missing some
features in kernel to get larger backtraces?

Piotr Szymaniak.



> -----Original Message-----
> From: Maria Wikstr=C3=B6m [mailto:maria@ponstudios.se]=20
> Sent: Friday, February 18, 2011 7:32 PM
> To: Zhong, Xin
> Cc: Johannes Hirte; linux-btrfs@vger.kernel.org
> Subject: RE: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped=
 buffer of the same page
>=20
>=20
> Seems like my reply got eaten by the lists spam filter, so I resend with =
attachment compressed. Should have thought of that :p
>=20
>=20
> fre 2011-02-11 klockan 12:39 +0800 skrev Zhong, Xin:
> > Hi,
> >=20
> > Could you paste the output of sysrq+t here? Thanks!
>=20
> Yes, it's in the attachment. I tried latest btrfs from git (last commit M=
on Feb 14 00:45:29 2011 +0000) but it hang so bad that I couldn't get the o=
utput from sysrq+t to hit the disk. So the output is from vanilla
> 2.6.37=20
>=20
> // Maria
>=20
> > -----Original Message-----
> > From: Johannes Hirte [mailto:johannes.hirte@fem.tu-ilmenau.de]
> > Sent: Wednesday, February 02, 2011 7:35 AM
> > To: Zhong, Xin
> > Cc: Maria Wikstr=C3=B6m; linux-btrfs@vger.kernel.org
> > Subject: Re: [PATCH v2]Btrfs: pwrite blocked when writing from the=20
> > mmaped buffer of the same page
> >=20
> > On Friday 28 January 2011 04:53:24 Zhong, Xin wrote:
> > > Could you describe the steps to recreate it?
> > > It will be a great help for me to look further. Thanks!
> >=20
> > It's a little strange. I have to systems with btrfs, both=20
> > Gentoo-based. One is affected by this bug the other is not. On the=20
> > affected system it is enough to do a 'emerge dev-libs/libgcrypt' that=
=20
> > should normaly compile and install libgcrypt. The emerge command is=20
> > part of portage, the package management of Gentoo.
> > The strace output looks similar to the one from Maria:
> >=20
>=20
> N?????r??y????b?X??=C7=A7v?^?)=DE=BA{.n?+????{?n?=DF=B2)????w*=1Fjg???=1E=
?????=DD=A2j/???z?=DE=96??2?=DE=99????&?)=DF=A1?a??=7F??=1E?G???h?=0F?j:+v?=
??w??=D9=A5

--=20
Druzyna  futbolowa  tutaj  jest  do  niczego, ale ucze sie troche pilki
noznej.  Trener  mowi,  ze  pilka nozna to futbol dla inteligentnych, a
futbol to futbol dla kretynow.
  -- Stephen King, "The Dead Zone"

--IYV9cRr2u6rjcP4B
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename="vanilla-2.6.38-rc6_sysrq-t.bz2"
Content-Transfer-Encoding: base64

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

--IYV9cRr2u6rjcP4B--

--DCA/C9WSnDtl50zu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk1m6zsACgkQ9xNbxaeWTTwS7gCbBJkEKQlKPyh0vonnKyViFRIp
SGkAn2xcPedho0UPuF22xRGQCY1/vafv
=CjTz
-----END PGP SIGNATURE-----

--DCA/C9WSnDtl50zu--
