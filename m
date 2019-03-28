Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4082CC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 05:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB14D2075E
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 05:51:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="MKQSsxCN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfC1Fvf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 01:51:35 -0400
Received: from mout.gmx.net ([212.227.17.22]:33921 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbfC1Fvf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 01:51:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553752286;
        bh=ZQKRNyJCx1OEFzKAMRRAdHuH6VkV+c9qDqaMAZSFB/s=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=MKQSsxCN0FNTa8ukfIwAw2sOLIi3r6bhR2vW+DB6Oi6hrWrQLiis7Uf/76u6uI4do
         9ybAsVh5T89q9sz2KDGLAEKqPFlGqm/3Rph/lzG8UkgQqXe1pM0MzVndZPd77nc9vU
         nAKywAWkP2nrphlrgzIBGw0MSpzFtgzmBbh8JTtU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LmNHK-1gasPO34V8-00ZuEX; Thu, 28
 Mar 2019 06:51:26 +0100
Subject: Re: [PATCH v1.1 00/14] btrfs-progs: check: Use fs/subvol trees to fix
 extent tree, not vice versa
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
References: <20190227060552.3841-1-wqu@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
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
Message-ID: <5db416d0-ada1-3ea6-bac1-88eaedea61c1@gmx.com>
Date:   Thu, 28 Mar 2019 13:51:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190227060552.3841-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ndvaqDNUyA3a4YwLDQdm4jizqVIae1B6S"
X-Provags-ID: V03:K1:p9utF8q6teKIrtZ7bG4UflhS10HEig6G+Xwro9nLOGsM/4ecHE5
 ILl7GiF92aiokSgxMyTekhQWPaO0Zljqa6+zoJhrFSMe3V67cC5igr3hx0l0KNi37vJhv4i
 7oqAd1b2Ar9h8r+seOg+TJoEaDO+UTGO1YHldNehDS29VWA55UfR2P7/2X5+Dz8jLAuiYza
 OxhJb1fEfbh5RX3QCHD8g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:sd+WtaMsns0=:aXPZHPDYHTS2gFNgF6UDbl
 497wtkfqSbTrk0Q6u/15ZBefbvveDqtAUPQepIHw+SYtSeHXeLDxBzrlYGY/cq4Uj+MwF72wW
 LIXUogOFG6xuVx3Jtmox2lePrsNYFLOQbUCrKzezDH6dpIo00nrCZ87SC9n4pH8w11lpzTVz3
 EZAa2ax13G6hk8TRk3xzfGRjMY+U/6HjdCOdf1e4DN2r6MtFIFncIu0Be7nKFEibWIHS7Ybss
 3mEr73HDG8U2r9iJVnvNA+/iVfFuDGNTR59wsZ7V6xij1CPxVMMrD2O/5c6y1JQ0HPqD1jVTu
 3z0WsRGSc28cp4U40SKzyYa09Ud2DDNfgLT+qgQtrCIJ1RIE1dl5ROp64G/amC/und1dLTv1L
 zhRTymRroRAE3KYQwfjE9J0GTc5oy9rlF3PwJ2sM9YL+SWLt8DINnn7cpQTfzLlzJMKeNEHfn
 AKs2xvV7T/zmxCa2S3QqwXKk1Pu5gu8c3+LhQ1/xd9TnQii7eHrpkBCJJ3aTDoiBJ88duCyri
 +582bDAIDZgbQYeGpTMoETn3LR4DzgUJ2wyofAdHc+3vTttsMNRO2b8r20pTa6Y97cAmue6TL
 q45lkwKKYdWqfbfN21SXJvSJHHJmaTLNrkXSxZpGlJm6GkJ127m8QkfVumcStx6VhIBcxIM92
 /SgYwIGYjYJIWkXzm/pJrqbGLRHnPlrT4YP5n9TJyc4/2XzoCpoEUsFFsTCks1AJ4W2nwI33/
 06E6i/tnbvXvOFSyN1KJFMApkHhfU0rr2K5vngk9U6LydKUNv5bVwKO5mt30JAWWv11JAuQQU
 P36+9A3b2ebmbTWSTr8BBiYhuhSFS+Wz/34/XQoF2fTt1OjwvzcKzuFmt4w03lDRJNyOjOrtX
 JOEtJQW5BB+lc4hP0f2b6JoMkDqr9liLJTQUGx+hLOVSEZ/RMOsGXVKsQlEM/l
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ndvaqDNUyA3a4YwLDQdm4jizqVIae1B6S
Content-Type: multipart/mixed; boundary="qyinQ8K2LVKAizCF4N4KwHLFlqdMz9U8N";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 David Sterba <dsterba@suse.cz>
Message-ID: <5db416d0-ada1-3ea6-bac1-88eaedea61c1@gmx.com>
Subject: Re: [PATCH v1.1 00/14] btrfs-progs: check: Use fs/subvol trees to fix
 extent tree, not vice versa
References: <20190227060552.3841-1-wqu@suse.com>
In-Reply-To: <20190227060552.3841-1-wqu@suse.com>

--qyinQ8K2LVKAizCF4N4KwHLFlqdMz9U8N
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Gentle ping?

Any comment on this?

Thanks,
Qu

On 2019/2/27 =E4=B8=8B=E5=8D=882:05, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/file_extents_fixes
>=20
> This is based on v4.20.2 tag.
>=20
> Originally for fsck-tests/001-bad-file-extent-bytenr we're going to fix=

> it by resetting the corrupted file extent, using the disk bytenr from
> data backref.
>=20
> However in real world, extent tree is the most fragile one while fs tre=
e
> is more reliable.
> This means fixing using extent tree can sometimes be more dangerous, an=
d
> causing extra corruption from repair.
>=20
> Further more, that test case is a big blockage for any later
> modification on file extent repair code.
>=20
> So the goal of this patchset is to change the repair behavior from
> rebuilding file extents using data backref, to dropping invalid file
> extents and modify extent tree.
>=20
> Despite above change, we have some small bug fixes for:
> - False alert for file extents gap
> - Bad data backref -> file extent search in repair mode
>=20
> The patchset is mostly from Fujitsu guys (Lu, Su Yue, Su Yanjun).
> My work here is:
> - Solve rebase conflicts
>   Mostly with DIR_ITEM hash mismatch patchset
>=20
> - Commit message/comment update
>   Make them a little more reader friendly
>=20
> - Reorder the patchset
>   Make small fixes first.
>=20
> Changelog:
> v1.1:
> - Rebase to v4.20.2
> - Run self tests for misc/mkfs/fsck group.
>   The only problem is from misc/035, due to we have reverted the fix.
>   It's not a regression so the patchset should still be good.
>=20
> Lu Fengqi (2):
>   btrfs-progs: lowmem: fix false alert about the existence of gaps in
>     the check_file_extent
>   btrfs-progs: tests: add case for inode lose one file extent
>=20
> Qu Wenruo (1):
>   btrfs-progs: Update backup roots when writing super blocks
>=20
> Su Yanjun (4):
>   btrfs-progs: Revert "btrfs-progs: Add repair and report function for
>     orphan file extent."
>   btrfs-progs: Revert "btrfs-progs: Record orphan data extent ref to
>     corresponding root."
>   btrfs-progs: check: fix wrong @offset used in find_possible_backrefs(=
)
>   btrfs-progs: check: Delete file extent item with unaligned disk byten=
r
>=20
> Su Yue (7):
>   btrfs-progs: lowmem: add argument path to punch_extent_hole()
>   btrfs-progs: lowmem: move nbytes check before isize check
>   btrfs-progs: lowmem: fix false alert if extent item has been repaired=

>   btrfs-progs: lowmem: check unaligned disk_bytenr for extent_data
>   btrfs-progs: lowmem: rename delete_extent_tree_item() to delete_item(=
)
>   btrfs-progs: lowmem: delete unaligned bytes extent data under repair
>   btrfs-progs: fsck-test: enable lowmem repair for case 001
>=20
>  check/main.c                                  | 584 +++++++++++-------=

>  check/mode-lowmem.c                           | 293 +++++----
>  check/mode-original.h                         |  30 +-
>  ctree.h                                       |  10 +-
>  disk-io.c                                     |  80 ++-
>  .../.lowmem_repairable                        |   0
>  .../.lowmem_repairable                        |   0
>  .../default_case.img                          | Bin 0 -> 3072 bytes
>  8 files changed, 621 insertions(+), 376 deletions(-)
>  create mode 100644 tests/fsck-tests/001-bad-file-extent-bytenr/.lowmem=
_repairable
>  create mode 100644 tests/fsck-tests/038-missing-one-file-extent/.lowme=
m_repairable
>  create mode 100644 tests/fsck-tests/038-missing-one-file-extent/defaul=
t_case.img
>=20


--qyinQ8K2LVKAizCF4N4KwHLFlqdMz9U8N--

--ndvaqDNUyA3a4YwLDQdm4jizqVIae1B6S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlycYNYACgkQwj2R86El
/qhkfwf/SwqY5Y/hco0Yi6xpNsHhAqzmq2froiJx9Z4XMahBO1RUJ5JMJvHH7/Hp
TrhYU1986U8S12RnCnPcjm3I+E8kjmvmVhPub1DtkkkH8DuxF1lqNlg8JvT87YFK
2qa6VPXAw2IAamQvNy15U/09pLiiqzs1pHkRABkKGrlQXtonsZo5t0ooLOvCYuEK
SAzpwB2dsz7fxwtq0MhkgJ44f2/7rVmK8IKKriiDF/UVBV5IgJ4DEYtXV+5IhWNl
9JpaOX452q6+eeULugA3eE5954oSMS3BV8MG1J8elteJD+TEyjgv0YQP6tmhsFDv
aqUKjsW7odVI+ANIJ0udAaNjkKUFpA==
=V5iB
-----END PGP SIGNATURE-----

--ndvaqDNUyA3a4YwLDQdm4jizqVIae1B6S--
