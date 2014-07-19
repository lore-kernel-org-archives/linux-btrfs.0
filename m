Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:51917 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617AbaGSUK7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 19 Jul 2014 16:10:59 -0400
Received: from marcec ([77.22.138.176]) by mail.gmx.com (mrgmx102) with
 ESMTPSA (Nemesis) id 0M03qC-1WGVLh3J6a-00uKI4 for
 <linux-btrfs@vger.kernel.org>; Sat, 19 Jul 2014 22:10:57 +0200
Date: Sat, 19 Jul 2014 22:10:51 +0200
From: Marc Joliet <marcec@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: Fw: ENOSPC errors during balance
Message-ID: <20140719221051.57378a41@marcec>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/BFGblOPVc=nL5xvKaK.lchG"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/BFGblOPVc=nL5xvKaK.lchG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



Start weitergeleitete Nachricht:
Huh, turns out the Reply-To was to Chris Murphy, so here it is again for the
whole list.

Datum: Sat, 19 Jul 2014 20:34:34 +0200
Von: Marc Joliet <marcec@gmx.de>
An: Chris Murphy <lists@colorremedies.com>
Betreff: Re: ENOSPC errors during balance


Am Sat, 19 Jul 2014 11:38:08 -0600
schrieb Chris Murphy <lists@colorremedies.com>:

> The 2nd dmesg (didn't look at the 1st), has many instances like this;
>=20
> [96241.882138] ata2.00: exception Emask 0x1 SAct 0x7ffe0fff SErr 0x0 acti=
on 0x6 frozen
> [96241.882139] ata2.00: Ata error. fis:0x21
> [96241.882142] ata2.00: failed command: READ FPDMA QUEUED
> [96241.882148] ata2.00: cmd 60/08:00:68:0a:2d/00:00:18:00:00/40 tag 0 ncq=
 4096 in
>          res 41/00:58:40:5c:2c/00:00:18:00:00/40 Emask 0x1 (device error)
>=20
> I'm not sure what this error is, it acts like an unrecoverable read error=
 but I'm not seeing UNC reported. It looks like ata 2.00 is sdb, which is a=
 member of a btrfs raid10 volume. So this isn't related to your sdg2 and en=
ospc error, it's a different problem.

Yeah, from what I remember reading it's related to nforce2 chipsets, but I
never pursued it, since I never really noticed any consequences (this is an=
 old
computer that I originally build in 2006).  IIRC one workaround is to switc=
h to
1.5gpbs instead of 3gbps (but then, it already is at 1.5 Gbps, but none of =
the
other ports are?  Might be the hard drive, I *think* it's older than the
others.), another is related to irqbalance (which I forgot about, I've just
switched it off and will see if the messages stop, but then again, my first
dmesg didn't have any of those messages).

Anyway, yes, it's unrelated to my problem :-) .

> I'm not sure of the reason for the "BTRFS info (device sdg2): 2 enospc er=
rors during balance" but it seems informational rather than either a warnin=
g or problem. I'd treat ext4->btrfs converted file systems to be something =
of an odd duck, in that it's uncommon, therefore isn't getting as much test=
ing and extra caution is a good idea. Make frequent backups.

Well, I *could* just recreate the file system.  Since these are my only bac=
kups
(no offsite backup as of yet), I wanted to keep the existing ones.  So
btrfs-convert was a convenient way to upgrade.

But since I ended up deleting those backups anyway, I would only be losing =
my
hourly and a few daily backups.  But it's not as if the file system is othe=
rwise
misbehaving.

Another random idea:  the number of errors decreased the second time I ran
balance (from 4 to 2), I could run another full balance and see if it keeps
decreasing.

--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup


--=20
Marc Joliet
--
"People who think they know everything really annoy those of us who know we
don't" - Bjarne Stroustrup

--Sig_/BFGblOPVc=nL5xvKaK.lchG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTytDQAAoJEL/Q5oYsiHj04NUP/icZGevGjfWrHNkOVSEncvrs
tftQ2W2fcmgwq9oBABCq/NfN6wbx26JvP0V/NCyyVBe+Pu/vfExvr3hrImt3U4Vf
Any26M1TI9BCiLqnFEi/o6EpZiMGFJCmrPRHSOhEt2qv/usalhEJduhNseDxU0kc
gyKdwRMCNBA+JHs8+w18NANo55Pu4l74IuDFqpgEAciPMF88fQWfjtxvCKncsJTr
K1+EPnUeAQkjBNRrgM4A1z6Zd165aKKXp0N0NO3H52qSvepY9Gb2gEv2KsDsWU0B
QVdXXvFhMVm4ypIkqgTjCGhpCrDJDDa62lgIAv652LwHsoBHPxvBJIcHbUPKF4ur
YG236ArenoYmxHXOBbo3+kWbmdKf+ZK+SiGQOtV3gVpR5U7kfSpE7xC0SvwAyEa7
OWyNdDnUelE+VOVc734Mn5IF6H8mTloLF5HcHBb9H8QCTn+TKwxB8eich0bdRciC
1JO1/sHG7rR2NsvEScZtfcVQ7tfAhrU/CrAnokt2+/Y9tWUPFX4aRLsd/+7Vm7oZ
AHZsewpzTUd4j8r3JOaUf76M4i7Egv/kuDZDnx+YZx023wZgwM2WA16wRSqPKYpd
gauCajmQCOofDfghfZjB/nnByVBiJu3xhA8hdrU64NYXOH1F7l2jz1rRd0f42P5a
3bQA2XArp9qjfoyDC6dp
=Dl8f
-----END PGP SIGNATURE-----

--Sig_/BFGblOPVc=nL5xvKaK.lchG--
