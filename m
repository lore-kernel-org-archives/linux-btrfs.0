Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38288 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751962AbdJKMJ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 08:09:58 -0400
Subject: Re: Fatal failure, btrfs raid with duplicated metadata
To: Ian Kumlien <ian.kumlien@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAA85sZtPya5pQvRxyYpNB_HO0jfajvpg42EKNkKjuPuojZ-2pQ@mail.gmail.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <4b291404-9f0a-e95d-e505-4a14fb1160d0@suse.com>
Date: Wed, 11 Oct 2017 14:09:56 +0200
MIME-Version: 1.0
In-Reply-To: <CAA85sZtPya5pQvRxyYpNB_HO0jfajvpg42EKNkKjuPuojZ-2pQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="olLHvvlXmhaCxe7JFt78NRHXVJIBpPkj4"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--olLHvvlXmhaCxe7JFt78NRHXVJIBpPkj4
Content-Type: multipart/mixed; boundary="k4jWFMD0HKOG87tK5DV9cjqMC4vm4xnOa";
 protected-headers="v1"
From: Jeff Mahoney <jeffm@suse.com>
To: Ian Kumlien <ian.kumlien@gmail.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <4b291404-9f0a-e95d-e505-4a14fb1160d0@suse.com>
Subject: Re: Fatal failure, btrfs raid with duplicated metadata
References: <CAA85sZtPya5pQvRxyYpNB_HO0jfajvpg42EKNkKjuPuojZ-2pQ@mail.gmail.com>
In-Reply-To: <CAA85sZtPya5pQvRxyYpNB_HO0jfajvpg42EKNkKjuPuojZ-2pQ@mail.gmail.com>

--k4jWFMD0HKOG87tK5DV9cjqMC4vm4xnOa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/11/17 12:41 PM, Ian Kumlien wrote:
> Hi,
>=20
> I was running a btrfs raid with 6 disks, metadata: dup and data: raid 6=

>=20
> Two of the disks started behaving oddly:
> [436823.570296] sd 3:1:0:4: [sdf] Unaligned partial completion
> (resid=3D244, sector_sz=3D512)
> [436823.578604] sd 3:1:0:4: [sdf] Unaligned partial completion
> (resid=3D52, sector_sz=3D512)                             [436823.61759=
3]
> sd 3:1:0:4: [sdf] Unaligned partial completion (resid=3D56,
> sector_sz=3D512)
> [436823.617771] sd 3:1:0:4: [sdf] Unaligned partial completion
> (resid=3D222, sector_sz=3D512)
> [436823.618386] sd 3:1:0:4: [sdf] Unaligned partial completion
> (resid=3D246, sector_sz=3D512)
> [436823.618463] sd 3:1:0:4: [sdf] Unaligned partial completion
> (resid=3D56, sector_sz=3D512)
> [436977.701944] scsi_io_completion: 68 callbacks suppressed
> [436977.701973] sd 3:1:0:4: [sdf] tag#0 FAILED Result: hostbyte=3DDID_O=
K
> driverbyte=3DDRIVER_SENSE
> [436977.701982] sd 3:1:0:4: [sdf] tag#0 Sense Key : Hardware Error
> [current]
> [436977.701991] sd 3:1:0:4: [sdf] tag#0 Add. Sense: Logical unit
> failure
> [436977.702000] sd 3:1:0:4: [sdf] tag#0 CDB: Read(10) 28 00 02 fb fb
> 80 00 00 28 00
> [436977.702005] print_req_error: 68 callbacks suppressed
> [436977.702010] print_req_error: critical target error, dev sdf,
> sector 50068352
> [498132.144319] print_req_error: 450 callbacks suppressed
> [498132.144324] print_req_error: critical target error, dev sdf,
> sector 41777640
> [498132.144590] btrfs_dev_stat_print_on_error: 540 callbacks
> suppressed
> [498132.144600] BTRFS error (device sdb1): bdev /dev/sdf1 errs: wr
> 632, rd 1526, flush 0, corrupt 0, gen 0
>=20
> Eventually the filesystem becomes read-only and everything is odd...

Are you still able to mount it?  I'd be surprised if you could if check
can't open the file system.

> Trying to run btrfs check on the disks results in:
> btrfs check -b /dev/disk/by-uuid/8d431da9-dad4-481c-a5ad-5e6844f31da0
> bytenr mismatch, want=3D912228352, have=3D0
> Couldn't read tree root
> ERROR: cannot open file system
>=20
> (For backup and normal)
>=20
> So even if the data is duplicated on all disks, something in the above
> errors seemed to cause it to abort
> (These disks are seagate sshd disks, never ever buying them again)

If you have metadata: dup, that doesn't mean the metadata is duplicated
on every disk.  It means that there are two copies of the metadata on a
single disk.  If that disk is going bad and returning failures for both
copies of the metadata, you may be out of luck.  It's really intended
for single spinning disks to get a little bit more resiliency in the
face of bad sectors.

The check error above means that it wasn't able to map a logical address
to a physical address.  Typically that means that the mapping was lost.

-Jeff


--=20
Jeff Mahoney
SUSE Labs


--k4jWFMD0HKOG87tK5DV9cjqMC4vm4xnOa--

--olLHvvlXmhaCxe7JFt78NRHXVJIBpPkj4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE8wzgbmZ74SnKPwtDHntLYyF55bIFAlneChQACgkQHntLYyF5
5bI92xAAn336WiIDXphBvVcCR3OuNasPWY+FPusoBWs5vFUrHcZwqeiAleROGzqE
NPKnMeE8cCBeqGhQ7+/K/brzLG0t+R5OgAttP97V5wlKPU0409KBx3ZCVswQ9Pj1
BbXeEwhUMPjfL8kKfnOdA4/55eUS3UDjb+4N2WUPK+gvT/ePdAYAknubwku/AvAa
gv9I+HQcq8x5ROY3G11NOPovV0lOK9p89YPz58rEOoAjQxDtU3NLEBvNJc7rx+ew
A7uToTuWuNeugTXH16VIXCujNdMrQN4eu+yHEOyls2X/g5PeuB0AtYLLXp9gy0Yo
LeKqTqfqKMOjVq1giMxCJGX3DlFywAWrX9YwHqyYth0jezR9473u3RB11v4hhUzX
cPw0sEQPjJQfHjaJpEWekSwNWmvL/uriOMbmeDw3VdkjEDJXS8s0ghlyvEmXNEH3
1M+k+IFVrv5josNwN1unQP0/4ahadv4dzu3hc2owQ+vRQ98qPzN5SrGWQ+V4BWev
4veDTgDHPqN+j3+wIsDM/JCw/hnClXY6TY4yBNxYrFczyxTGb19yWPpViDF6fhYq
DStQ+XJrefprjf7INpsDPJ1IoqDN/mhvf/ooa9hZx/KpfQV2ZAZOALFZ0E3Y19M/
6TN0sSkiWy3xe0qz6y3UPv7W/Ivqk7632tYk6Fe69rlTh1Kj310=
=eyMA
-----END PGP SIGNATURE-----

--olLHvvlXmhaCxe7JFt78NRHXVJIBpPkj4--
