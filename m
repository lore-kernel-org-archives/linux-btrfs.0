From: Adrian von Bidder <avbidder@fortytwo.ch>
Subject: Re: task imap:2958 blocked for more than 120 seconds
Date: Mon, 11 Jan 2010 08:34:36 +0100
Message-ID: <201001110834.36865@fortytwo.ch>
References: <201001102105.47192.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3876765.vYeTiJJ8uA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001102105.47192.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

--nextPart3876765.vYeTiJJ8uA
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sunday 10 January 2010 21.05:46 Johannes Hirte wrote:
> I've observed this hanging task now several times. Not sure when this
>  started, but 2.6.32 is affected too, IIRC. I don't have a test pattern
>  for this. Dovecot imap triggers this from time to time. I've enabled
>  CONFIG_DETECT_HUNG_TASK now and got this two tasks which hang:

I've had vey similar hangs occasionally; don't remember if they were the=20
exact same code path or not.

"btrfs-vol -b" on an 2T btrfs fs (raid 1 mode over 4 disks) on an arm CPU=20
has triggered it several times, so it seems a reliable way to reproduce=20
this.

Unfortunately log rotation has already killed the messages.  Do you want me=
=20
to re-run?  2.6.32 kernel, btrfs-progs from git about 4 weeks ago.


cheers
=2D- vbi


=2D-=20
Place stamp here.

--nextPart3876765.vYeTiJJ8uA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: get my key from http://fortytwo.ch/gpg/92082481

iKcEABECAGcFAktK1IxgGmh0dHA6Ly9mb3J0eXR3by5jaC9sZWdhbC9ncGcvZW1h
aWwuMjAwMjA4MjI/dmVyc2lvbj0xLjUmbWQ1c3VtPTVkZmY4NjhkMTE4NDMyNzYw
NzFiMjVlYjcwMDZkYTNlAAoJECqqZti935l6SmwAoLEaqUxh+lKv6XodLxZMuiZ4
tyB+AJ4i+xIr0xINN56M3T29ZfIgD664HA==
=0lwA
-----END PGP SIGNATURE-----

--nextPart3876765.vYeTiJJ8uA--
