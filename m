Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 356C5C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 05:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B36BF20823
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 05:23:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=seblu.net header.i=@seblu.net header.b="cP95btnE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B36BF20823
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=seblu.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbeKSPpn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 10:45:43 -0500
Received: from mail.seblu.net ([212.129.28.29]:38274 "EHLO mail.seblu.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbeKSPpm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 10:45:42 -0500
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id AE7D352F52B8;
        Mon, 19 Nov 2018 06:23:11 +0100 (CET)
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id D_Wpe8GRbbls; Mon, 19 Nov 2018 06:23:11 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id 2762752F52BD;
        Mon, 19 Nov 2018 06:23:11 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.seblu.net 2762752F52BD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seblu.net; s=pipa;
        t=1542604991; bh=FZAGKXn2bHLs3HYwzMdgD5LAvqFJdrgatnDy/tlT4Wg=;
        h=Message-ID:From:To:Date:Mime-Version;
        b=cP95btnEH3GDTboJHl1Ho53nrwH6jcmH5/fwsxLM4HDHQ6YBWA0XNtQVXrsMtMfVY
         lqd0/PF8zrsv14DPHNvTqYNTSuMXAClvazTEJnl6VweYQz0CBCtkHqkdUA3FpI6cgt
         dqOApN/RNqlIi3Oc06YROPhZUOLijhmS7VVVkGG0l0n8jJKZzzzjJqzztzFFGzIWI9
         4UpkXYv3xPKgvxKqfqrBJ3M6mMG3QMhRxLYevw9Z4Q7uPqfVAJJXtDvUVtToigfpz0
         K5Cn9Tp+A271k/lrOFDMrsEM/Dgcpvq0hr3/3q9nCI+UwKJytWOs3GZpf83J+7xhsr
         1obBJlKU4hyMQ==
X-Virus-Scanned: amavisd-new at seblu.net
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id D9esIW6I7hxi; Mon, 19 Nov 2018 06:23:10 +0100 (CET)
Received: from dolores (astlambert-681-1-17-132.w90-86.abo.wanadoo.fr [90.86.138.132])
        by mail.seblu.net (Postfix) with ESMTPSA id BCC7752F52B8;
        Mon, 19 Nov 2018 06:23:10 +0100 (CET)
Message-ID: <43ddede36c4d58bd12a9a4f549a9bf05cb9c0c1c.camel@seblu.net>
Subject: Re: Broken filesystem, looking for guidance
From:   =?ISO-8859-1?Q?S=E9bastien?= Luttringer <seblu@seblu.net>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Date:   Mon, 19 Nov 2018 06:23:10 +0100
In-Reply-To: <67736550-3c2c-0ba6-81d4-d0cdc9a1d1eb@gmx.com>
References: <6e66eb52e4c13fc4206d742e1dade38b04592e49.camel@seblu.net>
         <dff4ca38-50e2-7285-10f9-2a5081c5e420@gmx.com>
         <59b638cccb17aa24f2aa5ddba15a5f3f9ad4c4eb.camel@seblu.net>
         <67736550-3c2c-0ba6-81d4-d0cdc9a1d1eb@gmx.com>
Content-Type: multipart/signed; micalg="pgp-sha384";
        protocol="application/pgp-signature"; boundary="=-tMHsnz7FpS+YuaqR8aSv"
X-Mailer: Evolution 3.28.5 
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--=-tMHsnz7FpS+YuaqR8aSv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-11-19 at 13:00 +0800, Qu Wenruo wrote:
> May I ask for the oldest kernel ran on the fs?
Looks like the first kernel on the host is 3.12.2.

> To make it clear again, any --init-* should only be used when you're
> completely sure what is going to happen (at code level).
Copy.

>=20
> From btrfs-check-20181119, all the extra damage are possibly caused by
> either --repair or this --init-csum-tree.
Copy that.

>=20
> From 20181029, it may be possible with extra help from btrfs-progs
> developers. But at current point, it's near impossible to recover it to
> a fully functional state.
I understand the only solution is to rsync data to another server, format a=
nd
rsync back ?

Regards,

S=C3=A9bastien "Seblu" Luttringer

--=-tMHsnz7FpS+YuaqR8aSv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIrBAABCQAdFiEEVyJOyaX8pvvJK7iqShr8NF6+GPgFAlvySL4ACgkQShr8NF6+
GPhovw+/cgG0VYenAlhtGuvbRFqYkX85D/ljVF01+y1od3yLaTdcMNvFQzq75ZZO
Gv2xz6MY8R4wMjU33BKNVYtQ553J5Y20QLp42GfnYvKpAozJDFFWscVH36BKxEP1
QRA3+iNBOFCD1bvrDjgDtczUCuDSb1T2O4+IPdCuxxWGiY/ESuNWowh1ExlbsJFq
uqKXPy/wLBJEw51agsFLVATQBcA6GHYrBDfS8NrHYaGvkt1hCHjh3m8zME7eDP9B
zaV84xY39Tux+CcXS91gevaXCTmgIk61LJkdEv4IjXZ0IhAeUxYEJDbSaKmC+oRl
0cUmfJ8LoaiVUvqc8NObfrBpcgaGq+FRXXnUPrMxx5C7x+fZXGci81bpBYZrMQKR
iDr+IJV+53vRUKGOuwCugXiWpjJv/Pxp1uo5d6vHjx/+ErSr5ZtXtNlZ6l2t9l12
k0DbJoIzzXOPjqeMRnXodkhJTUZD5BvwSYyxjvoRkyU0W/YXb05W9tL6+MLm5DRn
127oI7n+JZRa466PsrXUW6lQ9FrZRQ6V6vuWKYyfQ8vtUttkz3//rs4kxke231B9
4ov5ar4bgg3dm8X85L4y8VbobCxy/F5mb96Bmv//k5yCX7Cq4Hm3wRrfEFUUHwHC
J6AoA4XW2JwGS+yN1HMb9RfotorFYq9bOkq92uZ6
=Gv0E
-----END PGP SIGNATURE-----

--=-tMHsnz7FpS+YuaqR8aSv--

