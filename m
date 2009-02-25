From: Thomas Kuther <gimpel@sonnenkinder.org>
Subject: Re: questions about GRUB and BTRFS
Date: Wed, 25 Feb 2009 19:19:44 +0100
Message-ID: <20090225191944.532a3a0f@gimpel.ath.cx>
References: <a3a222ba714187fedfe43fe9f7086242@smtp.arbitraryconstant.com>
 <3a7f57190902241753s6738fcdl1b7573dcbf23e151@mail.gmail.com>
 <49A4DF3D.90206@cs.drexel.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gFRCMqWU4CSqEflc_iHllRO";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49A4DF3D.90206@cs.drexel.edu>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/gFRCMqWU4CSqEflc_iHllRO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mi, 25.02.09 01:03 Lee Trager <lt73@cs.drexel.edu> wrote:

> I'm not sure when we should start developing BTRFS support for GRUB
> but I do agree that it will be very difficult to support all the
> features of BTRFS.  As far as I know GRUB does not support LVM and
> only supports RAID1. Doing this shouldn't be that hard to do, in fact

GRUB2 maybe?

Using trunk I see things like

/lib64/grub/i386-pc/lvm.mod
/lib64/grub/i386-pc/ext2.mod
/lib64/grub/i386-pc/reiserfs.mod
and
/lib64/grub/i386-pc/raid.mod


...which a grub-install will copy to /boot/grub

I haven't tested those though.

--Sig_/gFRCMqWU4CSqEflc_iHllRO
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkmli8QACgkQMQFfAqZTGfzwAACfRZyc6fDXT4y6ACk5RCelLRFq
WCwAoIVy3yI7I3Uw+eIC40kENh74jGXD
=nnDa
-----END PGP SIGNATURE-----

--Sig_/gFRCMqWU4CSqEflc_iHllRO--
