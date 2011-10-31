From: Hugo Mills <hugo@carfax.org.uk>
Subject: New integration branch for btrfs-progs
Date: Mon, 31 Oct 2011 08:40:11 +0000
Message-ID: <20111031084011.GU29548@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lh1tzOZp3jg2TtWy"
Cc: Chris Mason <chris.mason@oracle.com>
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--Lh1tzOZp3jg2TtWy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   All - 

   I've put together a new integration branch based on Chris's new
master. This includes the userspace patches for qgroups, restriper,
and Josef's restore utility, plus a bunch of other things with mostly
minor impact. The shortlog is attached at the end of this email.

   As always, it's available from:

http://git.darksatanic.net/repo/btrfs-progs-unstable.git/  integration-20111030

and the gitweb address is 

http://git.darksatanic.net/cgi/gitweb.cgi?p=btrfs-progs-unstable.git;a=summary

   Could I ask that if anyone is writing patches to go in btrfs-progs,
that you base them on Chris's master (or on my for-chris branch, when
it exists). Basing patches on the integration-* branches is a bad
idea, because they get thrown away each time I make a new one, and
it's just more work for me to rebase the patches.

   Chris -- Don't pull from this directly, I'll be sending you a pull
request for a subset of the patches in a few days.

   Hugo.

Arne Jansen (1):
      btrfs-progs: add qgroup commands

Chris Mason (5):
      btrfs-progs: fixup is_mounted checks
      restore: deal with holes and set i_size correctly
      btrfs-debug-tree: add -r option to print only the roots
      btrfs-progs: add a utility to corrupt a single block
      btrfs-progs: remove old debugging statement

David Sterba (3):
      btrfs-progs: ignore -a option in mkfs
      btrfs-progs: ignore deleted loop devices
      btrfs-progs: pass correct build option for pthreads

Goffredo Baroncelli (9):
      Add the --force option.
      mkfs.btrfs man page: document the --force option.
      Ignore the error ENXIO and ENOMEDIUM during a devs scan
      Add info for the commands.
      Add the header/footer/introduction of the man page.
      helpextract: tool to extract the info for the help from the source.
      Update the makefile for generating the man page.
      Show the help messages from the info in the comment.
      Update the makefile for generating the help messages.

Hugo Mills (2):
      Regression tests
      Fix sub snap parameter handling

Ilya Dryomov (1):
      Btrfs-progs: add restriper commands

Josef Bacik (1):
      btrfs-progs: add a recovery utility to pull files from damanged filesystems

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
   --- We are all lying in the gutter,  but some of us are looking ---   
                              at the stars.                              

--Lh1tzOZp3jg2TtWy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOrl7rIKyzvlFcI40RAuuvAJ9m4zNmr5aX47auIOfOOIIsiLKwNgCg0K0Z
Ve4AYAYcTMjguz97J23C3s0=
=TVdF
-----END PGP SIGNATURE-----

--Lh1tzOZp3jg2TtWy--
