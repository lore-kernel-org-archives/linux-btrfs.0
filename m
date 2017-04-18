Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34345 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755912AbdDRNPI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 09:15:08 -0400
Date: Tue, 18 Apr 2017 13:15:06 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Werner Braun <wb@o3-software.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs check --check-data-csum malfunctioning?
Message-ID: <20170418131506.GJ21462@carfax.org.uk>
References: <4b1b08de-9012-fb2a-eca1-a8adfdbf8e7b@o3-software.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tAmVnWIZ6lqEAvSf"
In-Reply-To: <4b1b08de-9012-fb2a-eca1-a8adfdbf8e7b@o3-software.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--tAmVnWIZ6lqEAvSf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 18, 2017 at 02:41:49PM +0200, Werner Braun wrote:
> Hi,
> 
> i have a WD WD40EZRX with strange beaviour off btrfs check vs. btrfs scrub
> 
> running btrfs check --check-data-csum returns no errors on the disk
> 
> running btrfs scrub on the disk finds tons of errors
> 
> i could clear the disk and send it to anyone intrested in ;-)

   Do you have anything likely to be writing with O_DIRECT during the
scrub? Specifically, databases and VMs. Possibly some kinds of
torrent/distributed downloads.

   Hugo.

-- 
Hugo Mills             | In event of Last Trump, please form an orderly queue
hugo@... carfax.org.uk | and await judgement.
http://carfax.org.uk/  |
PGP: E2AB1DE4          |     Unofficial notice in Cambridge University Library

--tAmVnWIZ6lqEAvSf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJY9hFaAAoJEFheFHXiqx3knLsP/1YX80HmxU/9Pep8ESvTezgU
fXeUuDb9sjiudkAEvJaPNm0XxdV/6aObe4OUfG4klCdMiEibTbp/vGR59Weq8zYZ
N5uTr3D08DiFS/7zCg1rfwnOyGKX6VRcEyv5TZ23pbQfXpXHQRMIgyymukoc8owy
dE9dqoBrXFpIFrCd0U3zASnK3YB7GZAIbC8OOtYuBS7Na/kvbpalS1IbBRTmxw1r
5UkqHIaZEbY554Hu9dCD3Q297hQ5jmzyRcCyefBD3K0LVlbqNK75sd52cL9O9RjJ
Pztc+8+u7Uq0V+XPgMuNUD+n7n5dSHMXcLDDO+Tmc6ckIOKZ4HDG2dILEVy5I8Vy
LUlPOzavqs3UGm1Ahv51GWDOy75pLSXNX9vM/FNzN83Lf828PhB14DhKWSULusCs
ktLvtmkQ57tWvsY8qSdcx4/MxG/kDUwZ/IxsCX04621lUcEm53iZPONNxsdFXO0a
euAUlajt3UOspIAMbqDzX5nBgOXkJnCDgrh9AL4ot/6OCzL2jAvpljnjrk13We13
cUOVJt6m0pw9Bn+tKHrTKFIp7PpP56Sjinc/Y+uwzJ7I0VkUzwCwT+pKXMMyr/vb
x9wf6vq2X47dWs6srQBaKdOmedbb2w5aTR93rz0XqhXqf3S2yPD0jrHuew6HK3W9
PR3+qSsA8z1xaRlxpaD0
=gSra
-----END PGP SIGNATURE-----

--tAmVnWIZ6lqEAvSf--
