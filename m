From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: remote mirroring in the works?
Date: Mon, 30 Aug 2010 19:33:44 +0200 (CEST)
Message-ID: <8525090.4.1283189624753.JavaMail.root@zimbra>
References: <AANLkTimBVG3eGHvNUHFGYri+JyOXrOW91GKWeM_GVOYM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Fred van Zwieten <fvzwieten@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimBVG3eGHvNUHFGYri+JyOXrOW91GKWeM_GVOYM@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

----- Original Message -----
> Hi there,
>=20
> I would like to know if there is something functionally equivalent to
> NetApp's SnapMirror in the works or planning? It would require block
> level access to a snap and the ability to rebuild (subvolumes
> including it's) snap's on another machine.
>=20
> If not, what would be the best way to build something more or less
> equivalent using existing tools? rsync-ing a snap seems the same, but
> it isn't. First of all it 's file based, not very nice for DB's, and
> you don't get the snap's on "the other side" the same.

Perhaps DRBD - see http://www.drbd.org/ - that'll mirror the block devi=
ce(s) on which btrfs resides.

Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 97542685
roy@karlsbakk.net
http://blogg.karlsbakk.net/
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med fremmed opprinnelse. I de fleste ti=
lfeller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
