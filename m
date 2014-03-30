Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:60922 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaC3Mm3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Mar 2014 08:42:29 -0400
Date: Sun, 30 Mar 2014 13:42:24 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org,
        Filipe David Borba Manana <fdmanana@gmail.com>
Subject: Re: btrfs send/receive still gets out of sync in 3.14.0
Message-ID: <20140330124224.GN7442@carfax.org.uk>
References: <20140322210455.GL28005@merlins.org>
 <20140330032202.GV22552@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CaPKgh3XHpq3rEUV"
In-Reply-To: <20140330032202.GV22552@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--CaPKgh3XHpq3rEUV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 29, 2014 at 08:22:02PM -0700, Marc MERLIN wrote:
> On Sat, Mar 22, 2014 at 02:04:56PM -0700, Marc MERLIN wrote:
> > After deleting a huge directory tree in my /home subvolume, syncing
> > snapshots now fails with:
> > 
> > ERROR: rmdir o1952777-157-0 failed. No such file or directory
> 
> So, I'm ok again after I deleted my destination snapshot and re-init'ed,
> but on multi terabyte backups, this ain't great :)
> 
> Do I need to file a bug that btrfs send/receive still gets out of sync
> in 3.14, or is it already known and maybe even fixed in btrfs-next?

   Filipe has been posting a series of patches related to send/receive
recently, so this may be related to those bugs.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                   --- Gort!  Klaatu barada nikto! ---                   

--CaPKgh3XHpq3rEUV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBUzgRMFheFHXiqx3kAQIsfRAAkg5Gj8VkCi2161LW5XA7tObE2VpPLDir
Qp5F+hQ1g06sDhFgjPcb/tAO5E1iqnzMJReCCOYzCnD3YE5fLdaPdzmkDDSiQucI
pcCrwdjk6QL10Ixy/YjHTs1RxuTNAQ6ML0xoiStVk1mK2tiJ10CyzNlysivpH6df
As9iCC6kjFWH1cyIt148nrCldXroGoK0UHJ/Ip0fhWCZz5uEXzSMSA2tdFM5vi8Z
eHNsZDiF1yXTnOMxV6plPDCW13JgYNW/dM9xUEvlkKqRVu1uUOuROdcb6HMco0mw
FRmwW+RF1uB1wGtcHepd+PPLv4omw/UMC6+r12I5eWCpSVnj8KaZSNQMKXEVF4ec
fGRgHklZ0onP8F1cSClUyUDiZgLM0ocXj48raiO9XovhyNmmqC6w+4Zbc/BqYWMH
DReAh0Z+Pc6qlaiaRuvRZi6KQoUjg3AkO4pqMTf2qvNn3VpAszV8KUEoqe9kH1k8
U1Ar2JmPzQ5+q/RspI62aPoLcmai3quYMNSxvM4rcF/Z75QbXDF7K92nEgC1jyQp
mGnM08kvIOOeqTaU6rwQHcoXfEAgDtI3YuNY6yNIbSVhg0YoStLeOcU99kg5Vcwt
s0q3CmzEiLPAek22PiCq5RRYK67HE96iFpc/sO3TWPvZ4H0r1XLrPzq8aqFFqPfc
q8yxs+9SC5Q=
=Affr
-----END PGP SIGNATURE-----

--CaPKgh3XHpq3rEUV--
