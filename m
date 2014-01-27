Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59480 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbaA0Sub (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 13:50:31 -0500
Date: Mon, 27 Jan 2014 18:50:08 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: KC <impactoria@googlemail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Snapshots =?utf-8?B?4oCTIG5vbw==?= =?utf-8?Q?b?= questions
Message-ID: <20140127185008.GN3314@carfax.org.uk>
References: <52E664E0.5070909@gmail.com>
 <3022B1A5-391E-431C-B5F9-2BE9206B8578@colorremedies.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g6DVDhPhk1bqxDrC"
In-Reply-To: <3022B1A5-391E-431C-B5F9-2BE9206B8578@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--g6DVDhPhk1bqxDrC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 27, 2014 at 11:44:24AM -0700, Chris Murphy wrote:
> 
> On Jan 27, 2014, at 6:53 AM, KC <impactoria@googlemail.com> wrote:
> > 4. If I have a snapshot of  /, can I completely erase this partition and later restore it in full form that snapshot, or do snapshots work only if a limited number of files has been changed?
> > If the former, then does it mean that snapshot size will be comparable to the original data size?
> 
> I'm confused by what you mean by completely erase this partitions and later restore it. What do you mean by partition? Taken literally I'd say no because a snapshot is a subvolume, it's a function of a Btrfs file system, and if you erase the partition you've erased the file system and everything on it.
> 
> Otherwise, either the snapshot or its parent subvolume can be deleted at any time. At the moment the snapshot is taken, they are clones, but they behave as completely separate file systems. Any changes to one do not affect the other.

   Probably slightly more accurate to say "completely different file
trees", as they're part of the same filesystem (the single btrfs FS
that contains all of the subvolumes in this example).

> > 5. Can a snapshot be stored on a different partition?
> 
> Yes Btrfs send/receive.

   Mmmm... debatable semantics again. You can transfer the data with
btrfs send/receive, but after that it's not really a snapshot in the
sense of being a CoW copy on the same filesystem...

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
             --- I always felt that as a C programmer, I ---             
                         was becoming typecast.                          

--g6DVDhPhk1bqxDrC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIUAwUBUuaqYFheFHXiqx3kAQIjAQ/4sTcm+yRMzXqxbPn/B0692LqvBqy124ie
0qmQvOQXpc+4VRysTvIfzNehbUjdVa65zkeV5OnvPlNQZ6CdQdcUjQDYTe25BwVQ
V1/vKxQpOcDQo1NGousyNQN4saPt26wjCaeQcGjsZS9t3RS2gtJH/XPVDdyzpDKn
Q4CUATZCFqleetAhxcSDCuyEKX9mQ8Gs2fdr5xMf4/DfGnwjAY57/Kkrb5EoUfoc
AuRw6U2X2mbhTcEF0bqJG7qEnPOKBYnLQnch/rC+2E04+uoof41PYwaOWXxcejSw
TEhDSWwZnMSIpHzoJ7dB5AQmesZQpPcqEE49jux+Z2+Sg2skALwIRXBUd4bhR2zF
xZfry5VNfSYCaUZ3h/wqd9DW+bYIcfkFMnaTLC88ICKfLpdA84pxC8nM6mhccq7q
ogBu63qC4F30l+BWjqKZA+4CrmhrLKEIsaGypxqVXLj7CntDYgn8L8ZmVM4Skt8B
9a1emsGqIXQII9KYbDGi0K2e2dCfwELdljkjsBOMoE680jWqHV+7b3bBu8hKbDWi
iLUra0AvaKpxn0/fMKmfcffBr6bftqkrjLkpVwBvGqtoFXFbA0QOqyp4utM7SJT+
WDHOBJw48ZFyLVmk9bplpy50beJJ3QpMDmNP7hW2Tj35Ecnf4/f4pi/DY3Pd8Dax
nFQvbNPxFg==
=odQy
-----END PGP SIGNATURE-----

--g6DVDhPhk1bqxDrC--
