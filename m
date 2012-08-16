Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([176.31.121.172]:44456 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab2HPRZx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 13:25:53 -0400
Date: Thu, 16 Aug 2012 23:25:49 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: Johannes Stezenbach <js@sig21.net>
Cc: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] Update LZO compression
Message-ID: <20120816232549.4d14a6aa@natsu>
In-Reply-To: <20120816150647.GA22010@sig21.net>
References: <50299142.2030504@oberhumer.com>
	<20120814123937.GA14756@sig21.net>
	<502B8FE3.7080501@oberhumer.com>
	<20120815144539.GA8300@sig21.net>
	<502C92C3.7090701@oberhumer.com>
	<20120816150647.GA22010@sig21.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=C.lUB/2VdSczshZJsDxK4."; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/=C.lUB/2VdSczshZJsDxK4.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Aug 2012 17:06:47 +0200
Johannes Stezenbach <js@sig21.net> wrote:

> Well, ~2x speedup on x86 is certainly a good achievement, but there
> are more ARM based devices than there are PCs, and I guess many
> embedded devices use lzo compressed kernels and file systems
> while I'm not convinced many PCs rely on lzo in the kernel.

Keep in mind that a major user of LZO is the BTRFS filesystem, and I believ=
e it
is used much more often on larger machines than on ARM, in fact it had prob=
lems
operating on ARM at all, until quite recently.

> I know everyone's either busy or on vacation, but it would
> be so cool if someone could test on a more modern ARM core,
> with the userspace test code I posted it should be easy to do.

I have locked the Allwinner A10 CPU in my Mele A2000 to 60 MHz using cpufre=
q-set,
and ran your test. rnd.lzo is a 9 MB file from /dev/urandom compressed with=
 lzo.
There doesn't seem to be a significant difference between all three variant=
s.

# time for i in {1..20}; do old/unlzop < rnd.lzo >/dev/null ; done

real	0m11.353s
user	0m3.060s
sys	0m8.170s
# time for i in {1..20}; do new/unlzop < rnd.lzo >/dev/null ; done

real	0m11.416s
user	0m3.030s
sys	0m8.200s
# time for i in {1..20}; do test/unlzop < rnd.lzo >/dev/null ; done

real	0m11.310s
user	0m3.100s
sys	0m8.150s

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/=C.lUB/2VdSczshZJsDxK4.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAtLR0ACgkQTLKSvz+PZwiO5ACgiTDInffOSNH2Gi6UsYyydH53
5lwAoJB3qOltOGc3UxJgkYbOP9sfBkh9
=UjHj
-----END PGP SIGNATURE-----

--Sig_/=C.lUB/2VdSczshZJsDxK4.--
