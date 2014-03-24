Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from omr-d07.mx.aol.com ([205.188.109.204]:54155 "EHLO
	omr-d07.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaCXWyh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Mar 2014 18:54:37 -0400
Received: from mtaout-mba01.mx.aol.com (mtaout-mba01.mx.aol.com [172.26.133.109])
	by omr-d07.mx.aol.com (Outbound Mail Relay) with ESMTP id EEEC27020CA36
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 18:54:36 -0400 (EDT)
Received: from [192.168.178.62] (port-92-195-22-51.dynamic.qsc.de [92.195.22.51])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mtaout-mba01.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id 5F1A9380000BA
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Mar 2014 18:54:36 -0400 (EDT)
Message-ID: <5330B7A9.8000207@aol.de>
Date: Mon, 24 Mar 2014 23:54:33 +0100
From: Karl-Philipp Richter <krichter722@aol.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: mounting and unmounting of btrfs filesystem on qemu qcow2 image mounted
 as NBD
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="aQFgjmu7frTwKlCQmPNpheQN252SNl1td"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aQFgjmu7frTwKlCQmPNpheQN252SNl1td
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi together,
I've created a btr(fs) filesystem on a partition on a qcow2 image with
GUID partition table created with qemu (1.7.0) tool:
qemu-img create -f qcow2 image.qcow2 2T
I'm connecting this image to a NBD with qemu-nbd and mounting the NBD.
I'm experiencing errors which I don't with partitions on the real HDD, e.=
g.
<output /var/log/syslog>
Mar 24 20:38:48 myhostname kernel: [92324.728828]  nbd14: p1
Mar 24 20:38:48 myhostname kernel: [92324.759664] device fsid f
a920d4d-524b-4d17-86e9-bcb82b51cd1f devid 1 transid 2658 /dev/nbd14p1
Mar 24 20:38:48 myhostname kernel: [92324.759968] btrfs: disk s
pace caching is enabled
Mar 24 20:38:48 myhostname kernel: [92324.818021] btrfs bad tre
e block start 902103040 901578752
Mar 24 20:38:48 myhostname kernel: [92324.851668] btrfs: open_c
tree failed
</output>
Some images are broken. The image file is located on a NFS mount from
another physical machine for which I haven't found any info on
malfunction of NFS (I guess usual network errors are treated by NFS and
qemu-nbd).

I'm addressing to the list not in order to get detailed debugging
instructions, but rather a statement on whether it is possible to do
what I want to do (mount a qcow2 image on a NFS mount) or why not. I'm
not looking for alternatives :)

Further infos:
when I created the btrfs partition and partition table I did it on the
NBD /dev/nbdX.

Thanks in advance for your help and pointers!

Best regards,
Karl Richter


--aQFgjmu7frTwKlCQmPNpheQN252SNl1td
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTMLepAAoJEGadKJ8eJ7ZGBboIALBUnomUHAJ7rklrrkZdh5PF
ZC/7tccWHjp8krUtjaR8OVtJS/+m32B5kBl6ruYPlpdjPuQBLYoqmVBJCrEqsMDE
TVTnUvaeTGP4pF6CgEtz5WK3mTqispQ7CGtTu0ayJ5QP1WYQVKVrgaUE+iuNHIkP
ypCbzYgsSqoRhKtEmocYbmlTbFQpSEDByl2yimPh3VOKRkItp3XiiU+Mp+MeAJmL
tgiIN7opxKZHPd4JE6pIq990E7S9KRRmzPYBMXeV/bHf02XzucX4PtNSu1ukd2I4
nQGZd5hWbkk6XDTdCuTQ3W1Kx+dNZ/RxXFL0xym63EWjbq+iUSCZbYGWWFHE/aU=
=EpDx
-----END PGP SIGNATURE-----

--aQFgjmu7frTwKlCQmPNpheQN252SNl1td--
