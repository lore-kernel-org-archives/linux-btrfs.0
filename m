Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C84C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 18:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0A63222A1
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 18:56:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=georgianit.com header.i=@georgianit.com header.b="OYDqH/dL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Z2CtqOlx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390758AbfBOS4H (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 13:56:07 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:40649 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387768AbfBOS4H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 13:56:07 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 198AE329F
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2019 13:56:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 15 Feb 2019 13:56:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=georgianit.com;
         h=subject:to:references:from:message-id:date:mime-version
        :in-reply-to:content-type; s=fm2; bh=bk73rRRYVTxIf9Qt30f+0b1/sgT
        TdAHp3vk04DFlp/Y=; b=OYDqH/dLi9yUAcNy+LeNPgRY/q4tMvztv5nOIklMdPS
        n//fSA3rc/TSoRyKUfeoPGmpWR8lb86eDlzo7/5m+ypNBgZhsomB35vi0YgRsp8a
        sJLgK7sKh+76y8oKTidrFGceOm6DP2yXcmB98WlRAad40jeMxWEKpjav4CRiwJqX
        AJP08hLpyqm6dz6dI1hjO1/BVSI2kJ2I0K6cmz8POeO1cuqgHV5q6OpqVCx7yTjW
        dl+/+rJm6odnzid467Ky/C67C52H7bob8ZYrHQOuZtsIOnGr0sZ9+m1ShbOtDvOc
        fQt8H5e/EWIjJMb+lC1fHGbEE8OST0nK4DqNLKwyAcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bk73rR
        RYVTxIf9Qt30f+0b1/sgTTdAHp3vk04DFlp/Y=; b=Z2CtqOlxkCSUdPsja0JPCr
        gCIics2M5+HNf/l5YynvJxcigReva+/4wgPgSODUQYqm8uA9sRQuXV1655YMKAsM
        4X88h48pQM0ky0+MaGGgMgcwiiP8cvtrercU87scY/7IkVk0CWWDI1/g/lCU6hf4
        Kswsx3yTJSYuT2veekYmloXsy+6p2ltozrHGC0ooIOoV0kMQeip6OyeTb+9bXCtE
        Q6TlXh8vOmQx5lh/JlSgUIpRzkFouQQPPTNlDJf3WMbMBn7EK+POok/8AVev1pue
        +DbjGQ6wmW8FfQQsO8EMPRJ23vXwvfkQt9mO+CovjUV+fU07B4rzlEviMzlJYYig
        ==
X-ME-Sender: <xms:RQtnXEy8SV0rqjLQ3MBJNgBOapuui2CghoB88O1D9LObIm-FX7FuKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedtledruddtjedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfhuthenuceurghilhhouhhtmecu
    fedttdenucenucfjughrpefuvfhfhffkffgfgggjtgesghdtrefotdefjeenucfhrhhomh
    eptfgvmhhiucfirghuvhhinhcuoehrvghmihesghgvohhrghhirghnihhtrdgtohhmqeen
    ucfkphepudefhedrvdefrddvgeeirddufedunecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hrvghmihesghgvohhrghhirghnihhtrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:RQtnXJzdcr9FbVZuDgCm7IJXOeuFem52fZes4Z66yYmL36MQpWD--g>
    <xmx:RQtnXK7i4Y4YGL_cmC4f8mOQ4Veh28p1ibhJ70-hSvYuaevIDTkLxA>
    <xmx:RQtnXCCCL0jvRSF95_kYwdTkAb32fDI_rUltNqgzgmiKcVl5AdWHgA>
    <xmx:RQtnXCX8R9c890ScrjZQKQ6L5-qxnfm2mVvuBqeb7nzbEtrwTqBjDQ>
Received: from [10.0.0.6] (135-23-246-131.cpe.pppoe.ca [135.23.246.131])
        by mail.messagingengine.com (Postfix) with ESMTPA id F346FE46AD
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2019 13:56:04 -0500 (EST)
Subject: Re: Btrfs send with parent different size depending on source of
 files.
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <CAJCQCtQnNQeGsi=K+pgq1sa9t8GQO1yMNx=UcchGs79zM46cTg@mail.gmail.com>
 <d8a2685c-1844-fd01-de2b-00425458df2a@georgianit.com>
 <CAJCQCtRTOcCttXm_pP5nnxnfn86ApgPxSPu81ffvQGBTNPKZ+g@mail.gmail.com>
