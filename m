From: TAXI <taxi@a-city.de>
Subject: FS Errors with 2.6.37
Date: Mon, 28 Feb 2011 08:30:38 +0100
Message-ID: <20110228083038.18d56790@schlepptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1E16CzvVukCmTWi/0sXONWb"; protocol="application/pgp-signature"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/1E16CzvVukCmTWi/0sXONWb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,
I updated my kernel from 2.6.36 to 2.6.37 today but now I can't boot
anymore. The kernel sends BUG messages for BTRFS and couse of
that different services won't start correctly. Which services are
affected seems to chance from boot to boot and at the end the computer
hangs and my only change to reboot is using MagicSysRQ. I could save
the output of dmesg after one boot (which was hard couse the time I can
log me in and do things till the system hangs is short). Also when I'm
using magicSysRQ for syncing/unmounting partitions the BUG messages are
looping a few seconds.

Here is the relevant part of dmesg: http://pastebin.com/ideNvhBH
And (if needed) the full dmesg: http://pastebin.com/xDEct6TZ
The dmesg after booting with 2.6.36: http://pastebin.com/puT6Wx0v
The output of btrfsck: http://pastebin.com/9HbkVwLf
And a (bad quality) image of the (end of the) message when using
MagicSysRQ: http://img17.imageshack.us/img17/6895/dsc01892ja.jpg

I can still boot with the old 2.6.36 kernel.
Is there any way to access my data correctly with the 2.6.37 kernel?

P.S. Sorry for my bad english. :)

--Sig_/1E16CzvVukCmTWi/0sXONWb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Public Key: http://tinyurl.com/34e7nuv

iQEcBAEBAgAGBQJNa08kAAoJEKLAseaYKARoSTIH/0iijDfth6q4r+e0WbJq/8CM
pQb8i7Amk8gCxB3hfpDdWU2uHxFDpjoAJSmFMAVJu5XdkLAIcGP/RGwIdputlkmD
PQV0x9NvX7/TplC3zlY16SzABjuWQP0+qdNXB9If5xV7JwfisJYj8JkwneFIkBzC
wxZwj5MCd2cLZm6sII1qTveFWNUl+7zvhkKlPkEgHo/9sucgD6+uQgB2xqRTAcEQ
dyKGZNMooL55xsgamFKRYbwYa4nqc5a6Y1AkMfI8ZkkM5f5VSQ3/6gMvPqRnz61a
QWw7UtngiMEjHUpqpvdjfpE18t8JLzdHllsIKETHPyrJ+b5cZUMu6emv1YhQDY8=
=ZwsW
-----END PGP SIGNATURE-----

--Sig_/1E16CzvVukCmTWi/0sXONWb--
