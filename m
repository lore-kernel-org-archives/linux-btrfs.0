Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57949 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbbHZLuM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 07:50:12 -0400
Date: Wed, 26 Aug 2015 11:50:10 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: George Duffield <forumscollective@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Understanding BTRFS storage
Message-ID: <20150826115010.GC23769@carfax.org.uk>
References: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pk6IbRAofICFmK5e"
In-Reply-To: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 26, 2015 at 10:56:03AM +0200, George Duffield wrote:
> Hi
> 
> Is there a more comprehensive discussion/ documentation of Btrfs
> features than is referenced in
> https://btrfs.wiki.kernel.org/index.php/Main_Page...I'd love to learn
> more but it seems there's no readily available authoritative
> documentation out there?
> 
> I'm looking to switch from a 5x3TB mdadm raid5 array to a Btrfs based
> solution that will involve duplicating a data store on a second
> machine for backup purposes (the machine is only powered up for
> backups).
> 
> Two quick questions:
> - If I were simply to create a Btrfs volume using 5x3TB drives and not
> create a raid5/6/10 array I understand data would be striped across
> the 5 drives with no reduncancy ... i.e. if a drive fails all data is
> lost?  Is this correct?

   With RAID-1 metadata and single data, when you lose a device the FS
will continue to be usable. Any data that was stored on the missing
device will return an I/O error when you try to read it. With single
data, the data space is assigned to devices in 1 GiB chunks in
turn. Within that, files that are written once and not modified are
likely to be placed linearly within that sequence. Files that get
modified may have their modifications placed out of sequence on other
chunks and devices.

> - Is Btrfs RAID10 (for data) ready to be used reliably?

   I'd say yes, others may say no. I'd suggest using RAID-1 for now
anyway -- it uses the space better when you come to add new devices or
replace them (with different sizes).

   Hugo.

-- 
Hugo Mills             | Preventing talpidian orogenesis.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--Pk6IbRAofICFmK5e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV3afxAAoJEFheFHXiqx3kuccQAJWPc0D7wWUtUjNXWBlANF9K
L4gYYmfcrjD45yloAl1gJoW32SxeDo48PW1RqIpOyGXchJvocmw8TXr8pCfoXSq3
YI/iBcr7xOdbpO9gomMo5nPwT8ya20e5GhcnLR6quyx/7b0ZLS8Ji7fPUPZ5we95
RNPxjx9m8tJY1KkSSAj+luDrzQT/50zWrmjpllRqfvaNAFEX0TTo3O/kvf4G2ngj
VELONNt132pHxHlNJqe2caC4wZmkQ5/V+HiHMsqr/SRGrlKvPh/jBmXJDJqJp3Eg
UH/qKQMchH+wvv84PxttRcBY0l5lBFiUcwvf4n7RbB8Ztcol74ojmbM3fz5/X2dR
6HWpD1746udliQ66dl33BRBYiooNG2QXvsZXPEZLEEMZ4vuqlyjGZ+/7Qb/6oYJM
FOOM20iTHa0sOelhnX63qpPlA5PKG/yR+0N5iSsljE6kkQgaraQT1CLQL6G4quXV
OIrCnDNp412zz9xF7t5z0sJgfKfH4grv5XD/bTCKRSm/yhiIA6BvfP0A9spKeyJy
tt7anMJk46NQJHuPwqhqJysHTeA6AbSRx7yBuiefu/kFdaBd7Yx2esI/Me7pAdye
lNaa9cau56qv4AIe5J9maMwVvE9YHNPZJwjDlCL8hOPEPNfFrMyIjbcBwsomXL3e
IrkcwB6K7xg5L1gLooxw
=xs0H
-----END PGP SIGNATURE-----

--Pk6IbRAofICFmK5e--
