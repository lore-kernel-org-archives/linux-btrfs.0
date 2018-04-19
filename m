Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34741 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753537AbeDSWn6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 18:43:58 -0400
Received: from hrm by frost.carfax.org.uk with local (Exim 4.80)
        (envelope-from <hrm@carfax.org.uk>)
        id 1f9IHV-0000wL-C6
        for linux-btrfs@vger.kernel.org; Thu, 19 Apr 2018 22:43:57 +0000
Date: Thu, 19 Apr 2018 22:43:57 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: Re: Recovery from full metadata with all device space consumed?
Message-ID: <20180419224357.GI13551@carfax.org.uk>
References: <20180419220848.GB24508@bottomless.cesspool.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="U3s59FfKcByyGl+j"
In-Reply-To: <20180419220848.GB24508@bottomless.cesspool.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--U3s59FfKcByyGl+j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 19, 2018 at 03:08:48PM -0700, Drew Bloechl wrote:
> I've got a btrfs filesystem that I can't seem to get back to a useful
> state. The symptom I started with is that rename() operations started
> dying with ENOSPC, and it looks like the metadata allocation on the
> filesystem is full:
> 
> # btrfs fi df /broken
> Data, RAID0: total=3.63TiB, used=67.00GiB
> System, RAID1: total=8.00MiB, used=224.00KiB
> Metadata, RAID1: total=3.00GiB, used=2.50GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> All of the consumable space on the backing devices also seems to be in
> use:
> 
> # btrfs fi show /broken
> Label: 'mon_data'  uuid: 85e52555-7d6d-4346-8b37-8278447eb590
> 	Total devices 4 FS bytes used 69.50GiB
> 	devid    1 size 931.51GiB used 931.51GiB path /dev/sda1
> 	devid    2 size 931.51GiB used 931.51GiB path /dev/sdb1
> 	devid    3 size 931.51GiB used 931.51GiB path /dev/sdc1
> 	devid    4 size 931.51GiB used 931.51GiB path /dev/sdd1
> 
> Even the smallest balance operation I can start fails (this doesn't
> change even with an extra temporary device added to the filesystem):

   Given that both data and metadata levels here require paired
chunks, try adding _two_ temporary devices so that it can allocate a
new block group.

   Hugo.

> # btrfs balance start -v -dusage=1 /broken
> Dumping filters: flags 0x1, state 0x0, force is off
>   DATA (flags 0x2): balancing, usage=1
> ERROR: error during balancing '/broken': No space left on device
> There may be more info in syslog - try dmesg | tail
> # dmesg | tail -1
> [11554.296805] BTRFS info (device sdc1): 757 enospc errors during
> balance
> 
> The current kernel is 4.15.0 from Debian's stretch-backports
> (specifically linux-image-4.15.0-0.bpo.2-amd64), but it was Debian's
> 4.9.30 when the filesystem got into this state. I upgraded it in the
> hopes that a newer kernel would be smarter, but no dice.
> 
> btrfs-progs is currently at v4.7.3.
> 
> Most of what this filesystem stores is Prometheus 1.8's TSDB for its
> metrics, which are constantly written at around 50MB/second. The
> filesystem never really gets full as far as data goes, but there's a lot
> of never-ending churn for what data is there.
> 
> Question 1: Are there other steps that can be tried to rescue a
> filesystem in this state? I still have it mounted in the same state, and
> I'm willing to try other things or extract debugging info.
> 
> Question 2: Is there something I could have done to prevent this from
> happening in the first place?
> 
> Thanks!

-- 
Hugo Mills             | Always be sincere, whether you mean it or not.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |                                      Flanders & Swann
PGP: E2AB1DE4          |                                The Reluctant Cannibal

--U3s59FfKcByyGl+j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJa2RutAAoJEFheFHXiqx3kteoQALKttKjzhFcTuvbCf1GJ4Dvn
ldgCBn5CZl6IgrqKLTxBxBFqmFRH7K1QT2aa2zbplHndHjnwkIXKHt9eadnoRagn
PZiMuteYfKipyGtD22FHJ/lSmHIPcoBtLporgzUxvQfv1P2rbjwQw1hQoY2FQWBG
7ojQYDkR/oYcG360WhZWhtPUMI3Ar1WqR+GCWwqZhcpCP5rMSFN0dgI9WOtjqgqD
9XkbxYhX3AuWYglGjIeNdbpEy6lcc4diClEFarO24i2WlYlOoxULijc1BE9+D7DQ
GFBeKw5jHi6l18EPcXg5oB/SzFhPwd9LuX6Hx7zeovlCTNGgry5YC5murQofqVii
d2ky6uzPh57eOesGHZqoHHA2MMMHqgKJVgwi8St0lveCB+1Bfh3NPV7IVVfm2bdD
9hO0SmjO7wTiaDX/vz/xWaWuthW22Q42CJ+fRqKpd4ah/aupLapejulTnahGW0g1
nB8cYRt95334uKgb9FZoshUgCaPLNC51GRRilFSyYN+8yRWmC1wOYwTMHebZKqoU
PvGXlMpJZ/Bc9EIj2lwuRpPO2XeLLFHIqzsHgYB+Epc+KlIzxbJ37Q3iqNGQ720B
/4uMwv6X6AWXMWiJXNRRK8nWoDkGiRKuqfzmuCatUQwq87ZDjFEb8xnFBQybNzwD
bph0JwJNHZPlH4A0D4Ys
=C7cI
-----END PGP SIGNATURE-----

--U3s59FfKcByyGl+j--
