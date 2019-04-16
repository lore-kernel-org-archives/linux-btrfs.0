Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8633EC10F0E
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 02:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EE162070D
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 02:29:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="D1Oaiys4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfDPC3J (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 22:29:09 -0400
Received: from mout.gmx.net ([212.227.15.18]:42627 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbfDPC3J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 22:29:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1555381747;
        bh=xBq6HVHQAxCiNVdiP3K3co9PVnVYyTAqr3D5vMv6XdQ=;
        h=X-UI-Sender-Class:To:From:Subject:Date;
        b=D1Oaiys4kOnDz80PlPKVuC1ImD76hK6/30RzSdMLv8giVqRv7qURun+M7/IRyCXpN
         OhwSjWOe2oHvo+jM3nJdoCnlPgp6ByTgeXmj0/QbMKk99ljjYUHTEaohpAeJe74CCJ
         VrL0YIJy3MY92hYnu/9oFssJD4D1AFEiqz9c8ZMI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MO77c-1hAhSY36bU-005bCN; Tue, 16
 Apr 2019 04:24:03 +0200
To:     David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: [PULL REQUEST v2] btrfs-progs updates, the main part
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
Message-ID: <cb2ed110-4ad0-6f72-2dcb-fe150bab461e@gmx.com>
Date:   Tue, 16 Apr 2019 10:23:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fpNvBfWaVx2ihyb2PWLPFzxBBuhX2pVzm"
X-Provags-ID: V03:K1:RJ46AMobSpGPnywm8U7hbgtO6JaBqMFRIDH28iCMi9T2p7Z7FTA
 6Eru0+bcRyyk+4hZHgV/gkIXrIgauZ6Ryeqs6F7rH7dSLxp6tVQGJ0qzom3opSWzEfcQVFE
 DCeF1JgJO96AxiX/a/AYs1WNc146QOI3edRpsEtYZIDd0XHB4VX3OoRHVqOjnhx5U6DRYr6
 67Rte6U7kI21sFHe0P+eg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ILd5FE6CXHc=:MD7de8ginMDNtyEZwDd2C5
 mvjr7odjHISUK06KH7q4ThPKRgu5QGIDEu7K6ltvBwKQVRh5U7IW84xCg+WZS0Os9yTHMZfXL
 9XNXxYOAgRC7YreF7pE3CsV20FXPwWKYmR7hUjBhbVdKE8pRS04BGmE4WVZP7BXki0j4E/QNx
 3fKQtgmB59zgM7fH56BqJJg4tzIk1uTqFaOmfUUGbvlrWpGX221O03ytlnlIk9BND0mqD2eHB
 jP5MDhLYQpkrT6LaWqeCaTgMDcB2pR111YtVd1/Qa9gX2j459LJqidn+9QlThVhM2NunQViaw
 FBHBhfdh1oq+N7LA7B+BMc/0+cPfsbyBR1fZ+7fU+E2lVYJC3ngDvXW3QPhG61G0tp/hUwDYt
 pHrJR9iHltH2s9X5wPpR/38ryotxHwq4k06c4AVwrc23VlUMjpLdnt43SDbnvpMc81L51DIxT
 S8+ZkxJyTi49EJ2AIsOBX0nq/0OZx6HpAYbt+gsmGfwwzmhu7smcMNF0U9dHq4yrAKZz6/+l2
 arpCCJ1Sek5D8tvNkmN8TXEisBExArx/w+qdkzIRQOXfFT1IrAFEryNy15PTVshYMjqo73yKB
 P3lOQDt7cXU3ZCONZbIerlf7yLHKjLTLuwSX9gzfIShbJ+f+8AfpoCGe1OQRafJZLgbQr4kAd
 w0WeYRrXoXnuL1i3z/630YzomKPJoZJk8fWd5YWhcz9g71yA4veQP5q1igqBH+wf/dWs9745O
 iyi/+bC9dPIkfqLrm6OUIl4AnGCERypGDEvsvwTvn95rxxz5eNjlzfI7PRgwiXCXW9kU5BNzc
 s9cG3lOjg1qUOLSsOa2RZIsHFbAv6rSLHI7MCL49cH3L85tZlig9+MVwFkloLpQZn4ln7Ch3p
 mIXoh4uvMCJJ0CB0snv4e9+/HlomKXU+F0LjMC8Y+oGxk66aNSw2a4PLRhOyP6
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fpNvBfWaVx2ihyb2PWLPFzxBBuhX2pVzm
Content-Type: multipart/mixed; boundary="Yairbt5obpG7l0IKtv3TfiTkGw2sal5yy";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: David Sterba <dsterba@suse.cz>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-ID: <cb2ed110-4ad0-6f72-2dcb-fe150bab461e@gmx.com>
Subject: [PULL REQUEST v2] btrfs-progs updates, the main part

--Yairbt5obpG7l0IKtv3TfiTkGw2sal5yy
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi David,

Here is my pull request for the btrfs-progs:
https://github.com/adam900710/btrfs-progs/tree/for_devel

The basis is the following commit from your devel branch:
commit cfa470d5a6b6b305fed4898b64db31c125b4dcbc (david/devel)
Author: Nikolay Borisov <nborisov@suse.com>
Date:   Mon Mar 11 12:20:56 2019 +0200

    btrfs-progs: Remove get_argv0_buf

The commit on the top is going to revert 7a12d8470e5f ("btrfs-progs: Do
metadata preallocation as long as we're not modifying extent tree").

You can drop that commit if you have discarded that commit.

The branch passes all selftests, except:
- misc/035
  Known bug as the fix is reverted.
- fuzz/003
- fuzz/009
  Not a regression, as stable tags also triggers them.
  BUG_ON() in commit_transaction get triggered due to ENOSPC.
  These two bugs will be addressed soon. but not in this pull.

This pull request include the following features:

Core change:
- check --repair
  * Flush/FUA support to avoid breaking metadata CoW
      Now btrfs-progs crashing or transaction aborted won't cause
      new transid error.

Fixes and Enhancement:
- generic
  * Try best copy when reading tree blocks.
  * Skip unnecessary retry when one tree block copy fails.
  * Avoid back tree block to populate tree block cache.
  * Don't BUG_ON() when failed to flush/write super blocks
- check
  * File extents repair no longer relies data in extent tree.
  * New ability to check and repair free space cache invalid inode mode.
  * Update backup roots when commit transaction.

- Misc
  * fs_info <-> root parameters cleanup for btrfs_check_leaf/node()


For reference, the devel branch itself contains the following features.

Core change:
- device scan:
  * Add the ability to forget a device

Fixes and Enhancement:
- generic:
  * Better unrecognized/invalid option handling.
    Including btrfs-prop, btrfs-qgroup, btrfs-find-root.
- mkfs:
  * Enlarge metadata chunk size to follow kernel size.
- dev-replace:
  * Better error handling and error message.
- receive:
  * New quite mode.
- dump-tree:
  * allow multiple --block to be specified.
- misc
  * Fix compiler false alerts about uninitialized variable.
  * Update gitignore file to ignore dot files.
  * kernel version parsing fix.


Changelog:
v2:
- Reorder the tags to follow the general guideline
- Rebase to latest devel branch
- Add SoB line for commits not authored by me
- Add revert commit other than dropping the offending commit
  This should makes merge itself easier.
- Updated the cover letter feature list
  Split into two parts, the features introduced in this pull, and
  the feature introduced by devel branch.

Thanks,
Qu



--Yairbt5obpG7l0IKtv3TfiTkGw2sal5yy--

--fpNvBfWaVx2ihyb2PWLPFzxBBuhX2pVzm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAly1PL8ACgkQwj2R86El
/qhQxAgAnH+jCvqUWzIbuJRVwKKnqNzrv2bg7pb7UDxbwF/Q+wfOVM+2xyiBxhLs
9v+eFQKnd3yCTgXQcykkuu1PGrADEuYtFohyE8DUaa9iHKXp/g6hkdSOP7Y3oANM
THr5hB978gx2zN5JFSCNEHQ9xzbfgMxeTPMyJ7wQiKmJujrQSuEo9gKrfiK74R1a
LQ/qXGA0wHXpgVAMMb2EfXZtQ/cuFPVfNqSnnF8SiCgmGPq3f15urjWCVr0C9S2u
bXkF98vbohbQ21AIQvHN2W8nzB+aCBOYxqhO1cxAQEHjjiFnprS0lhuM1wBqUeLz
Yhkh9kVYFQN/3SvjFFk/72gTShdd8A==
=wEnx
-----END PGP SIGNATURE-----

--fpNvBfWaVx2ihyb2PWLPFzxBBuhX2pVzm--
