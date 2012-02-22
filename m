From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: Balance RAID10 with odd device count
Date: Wed, 22 Feb 2012 11:22:08 +0100
Message-ID: <1591210.klPCAKoV0g@bursa22>
References: <CA+Huu1H9WAiRH203N60XVRAHE1oBx_Bh9DTcshbJ280jYvG+kA@mail.gmail.com> <20120221075422.GG5350@carfax.org.uk> <20120222085627.GS30450@jeru.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: Hugo Mills <hugo@carfax.org.uk>, tom@drdabbles.us,
	Gareth Pye <gareth@cerberos.id.au>, linux-btrfs@vger.kernel.org
To: nicollet@jeru.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120222085627.GS30450@jeru.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 22 of February 2012 09:56:27 Xavier Nicollet wrote:
> Le 21 February 2012 ? 07:54, Hugo Mills a =E9crit:
> >    Some time ago, I proposed the following scheme:
> > <n>C<m>S<p>P
> >=20
> >    where n is the number of copies (suffixed by C), m is the number=
 of
> >=20
> > stripes for that data (suffixed by S), and p is the number of parit=
y
> > blocks (suffixed by P). Values of zero are omitted.
> >=20
> >    So btrfs's RAID-1 would be 2C, RAID-0 would be 1CnS, RAID-5 woul=
d
> >=20
> > be 1CnS1P, and RAID-6 would be 1CnS2P. DUP would need a special
> > indicator to show that it wasn't redundant in the face of a whole-d=
isk
> > failure: 2CN
>=20
> Seems clear. However, is the S really relevant ?
> It would be simpler without it, wouldn't it ?

It depends how striping will be implemented. Generally it provides=20
information on how much spindles is the data using. With static=20
configuration it will be useless, but when you start changing number of=
=20
drives in set then it's necessary to know if you're not under- or over-
utilising the disks.
--=20
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawer=F3w 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