From:   Remi Gauvin <remi@georgianit.com>
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
Message-ID: <ee16ad81-2e27-ff71-91dc-ea25cb7da924@georgianit.com>
Date:   Fri, 15 Feb 2019 13:56:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRTOcCttXm_pP5nnxnfn86ApgPxSPu81ffvQGBTNPKZ+g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7YYtCRpHLRfbm1HuoVVT95PBSR8JrOAsK"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7YYtCRpHLRfbm1HuoVVT95PBSR8JrOAsK
Content-Type: multipart/mixed; boundary="WfZrxyDOxQu4Taxy33QgjIdZmj56NoQFo";
 protected-headers="v1"
From: Remi Gauvin <remi@georgianit.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <ee16ad81-2e27-ff71-91dc-ea25cb7da924@georgianit.com>
Subject: Re: Btrfs send with parent different size depending on source of
 files.
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <CAJCQCtQnNQeGsi=K+pgq1sa9t8GQO1yMNx=UcchGs79zM46cTg@mail.gmail.com>
 <d8a2685c-1844-fd01-de2b-00425458df2a@georgianit.com>
 <CAJCQCtRTOcCttXm_pP5nnxnfn86ApgPxSPu81ffvQGBTNPKZ+g@mail.gmail.com>
In-Reply-To: <CAJCQCtRTOcCttXm_pP5nnxnfn86ApgPxSPu81ffvQGBTNPKZ+g@mail.gmail.com>

--WfZrxyDOxQu4Taxy33QgjIdZmj56NoQFo
Content-Type: multipart/mixed;
 boundary="------------226E043AF94E5C0E0B4ED11F"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------226E043AF94E5C0E0B4ED11F
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 2019-02-15 1:38 p.m., Chris Murphy wrote:
>
> Well I'd say maybe use -vvv and --no-data instead of -f and see what
> it's doing. It sounds like the former has no payload, just difference
> information, and the latter has a payload. I don't know why.
>=20
>=20


Both have all the payload they need to re-create the subvolumes.  The
first one correctly CoW's the file from subvolume a.. the second one
stuffs it in the output... Why is indeed the question.

--------------226E043AF94E5C0E0B4ED11F
Content-Type: text/x-vcard; charset=utf-8;
 name="remi.vcf"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="remi.vcf"

begin:vcard
fn:Remi Gauvin
n:Gauvin;Remi
org:Georgian Infotech
adr:;;3-51 Sykes St. N.;Meaford;ON;N4L 1X3;Canada
email;internet:remi@georgianit.com
tel;work:226-256-1545
version:2.1
end:vcard


--------------226E043AF94E5C0E0B4ED11F--

--WfZrxyDOxQu4Taxy33QgjIdZmj56NoQFo--

--7YYtCRpHLRfbm1HuoVVT95PBSR8JrOAsK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJcZwtEAAoJEO9Tn/JHRWptmoYIAJ4ml+sQaaaKq/XgPnuyO1F3
Si+M7ppw8V/0tXi1/V611sv7Z4RpqEWIhUhJsWMn0JWZGvgVRCHrrwZsr1YzLels
pnRa72l+8CnqpeKuQQ76NDxnjkZT80/Rk9CYfOu/U4Dlk0yiNoYSd/rEoYHus688
4zxQp8rhuVzJelhgu45vVVxDrmMyCI48RlcSxEXpIswnt1EMCfQbGJnvSxQWZz4y
UAl8Z501rJcYtn8mBxYl5LphnO1xDEeezHRNBWwLJ8kbUkc6B2xXkZbQ9TYPNmR+
r/hlkvm4Qhtpu59UR+ROuBoDhp01miQ6guR1PzMZtqJuJoWYwASYE86xFPC/iaI=
=BzSC
-----END PGP SIGNATURE-----

--7YYtCRpHLRfbm1HuoVVT95PBSR8JrOAsK--
