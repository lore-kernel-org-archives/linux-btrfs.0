From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Poor performance (1/4 that of XFS) when appending to lots of
 files
Date: Tue, 8 Jun 2010 09:53:48 +0200 (CEST)
Message-ID: <13074499.131.1275983628404.JavaMail.root@zimbra>
References: <huj87q$8ov$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Peter Niemayer <niemayer@isg.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <huj87q$8ov$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

----- "Peter Niemayer" <niemayer@isg.de> skrev:

> Hi,
>=20
> we ran a benchmark using btrfs on a server that essentially does
> the equivalent of the following:
>=20
> Open one large (25GB) test-set file for reading, which consists of
> many
> small randomly generated messages. Each message consists of a
> primary key (an integer in the range of 0 to 1,000,000) and a random
> number of arbitrary data bytes (length in the range from 10 to 1000
> byte).
> <snip/>

Can you share the code for this benchmark, please?

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
