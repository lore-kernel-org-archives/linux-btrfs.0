Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5508C282CA
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 19:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A20CC21905
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 19:09:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="GjwjCdYw";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="aZpfJl1U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbfBLTJh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 14:09:37 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:33891 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726748AbfBLTJh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 14:09:37 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id E41AB2206A
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 14:09:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 12 Feb 2019 14:09:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=from:subject:to:references:message-id:date:mime-version
        :in-reply-to:content-type; s=fm2; bh=IbK9ZdEHdfZ9ERdvHtUXHAFchXd
        UTZBJR/8jueGIxd8=; b=GjwjCdYw4q/iFVvyZyaZZS5Ur3XgSgBdGS/Db1J+AWA
        22OpsE0A8A0AabPC5MiDQ7+VUO+/hMhPjTiVkhb6HyrR0r2Z26Iuc7l/bHJJEQ6R
        4ow5FvE0jbG4tXyCjjWDF0LOnnHkcd3enweP7F5Xhj2Ye28WBfFsMxEVwhux+Ey1
        7MWUrOSmhpXA8Ir+q22Pt296X+YKQJKq3tVh7fFoeFSp3VFltbDgN1i++h6grGgd
        4i2Y82LA1BTUT7sITN0AjtQPJySrk7QEUdH49mjCriUKhSZoeAEiaGzn4Zn4pVH1
        LviNHnC8aSaRlMibV/OdrLyANWWw1ywpHvSOlMasang==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IbK9Zd
        EHdfZ9ERdvHtUXHAFchXdUTZBJR/8jueGIxd8=; b=aZpfJl1UGUGhMddNsUBOn9
        0tLfC0KkwVCJL2yc9v95jNg83mZaG+OmTOwSfFCeUps8BOUFw5iap9CJ8ejHEwEV
        DK5f5q1yyNMiubdpXt/3Ct5Tr3AL+CcAm/G54IIgOqhX0CpgLGJtSfuhZTok2x4n
        QWc5qkFhNYmzQYJBxeGlR1ma0yN60mIsrv2FE0/JkWd7sOyioU51jbEj/eBPbfVg
        chwD57Ff+N1qGD0iJJs+LPFW5bqxPkpr2tN4sTAiZRdVPpe4A9zcos3mrGK8aG0J
        B8WlyLQxoVUASgKNwqnNtBgtj2y8MY1x4dascJXGM1yPr7LRr3X5Hv8rO/EGQWig
        ==
X-ME-Sender: <xms:7xljXL9nw4S90-C5RB5TzxyyHRKRZJ6a2rdj9mObwYNBGnNW5bPHuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledruddtuddguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecu
    fedttdenucenucfjughrpefhuffvfhfkffgfgggjtgesghdtrefotdefjeenucfhrhhomh
    eptfgvmhhiucfirghuvhhinhcuoehrvghmihesghgvohhrghhirghnihhtrdgtohhmqeen
    ucfkphepudefhedrvdefrddvgeeirddufedunecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hrvghmihesghgvohhrghhirghnihhtrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:7xljXDb_ItBZUR2XIABjQxCJK9gQcMFAouiCcSKHFD6ef0yU1XBQ5w>
    <xmx:7xljXFcvblrJ-tq9ZPOEetBaZ-Zzt25RME4gy2A86WenEm--APjRmg>
    <xmx:7xljXAkqxPEZSr-VjCyyhrIBPophbjuYl6xZr0kpfr8fnp88G98csA>
    <xmx:7xljXOE9rTMC3fRXBlh6W9SwbTVTi7yhokVkDQhbdwBg0XqG-OA78A>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id 52995E4652
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 14:09:35 -0500 (EST)
From:   Remi Gauvin <remi@georgianit.com>
Subject: Re: [PATCH RFC] btrfs: Don't create SINGLE or DUP chunks for degraded
 rw mount
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190212070319.30619-1-wqu@suse.com>
 <aabbd673-fdc0-77dd-7e1e-1b5d1ed12bff@georgianit.com>
 <964481b6-e761-8d0d-3ef1-cbe19dbfae9e@suse.de>
 <79f33db2-f39c-6bd6-4697-d9d9f6a704f1@georgianit.com>
 <d5ad9e15-a572-2819-c39f-43d4c0ff2832@suse.de>
 <d1093c59-f432-b2b6-ca53-e46414c945a6@gmail.com>
