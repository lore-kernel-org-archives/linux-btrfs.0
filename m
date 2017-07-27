Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59726 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751753AbdG0PLA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 11:11:00 -0400
Date: Thu, 27 Jul 2017 15:10:38 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Alan Brand <alan@georgiabrands.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Raid0 rescue
Message-ID: <20170727151038.GT7140@carfax.org.uk>
References: <CAFcRpx4q7N1zG4gz-g6MgkU6c-F_gQ6+2-4ibgm+nyRCp5pTXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SKuKPt3hQSBflurX"
In-Reply-To: <CAFcRpx4q7N1zG4gz-g6MgkU6c-F_gQ6+2-4ibgm+nyRCp5pTXQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SKuKPt3hQSBflurX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 27, 2017 at 10:49:37AM -0400, Alan Brand wrote:
> I know I am screwed but hope someone here can point at a possible solution.
> 
> I had a pair of btrfs drives in a raid0 configuration.  One of the
> drives was pulled by mistake, put in a windows box, and a quick NTFS
> format was done.  Then much screaming occurred.
> 
> I know the data is still there.

   Well, except for all the parts overwritten by a blank NTFS metadata
structure.

>   Is there anyway to rebuild the raid
> bringing in the bad disk?  I know some info is still good, for example
> metadata0 is corrupt but 1 and 2 are good.

   I assume you mean superblock there.

> The trees look bad which is probably the killer.

   We really should improve the error messages at some point. Whatever
you're inferring from the kernel logs is probably not quite right. :)

   What's the metadata configuration on this FS? Also RAID-0? or RAID-1?

> I can't run a normal recovery as only half of each file is there.

   Welcome to RAID-0...

   Hugo.

-- 
Hugo Mills             | We don't just borrow words; on occasion, English has
hugo@... carfax.org.uk | pursued other languages down alleyways to beat them
http://carfax.org.uk/  | unconscious and rifle their pockets for new
PGP: E2AB1DE4          | vocabulary.                           James D. Nicoll

--SKuKPt3hQSBflurX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJZegJuAAoJEFheFHXiqx3kW28P/jufFQQ6mzJtln/nvXwuyWPd
t1eTBew/3AFUuu85GpuiXMHrevll1n1wQ2wIVgIksMAos1hivp2+C/fvBVX63phR
521iuBJTufGUMXW18IGUQd3zLSVl8wm64FPOX3bfBsjNJXfRvpBFOTag4LAV79no
nOQsSMjOeIV+MRTXUmfx7YjYkZhm+enfMD6Mm7mGvInYoGjnHDsin1AySKKn3Q2+
MgIkjhn0iexziV6351UGIilpn+0c4y5fDOn3hu8HLJeEkZWtcCmvDfWIiIM36KaO
/SXU64KHYdtBNuPNIEvDgHtkd1PLFw32n0zbCB2JAMpgqDUj7qIW9cd6NJ2cnkvM
ZhFPBTMD/Hs5njSYTho8BOXGOQ1k24cI0U/V6HA4QzLxuUN+LTjCVpYlk0ArGQXk
REciUj5UhC7EEIZqxGtPkXEIqmglCx7u54WnAtk1qWM+wom8DpXeh0LReGpmpucl
b5E+zibEe74zcDaHDekYVuwhCMJPNbFARE1WXjVVHRkV2l3tRHEVnYllwNiJSJul
NDnHIVdT+WavuLDRuEI4qbWG0TY64sl1oMz+5k2RsJxyUewkfeHSpLYs+WEuoujy
sSZoyyKae2i9/3iwDXbJ0o/k51lBUfePmKFSya/zgbybj6ewC8OMD0UWxBBLuGn3
IpA3+P0EK2m2VaW6sFTx
=6yeX
-----END PGP SIGNATURE-----

--SKuKPt3hQSBflurX--
