From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: 2.6.36-rc1 btrfs still unstable
Date: Fri, 27 Aug 2010 00:48:00 +0200 (CEST)
Message-ID: <12380554.111.1282862880731.JavaMail.root@zimbra>
References: <20100826085801.GQ1344@jeru.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: nicollet@jeru.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100826085801.GQ1344@jeru.org>
List-ID: <linux-btrfs.vger.kernel.org>

> Le 25 ao=C3=BBt 2010 =C3=A0 18:57, Johannes Hirte a =C3=A9crit:
> > > the other big question is:
> > > Is btrfs with 2.6.36 really rockstable and ready to use in
> > > productive environments?
> >
> > I don't think so. There is at least one checksum bug and ENOSPC
> > problems are also still present.
>=20
> I am planning to put 2 dedicated web hosting servers in production
> (backuped every day), with 2.6.34.5 vanilla kernel.
>=20
> I also use btrfs on a 2.6.34 kernel on the backup server (rsync) for
> some time.

IMHO using btrfs in production is like playing Russian roulette - it mi=
ght work and can be benifitable, but then, there's another side of the =
coin...

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