Openpgp: url=http://www.georgianit.com/pgp/Remi%20Gauvin%20remi%40georgianit.com%20(0xEF539FF247456A6D)%20pub.asc
Autocrypt: addr=remi@georgianit.com; prefer-encrypt=mutual;
 keydata= mQENBFogjcYBCADvI0pxdYyVkEUAIzT6HwYnZ5CAy2czT87Si5mqk4wL4Ulupwfv9TLzaj3R
 CUgHPNpFsp1n/nKKyOq1ZmE6w5YKx4I8/o9tRl+vjnJr2otfS7XizBaVV7UwziODikOimmT+
 sGNfYGcjdJ+CC567g9aAECbvnyxNlncTyUPUdmazOKhmzB4IvG8+M2u+C4c9nVkX2ucf3OuF
 t/qmeRaF8+nlkCMtAdIVh0F7HBYJzvYG3EPiKbGmbOody3OM55113uEzyw39k8WHRhhaKhi6
 8QY9nKCPVhRFzk6wUHJa2EKbKxqeFcFzZ1ok7l7vrX3/OBk2dGOAoOJ4UX+ozAtrMqCBABEB
 AAG0IVJlbWkgR2F1dmluIDxyZW1pQGdlb3JnaWFuaXQuY29tPokBPgQTAQIAKAUCWiCNxgIb
 IwUJCWYBgAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQ71Of8kdFam2V1Qf9Fs6LSx1i
 OoVgOzjWwiI06vJrZznjmtbJkcm/Of5onITZnB4h+tbqEyaMYYsEIk1r4oFMfKB7SDpQbADj
 9CI2EbpygwZa24Oqv4gWEzb4c7mSJuLKTnrhmwCOtdeDQXO/uu6BZPkazDAaKHUM6XqNEVvt
 WHBaGioaV4dGxzjXALQDpLc4vDreSl9nwlTorwJR9t6u5BlDcdh3VOuYlgXjI4pCk+cihgtY
 k3KZo/El1fWFYmtSTq7m/JPpKZyb77cbzf2AbkxJuLgg9o0iVAg81LjElznI0R5UbYrJcJeh
 Jo4rvXKFYQ1qFwno1jlSXejsFA5F3FQzJe1JUAu2HlYqRrkBDQRaII3GAQgAo0Y6FX84QsDp
 R8kFEqMhpkjeVQpbwYhqBgIFJT5cBMQpZsHmnOgpYU0Jo8P3owHUFu569g6j4+wSubbh2+bt
 WL0QoFZcng0a2/j3qH98g9lAn8ZgohxavmwYINt7b+LEeDoBvq0s/0ZeXx47MOmbjROq8L/g
 QOYbIWoJLO2emyxmVo1Fg00FKkbuCEgJPW8U/7VX4EFYaIhPQv/K3mpnyWXIq5lviiMCHzxE
 jzBh/35DTLwymDdmtzWgcu1rzZ6j2s+4bTxE8mYXd4l2Xonn7v448gwvQmZJ8EPplO/pWe9F
 oISyiNxZnQNCVEO9lManKPFphfVHqJ1WEtYMiLxTkQARAQABiQElBBgBAgAPBQJaII3GAhsM
 BQkJZgGAAAoJEO9Tn/JHRWptnn0H+gOtkumwlKcad2PqLFXCt2SzVJm5rHuYZhPPq4GCdMbz
 XwuCEPXDoECFVXeiXngJmrL8+tLxvUhxUMdXtyYSPusnmFgj/EnCjQdFMLdvgvXI/wF5qj0/
 r6NKJWtx3/+OSLW0E9J/gLfimIc3OF49E3S1c35Wj+4Okx9Tpwor7Tw8KwBVbdZA6TyQF08N
 phFkhgnTK6gl2XqIHaoxPKhI9pKU5oPkg2eI27OICZrpTCppaSh3SGUp0EHPkZuhVfIxg4vF
 nato30VZr+RMHtPtx813VZ/kzj+2pC/DrwZOtqFeaqJfCi6JSik3vX9BQd9GL4mxytQBZKXz
 SY9JJa155sI=
