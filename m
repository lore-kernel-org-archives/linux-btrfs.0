Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:32796 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756365AbdIHPiR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Sep 2017 11:38:17 -0400
Date: Fri, 8 Sep 2017 15:38:16 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: test if a subvolume is a snapshot?
Message-ID: <20170908153816.GD23980@carfax.org.uk>
References: <20170908085446.GA7876@rus.uni-stuttgart.de>
 <20170908131035.GO31874@twin.jikos.cz>
 <CABB28Cz6wb0gvFF3sAUG5fw2JfgiB3KGGKfzOwAW0_2xBRcEFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EP0wieDxd4TSJjHq"
In-Reply-To: <CABB28Cz6wb0gvFF3sAUG5fw2JfgiB3KGGKfzOwAW0_2xBRcEFQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--EP0wieDxd4TSJjHq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 08, 2017 at 04:25:55PM +0100, Tomasz K=C5=82oczko wrote:
> On 8 September 2017 at 14:10, David Sterba <dsterba@suse.cz> wrote:
> > On Fri, Sep 08, 2017 at 10:54:46AM +0200, Ulli Horlacher wrote:
> > > How can I test if a subvolume is a snapshot?
> >
> > The inode number is 256 on a btrfs filesystem:
> >
> > if [ stat -f --format=3D%T $path =3D btrfs -a stat --format=3D%i $path =
=3D 256 ]; ...
>=20
> This oneliner shows how much really basic btrfs tools commands syntax
> is broken by design :(
> Looking on how so freakishly overcomplicated btrfs command syntax is
> that command like above is completely unintuitive and unreadable

   This is nothing to do with btrfs tooling. The two commands involved
here are test (aka "[") and stat.

> sometimes I'm really thinking about start rewrite btrfs-progs to make
> btrfs basic tools syntax as similar as it is only possible to ZFS zfs,
> zpool and zdb commands on using which in +90% cases you can guess how
> necessary syntax must look like without looking on man pages.
>=20
> Any volunteers want to join to help implement something like this?
> Maybe someone already started doing this?

   The main complaint that can be directed at the btrfs command is
that its output is rarely machine-processable. It would therefore make
sense to have a "--table" or "--structured" mode for output, which
would be more trivially parsable by shell tools.

   Hugo.

--=20
Hugo Mills             | Ceci est un travail pour l'Australien.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                 Louison, Delicates=
sen

--EP0wieDxd4TSJjHq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZsrloAAoJEFheFHXiqx3kzVkP/jASmFKBzFa+KOVB6l/WJ2wk
tnlrx9hg+B5+pM62fgs5TiwVn64QBzEH8bofhUjLaTF5yAKOUz8wclvAp0ASnB9V
wjp5dirslwot7+fwuyGGd5SqpgHgOtjeJHgizKY4f6PyMHISZUKAV9MrsbOoMmFa
vXN7+7sSfbY3KkAzvm8fTc5sQpH0NVaKZInZAL3s3tA2OiPcS5K+xVr9ohDpJEOC
EvYUFp3M/JOdgUS7MsK0bS0/P8k/XaAx68UGlbmZ9Bpl/zYmEsS7QCMdf6qrzqFX
cIKlDSoHJjOk7Oe/AcOyR7uXu3QRz1Or+30nHH0j3UNLfyPpIszunpoz3tsS3+kM
wO5/4q+6fsuCNHw+iEEODlBB1/eCGgTEing+BwLJDh1Z/6U23C8PiLgEncay8RtI
4ImgxyP+0cmLjb6eCvZEQGj2CTIisAXZK1uoF1ys6DpF1AIzTY8cwK5YVDG82lrt
Rl3Kr3C8bplQKtivG070WqZJWAKypEytdK9qTD5hQett76WHZl3uGE7qnlA0DTf7
bAcBssQGQM6KMLJYiLrs2fjT97A0wyNg98tmcdECeloIltXoMLyB96ozMIbEp6zo
PNifLLcdfR5fUE72jQedByXFVH+hdH6L17zzzp2ro1Bn1No37DUQ6QDYHtEL6bf/
27kRWPVk6qpWVJ6rxayk
=tJoP
-----END PGP SIGNATURE-----

--EP0wieDxd4TSJjHq--
