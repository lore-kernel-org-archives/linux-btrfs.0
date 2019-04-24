Return-Path: <SRS0=IMPl=S2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27AB2C10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 07:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D954F2148D
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Apr 2019 07:55:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="BqC0Vu/D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfDXHy7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Apr 2019 03:54:59 -0400
Received: from mout.gmx.net ([212.227.17.22]:36199 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727277AbfDXHy7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Apr 2019 03:54:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1556092497;
        bh=FwBorx62TYYnKUJshPturYKNIBGaoQ+WHhnhvEhEDi0=;
        h=X-UI-Sender-Class:To:From:Subject:Date;
        b=BqC0Vu/Dr01bSzXW4YTAxlRKXtN6ZtZhT+tFvilz5vAX1o/dFFaH4Xcwtc4xJkhP0
         BHNK3WurRThmiWRuyf3ndgPyhEF3vS2nT60uAmfAIbK2ChWMxpOd2dCrqYhQH/vQsA
         WQaLuSj+254G7vLTpZKnVn8qNOmxzAlGI5vkK0bA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([52.197.165.36]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MSIf1-1hDXZL0aOB-00TWum for
 <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2019 09:54:57 +0200
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: btrfs-profiler: Error injection tool added
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
Message-ID: <ca15b5c6-433f-9968-9577-7a6e6cdd338d@gmx.com>
Date:   Wed, 24 Apr 2019 15:54:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OqR5hsqY8wXyWDriw2jLpwCuy6wYmqfHb"
X-Provags-ID: V03:K1:awyQ7Ad6KZe7OSLiWjE6Jf6zBvY9uscjZUq9CRXXpFL6nrAocq0
 RwdN7xBb5pfeVw12d6Eoh7WvnvDPeYGzTO4n+nE6xrHIaXQLMokeh8R6/hzYsHjyeJ2HkgR
 qCPnaT/iSYcDhOMcltlckQuFaC3Ny6VjmHvy/+4sDdBnY212Nha8qz/qBxH5zKAYOeZqYjS
 RXHPPHzpQ/g4k/vGac8ig==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/RvVGJHwk5w=:/2Lwp591t3ArA33SRWx5ma
 IpoGpvX6EKWzB6k+l6YYg9qSl0upo1p/mnDn6/xRcSvvD38JzaW2OUBgfoCkNun9y7VAM/glq
 IDIIKzTvYgGLTYB3Eg6V9QdyWoLXuAFJDCCbXAbBEjRyuZUjDo3l0SmxyuImHz3oiQbhGbeVN
 oRJMN9riBSkop4n0Hom+znsjJDC3kPhCd+TFIwtyfNQmTDzvMxoqgmLPpjnCwa7jdbAGhKqNE
 Rq65BKtyFY2cAKah5/VttLgeNIUoh4R3kMMEO/BFM5gTFw9jLMnCuO0ZYqiCdbLKIUHatYBK+
 n8HknXK1etZNLfGYbIKFtiTs7ErFmbKaWRtSjzT7dvw5r9knu3D94rTiWjVx9DEuH2rMRtF+0
 3YcBcA6fPeqy8/VLYmJIvU3E2U1EvQroAPFVwNkAZ4M8zTYMEdG+3+blM09bWA3yzfEfxq4aq
 0XVF/P35GD3TCrrEryfMQxYj2iRML5OL0FV0VNazpHQVaL5Xm2FmRBcCpJ1Q7k4GTcEWc2xfz
 m4aHlGnIAFNyHFY8rUF56Ww0QITA7yFhemiRSZms5t0qp0ZBW4CS/dprWVou9ycZbT3o2FVqy
 shmDwOz5FfRnDLzVO7JrI6I1VOoW1MnczsfUWL+qnpLp8lDmm4vm/4yseXiBpmaC6svnaj6jh
 PRcrYLRpB7/50CXxlbkpRGFAhoXbB10bWx2v5K8i3NHLK/Z2NjYB7SP5kz4ouqgYDraDw8wJt
 d8+Yu1sCHEcHr1AzW08ofONfX1q1KBU+nOhIPso1xzDfe20+iOX39pzD3dIyUMF7BUGrdyYrm
 uTs8LHRli2xSsPSnovABXxSXNzqX65GLWa8pEbVQF5mWn5z+LX6vdAnMaLBAxkNtC5djEmnH9
 7bPsavNfPLuw0mqSY0kRyTOUAZeXbcTlPjfP5okUcy64HH/LkJhP+WmtkrRc4t
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OqR5hsqY8wXyWDriw2jLpwCuy6wYmqfHb
Content-Type: multipart/mixed; boundary="7gETOfzwYQiF2NHlS6mpN6qrNvfdmUsMO";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <ca15b5c6-433f-9968-9577-7a6e6cdd338d@gmx.com>
Subject: btrfs-profiler: Error injection tool added

--7gETOfzwYQiF2NHlS6mpN6qrNvfdmUsMO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

btrfs-profiler (https://github.com/adam900710/btrfs-profiler) has added
a new tool: inject.py.

The tool is mostly a blend between bcc/tools/inject.py and Josef's
debug-scripts/inject-error.py:
- Variable length callchain (trigger) support
  This feature is mostly from bcc.
  With this tool, we can inject error for certain call stack.
  E.g. to only trigger error for the following call trace in tree block
       write path:
       -C \
       "btree_submit_bio_hook:btree_csum_one_bio:btrfs_check_leaf_full".

- Any target function support
  This feature is mostly from Josef's script.
  Unlike the limited target from bcc/inject, as long as the target
  function is declared by ALLOW_ERROR_INJECTION(), it can be the target.
  E.g. to inject error for btrfs_check_leaf_full():
       "btrfs_check_leaf_full(struct extent_buffer *eb):-EUCLEAN"

- Extra condition to check before triggering error
  This feature is mostly from bcc.
  And this support custom parameters like above tree-checker parameters.
  This allows us to filter certain calls before triggering error:
  E.g. Don't inject error for __GFP_NOFAIL calls:
       -F "!(gfpflags & __GFP_NOFAIL)"

Some misc features:
- Easier to edit C files
  Unlike bcc tool which generate the C file, making the C code
  fragmented and hard to read, this tool replaces placeholder inside
  a complete C file, thus C part is easier to read.

- Easier to understand parameters
  Good examples (although with poor English) for each option.

Limitation:
- No support for recursive callchain support
  If the target get called recursively, callchain check is unreliable
  and skipped.
  Please use -F for such use case to filter out unwanted calls.

- Callchain sequence check for lower level is unreliable
  Thus "func_a():func_b():func_c()" is the same as
  "func_a():func_c():func_b()".
  Normally two level callchain should be good enough(TM).

Thanks,
Qu


--7gETOfzwYQiF2NHlS6mpN6qrNvfdmUsMO--

--OqR5hsqY8wXyWDriw2jLpwCuy6wYmqfHb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlzAFkwACgkQwj2R86El
/qjYuwf/R/OZXo0J+j957SzWrwBU7deGewcxoHfPD8XQez/7PIvu+Q704s8XwkP+
1lM3cfZHHLBx3HyJo3EyasP1NZ5ZFY0ww0WHRCqiT0zPKzz8GJJRmuA5oG9VTqPh
LlQ4pHAjMLzdoeGW0cxXX5sGYjkJh/9xxuMqR2SzkA8R4HCu53+wc8HCLtP0zSvG
pHx4WHU2ZiVKqammARGpeD3Vh5QTa9uIOA5JwKixPcLM5o+8pYbt5yODPpqLNYqH
zuZ7K3bMNg9I1Zx9NDi29uq8Npx5q9MxcwElVDIVrT1JlP7tQ1TYoVJuugVml44W
9/s2Mm/df2fqMR9FbjJUooTQ/yxJkw==
=OdAj
-----END PGP SIGNATURE-----

--OqR5hsqY8wXyWDriw2jLpwCuy6wYmqfHb--
