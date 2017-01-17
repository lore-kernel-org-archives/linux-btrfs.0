Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:56975 "EHLO
        smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751484AbdAQXte (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jan 2017 18:49:34 -0500
From: Christoph Groth <christoph@grothesque.org>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Unocorrectable errors with RAID1
References: <87o9z7dzvd.fsf@grothesque.org>
        <42eaf69b-c444-fc50-2128-3a1fbd18b335@suse.de>
        <871sw2cbzb.fsf@grothesque.org>
        <6f5ba97f-0c13-4ad1-fda3-a10db7024ef7@suse.de>
        <87lgu9cu2v.fsf@grothesque.org>
        <e7412986-d0bd-d0e3-b268-d3aede1cc80b@suse.de>
Date: Wed, 18 Jan 2017 00:22:20 +0100
In-Reply-To: <e7412986-d0bd-d0e3-b268-d3aede1cc80b@suse.de> (Goldwyn
        Rodrigues's message of "Tue, 17 Jan 2017 16:57:21 -0600")
Message-ID: <8737ghclw3.fsf@grothesque.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--=-=-=
Content-Type: text/plain; format=flowed

Goldwyn Rodrigues wrote:

> As Chris mentioned, try a later version. If you are familiar 
> with git, you could even try the devel version.

Looking at the commits in current devel (2f4a73f9a612876116) since 
v4.9, there doesn't seem to be anything relevant, but I can retry, 
if you think it's worth.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEUimQV/rXmWU8TwiKw/FH9ZgPNTUFAlh+pywACgkQw/FH9ZgP
NTWLvA/+P2c+DiQgi+ZsPdL4C0vMiKBsl16ogbN3JVFGHMygaR2pKvr/IsUUoVLF
ZcldRP6Zv4W2AFEK2pQBdoowgWzwwhNTYgFizCptP22GSJH3W/WsN74+wFK5UYE9
IYUvOpMsCKdBZLgWuBgAwJkKEYvpJ9GCuGmK4lO4LgC+JY2pRrtidd2QvIXXofnj
4l5f0TZ2BSXQ1BswAEBnqNdeKjnY0aGzlWKEqjGzZ/lKoB0oQx4LiGW97JHpJjiE
l021aIeCMng1gPO58m79C4WDnTaXkopwCxFpG5bZg2ZewT2biEPPYgXE7D0f2oPj
a0ZSzjfOG6xRYUgfQPG7Y93S0wgGCu2ML+fFryYYDKkBuUQlnMV5UOM1CkzqczX3
Hh25pzbY0ysqJTahq7aN8TqHQMQHHSWAUss4gxeQS19uhmz+ADcdWDQMB0DCtTuN
jspO1J9d1cuXe7U91uxJDsoNczreMRByDJjxaCYdZ3BTaYx2sId2i2Odfi81fYFl
+8tqyT1sdurZleoXJfxpnAyzlfNkpOLVY47QK0/3SPfGIMw15pvkt2Ggo9MeBjAd
cUxUXQZjRuc5Ln+UOb8OYDMkrfUKM4rxNrvjWqMrsXMUsPwsIgbTRNtp0lQy4euD
rAkbSuZzjT1Fso/MOLITEIYy03UYyGX6AY3sECS/Q24iYaYbE8I=
=91WG
-----END PGP SIGNATURE-----
--=-=-=--
