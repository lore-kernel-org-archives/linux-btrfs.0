Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47691 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819AbbIWN2c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 09:28:32 -0400
Date: Wed, 23 Sep 2015 13:28:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: dsterba@suse.cz,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
Message-ID: <20150923132827.GM5918@carfax.org.uk>
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com>
 <5601596B.1020607@googlemail.com>
 <20150922134131.GH5918@carfax.org.uk>
 <20150922142333.GH12815@twin.jikos.cz>
 <20150922143602.GI5918@carfax.org.uk>
 <20150923131226.GA12815@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FxlYARId5dseejUu"
In-Reply-To: <20150923131226.GA12815@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FxlYARId5dseejUu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 23, 2015 at 03:12:26PM +0200, David Sterba wrote:
> On Tue, Sep 22, 2015 at 02:36:02PM +0000, Hugo Mills wrote:
> > > Yeah, right now there's no persistent default for the allocator. I'm
> > > still hoping that the object properties will magically solve that.
> > 
> >    There's no obvious place that filesystem-wide properties can be
> > stored, though. There's a userspace tool to manipulate the few current
> > FS-wide properties, but that's all special-cased to use the
> > "historical" ioctls for those properties, with no generalisation of a
> > property store, or even (IIRC) any external API for them.
> 
> From the UI point, we proposed to add a specifier that would route the
> property to either subvolume or the filesystem:
> 
> $ btrfs prop set -t filesystem bgtype raid0
> $ btrfs prop set -t subvolume bgtype raid1
> 
> How this will get stored in the xattrs is another question. As there's
> always only single instance of the filesystem properties, it coud be
> something like 'btrfs.fs.bgtype' and be stored as a xattr of the
> toplevel subvolume.

   That's what Austin suggested as well. Makes sense to me.

   Hugo.

-- 
Hugo Mills             | 2 + 2 = 5, for sufficiently large values of 2.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--FxlYARId5dseejUu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWAqj7AAoJEFheFHXiqx3ku3cQALZi+mpra0ebLgQU4zYuBdW5
AmsU8BTgKtvw2PCrgmqcsRHXx8cw1HysChdgNfNvOutpT4iY35sd1POlxudZVLjF
CxPl3S8ti5t7gMqp5/V7VN7D61e9njXOudx+D8bgCJtLHR1ZzgqZLE3iniuTS+lo
izt1TvQdQm032Xf8NKWzxcpTD7wLg1DTuFUXCh1oCa5mRrRa9KI6V+26RNFyIvzU
DgMHIuhNURzbcncvYTODRPtQ2dP/SFwc7ll4M2xMilHK+v0bkiySk3b35HIiclXM
awdSLeL2uQAB4FlclUUkzaiXBkupnPscDu2U6Xpxadkod5YL+lSpkiZ3HzNgaK41
H8RurJgv5dpikEiXW0nbZvZwWxXDGL1LTZeAvd6CCQNcyr6ZxDKgafstUPt0WTdB
YwV/oidS/N86xLyZtBlYSemzNg3431fTGTcex7cvXCBNhQtm2JoMPfNxoQN209CN
TcWzo8+T55MYg32tRErkAtisjnzQSAETxxYD41xZvY7l8O8I9ZROm6zGGIevdMyC
g3GrqwMDeQsOf+XMd7dbahX1OgXXD1ewt5KYPgIb4PH9XWzcdWlbg7h/hh15muPm
1wovL0sbQpT7/ChCzef3UvmzkJDVPmCfKUGMGytQdsd+AJAB/7C7jPkdslvOJHdu
oeNpnEaIWhP05MTZdlp+
=D9l3
-----END PGP SIGNATURE-----

--FxlYARId5dseejUu--
