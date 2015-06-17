Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:59656 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbbFQKLW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 06:11:22 -0400
Date: Wed, 17 Jun 2015 10:11:21 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS: read error corrected: ino 1 off 226840576 (dev
 /dev/mapper/dshelf1 sector 459432)
Message-ID: <20150617101121.GQ9850@carfax.org.uk>
References: <20150617071654.GI16468@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v4cNTr+tRGSs1txX"
In-Reply-To: <20150617071654.GI16468@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--v4cNTr+tRGSs1txX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 17, 2015 at 12:16:54AM -0700, Marc MERLIN wrote:
> I had a few power offs due to a faulty power supply, and my mdadm raid5
> got into fail mode after 2 drives got kicked out since their sequence
> numbers didn't match due to the abrupt power offs.
> 
> I brought the swraid5 back up by force assembling it with 4 drives (one
> was really only a few sequence numbers behind), and it's doing a full
> parity rebuild on the 5th drive that was farther behind.
> 
> So I can understand how I may have had a few blocks that are in a bad
> state.
> I'm getting a few (not many) of those messages in syslog.
> BTRFS: read error corrected: ino 1 off 226840576 (dev /dev/mapper/dshelf1 sector 459432)
> 
> Filesystem looks like this:
> Label: 'btrfs_pool1'  uuid: 6358304a-2234-4243-b02d-4944c9af47d7
>         Total devices 1 FS bytes used 8.29TiB
>         devid    1 size 14.55TiB used 8.32TiB path /dev/mapper/dshelf1
> 
> gargamel:~# btrfs fi df /mnt/btrfs_pool1
> Data, single: total=8.29TiB, used=8.28TiB
> System, DUP: total=8.00MiB, used=920.00KiB
> System, single: total=4.00MiB, used=0.00B
> Metadata, DUP: total=14.00GiB, used=10.58GiB
> Metadata, single: total=8.00MiB, used=0.00B
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> Kernel 3.19.8.
> 
> Just to make sure I understand, do those messages in syslog mean that my
> metadata got corrupted a bit, but because I have 2 copies, btrfs can fix
> the bad copy by using the good one?
> 
> Also, if my actual data got corrupted, am I correct that btrfs will
> detect the checksum failure and give me a different error message of a
> read error that cannot be corrected?

   Yes, that's my reading of the situation. Note that the 3.19 kernel
is the earliest I would expect this to be able to happen, as it's the
first kernel that actually had the full set of parity RAID repair code
in it.

> I'll do a scrub later, for now I have to wait 20 hours for the raid rebuild
> first.

   You'll probably find that the rebuild is equivalent to a scrub anyway.

   Hugo.

-- 
Hugo Mills             | If you're not part of the solution, you're part of
hugo@... carfax.org.uk | the precipiate.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--v4cNTr+tRGSs1txX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVgUfJAAoJEFheFHXiqx3knsMQAIpCGdJI+j2ozKm49yZ6x6RK
4BmEDnY+3dGKjq8eG/Z5L3Vvw+uriiUDeUCNPglaT/4utAVtHAxKgE3sHVvpwBRz
PzQDhRwKmfrIwYxCB7CPztYgSyi8gDsp+vTws8YVESSHaZGoXCzDRVgOYxBlF4tU
XSAdNY7DOxudpm9Zl0XrgkRLJ8ZGGqTmfI8mjAqVLUrGljPzzwp1qVaTivhjDxxU
hdOP0WyYq8MQ3vU/NJqyUFxgImQJ1KxpeAxmaXaUPjl3E9r2ZE5k22nFZdh7WaMa
v/hEs3wgWMqTe9Y3y/BOnMHdhpAHF8jLNegy/DKj3eT7kinU5pF+IsqPkUTkYnaF
rIzpOBb8nEwlAoloJU//h7KGZU5unZ0E+BxbT70cT5renbXIf2z1fxmCd3a/63BZ
DpsZwae6JMk+ISym6pny+KuVjVh54yJFl9myT+hcAesf/mLM6G3n37TMYU72r139
XaOJ6LAjf1mrCGiWB445r9jI0Z9CnSi90gpE434WMrUrVJHPo6diwSfPJwfkc1jZ
CmTgB0BB9J1RQwOvblpxtGJ3NaAGTPTtI0j2YrVQe7hKM6pvL5gFHX9qBOfsUALm
XHy/aQMuyb6gywGkFwoq+PHvI0Koe2wIOvjewOfV78A2eF/GnhNm6zFr1vFoFmnJ
4kVEMDTOoZ3qT9MfluB+
=c0wP
-----END PGP SIGNATURE-----

--v4cNTr+tRGSs1txX--
