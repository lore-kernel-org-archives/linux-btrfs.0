Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C10C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 01:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 253A520831
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 01:49:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=seblu.net header.i=@seblu.net header.b="eMzMYn+P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 253A520831
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=seblu.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbeKTMQM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 07:16:12 -0500
Received: from mail.seblu.net ([212.129.28.29]:43132 "EHLO mail.seblu.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbeKTMQM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 07:16:12 -0500
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id CD18952E006C;
        Tue, 20 Nov 2018 02:49:33 +0100 (CET)
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id pZ6oohOFN9T5; Tue, 20 Nov 2018 02:49:33 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id 1EDC152E00B8;
        Tue, 20 Nov 2018 02:49:33 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.seblu.net 1EDC152E00B8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seblu.net; s=pipa;
        t=1542678573; bh=nABmuuk5YQUHnc5/iCmH89whGF+FAfyj9OYs3i+vNEw=;
        h=Message-ID:From:To:Date:Mime-Version;
        b=eMzMYn+Pz4hK+RKDJG2Uozko/dDQ3uTRq8oMSJqMMSovgEZLtAT9KknRtEO+/FYXL
         9kcXxcn4V/6AJ4/g5krudkwS9i4P29FCzDzFy6YdrTOjNSdq6LUX9qkxOmA6yINWnF
         1KWYcoeTZXaHa+CVu3Qvxngw8UitkbAmdjRyl8ZkH0V5Gym6YINsWZaUhz6Au5nfSy
         g81614DQlg15Im0wMCnNxTjt2AkKlN0nRWvkbWg2Op8UySqvkayS9CDIEcg8z7q2gw
         6T6DcAruV+4OckBxXJkgV/I2Q6DHXv3V2MblNspJPdHRNemDnn8fTVo7kwTDGhzp9w
         T46+yavMlJGxQ==
X-Virus-Scanned: amavisd-new at seblu.net
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id vY_cXjPZY7UZ; Tue, 20 Nov 2018 02:49:32 +0100 (CET)
Received: from dolores (astlambert-681-1-17-132.w90-86.abo.wanadoo.fr [90.86.138.132])
        by mail.seblu.net (Postfix) with ESMTPSA id C9F0E52E006C;
        Tue, 20 Nov 2018 02:49:32 +0100 (CET)
Message-ID: <09b7f7debf43d55fc17fac94f528a30f1f3789fa.camel@seblu.net>
Subject: Re: Broken filesystem, looking for guidance
From:   =?ISO-8859-1?Q?S=E9bastien?= Luttringer <seblu@seblu.net>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Date:   Tue, 20 Nov 2018 02:49:32 +0100
In-Reply-To: <22f635aa-ee0d-7f93-87fd-5d788124ebd6@gmx.com>
References: <6e66eb52e4c13fc4206d742e1dade38b04592e49.camel@seblu.net>
         <dff4ca38-50e2-7285-10f9-2a5081c5e420@gmx.com>
         <59b638cccb17aa24f2aa5ddba15a5f3f9ad4c4eb.camel@seblu.net>
         <67736550-3c2c-0ba6-81d4-d0cdc9a1d1eb@gmx.com>
         <43ddede36c4d58bd12a9a4f549a9bf05cb9c0c1c.camel@seblu.net>
         <22f635aa-ee0d-7f93-87fd-5d788124ebd6@gmx.com>
Content-Type: multipart/signed; micalg="pgp-sha384";
        protocol="application/pgp-signature"; boundary="=-U2ghrNbOSYQXRgS6WQm5"
X-Mailer: Evolution 3.28.5 
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--=-U2ghrNbOSYQXRgS6WQm5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-11-19 at 14:28 +0800, Qu Wenruo wrote:
>=20
> On 2018/11/19 =E4=B8=8B=E5=8D=881:23, S=C3=A9bastien Luttringer wrote:
>=20
> On Mon, 2018-11-19 at 13:00 +0800, Qu Wenruo wrote:
>=20
> From 20181029, it may be possible with extra help from btrfs-progs
> developers. But at current point, it's near impossible to recover it to
> a fully functional state.
> I understand the only solution is to rsync data to another server, format=
 and
> rsync back ?
>=20
> That's the basic idea.

Thanks for your help!

S=C3=A9bastien "Seblu" Luttringer

--=-U2ghrNbOSYQXRgS6WQm5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIrBAABCQAdFiEEVyJOyaX8pvvJK7iqShr8NF6+GPgFAlvzaCwACgkQShr8NF6+
GPgy1Q+8C8U7mpqermYYuo2lgUwGdF5ntOGQuY6yjdEEJTO/58HBJAcp4/9zCdBX
2CnlmRJ4oyuomgLe02ckLI++aiPzfDW4XGyc1WyBroZzIC/xfbLVjYBEhIKlD5hi
NVGRdd+aWg97u0wdx2xEVkREO3g6IUxe6IZqP0pH4LeHdDULqJ5O1KfNZTNNKH+H
G8Tq594Kx5ntE5hv0pMMg8ODYlHnzNu1afa3I7+zM+1Stj6V7Cy6PVlljP7mHbQE
puoCEg2d4QwmEcxQaNcP/KPQNr61t71K5FvzHf8QnjlWjULhfhgwoQtcI4lEWHE3
R54gPQ/eN/umWIa/KsEj3pSTtWDmRGh6+1WG2ELO/EQZRTgK3aY0NCiO9vPLzffH
44KTJTRY3scNWCsZIz6CTDvF28fFKeLWqSO9ts5gy9CvU/vGB/w5GMCvOSeMNnf7
pp7bV/2PxxqfaRgzMLs/aIMR1CupFrsBYxPPC2Z7YkltNcfvc/wdQwWiFAHwNAVo
9lyIMn6zbcLZaf1mf+dbG4GCdcz/c4gRkjtrE+vChRUyccXTXNOQAYdvGwQL90wG
jfDfVB6WTNwlXhdhTygKP0zahgsvywmm0K0NFlQscB1U/I/I2viv6de7/ZjO4R8S
zpLdpud7iUywGg9Bct/vMgN2W0Wddkn6ZVhT4wzM
=AFiy
-----END PGP SIGNATURE-----

--=-U2ghrNbOSYQXRgS6WQm5--

