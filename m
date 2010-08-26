From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: 2.6.36-rc1 btrfs still unstable
Date: Fri, 27 Aug 2010 00:45:51 +0200 (CEST)
Message-ID: <31081717.109.1282862751167.JavaMail.root@zimbra>
References: <201008170025.47510.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: "Morten P.D. Stevens" <mstevens@imt-systems.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org, Chris Ball <cjb@laptop.org>
To: diegocg@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201008170025.47510.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> On Lunes, 16 de Agosto de 2010 17:45:29 Chris Ball escribi=C3=B3:
> >    Note that Btrfs does not yet have a fsck tool that can fix
> >    errors.
> >    While Btrfs is stable on a stable machine, it is currently
> >    possible
> >    to corrupt a filesystem irrecoverably if your machine crashes or
> >    loses power. This will be fixed when the fsck tool is ready.
>=20
> But doesn't this happen only with cheap disks that don't honour
> barriers
> correctly?

Even with cheap drives, a filesystem shouldn't die. With stuff like ZFS=
, you can use all sorts of crap and still live with it. Btrfs should fo=
llow that track.

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
