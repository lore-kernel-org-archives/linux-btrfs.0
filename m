Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from haggis.pcug.org.au ([203.10.76.10]:37482 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab2JIWnf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 18:43:35 -0400
Date: Wed, 10 Oct 2012 09:43:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Johannes Stezenbach <js@sig21.net>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 0/3] Update LZO compression
Message-Id: <20121010094321.04047a2b5c4b692ccff12cd4@canb.auug.org.au>
In-Reply-To: <50748113.80408@oberhumer.com>
References: <cover.1349621096.git.markus@oberhumer.com>
	<20121009122614.569b9535.akpm@linux-foundation.org>
	<50748113.80408@oberhumer.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Oct_2012_09_43_21_+1100_1loXfPMpRaZOHY4M"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Signature=_Wed__10_Oct_2012_09_43_21_+1100_1loXfPMpRaZOHY4M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Markus,

On Tue, 09 Oct 2012 21:54:59 +0200 "Markus F.X.J. Oberhumer" <markus@oberhu=
mer.com> wrote:
>
> On 2012-10-09 21:26, Andrew Morton wrote:
> > On Sun, 7 Oct 2012 17:07:55 +0200
> > "Markus F.X.J. Oberhumer" <markus@oberhumer.com> wrote:
> >=20
> >> As requested by akpm I am sending my "lzo-update" branch at
> >>
> >>   git://github.com/markus-oberhumer/linux.git lzo-update
> >>
> >> to lkml as a patch series created by "git format-patch -M v3.5..lzo-up=
date".
> >>
> >> You can also browse the branch at
> >>
> >>   https://github.com/markus-oberhumer/linux/compare/lzo-update
> >>
> >> and review the three patches at
> >>
> >>   https://github.com/markus-oberhumer/linux/commit/7c979cebc0f93dc692b=
734c12665a6824d219c20
> >>   https://github.com/markus-oberhumer/linux/commit/10f6781c8591fe5fe4c=
8c733131915e5ae057826
> >>   https://github.com/markus-oberhumer/linux/commit/5f702781f158cb59075=
cfa97e5c21f52275057f1
> >=20
> > The changes look OK to me.  Please ask Stephen to include the tree in
> > linux-next, for a 3.7 merge.
>=20
> I'd ask you to include my "lzo-update" branch in linux-next:
>=20
>   git://github.com/markus-oberhumer/linux.git lzo-update

I have added this from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Wed__10_Oct_2012_09_43_21_+1100_1loXfPMpRaZOHY4M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQdKiJAAoJEECxmPOUX5FErz8P/0pHQdWcfYetE8gk6E1T0BjL
o+fqfSYrkiZ9oQN4zmlYS+IwUZ4wEaYUk53eAIFlyQuG5PxqdfEqaKOEFY28pHkA
zs1fvngNanaBP2re+ej3+WBsQfhUPXY2+bCPWOE/ta8Oo0urPXSUPG+fVrNRJK4x
gNQ2HDsfCIS6XQy74xGZMn3jig3vbTVSp/4zIXw+N4gcxRWpHmwC4dc1O8UMYB1n
9Ip3oRtwy6HowdUhjyo0jL9N2Ukguxth5p47e9naJjiBmyzOqINL/E9cPpnnfQGX
HwD+2DI4myID+dZLROkNsn4kYDnjTEoNVKgL6hh4GmGTOQU4uVDVRmx0CcPDFngD
BKguL4E0Fqjl//VmYztS+uKdC2F8Cv/FPxAu6DMsET7Jer9Jgpv2j3nVPVMiPzDl
T9UgoBeFxnz9YA4qEfLZtcEHXilLXzse3gR/XfQpw6RX1bLASI+roqrC9/KCEUO6
EW9F4as91n8cL7nJ9GW8/6Z7nO0ANFF2RYCVti9L71e1WiNhogyq7AXOZ+WKA/W3
aSHJvd2GGvuxmc6ZscBjIyaclR0X111R6XHbQydyIVc5ZNe41XetskeO5oE9lP25
oWp27Jee191uKWhMZUTT+9OptAsgoWMqFLLtVCRmguBTKb0hurz+9LHy+M0+I4Nq
NMvNjRQfBZst95q7GAdy
=btNj
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Oct_2012_09_43_21_+1100_1loXfPMpRaZOHY4M--
