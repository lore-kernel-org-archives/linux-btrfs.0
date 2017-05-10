Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47082 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751121AbdEJHkz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 03:40:55 -0400
Date: Wed, 10 May 2017 07:40:53 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: Roman Mamedov <rm@romanrm.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: runtime btrfsck
Message-ID: <20170510074052.GG9701@carfax.org.uk>
References: <9267c96a-72a7-0726-d058-4b2589d7e73e@profihost.ag>
 <f5c610b2-7400-2507-9db2-021b22c0b6d9@profihost.ag>
 <5d86903f-96f8-b61c-16b0-15ba9ac48986@profihost.ag>
 <20170510121840.06aa01b2@natsu>
 <39924a38-4c6a-b0ea-81a7-64c1d72cf7be@profihost.ag>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="j2AXaZ4YhVcLc+PQ"
In-Reply-To: <39924a38-4c6a-b0ea-81a7-64c1d72cf7be@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--j2AXaZ4YhVcLc+PQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 10, 2017 at 09:36:30AM +0200, Stefan Priebe - Profihost AG wrote:
> Hello Roman,
> 
> the FS is mountable. It just goes readonly when trying to write some data.
> 
> The kernel msgs are:
> BTRFS critical (device dm-2): corrupt leaf, bad key order:
> block=163316514816,root=1, slot=39
> BTRFS critical (device dm-2): corrupt leaf, bad key order:
> block=163322413056,root=1, slot=74
> BTRFS critical (device dm-2): corrupt leaf, bad key order:
> block=163325722624,root=1, slot=63
> BTRFS critical (device dm-2): corrupt leaf, bad key order:
> block=163316514816,root=1, slot=39
> BTRFS: error (device dm-2) in btrfs_drop_snapshot:8839: errno=-5 IO failure
> BTRFS info (device dm-2): forced readonly
> BTRFS info (device dm-2): delayed_refs has NO entry

   Can you show the output of btrfs-debug-tree -b <blocknum>, where
<blocknum> is each of the three "block=" values above?

   Hugo.

> Greets,
> Stefan
> Am 10.05.2017 um 09:18 schrieb Roman Mamedov:
> > On Wed, 10 May 2017 09:02:46 +0200
> > Stefan Priebe - Profihost AG <s.priebe@profihost.ag> wrote:
> > 
> >> how to fix bad key ordering?
> > 
> > You should clarify does the FS in question mount (read-write? read-only?)
> > and what are the kernel messages if it does not.
> > 

-- 
Hugo Mills             | Welcome to Hollywood, a land just off the coast of
hugo@... carfax.org.uk | Planet Earth
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                        The Cat's Meow

--j2AXaZ4YhVcLc+PQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZEsQEAAoJEFheFHXiqx3kpnwP/REAX9oXPo1SWgEjLju44nux
wAJ3NKXm0Zb0dnxZjA6NUJ0QbDW5ApX771wNhh8ySBgcW3pwMs8WM87Mcl9RmZi9
myvQ0+wl7FjDXM7mbHmRZAibW8is0roxrSLfoK6jFIpiYYNHKfvLbNw/mA9GlWWL
LzZVgQ2HSnn459X42PEN7P/S342SU1UPs2FBDDu8KFd/VeXa2p3bFrfa7usIyRa4
5xZlx2i2MnMLwTFnA6hSC1am4Pl0We5BAlhVpCevlo1aegnC1wX46ZkAvRG4I+7s
g/3AxZkTL9uWrIwTL7CNUSXNH2UTIr77r9LMVlAnGNxrufGCyqsg9S2WoKf0ZoXT
k2EF/5WDwSMb+6zVaylr6H8WcqbhBfqTCu7VCQnxT+PbvBBv6ya10Ypf+hEY6BPy
Ifcvr4ZAId5CaMoWINc2l+zg3pauig23N+qz8aZ8QOXMLzyfBTsopKNzU/axI1RS
hf6gPidrHS6snBXZmvY88QnIHuw0+YHuEU8fRhBhuwV7hIay6lfkdTVzefCAWgNS
o0XaTDVPlfJ/BDupe3jik07AigLmXM083PEBiV+iwQkBqGGHlsVJu9dBD0J2R7fV
Pmzpi1fyyYZuGbxdwnZrRgIhdOkKuhSYTa0Ny3pT+TnY59ghRv0yyKkQslytr84x
teywfl3LZf26rXCN4G9i
=daDQ
-----END PGP SIGNATURE-----

--j2AXaZ4YhVcLc+PQ--
