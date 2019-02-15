Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0609C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 15:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C86A2081B
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 15:49:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=sd85.net header.i=@sd85.net header.b="g2RSDyud"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728159AbfBOPtB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 10:49:01 -0500
Received: from [142.93.181.243] ([142.93.181.243]:50950 "EHLO mail1.sd85.net"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726214AbfBOPtB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 10:49:01 -0500
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Feb 2019 10:49:00 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=sd85.net; s=mail1;
        t=1550245269; bh=tu6TU/c+6EyUx7eyZdCktKWQJUdvogGLb1a5/+u1H0Q=;
        h=To:From:Subject:Date:From;
        b=g2RSDyudd/stkFcF6+wZKhgRAPf+9mkr5igQFZwt0zihg4CGXifttu5xeIudtAGjO
         eKdE79Sw5swMLq2f8X7X9BFtqdc/obB58LVJhFYSnXrzIZMeUsDLIU/qwF0CXSZQps
         hIk7qymcqO+w+94RZU0Pot4FXhb5qFtA/gNIYwMA1Jy5r1EwMALwhJBhYHlzXeB1FP
         0y9E8kGoloNwmWp80lXe6++NWD5wpbwW8gP3KCb8MgwA0ld9f4FF/TM/+grpZNja7T
         MLiyXAktXABYRwA1/X/AvF6us+67pmcSMQ4s+26bYLJ9otP/15ZW9RtjRgefY/ngTC
         8xQGmBFa3/T4Q==
To:     linux-btrfs@vger.kernel.org
From:   Brian B <brian@sd85.net>
Subject: Better distribution of RAID1 data?
Openpgp: preference=signencrypt
Autocrypt: addr=brian@sd85.net; prefer-encrypt=mutual; keydata=
 mQENBFjv4BEBCADyjthJzlzcuVxBt85raqXVSIoxTLabdZkT/KxfJub5Ly05/+1ByItgPMRk
 HYmYf3QK+dmaDYeBuNZfVmPWd33f6CHVc01h2NqL3CWgMZuRSzOMINlB25xm9XR6I5763NNU
 wWrvqNxDs5/T+/0suIObe3IB3FoKkfdCbSyls13a3TKgtUiLxBZdROJZPNsxtL6R9dpxP1uE
 8DmmR07E9igqvfdKRbEyOev1LhYlDHvpKGys9JeYrYVPdeBMB1H11RvDnsdRKFeQQilGYr0k
 ZYSSJGjf0Q4HagIRw6kCgMiwD9HlwCHFKJsSCSiarumHjsWjcE9uHVZnn5yFjGpctffbABEB
 AAG0HkJyaWFuIEJhYmNvY2sgPGJyaWFuQHNkODUubmV0PokBPQQTAQoAJwUCWO/kpgIbAwUJ
 B4TOAAULCQgHAwUVCgkICwUWAwIBAAIeAQIXgAAKCRCrRF/6bTfxQUuECADnyT1nVB94ZGtY
 RkwV7w+ujV/rdmz8DcAxu5c87gJQvn6/bm8PULoD8nu149u45S7zXclEfVznl4qGQFw/pF73
 wJ0PHNsigsXYHi8oyg2YHqktXclH4104gunhSgvCF3eE6sadf1sPhv3y1vlwVyXIioKsQ4dH
 oftcTAoU5kQnNoNZORRaPnAZhXNhLpMa4T3Hi9t07drADFMn0i6vpreYk1/zwnBZQQvDRba9
 BWT47iotHYFW7uRhrbM7jyr6nie5ZeHaWI/2RNcRuGfxDLlMXETSiihYsEdnMXMZAR2XHR2J
 pmNHamrX95DWeHDsSt6EI1QOHxyYQyjCA3gu/mW5uQENBFjv4BEBCAC4L1Om/DhFjSozFWj8
 8nbNFawBeAaDCIrzXmnRXO04mqApa+GF8TRVE2qUZJi0joukmuSQ3OhK7Hj+Wh5f99LT+LAa
 FtmNE2oGDlYBy83zePAyizQQ1NK2fCv+WNotFZMIo+NHjq5ua2XrCo/X5VytPUKNMgNabZuR
 sj2UEOW3K08i0ifJ4Kq5PJFi6wRhz+lukMRzAhNtumsoD4xTTunxPf7K16rv8ElbmOP7acL4
 /A+35fB8d+1e51aApr21Z0PKHsaQfkQOOVHYXFF0oIFAVRAajrvQ3kHK+cRDFDEn0q1yIH/v
 82q9BfA4f4hPE1jZcnZ/7D4ceLUES2MpUrEbABEBAAGJASUEGAEKAA8FAljv4BECGwwFCQeE
 zgAACgkQq0Rf+m038UFMAgf+ISROpL6fo2kropyyg5is4MMGWyR9Z3DKRdSGcAAf71KA/XKj
 EA6tDjqO3MkIfuWFLjM9qivvECDHdIORGOuC4dzrou5BUv3W/2zoHABMsZzCNB4lcZwWVNYf
 pk7+JpRb+2d3Jh4O2TG3phOw1KND01dot7LQYBdk+yeHvMIoxG/XZrPfRYKEU8kFHgnugoqS
 0TMGN23fMexcnbQ4ijBKYpfuKS1S5X2U81qQiQbVuq1oBTw43OXnaosNpJkSLee1VdrlCr8O
 9NpCLZ24Jc6ZVch9xEQpIMpzLCSUpeH82nZuXPhPBhT0WpPWacZgSiVnCdMp3hbYnDdVBsbp
 /usESw==
Message-ID: <db678e75-6f56-a247-adb9-c7cca4d63528@sd85.net>
Date:   Fri, 15 Feb 2019 10:40:56 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="bf7XmRGiH28LkvdksibaIxGbAKVqfkj1j"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bf7XmRGiH28LkvdksibaIxGbAKVqfkj1j
Content-Type: multipart/mixed; boundary="ADGNqLAgNEGkEa0vrlt2ozOMAUm9d3Qpb";
 protected-headers="v1"
From: Brian B <brian@sd85.net>
To: linux-btrfs@vger.kernel.org
Message-ID: <db678e75-6f56-a247-adb9-c7cca4d63528@sd85.net>
Subject: Better distribution of RAID1 data?

--ADGNqLAgNEGkEa0vrlt2ozOMAUm9d3Qpb
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

It looks like the btrfs code currently uses the total space available on
a disk to determine where it should place the two copies of a file in
RAID1 mode.=C2=A0 Wouldn't it make more sense to use the _percentage_ of =
free
space instead of the number of free bytes?

For example, I have two disks in my array that are 8 TB, plus an
assortment of 3,4, and 1 TB disks.=C2=A0 With the current allocation code=
,
btrfs will use my two 8 TB drives exclusively until I've written 4 TB of
files, then it will start using the 4 TB disks, then eventually the 3,
and finally the 1 TB disks.=C2=A0 If the code used a percentage figure
instead, it would spread the allocations much more evenly across the
drives, ideally spreading load and reducing drive wear.

Is there a reason this is done this way, or is it just something that
hasn't had time for development?



--ADGNqLAgNEGkEa0vrlt2ozOMAUm9d3Qpb--

--bf7XmRGiH28LkvdksibaIxGbAKVqfkj1j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEE1Fb9ER7X4mVjKS1rq0Rf+m038UEFAlxm3YgACgkQq0Rf+m03
8UEN9Af/e+ITOeUlEWnZ6v/0v7vVC+A7se/liimuQP7wxXa/x6yB9uip0UW6Yt3o
9+gk78VupHkgcygiUBKJ7SLGWRPaj3+IMoU1R8u2gPIapaOJNBmWna63p7j98trL
TtQxRQbqWFizXjeh1h02KgsPvZFAaxODiQjzE1BXDPHCEB3ds0uKFge2092xxCiP
PU26+KvgLLjO+6BqYNejca1CjnGW9vdo8Ydf14qJ17l71QRoUBGIAbNbsEpMTiAh
NLvXo4fL9NKwqxoe4TCIeIHDrk4xalI2MQgrWhDsLbcUScTIo7X9MfP7Wxdsubim
fhx0o61q1qAfSo44WH7JNGqOzTJs9Q==
=WpE6
-----END PGP SIGNATURE-----

--bf7XmRGiH28LkvdksibaIxGbAKVqfkj1j--
