From: Dave <dave@thekilempire.com>
Subject: Re: [RFC] btrfs auto snapshot
Date: Wed, 17 Aug 2011 10:04:33 -0400
Message-ID: <20110817140433.GA32261@hendrix.borisch.local>
References: <4E4B2452.9070407@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4B2452.9070407@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I've already done something similar.  I take hourly, daily, weekly, and mon=
thly
snapshots of my /home subvolume.  Here's the script I've created for this:

#! /bin/bash

if [ "$#" -ne 2 ]; then
   echo Usage $0 SNAPSHOT_PREFIX NUM_SNAPSHOTS
   exit 1
fi

SNAPS=3D/var/lib/btrfs-root/__snapshot/home

btrfs subvolume snapshot -r /home $SNAPS/$1_$(date +%F_%T.%N)

num_snaps=3D$(ls -1d $SNAPS/$1_* | sort | wc -l)

if [ "$num_snaps" -gt "$2" ]; then
   let over=3D$num_snaps-$2
   ls -1d $SNAPS/$1_* | head -n $over | while read s; do
      btrfs subvolume delete $s
   done
fi


Here's my crontab:
0 * * * * /usr/local/bin/snapshot hourly 6
0 0 * * * /usr/local/bin/snapshot daily 7
0 0 * * 0 /usr/local/bin/snapshot weekly 4
--=20
-=3D[dave]=3D-

Entropy isn't what it used to be.

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iF4EAREIAAYFAk5LynEACgkQXM0u5ajNnChXZAD7Bte+oFB8tN0N9vvJ/dAjnZKF
GhD/drCjinLFQmD76AkA/1edfqnkzbVuFO+8yiMH3e+DF0cjw+cdBs2Z4bCXZDsK
=oZvL
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
