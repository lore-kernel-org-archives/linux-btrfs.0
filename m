From: Hugo Mills <hugo@carfax.org.uk>
Subject: Announcing btrfs-gui
Date: Thu, 2 Jun 2011 00:20:58 +0100
Message-ID: <20110601232058.GA22619@carfax.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Over the last few weeks, I've been playing with a foolish idea,
mostly triggered by a cluster of people being confused by btrfs's free
space reporting (df vs btrfs fi df vs btrfs fi show). I also wanted an
excuse, and some code, to mess around in the depths of the FS data
structures.

   Like all silly ideas, this one got a bit out of hand, and seems to
have turned into something vaguely useful. I'm therefore pleased to
announce the first major public release of btrfs-gui[1]: a point-and-
click tool for managing btrfs filesystems.

   The tool currently can scan for and list btrfs filesystems and the
volumes they live on. It can show the allocation and usage of data in
a selected filesystem, categorised by use, replication, and device. It
can show and manipulate subvolumes and snapshots: creation, deletion,
and setting the default. For those with servers to manage, it also has
the ability to ssh into a remote machine, and manage its filesystems
remotely (so you don't have to have X installed on your servers just
to use btrfs-gui on them).

   You can get the latest version from git[2] (or gitweb[3]), or
tarball download of the sources from [4]. To install and run the GUI,
you will need python3 and the python tk libraries (package python3-tk
on my Debian system). The root helper component (which can be
installed independently on an X-less server) will run under python2 or
python3, depending on how it's installed. Installation instructions
can be found on the main web page, and in the README file.

   Unless the traffic gets too high-volume, or unless someone
important objects, I'm going to suggest that bug reports should go to
this list for now (cc'd me, if you like). Note that this isn't an
"offical" btrfs project -- it's just something I knocked together on
my own.

   Finally, I'd like to thank David Sterba for testing the pre-release
versions, reporting bugs, and making many good suggestions for
improvements. Any deviation from his instructions is entirely my
fault. :)

   Hugo.

[1] http://carfax.org.uk/btrfs-gui/
[2] http://git.darksatanic.net/repo/btrfs-gui.git/
[3] http://git.darksatanic.net/cgi/gitweb.cgi?p=btrfs-gui.git;a=summary
[4] http://carfax.org.uk/node/79

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
      --- Great oxymorons of the world, no. 7: The Simple Truth ---      

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFN5slaIKyzvlFcI40RAtp0AJ9cY5MFTFpZVHIWsuSZTGMf6J8WOACdH96P
9W+9w9MQrC6SPQfeyT/W+B8=
=lP1s
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
