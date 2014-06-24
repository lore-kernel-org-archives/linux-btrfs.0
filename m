Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from omr-m05.mx.aol.com ([64.12.143.79]:59138 "EHLO
	omr-m05.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaFXNtc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 09:49:32 -0400
Received: from mtaout-mbb01.mx.aol.com (mtaout-mbb01.mx.aol.com [172.26.254.109])
	by omr-m05.mx.aol.com (Outbound Mail Relay) with ESMTP id B5169702720F1
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 09:43:58 -0400 (EDT)
Received: from [192.168.178.62] (port-92-195-21-33.dynamic.qsc.de [92.195.21.33])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mtaout-mbb01.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id D49B23800008D
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 09:43:57 -0400 (EDT)
Message-ID: <53A9809C.30705@aol.de>
Date: Tue, 24 Jun 2014 15:43:56 +0200
From: Karl-Philipp Richter <krichter722@aol.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Assertion `!(exist->nmirrors >= 2)' failed
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="DcsmVRBSEtbh5uW6AttFpkoSMmPiNiq5W"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DcsmVRBSEtbh5uW6AttFpkoSMmPiNiq5W
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi together,
I wondered whether

    $ sudo btrfs rescue chunk-recover -y /dev/loop2p1
    btrfs: chunk-recover.c:124: process_extent_buffer: Assertion
`!(exist->nmirrors >=3D 2)' failed.
    $ echo $?
    134

is an error in btrfs or an error message of (the correctly working)
btrfs. Any ideas what this could mean? I'm having this trouble with a
system which is so messed up that I even can't restore

    $ sudo btrfs restore /dev/loop2p1 /mnt/data_extension/restore
    parent transid verify failed on 1068982272 wanted 47618 found 47575
    parent transid verify failed on 1068982272 wanted 47618 found 47575
    parent transid verify failed on 1068982272 wanted 47618 found 47575
    parent transid verify failed on 1068982272 wanted 47618 found 47575
    Ignoring transid failure
    leaf parent key incorrect 1068982272
    Couldn't setup extent tree
    parent transid verify failed on 1068982272 wanted 47618 found 47575
    Ignoring transid failure
    leaf parent key incorrect 1068982272
    Couldn't read fs root: -1

I'm issueing the command because it seems to be the last thing I can do
to rescue any data of that partition.

This occurs with v3.12 (output of `btrfs --version`) as well as the
latest commit 24cf4d8c3ee924b474f68514e0167cc2e602a48d of btrfs-progs.

Best regards,
Kalle Richter


--DcsmVRBSEtbh5uW6AttFpkoSMmPiNiq5W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTqYCcAAoJEGadKJ8eJ7ZGE64H/2n43QDo9dIuzzigWKW0LFoV
syPWXRfify1lYhYM/rtgJ8RYNUY5ep4ISfj3/2PBI97FJncn+Z1GtKgu1DR8VUZo
cYbU4YBFhFxWraXjObWMJMRQsaeQvNmdwEvSO2tDJVeKA354IeIzBvXJZY9qqXGx
K01NOSCfbEfr7kGiuDxooWqgiosjJdvP6EwC+Y+g7MfEiMMcERF3smlUj95FRwZ0
DLvyHgZfdY/uxS4EOiDQVYJORMG9b5UWGW5ra95FRiHA12PP/GLg09jSQJ50zBxf
U0Z+GN59wlYZ4jbB5QV/9a5nMwbUay2fKE+fCZu5Slg+K1GiaW2aH9ARrR/istU=
=fuv7
-----END PGP SIGNATURE-----

--DcsmVRBSEtbh5uW6AttFpkoSMmPiNiq5W--
