From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: A couple of questions
Date: Wed, 2 Jun 2010 18:19:26 +0200
Message-ID: <201006021819.26668.hka@qbs.com.pl>
References: <201005271539.55644.paul.millar@desy.de> <201005271656.00398.hka@qbs.com.pl> <201005311959.47212.paul.millar@desy.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Paul Millar <paul.millar@desy.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201005311959.47212.paul.millar@desy.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 31 May 2010 19:59:46 Paul Millar wrote:
> Hi Hubert,
>=20
> On Thursday 27 May 2010 16:56:00 Hubert Kario wrote:
> > > Would [obtaining file checksum] be possible (without an awful lot
> > > of work)?
> >=20
> > [Calculating checksum in-memory]  won't detect in-memory corruption
> > though, but if you want to be resilant to this, you should be looki=
ng at
> >=20
> >  ECC RAM as subsequent checks can be affected by it to.
>=20
> Certainly ECC RAM will help, but unfortunately it doesn't remove the
> possibility of corruption; for example, CERN found [1] that double-bi=
t
> memory corruptions (which ECC cannot recover from) can still happen.
>=20
> [1]
> http://indico.cern.ch/getFile.py/access?contribId=3D3&sessionId=3D0&r=
esId=3D1&mat
> erialId=3Dpaper&confId=3D13797
>=20
> Also, IIRC there was a case where Fermilab tracked down a data corrup=
tion
> to a faulty PCI bus in the server.  So who knows where are all the pl=
aces
> corruption could occur?
>=20
> I guess the real problem is that, when processing large amounts of da=
ta,
> these rare occurrences start to stack up.
>=20

Yes, but AFAIK btrfs checksums don't have internal checksum (e.g. you c=
an't=20
check if the read checksum is a valid one or not, it does not have cont=
rol=20
bits), as such, if you consider PCI bus corruption as likely, you still=
 don't=20
get 100% certanity that the data reached the HDD unharmed.

If you need such level of certanity when recording data, I'd consider=20
mainframe hardware and/or duplicating whole storage stack.

Cheers,
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=C3=B3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl

System Zarz=C4=85dzania Jako=C5=9Bci=C4=85
zgodny z norm=C4=85 ISO 9001:2000
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
