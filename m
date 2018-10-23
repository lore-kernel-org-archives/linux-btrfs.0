Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49170C46475
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCEF620665
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 09:31:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCEF620665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=automatix.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbeJWRxy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 13:53:54 -0400
Received: from mail.automatix.de ([213.131.255.221]:37970 "EHLO
        mail.automatix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727714AbeJWRxx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 13:53:53 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Oct 2018 13:53:52 EDT
Received: from [192.168.11.16] (statdsl-085-016-075-093.ewe-ip-backbone.de [85.16.75.93])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jojo@automatix.de)
        by mail.automatix.de (Postfix) with ESMTPSA id 2CA0E600B4;
        Tue, 23 Oct 2018 11:25:32 +0200 (CEST)
From:   Juergen Sauer <juergen.sauer@automatix.de>
Subject: Filesystem corruption?
To:     "Gervais, Francois" <FGervais@distech-controls.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <BN6PR01MB2531B41C0F7A49D2DBF001C1F3F40@BN6PR01MB2531.prod.exchangelabs.com>
Openpgp: id=D41F20FCD4A08AD588776084C89D88C98852A789
Autocrypt: addr=juergen.sauer@automatix.de; prefer-encrypt=mutual; keydata=
 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
 8CGD2mDl+cnaYgWQxjU9aDyOAw==
Organization: automatiX GmbH
Message-ID: <912b9ba4-f142-008d-ac07-0bea1b2a5d00@automatix.de>
Date:   Tue, 23 Oct 2018 11:25:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <BN6PR01MB2531B41C0F7A49D2DBF001C1F3F40@BN6PR01MB2531.prod.exchangelabs.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="cqq2pKOydIjGOl4hrFJdw7EQfTzb0pU2b"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cqq2pKOydIjGOl4hrFJdw7EQfTzb0pU2b
Content-Type: multipart/mixed; boundary="2k5HxdlS51gBkfAa9meHM0peSzSIwLWPj";
 protected-headers="v1"
From: Juergen Sauer <juergen.sauer@automatix.de>
To: "Gervais, Francois" <FGervais@distech-controls.com>,
 Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <912b9ba4-f142-008d-ac07-0bea1b2a5d00@automatix.de>
Subject: Filesystem corruption?
References: <BN6PR01MB2531B41C0F7A49D2DBF001C1F3F40@BN6PR01MB2531.prod.exchangelabs.com>
In-Reply-To: <BN6PR01MB2531B41C0F7A49D2DBF001C1F3F40@BN6PR01MB2531.prod.exchangelabs.com>

--2k5HxdlS51gBkfAa9meHM0peSzSIwLWPj
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

Am 22.10.18 um 22:02 schrieb Gervais, Francois:
> Hi,
>=20
> I think I lost power on my btrfs disk and it looks like it is now in an=
 unfunctional state.
>=20
> Any idea how I could debug that issue?
>=20
> Here is what I have:
>=20
> kernel 4.4.0-119-generic
> btrfs-progs v4.4
>=20
>=20
>=20
> sudo btrfs check /dev/sdd
> Checking filesystem on /dev/sdd
> UUID: 9a14b7a1-672c-44da-b49a-1f6566db3e44
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> checking quota groups
> Ignoring qgroup relation key 310
> Ignoring qgroup relation key 311

Since Kernel 4.4. were quite a lot of stability changes.
In practice, I try first booting a nearly current kernel with current
btrfs-tools.

Practical easiest way to do so is to download and dd an arch linux iso
to a usb stick and booting from this stick.

see: https://www.archlinux.org/

Afterwards I repeated the repair try.

In more than one case before this procedure worked for me.

mit freundlichen Gr=C3=BC=C3=9Fen
J=C3=BCrgen Sauer



--2k5HxdlS51gBkfAa9meHM0peSzSIwLWPj--

--cqq2pKOydIjGOl4hrFJdw7EQfTzb0pU2b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEepxTH+9otopXeixExh7qHMhf53gFAlvO6QsACgkQxh7qHMhf
53hW2w/7BfAaqP6gUD9BnLjfIqXMblQWAehwbLbghTQqoXhLId4YI8UTxeec7yFZ
aoDBy1Q5dQL240/sEyLkIwby5P0IcOSjH/QH53ODmZ8CCceUKir8H0nn1fOlhIbm
V8Tj2dxbDEk2ylYwM3XRAZ4gJ6L/jfhtKFbxGuAS8040xHDTlfgxB9O1aIwOrYel
CuLBq79diX5yo/MbMGwQjFlsrbaVHrmftPfifrQqeCBzXO42jxJUe6KN39aNPtfE
gToE67Y3PzHpE99QrNdLBZ5dyVlFbaAdM5CTzy6MenidKXD0KX5gpClSdFwxIt8p
HfyYseUQRb0KbLAUu7tsFumAhhTBLD88tyEvZT9pV01qAWqGJZyE41fnBqxjia3Q
uvX6Phto5q1hqGScy7vaqGd/kuhyt+L+NbukrOOg7GXF3zQokdiB0lNHLy8vsmhG
bQKssAAzZ5mhdkI7zgLs3c4t09MJ9yHa86aOLNzODWEq300eawqXJ7HB3RFilAnR
WdAe0u2fhUSZReQ3wpSckzwZ987QKXRfujJtofQYltQcsJwkE+uAenZSMU/ZVYfa
Na85pyUZRgBQMTh5UJUZ/MABlpbetX0D6JvA8GPVfVFrKyrzv0rGUL2fETeHEkUt
xINiz3FsJoT5oelQTMWUcT1AQfVrxVzyGNv3HHqpzPIFhAlZljQ=
=SakI
-----END PGP SIGNATURE-----

--cqq2pKOydIjGOl4hrFJdw7EQfTzb0pU2b--
