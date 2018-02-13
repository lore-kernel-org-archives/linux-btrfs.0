Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:36873 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964828AbeBMPUa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Feb 2018 10:20:30 -0500
Received: by mail-it0-f45.google.com with SMTP id d10so5284630itj.2
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Feb 2018 07:20:30 -0800 (PST)
Date: Tue, 13 Feb 2018 15:19:44 +0000
From: Dan Robertson <danlrobertson89@gmail.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs: compile with musl libc
Message-ID: <20180213151943.GA16750@drobertson-crashbox.lab.tripwire.com>
References: <20180213132509.GA16525@drobertson-crashbox.lab.tripwire.com>
 <20180213151347.GT3003@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
In-Reply-To: <20180213151347.GT3003@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Thanks, this has been fixed in
> https://github.com/kdave/btrfs-progs/commit/3aa1bbdd89ee9c9c48d260a6192fae08328f1b2f

Ah, my bad. Didn't check the dev branch. Thanks for the quick response!

Cheers,

Dan

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE/rsbXA6uV265z+m9Btkjh+bF0AgFAlqDAg8ACgkQBtkjh+bF
0AhkEg/9GIdrZddTGougR/hPnt765pVJQaB1/zj1SGZ/2pnCUInU95WToub9Q+23
8d5NpgvQMRUJ9zTj/eIP9Zsqz97AzEauqX/13VxS0S5cW1lmdcdYMc8yKEbzG33+
xQRwRqACfIlw+XZ/7Rb7TxNxiWP7bqd7nFDEcgbkNbCR1ZUQ6NMDuxsgb4y39Eb6
uTQpQ4SE6iNehJoeZ2q47AlRD2KXygezCumVgzJcrVP5ri48r5znIkrA7lH8E+YR
HtcDWK1sW2DCDzNTUJkpCCLHvjVZa+MbiTABIb60t+EZ5EfITrf9PnnNAv0by/nv
0fW3UlAyhQTz7elkVugxbCZyOkNRHljXE+4xZyFYv9fEd8i3K+kK/0O2cUA5ijv3
3Rknu+sRlyH+CbY0BZ595p4wqhE9GmsxciNgqt3fPUMGkD3VRxz4Rw4/x6kP005r
f1RsnR/FUs+4Gj+O/v2yRMQfhaOZNO6VY/GjxqCvNiCtLQhODI+IMgDVkc8lhJzM
LecNUH75hPPBZemhlQj71+PC1N/OmHSOtyAbyjxXm/cvi99v0RAzD8CTAQOqEc+d
8r+3OZOWzZv7NEBoZyeXswzDsxGg81Y9b+OgBPIuVOY2Qtj5f/ueM+dyG1Urc74j
8p6N5D9vwIf2INpPLXDtxllVgT7H4iY9KyhtBMe5MiDYLbulDf0=
=hikP
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
