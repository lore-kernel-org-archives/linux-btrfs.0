Return-Path: <SRS0=QfkU=SF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDBFBC4360F
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 08:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79A64206B7
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 Apr 2019 08:54:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="IVLk9fhb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfDCIyz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 04:54:55 -0400
Received: from mout.gmx.net ([212.227.15.15]:41855 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725935AbfDCIyz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 04:54:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554281693;
        bh=+hmF9BLZh9iC041/7thQeT4yfF8Sa09/PSZU5NY2fhE=;
        h=X-UI-Sender-Class:To:From:Subject:Date;
        b=IVLk9fhbIbc7SIgdESyKWCa6iQqJtX4IlP8URFqJemiyqwEpkb+7LjYNLTN4uhCUU
         jvNlcWdGML2m32BBQUejh3et3JcmySRo154XktPi0ym8YrX6WtQpEza8sjhmL5GEXK
         HzUq4apn1QpbEqnsDXCCaxhHKpSCxBD6MimSFyrw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MYwyp-1hPVtI3aWx-00VgFr for
 <linux-btrfs@vger.kernel.org>; Wed, 03 Apr 2019 10:54:52 +0200
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Interesting btrfs csum and tree-checker performance penalty analyse
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <b1640ba7-b42b-8b60-6626-ab215c8e0b8e@gmx.com>
Date:   Wed, 3 Apr 2019 16:54:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="SXkgDCTb8TqRipkXn6erGBOmiKyhg3JaL"
X-Provags-ID: V03:K1:sEbFr8GZeql13mmFK+Zxp9oIUS34HgJoR7bZVxTqgqSC93KZiRn
 NQlI+LlYg12R43hARrzEIxqo1k6yUMze/oKNXW4yjJwoYVJOtfjoamApYjRPS9kBGt70+Kn
 sigpRPJrDcZSLG1sdAWXqtfieyWu0NEQ2wsXIN71s8/bKKiZjZR34/aM6rJj4APdpI8k88Q
 zx0BoZ5QNFbBobbvSlrWg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:I1wx6pezwSg=:n2QfnQ9OJq1EUrb0zcJd7R
 vbEK7kfYRcSmLqLu9bHy4PHejHNM2gzVe3ku9VQ17Qz241dik61K9YuMkytVgcmfKsedyRM1r
 WUyiOkRuAmPp9y5ba4enUpbmO2Q/220Gavjg4fJtZS/azrJpPKdjQjxoMQOatFSuEdPvbizI1
 SdU4hzn3TfggNtLt5XU6UgejLw6BbfrbCnKQIOkMmsX8okVVFYXvbsZQ9E5HTh7syPR/+IDKX
 I61rAUVA/GChpf4q6/XILJt6FLXWVMUuSAY7Q4RSmn1lZAnz66s+TJ6I22mxPzQRnil4wDD5M
 bCEJY/cFQLJ1kLkb6tb/wx4YFFJA1UiE2L9+C4GcEMWh9Ale+Z9Wnr5EJJWwOPemgPLbkPsV5
 9IsXXlPIyZe0dSZeZ9kwrF2LPLcdDSfq3cM+GVNBA6SUaBEuG1bycjQ0yxKXfakRDtS9P/VLY
 YNPfs7at2fwdwNw46lNkRBxp9Ld0tymYTXrd7D5NQaYhrdhc4S+yE/7Gh/lxcy8K6stjYnBPQ
 CtzNAsOMYqiP6xDUAT9QESNjK4xQGaZHgDmIv+OzvHTgRZdtTEf2YqqSkWEOV9mjscIYYvW47
 OtU8LEY6LQIb32fZIkBaZkKjU0DGLFoZxNT5EsIJTSn3EoK6Y1zO/pbfiW6ccQtvp3XoSNGhi
 TkCO/OIRtJb7fd+o+iOHp7YaWJW5eo7ME9RgXA0UfEfwjoBLnhFpruoi8gOeN02VxWK6WWzMc
 rBJ4JeRgcZPtrjDVKzodDjPfB2cLCaybmLVeICHPBs3TyqVBD0Bs2O7Drjjg9ByssqPttkXFC
 +XV1ZWgQ3S5aTHpm4j6KjDR7oJVESK17l9MpkZPA4tj5BnK0cPxNafYirInwlgtjNF3a3FI1y
 MHzfDlEGIQqSw8YKn6nzC/F3oKk4M5IASKSPEHdrDJHS5Hf9AJoVEhMkMebPku
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--SXkgDCTb8TqRipkXn6erGBOmiKyhg3JaL
Content-Type: multipart/mixed; boundary="QYIQDc1DfW6SZ0gvEc99GVHKSnRMlfoJ4";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <b1640ba7-b42b-8b60-6626-ab215c8e0b8e@gmx.com>
Subject: Interesting btrfs csum and tree-checker performance penalty analyse

--QYIQDc1DfW6SZ0gvEc99GVHKSnRMlfoJ4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

Recently Intel LKP performance test is reporting regression of btrfs
performance.

It points to tree-checker code, and since I'm poking around the
bcc/ebpf, I spend some time to do an interesting look into the
performance penalty about both btrfs csum and tree-checker.

The code base is David's misc-next, which contains both write-time tree
checker and enhanced code to handle fuzzed image.

The tool can be find in my gist:
https://gist.github.com/adam900710/b5542f2e52ed4687986cf41f64b85253

To use the tool, one needs bcc-python binding and kernel config for
eBPF, but at least Arch default kernel has all needed config, so any one
can try it on Arch.

The work load is:
 mkfs.btrfs -n 4K $DEV
 mount $DEV $MNT
 fsstress -n 10000 -w -d $MNT
 umount $MNT

 ## start my script ##
 mount $DEV $MNT
 ls -R $MNT > /dev/null # To read all fs tree blocks
 fsstress -n 1000 -w -d $MNT # Trigger enough write
 umount $MNT
 ## stop my script ##


The result is very interesting:
Basic result is:
CSUM_TREE_BLOCK: nr=3D2311 total=3D10000612 avg=3D4327
TREE_CHECKER_READ: nr=3D461 total=3D41911553 avg=3D90914
TREE_CHECKER_WRITE: nr=3D1575 total=3D5783330 avg=3D3671

So if just looking at the average number of csum calculate, it only
brings 3~5=CE=BCs. And surprisingly, write time tree checker even slower =
than
checksum!

Also surprisingly, read time tree checker takes near 100=CE=BCs. nearly 2=
0
times slower than csum/write time tree checker.

So we have a new direction to enhance tree-checker performance.
BTW, bcc/ebpf is really awesome!

Thanks,
Qu


--QYIQDc1DfW6SZ0gvEc99GVHKSnRMlfoJ4--

--SXkgDCTb8TqRipkXn6erGBOmiKyhg3JaL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlykdNcACgkQwj2R86El
/qhLfAf+PkEftY4tGYSttmBvS3DI+h8OBQtd+ycN5RaOqiJDqsvSFidw09MWC2Bg
yQXdEU+pDpFyX3eEtTOs/abuzaoZ2YHMkdMLtHYKmfcRfWFQ3FpiNGd0E5W18FR4
sgmpptI0jJsyJxc7Pz0yJitg1agHM/m6P2990JIv/IUmstswStPNVNOQSBwdDzga
hsf7LykkSAFYJlonXDJkz5vpU/PhILHm1PDq27qhp0l8thOJ/yRl5g+/dgNFgzH4
emupga3TJtVi7aAiEQZjTiwL/ye8fy7ogtezLiAQKmY//wq/y3U57HZq9zx6lN6a
2x0v7pJ4IwKCVqjBPD4ZNBnV02WSug==
=qdbx
-----END PGP SIGNATURE-----

--SXkgDCTb8TqRipkXn6erGBOmiKyhg3JaL--
