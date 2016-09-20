Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47545 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbcITITb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 04:19:31 -0400
Date: Tue, 20 Sep 2016 08:19:28 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: stability matrix (was: Is stability a joke?)
Message-ID: <20160920081928.GP7138@carfax.org.uk>
References: <20160912142714.GE16983@twin.jikos.cz>
 <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
 <20160912165107.GG16983@twin.jikos.cz>
 <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com>
 <20160915010759.GD32452@DigitalMercury.dynalias.net>
 <5dec6544a78a0301a8e0cd9086179f99@crc.id.au>
 <1473905644.8603.44.camel@scientia.net>
 <20160919152753.GG933@twin.jikos.cz>
 <1474314346.10189.19.camel@scientia.net>
 <pan$9faa9$336f6d31$1fa59209$17e07862@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TN8pJM9vJMHHFgJc"
In-Reply-To: <pan$9faa9$336f6d31$1fa59209$17e07862@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--TN8pJM9vJMHHFgJc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 20, 2016 at 07:59:44AM +0000, Duncan wrote:
> Christoph Anton Mitterer posted on Mon, 19 Sep 2016 21:45:46 +0200 as
> excerpted:
>=20
> > On Mon, 2016-09-19 at 17:27 +0200, David Sterba wrote:
> >=20
> >> > For specific features:
> >> > - Autodefrag
> >> > =A0 - didn't that also cause reflinks to be broken up?
> >>=20
> >> No and never had.
> >=20
> > Absolutely sure? One year ago, I was told that at first too so I started
> > using it, but later on some (IIRC) developer said auto-defrag would also
> > suffer from it.
>=20
> AFAIK it was Hugo that said he looked into that, and that (if I'm=20
> representing it correctly) autodefrag breaks reflinks and triggers space-
> using duplication much as defrag does, but that it does it on a much=20
> smaller scale, since it (1) only triggers when some parts of a file are=
=20
> being rewritten anyway, thus breaking the reflink for those specific=20
> parts of the file due to COW (COW1 on otherwise NOCOW files) in any case,=
=20
> and (2) unlike defrag, doesn't rewrite and thus break the reflinks on=20
> entire files, just somewhat larger extents than the pure rewrite by=20
> itself without autodefrag would.
>=20
> Thus making the reflink-breaking and duplication effect of autodefrag=20
> there, but relatively quite small compared to on-demand per-file defrag.

   I didn't investigate it -- It was my firmly-stated misunderstanding
which caused someone (Filipe, I think) with much more actual knowledge
to correct me, thus making the actual behaviour much clearer. :)

   I think your description is accurate as far as my current
understanding goes.

   Hugo.

> --=20
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Hugo Mills             | There isn't a noun that can't be verbed.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--TN8pJM9vJMHHFgJc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJX4PEQAAoJEFheFHXiqx3kEfwQALeuYXABujpDnfyEWCD+ZCGj
bIa2UnJIrE3qKrLPMIOrrb1+fOLsb00kWE1Kkk4M4lHjNC+D263SAsq4PN6CKL1x
hbKze3xQZDlhKaJYfOc4TAq06BcRuQxJZJGYu2t17jFoGBEh05VBJr/suQzyFq/c
ZnKjTAVJVg8QJiq6ptl7hsoN2/WE1wRah9/8pslTQZa3hIIGCrP3U2yZcAL7ucy4
UEyUPZJn8hUYzocozLICeum7Bw/nPy4yFKMeQKV3EYXRKVORVY4NAtMua8IHe72S
u1z8l91KJNExpNgDjqltzBR8iUgtS16oJ8gnQdLsFSnfrHUuraS0bPQBNFJKkZ5I
eCQG0AdIa8mmWLtbTamMORPPUl2/dmkezZbXTIyI6atyIfiAqvL2nZ05n/uHpR8k
5g5z9DmE25/NeEwIun2EJzHLzS+jQhRfGaY4+YDjEJ+QmbmVEgN9m3KSURSilLAw
+Sse0xNkr3sysKEPTc7bfP77/F5XxTpC6xmffVtAXBxtjVq0QhkrVo9/2srWND7z
XWXc/QnGnFQwTw7ywG1MXO8RWjxw99zWOhlvj5f7bSGNM2XXfYjuH2booV0RNbOK
mRNs8yZISYlkbmUymi4CWQili245Cu+bf2WWEY285tS4033x8flSBQ1nPVTVBTre
HzTG4X/E2qa5w2WcEUP9
=N2yW
-----END PGP SIGNATURE-----

--TN8pJM9vJMHHFgJc--
