From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: efficiency of btrfs cow
Date: Sun, 06 Mar 2011 10:46:20 -0500
Message-ID: <il0a8d$4ev$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB9E7E40CC27F433208E47717"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB9E7E40CC27F433208E47717
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I have a backup volume on an ext4 filesystem that is using rsync and
it's --link-dest option to create "hard-linked incremental" backups.  I
am sure everyone here is familiar with the technique but in case anyone
isn't basically it's effectively doing (each backup):

# cp -al /backup/previous-backup/ /backup/current-backup
# rsync -aAHX ... --exclude /backup / /backup/current-backup

The shortcoming of this of course is that it just takes 1 byte in a
(possibly huge) file to require that the whole file be recopied to the
backup.

btrfs and it's CoW capability to the rescue -- again, no surprise to
anyone here.

So I replicated a few of the directories in my backup volume to a btrfs
volume using snapshots for each backup to take advantage of CoW and with
any luck, avoid entire file duplication where only some subset of the
file has changed.

Overall, it seems that I saw success.  Most backups on btrfs were
smaller than their source, and overall, for all of the backups
replicated, the use was less.  There were some however that were
significantly larger.  Here's the analysis:

  Backup      btrfs  ext4
  ------      -----  ----
monthly.22:  112GiB 113GiB  98%
monthly.21:   14GiB  14GiB  95%
monthly.20:   19GiB  20GiB  94%
monthly.19:   12GiB  13GiB  94%
monthly.18:    5GiB   6GiB  87%
monthly.17:   11GiB  12GiB  92%
monthly.16:    8GiB  10GiB  82%
monthly.15:   16GiB  11GiB 146%
monthly.14:   19GiB  20GiB  94%
monthly.13:   21GiB  22GiB  96%
monthly.12:   61GiB  67GiB  91%
monthly.11:   24GiB  22GiB 106%
monthly.10:   22GiB  19GiB 114%
 monthly.9:   12GiB  13GiB  90%
 monthly.8:   15GiB  17GiB  91%
 monthly.7:    9GiB  11GiB  87%
 monthly.6:    8GiB   9GiB  85%
 monthly.5:   16GiB  18GiB  91%
 monthly.4:   13GiB  15GiB  89%
 monthly.3:   11GiB  19GiB  62%
 monthly.2:   29GiB  22GiB 134%
 monthly.1:   23GiB  24GiB  94%
 monthly.0:    5GiB   5GiB  94%
     Total:  497GiB 512GiB  96%

btrfs use is a calculation of the "df" value of the fileystem before and
after each backup.  ext4 (rsync, really) use is calculated with "du
-xks" on the whole backup volume, which as you know only counts a
multiply hard-linked file's space use once.

So as you can see, for the most part, btrfs and CoW was more efficient,
but in some cases (i.e. monthly.15, monthly.11, monthly.10, monthly.2)
it was less efficient.

Taking the biggest anomaly, monthly.15, a du of just that directory on
both the btrfs and ext4 filesystems shows results I would expect:

btrfs: 136,876,580 monthly.15
ext4:  142,153,928 monthly.15

Yet the before and after "df" results show the btrfs usage higher than
ext4.  Is there some "periodic" jump in "overhead" used by btrfs that
would account for this mysterious increased usage in some of the copies?

Any other ideas for the anomalous results?

Cheers,
b.


--------------enigB9E7E40CC27F433208E47717
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk1zrEwACgkQl3EQlGLyuXAU1QCg2FkA943FGNXGBEVzELLzfgc3
LuwAoO5Gu7DCgx4Bce56tcwUJ47qMKcW
=uWCj
-----END PGP SIGNATURE-----

--------------enigB9E7E40CC27F433208E47717--

