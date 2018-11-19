Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85A5DC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 03:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DA2A2086A
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 03:29:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=seblu.net header.i=@seblu.net header.b="WNkv2wfK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DA2A2086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=seblu.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbeKSNvx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 08:51:53 -0500
Received: from mail.seblu.net ([212.129.28.29]:34808 "EHLO mail.seblu.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728342AbeKSNvx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 08:51:53 -0500
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id CE57B52E00A9;
        Mon, 19 Nov 2018 04:29:37 +0100 (CET)
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id s5OWG4O8DDNA; Mon, 19 Nov 2018 04:29:36 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.seblu.net (Postfix) with ESMTP id 6AD1052E02EF;
        Mon, 19 Nov 2018 04:29:36 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.seblu.net 6AD1052E02EF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seblu.net; s=pipa;
        t=1542598176; bh=kE6pqo+F83H+osrRVfMYqV1kAeAejcc9ZbCkvqAgLHw=;
        h=Message-ID:From:To:Date:Mime-Version;
        b=WNkv2wfKB1QM+2BsxeMLC+qPdELESt02p3EonPscniXKmDq3uId128GdrPoAeta+i
         gsnTqR0SEIzHN5Nrfe1lBtqhSs3nZL19DxrRloywA3JGYBuq27UM33sf+mFq5+HIer
         KBnGelgeBXcjaWLRXoaIWfmA9JFOkveMqAW9rI3Wh9iKOxWjNBHQsz8qBVKCqhhu0C
         DwYjkB+i3+q3elfxdYwYd2is4D/AHJMgjrlIpO8HS7cMedklk6ETEnITBCw0IX8+Fr
         UZtpsPSiU5NJwC7CI6f+jsSN/1lUt0VEBDkg1RdysMZsm34oozAwUb21/0EVwSib85
         SQxAc+E5djogA==
X-Virus-Scanned: amavisd-new at seblu.net
Received: from mail.seblu.net ([IPv6:::1])
        by localhost (mail.seblu.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id JWsLThAUq8ac; Mon, 19 Nov 2018 04:29:36 +0100 (CET)
Received: from dolores (astlambert-681-1-17-132.w90-86.abo.wanadoo.fr [90.86.138.132])
        by mail.seblu.net (Postfix) with ESMTPSA id D7F4552E00A9;
        Mon, 19 Nov 2018 04:29:35 +0100 (CET)
Message-ID: <59b638cccb17aa24f2aa5ddba15a5f3f9ad4c4eb.camel@seblu.net>
Subject: Re: Broken filesystem, looking for guidance
From:   =?ISO-8859-1?Q?S=E9bastien?= Luttringer <seblu@seblu.net>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Date:   Mon, 19 Nov 2018 04:29:35 +0100
In-Reply-To: <dff4ca38-50e2-7285-10f9-2a5081c5e420@gmx.com>
References: <6e66eb52e4c13fc4206d742e1dade38b04592e49.camel@seblu.net>
         <dff4ca38-50e2-7285-10f9-2a5081c5e420@gmx.com>
Content-Type: multipart/signed; micalg="pgp-sha384";
        protocol="application/pgp-signature"; boundary="=-OTGucdPcJPbF870d5oFl"
X-Mailer: Evolution 3.28.5 
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--=-OTGucdPcJPbF870d5oFl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2018-11-19 at 08:48 +0800, Qu Wenruo wrote:
>=20
> On 2018/11/19 =E4=B8=8A=E5=8D=883:37, S=C3=A9bastien Luttringer wrote:
>=20
> You haven't post btrfs check --readonly output, thus not helpful.

The oldest `btrfs check --readonly' output I saved is from 29th October wit=
h a
vanilla linux 4.19.0 kernel. Filename: btrfs-check-20181029.log

A fresh `btrfs check --readonly' output was captured few minutes ago with a
4.18.18 vanilla kernel. The file is huge (2.7 GB uncompressed, 143MB after =
xz
-9). Filename: btrfs-check-20181119.log.xz

I saved a file named btrfs-check-20181119-sample.log with the first 1000 li=
nes
for easier reading.

You can find these files here: https://cloud.seblu.net/s/QzLk9ptSYrgofp8

> Please post the original kernel version where you hit the first kernel
> warning.
There is a lot of first time a warning. I dont' know which one may be relev=
ant.
I posted the output of `journalctl -oshort-iso --no-hostname |grep -e "Linu=
x
version" -e "BTRFS"|grep -v sdg' here :=20
https://cloud.seblu.net/s/QzLk9ptSYrgofp8/download?path=3D%2F&files=3Dbtrfs=
_kernever.log.xz

I excluded sdg because there is also a btrfs filesystem on it, but it's onl=
y
the system partition and there is no problem.

> Without any useful detail, it's hard to say, but your filesystem is
> already corrupted, by the original (maybe very old) kernel.
To give you a overview of what happen:
- The backuppc process crashed randomly during backups.
- I tried scrub
=3D> no error
- I tried btrfs check --readonly
=3D> founds errors
- I tried btrfs check --repair
=3D> segfault.
- I tried btrfs balance start --full-balance
=3D> ok, but still errors
- I tried btrfs balance start -mconvert=3Draid10,profile=3Draid1=20
=3D> ok, but still errors
- I tried btrfs check -p --repair --clear-space-cache /dev/sdd
=3D> ok, but still errors
- I tried btrfs check -p --repair --clear-space-cache v2 /dev/sdd
=3D> ok, but still errors
- I tried btrfs check -p --mode lowmem /dev/sdd
=3D> segfault (after long time)
- btrfs check --init-csum-tree /dev/sdd
=3D> abort

> Thus newer kernel can't process on the corrupted fs.
Is there tools which can fix these issue?

Looks like I can still access to the data in read-only, despite the wrong s=
ize
of filesystem displayed in 'df -h' or 'btrfs fi us /home'.

Regards,

S=C3=A9bastien "Seblu" Luttringer

--=-OTGucdPcJPbF870d5oFl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIrBAABCQAdFiEEVyJOyaX8pvvJK7iqShr8NF6+GPgFAlvyLh8ACgkQShr8NF6+
GPjJyg/AoBd1XPXYyVxTF8q6Da/KyoS6BqL9lc5IylFqstBUC1r5/R42qKPkS/Cn
ybVVXrr4xZClhcFWkIP3cmWI0VgaxoDEkQfB9j9pJRkr0AZVtSgGims1kmTzxJAd
IWtT+NGd+r2pIQjTL5e7Teym9uLKQGQH0I5mwHlPXrpBVQiM9Ber34+x6oGRHAOa
qx537+iUQHLKR0iKKYjNSK0rpE7Qedc2rO7MjkHRAalVaadXyK3trjgaVojuXVmH
MchAegjMSZGJywGeEu7WrqTLnPi/F0wlJzoRHrZOKokALjzIwaK2DNl1bGjjKMg9
m443Zm2AdOvJnuzYPsOX84GX/pzmKUBA3LCxoqUq5G/fIuZysxHlGksvAOHsco/Y
QwY/LGVxRGCR5UODQEj5mAtEQU+4+r73fkCN0Tq9mWiNY6VrHO0poTQ9XGjaFexC
4fZNbtRwhr/iIbg9ykgNsfSGYFAZnAQMT1LzD6za4JSyjkjlCx2r4l04D79xTZra
cFXS2H2Yiic1+pJmqS6CAv+o0tGUsFaStYLG+rtAkCz40dYpMrh8zwa8kCkoRB96
3nBAdWLuRsGROC1RFJ4IvayCI7vm6PEr+gw88C1wZ9cmpZzWlBui5A4vt0qqVIxY
3LQc9iUo9h6VFMWYEdIxUld4T/6i1CIvxZIQDHqQ
=d7OP
-----END PGP SIGNATURE-----

--=-OTGucdPcJPbF870d5oFl--

