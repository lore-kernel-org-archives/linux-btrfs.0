From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Online resize vs ENOSPC
Date: Mon, 9 Mar 2009 10:31:41 +0000
Message-ID: <20090309103141.GA5335@vlad.carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   After an online resize, the filesystem reports its new size, but
still runs out of space at the old size:

Mar  9 08:12:59 vlad kernel: no space left, need 4096, 380928 delalloc bytes, 51509866496 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use51510247424 total
[...]
Mar  9 08:14:21 vlad kernel: no space left, need 4096, 0 delalloc bytes, 51510247424 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use51510247424 total

hrm@vlad:~ $ df -h
Filesystem            Size  Used Avail Use% Mounted on
[...]
/dev/mapper/media-scratch
                       70G   48G   23G  68% /media/vlad/video/video

   This was online resized from 50G to 70G, using:

$ sudo lvresize media/scratch -L 70G
$ sudo btrfsctl -r 70G /media/vlad/video/video

   Version numbers:

$ btrfsctl
[...]
Btrfs v0.18-ge3b0f66
$ uname -a
Linux vlad 2.6.29-rc7 #1 Fri Mar 6 23:32:13 GMT 2009 x86_64 GNU/Linux

   Unmounting and remounting the filesystem seems to make the new
space available for use again.

   This is the second time I've had this happen to me now, so it seems
to be more-or-less reproducible, although I haven't deliberately tried
to trigger the behaviour yet.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Klytus! Are your men on the right pills? Maybe you should ---    
                         execute their trainer!                          

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJtPANIKyzvlFcI40RAsLpAJ9QRmuM7P0b3ceFjT699oJJMXpNYACeNvz5
Ty4O6/brH8OFlR22EtwwB1A=
=4KKo
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
