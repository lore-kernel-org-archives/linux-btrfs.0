Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:39843 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbbGOQPt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jul 2015 12:15:49 -0400
Date: Wed, 15 Jul 2015 16:15:46 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Chris Murphy <lists@colorremedies.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS raid6 unmountable after a couple of days of usage.
Message-ID: <20150715161546.GR10539@carfax.org.uk>
References: <55A4F74D.9000305@gmail.com>
 <55A50DBF.1080602@gmail.com>
 <CAJCQCtSEk3cfwWTyzzQft1+eHcUDm_zFiBpYZM15rhZBzF3U2A@mail.gmail.com>
 <55A63F03.2080207@gmail.com>
 <CAJCQCtRWSvHtH0rjn2twd3yOPFMECE--UJxTUO0r_ydXQ7AhRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zsAhXfiBV62A5hVr"
In-Reply-To: <CAJCQCtRWSvHtH0rjn2twd3yOPFMECE--UJxTUO0r_ydXQ7AhRQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--zsAhXfiBV62A5hVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 15, 2015 at 09:45:17AM -0600, Chris Murphy wrote:
> On Wed, Jul 15, 2015 at 5:07 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
> > I've managed to get the other filesystems I was having issues with mounted
> > again with the device= options and clear_cache after running btrfs dev scan
> > a couple of times.  It seems to me (at least from what I'm seeing) that
> > there is some metadata that isn't synchronized properly between the disks.
> 
> OK see if this logic follows without mistakes:
> 
> The fs metadata is raid6, and therefore is broken up across all
> drives. Since you successfully captured an image of the file system
> with btrfs-image, clearly user space tool is finding a minimum of n-2
> drives. If it didn't complain of missing drives, it found n drives.
> 
> And yet the kernel is not finding n drives. And even with degraded it
> still won't mount, therefore it's not finding n-2 drives.
> 
> By "drives" I mean either the physical device, or more likely whatever
> minimal metadata is necessary for "assembling" all devices into a
> volume. I don't know what that nugget of information is that's on each
> physical device, separate from the superblocks (which I think is
> distributed at logical addresses and therefore not on every physical
> drive), and if we have any tools to extract just that and debug it.

   There is at least one superblock on every device, usually two, and
often three. Each superblock contains the virtual address of the roots
of the root tree, the chunk tree and the log tree. Those are useless
without having the chunk tree, so there's also some information about
the chunk tree appended to the end of each superblock to bootstrap the
virtual address space lookup.

   The information at the end of the superblock seems to be a list of
packed (key, struct btrfs_chunk) pairs for the System chunks. The
struct btrfs_chunk contains info about the chunk as a whole, and each
stripe making it up. The stripe information is a devid, an offset
(presumably in physical address on the device), and a UUID.

   So, from btrfs dev scan the kernel has all the devid to (major,
minor) mappings for devices. From one device, it reads a superblock,
gets the list of (devid, offset) for the System chunks at the end of
that superblock, and can then identify the location of the System
chunks to read the full chunk tree. Once it's got the chunk tree, it
can do virtual->physical lookups, and the root tree and log tree
locations make sense.

   I don't know whether btrfs-image works any differently from that,
or if so, how it differs.

   Hugo.

-- 
Hugo Mills             | Radio is superior to television: the pictures are
hugo@... carfax.org.uk | better
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--zsAhXfiBV62A5hVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVpocxAAoJEFheFHXiqx3kpfQP/1XLfvyN60EnEK/vptoHh8Pf
jn5d4qpw+qGRccITu0ynRR/cL3nkurNBd0tvkTaF1RN5v1MtMulp12ALAgoO3TZG
I4VleyxN7hFV3hBh/zkn/jWli7QBjsMqce+TW9YuaS1VsfK5E4SzCGwrH2wrpcGY
6pBc3Q4znOKAZqO48CAO0SYhnmGUwhzMtL8WyYZ0QZeVzzqJ6FO/mIe0NI/GKc90
FzTxkrXkKoX215oYLipap586H5KQiy+vgXa6bQpmylaNQ9rjrxMoCn+t0t6dyBCw
qq+H5F6vDdgO6fN0AzriG3i64dw+MDL6suZ+jGxy63kRg08ZHgKxeCwgUbFKN2Zi
NmkQnFUO04orjaFeI7Ew/c3ggoRTAKocNFqhUw+S1+EnRiCxFgNPmhADTUvJq3i8
/VFMSPmKh17rXhnkaskQ9Wp+zOzJfkjEUhMDYwbr5b9+HoSohePvqY4zEaJk/mUz
VJViWaFCGWnNmRotnLPfIK6uKODymZpEKmEwtc2vRhKwijrIOXgkAMVcb8/k8ewI
HpIIh/KNOlP3mdMZWF/WiR0I8Qt3OOPwXjwib4onYT5C1Y0K1Qv+yvvwBlOXJ0/t
TFB0Iw/7natauvRPk8sERelqh2L8Yo4d852+TrHY+ByHenkxAHBfjgFI/ovQ+Pxy
ATm4mxiqg3gLeOJ95SA4
=ibJn
-----END PGP SIGNATURE-----

--zsAhXfiBV62A5hVr--
