From: Hubert Kario <hka@qbs.com.pl>
Subject: Re: btrfs RAID with enterprise SATA or SAS drives
Date: Thu, 10 May 2012 21:58:37 +0200
Message-ID: <1494795.CqqnWfNEaS@bursa22>
References: <4FAAE94D.4010103@pocock.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4FAAE94D.4010103@pocock.com.au>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 09 of May 2012 22:01:49 Daniel Pocock wrote:
> There is various information about
> - enterprise-class drives (either SAS or just enterprise SATA)
> - the SCSI/SAS protocols themselves vs SATA
> having more advanced features (e.g. for dealing with error conditions=
)
> than the average block device
>=20
> For example, Adaptec recommends that such drives will work better wit=
h
> their hardware RAID cards:
>=20
> http://ask.adaptec.com/cgi-bin/adaptec_tic.cfg/php/enduser/std_adp.ph=
p?p_f
> aqid=3D14596 "Desktop class disk drives have an error recovery featur=
e that
> will result in a continuous retry of the drive (read or write) when a=
n
> error is encountered, such as a bad sector. In a RAID array this can
> cause the RAID controller to time-out while waiting for the drive to
> respond."
>=20
> and this blog:
> http://www.adaptec.com/blog/?p=3D901
> "major advantages to enterprise drives (TLER for one) ... opt for the
> enterprise drives in a RAID environment no matter what the cost of th=
e
> drive over the desktop drive"
>=20
> My question..
>=20
> - does btrfs RAID1 actively use the more advanced features of these
> drives, e.g. to work around errors without getting stuck on a bad blo=
ck?

There are no (short) timeouts that I know of
=20
> - if a non-RAID SAS card is used, does it matter which card is chosen=
?
> Does btrfs work equally well with all of them?

If you're using btrfs RAID, you need a HBA, not a RAID card. If the RAI=
D=20
card can work as a HBA (usually labelled as JBOD mode) then you're good=
 to=20
go.

=46or example, HP CCISS controllers can't work in JBOD mode.

If you're using the RAID feature of the card, then you need to look at=20
general Linux support, btrfs doesn't do anything other FS don't do with=
 the=20
block devices.
=20
> - ignoring the better MTBF and seek times of these drives, do any of =
the
> other features passively contribute to a better RAID experience when
> using btrfs?

whatever they really have high MTBF values is debatable...

seek times do matter very much to btrfs, fast CPU is also a good thing =
to=20
have with btrfs, especially if you want to use data compression, high n=
ode=20
or leaf sizes

> - for someone using SAS or enterprise SATA drives with Linux, I
> understand btrfs gives the extra benefit of checksums, are there any
> other specific benefits over using mdadm or dmraid?

Because btrfs knows when the drive is misbeheaving (because of checksum=
s)=20
and is returning bad data, it can detect problems much faster then RAID=
=20
(which doesn't use the reduncancy for checking if the data it's returni=
ng is=20
actually correct). Both hardware and software RAID implementations depe=
nd on=20
the drives to return IO errors. In effect, the data is safer on btrfs t=
han=20
regular RAID.

Besides that online resize (both shrinking and extending) and (currentl=
y not=20
implemented) ability to set redundancy level on a per file basis.
In other words, with btrfs you can have a file with RAID6 redundancy an=
d a=20
second one with RAID10 level of redundancy in single directory.

Regards,
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