Message-ID: <4b92d34e-e45a-970f-c14e-53fadeaf19fe@georgianit.com>
Date:   Tue, 12 Feb 2019 14:09:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <d1093c59-f432-b2b6-ca53-e46414c945a6@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="q7zDv4wD0iNgoCjCifLp65Qftvzvbkwo0"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--q7zDv4wD0iNgoCjCifLp65Qftvzvbkwo0
Content-Type: multipart/mixed; boundary="j1EnanjBOYA8OemS6OxQkHxQupGY8xz11";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <4b92d34e-e45a-970f-c14e-53fadeaf19fe@georgianit.com>
Subject: Re: [PATCH RFC] btrfs: Don't create SINGLE or DUP chunks for degraded
 rw mount
References: <20190212070319.30619-1-wqu@suse.com>
 <aabbd673-fdc0-77dd-7e1e-1b5d1ed12bff@georgianit.com>
 <964481b6-e761-8d0d-3ef1-cbe19dbfae9e@suse.de>
 <79f33db2-f39c-6bd6-4697-d9d9f6a704f1@georgianit.com>
 <d5ad9e15-a572-2819-c39f-43d4c0ff2832@suse.de>
 <d1093c59-f432-b2b6-ca53-e46414c945a6@gmail.com>
In-Reply-To: <d1093c59-f432-b2b6-ca53-e46414c945a6@gmail.com>

--j1EnanjBOYA8OemS6OxQkHxQupGY8xz11
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-02-12 1:42 p.m., Andrei Borzenkov wrote:

>>
>=20
> But if I understand what happens after your patch correctly, replacemen=
t
> device still does not contain valid data until someone does scrub. So i=
n
> either case manual step is required to restore full redundancy.
>=20
> Or does "btrfs replace" restore content on replacement device automatic=
ally?
>=20

It should.... Qu's example assumes the drive being replaced stays
missing, in which case replace is copying all the data that should be on
the missing drive from it's mirror source.  There should be no
difference between the data that used to be there and the data that
didn't ever even get written there in the first place.

For some reason, my mind last night got stuck on the hypothetical
situation where a volume is mounted and used degraded, but then the
missing device, presumably not faulty, get's re-added.. then things
would go bad quickly.  But I concede that scenario falls squarely in the
"That's stupid don't do that" category.







--j1EnanjBOYA8OemS6OxQkHxQupGY8xz11--

--q7zDv4wD0iNgoCjCifLp65Qftvzvbkwo0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcYxnuAAoJEO9Tn/JHRWptK2QIAJ3tf3PXSk5s7ykBJMp3TzS8
Aru6CB6l02xOtnRy3LBMZABQq5eRsqebQL4NmGkJOKbhN0kkIAyrBDS7GwJMGPpG
sXfq5eKVKIJnmeWjYmx1LpgsPnoY7CiSMBwjATOOkALc4xhTIicmxDO/sdc3alrO
hh8/yk4dX/Z1UzELOb84FYjR60SLXJWLH84YKVApgH4zZLkoc1q247MPdvwPEXf/
DHrmlOf95HMnr0/bwabKMD+dKkUQll2nabxm7jo8pkF1lGf5ghBK2td2kk7Z1zI/
KdbKdLTnR1VBga4wdQTlLkaXcNIiTwUMhI951I+Fu/5ysOQetBu+cd8Mukdo6NQ=
=BbU2
-----END PGP SIGNATURE-----

--q7zDv4wD0iNgoCjCifLp65Qftvzvbkwo0--
