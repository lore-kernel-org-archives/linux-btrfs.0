From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: remote mirroring in the works?
Date: Mon, 30 Aug 2010 19:59:23 +0200 (CEST)
Message-ID: <29385727.6.1283191163871.JavaMail.root@zimbra>
References: <4C7BF087.6060400@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org, Fred van Zwieten <fvzwieten@gmail.com>
To: "K. Richard Pixley" <rich@noir.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C7BF087.6060400@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

> I think drbd does precisely what you want.
>=20
> It's not useful for fault tolerance, nor for load balancing, but it
> will
> produce a remote block copy that can be used as a sort of "hot
> backup".

drbd with heartbeat/pacemaker can provide fault tolerance...

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
