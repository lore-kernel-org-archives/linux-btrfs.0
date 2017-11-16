Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:50246 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754883AbdKPCSh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 21:18:37 -0500
To: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?
Message-ID: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
Date: Thu, 16 Nov 2017 10:18:25 +0800
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eOQUfBvoGWqjAE7W4pUGjjRG1DCv9Qhe0"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eOQUfBvoGWqjAE7W4pUGjjRG1DCv9Qhe0
Content-Type: multipart/mixed; boundary="Tn70opXBD3sqVkGlvgOKIHq9dW1FDpFKx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <477d2d2b-3893-50c1-5946-076670a03f2d@gmx.com>
Subject: Ideas to reuse filesystem's checksum to enhance dm-raid1/10/5/6?

--Tn70opXBD3sqVkGlvgOKIHq9dW1FDpFKx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi all,

[Background]
Recently I'm considering the possibility to use checksum from filesystem
to enhance device-mapper raid.

The idea behind it is quite simple, since most modern filesystems have
checksum for their metadata, and even some (btrfs) have checksum for data=
=2E

And for btrfs RAID1/10 (just ignore the RAID5/6 for now), at read time
it can use the checksum to determine which copy is correct so it can
return the correct data even one copy get corrupted.

[Objective]
The final objective is to allow device mapper to do the checksum
verification (and repair if possible).

If only for verification, it's not much different from current endio
hook method used by most of the fs.
However if we can move the repair part from filesystem (well, only btrfs
supports it yet), it would benefit all fs.

[What we have]
The nearest infrastructure I found in kernel is bio_integrity_payload.

However I found it's bounded to device, as it's designed to support
SCSI/SATA integrity protocol.
While for such use case, it's more bounded to filesystem, as fs (or
higher layer dm device) is the source of integrity data, and device
(dm-raid) only do the verification and possible repair.

I'm not sure if this is a good idea to reuse or abuse
bio_integrity_payload for this purpose.

Should we use some new infrastructure or enhance existing
bio_integrity_payload?

(Or is this a valid idea or just another crazy dream?)

Thanks,
Qu


--Tn70opXBD3sqVkGlvgOKIHq9dW1FDpFKx--

--eOQUfBvoGWqjAE7W4pUGjjRG1DCv9Qhe0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAloM9XIXHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qgZXAf/VtY9KOwLGKMEjf9S/K97oF56
kM02xIgYciwNV0inleo2fpw7MNdhKNJKpgjaC4TXEiGQHziv64CffFaeYWm3nxnt
VUNOos/PgOrxjie0/dBlLdeQrwb/kgk86jYOUDNYgPHTkF6olsmyG+7YInJnawdX
7oGqPNS2bR0CI1SBHUcT0JfZ68HmCGNck1dNvX6HAd0fP20h8Gq2a6eT5oordRpV
8U9WUnYUuvxXANSpZyxRHAsDn/2LqBAQ7wer6tj2vJvHPfqkD4o3ShhnvPvfrJIy
xlW+irIAJ2njWVKEIlMtUEcc93WLXmjfYNXEJwzn/8QN15ivWg67zB4fNOZn3Q==
=0aS5
-----END PGP SIGNATURE-----

--eOQUfBvoGWqjAE7W4pUGjjRG1DCv9Qhe0--
