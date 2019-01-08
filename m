Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,LOTS_OF_MONEY,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1390C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 07:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 885A320700
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 07:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbfAHHe4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 02:34:56 -0500
Received: from mout.gmx.net ([212.227.17.22]:34335 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727295AbfAHHe4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Jan 2019 02:34:56 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MPD8G-1gcM3n0FWK-004OuN; Tue, 08
 Jan 2019 08:34:28 +0100
Subject: Re: [PATCH 0/2] Use new incompat feature BG_TREE to hugely reduce
 mount time
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190102052945.16325-1-wqu@suse.com>
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
Message-ID: <33defd6f-8fff-17cb-aae1-bec3b875b8b5@gmx.com>
Date:   Tue, 8 Jan 2019 15:34:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190102052945.16325-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gPFyJoFdvAdxMrTU25hEZyR1xLoVdl2W8"
X-Provags-ID: V03:K1:8GGKQbo8x3R6hR+C5uhsnx/K8C9w68Hivlw4DqoS12RX7hl1qPI
 tjylUW1LCtKmenKTkm24ob5zqQ8gmOeuNe6c1sgyZsgeoI6L+KwMbx9aGxnjCKVgKNuARma
 e7BwVSk1JhsVSSo1Fa57OwcS93ATu8MTEnofYf5Bi0ofenv0s2drUSUng+pdk8M/17z6nXn
 0mdTEcrTysE6S2htcyTCA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:nq2dNkr+OE8=:Hu3oe8tJKDAmkqgm/2ldEj
 h87qGvBmSx36kAHtzFwH8E6uJz/j45QbFLCf3B6SWYspzbdnFvKcbVE3X++DHqZ5uBvwOvSFs
 +BiuTQTuBar0ADcWwpoJLZf9QX8zfPCvPtIFcTf1PkrlT0qjcv1TNGEOpfWTZF37GDlKLuEEj
 evpgAsmHJntZd90yW9i4nc/TiczUA2cC/6GxEgJH68EamUOM3vSXwA3WtdD4l7pnubAcPISgN
 1M/t19NKv2OwCxUibsdGKS6fJy8gCE/8F/pLUCoziw2kzWeusCf2uaGjkG3hQqbCf5qGgA4ou
 P8+vB+R5oNjaR/m37TgH3T3aP17TpzYiM5dN74gDFqwv06AUUbgheJVwn6ntHDlMTpfALlx8k
 NUbPHFfx+wDeaUUrVcPFDIJ5yD0g15cESjvSnmUvX5el0sp99g5bQ80wU/eoiOVNelOHfnxuo
 9UAvytdlEyBndt874Yt51lxuaytGEJANajWKtXsSo4gwJBMeuE/DwpLb9m0voGBa6U58aQgEb
 i7TpL4XyBMtiX+xagHROzGfw/9+/d17CU9yqgILytwcICIB0IIzyS852XV842632U9kxmABJ5
 sxk9R7oOGxDN2VDzPebCIUh+eZDt9Qg/16rJS3+pUPgUaqb+XJXa+A7X9af9parfUJTQYFN52
 Y2t5JpmM2pziKK2/1ZAiNB8fLuq7PpDbREXQnr5DnPAUHT59E48iG0yrISKpYX2hVAUM8Tybz
 TZ4kgZIFT+O8Ik2JN2uXliOptWvvcmFwjhK+LyhUBSgOWQL5/l0FACXtTdiJpSMsLTqK93Kyn
 1fjl0vIdJBOMvXeprAuezarmTxfFTPSQTfUiRor1VfA3zU6o0i6BEEVsGn1WRvS7MLuyoIuug
 F0GjNU6jVt1YrnGtxZjGn9JEtoj7OhQ6AynFw2nFeAgsQump5sm6DoX2GUXrOt
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gPFyJoFdvAdxMrTU25hEZyR1xLoVdl2W8
Content-Type: multipart/mixed; boundary="CQGKURcnO3uLKCUqxnmXxkrRzrQlzVj99";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <33defd6f-8fff-17cb-aae1-bec3b875b8b5@gmx.com>
Subject: Re: [PATCH 0/2] Use new incompat feature BG_TREE to hugely reduce
 mount time
References: <20190102052945.16325-1-wqu@suse.com>
In-Reply-To: <20190102052945.16325-1-wqu@suse.com>

--CQGKURcnO3uLKCUqxnmXxkrRzrQlzVj99
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Future proof benchmark for bg-tree.

The benchmark in the cover letter is in fact a pretty bad case for
original mode, with a lot of EXTENT_ITEMs bumping up extent tree height,
along with small node size to make searching extent tree super slow.
(Although that doesn't make any difference for bg-tree).


Now here is the best case scenario for original mode.
Just using plain fallocate to fill 12T, so every EXTENT_DATA will be at
its maximum size, causing minimal noise for block group items iteration.

For short conclusion:
Bg-tree still faster than best case original extent tree, by around 30%.
Bg-tree should be fast enough to mount the 12T filled fs less than *ONE*
*SECOND*.

And due to the fact that bg-tree doesn't care how crowded the extent
tree is, its block group iteration time is just O(N).
So for 12T filled fs, bg-tree should always mount around the same speed,
no matter how many extents are.

For full details, please check the sheet:

https://docs.google.com/spreadsheets/d/1YfZXiGoL9EoPcWGh0x1gIldS1ymsPgqZF=
QdngM-Iep0/edit?usp=3Dsharing


Thanks,
Qu

On 2019/1/2 =E4=B8=8B=E5=8D=881:29, Qu Wenruo wrote:
> This patchset can be fetched from:
> https://github.com/adam900710/linux/tree/bg_tree
> Which is based on v4.20-rc1 tag.
>=20
> This patchset will hugely reduce mount time of large fs by putting all
> block group items into its own tree.
>=20
> The old behavior will try to read out all block group items at mount
> time, however due to the key of block group items are scattered across
> tons of extent items, we must call btrfs_search_slot() for each block
> group.
>=20
> It works fine for small fs, but when number of block groups goes beyond=

> 200, such tree search will become a random read, causing obvious slow
> down.
>=20
> On the other hand, btrfs_read_chunk_tree() is still very fast, since we=

> put CHUNK_ITEMS into their own tree and package them next to each other=
=2E
>=20
>=20
> Following this idea, we could do the same thing for block group items,
> so instead of triggering btrfs_search_slot() for each block group, we
> just call btrfs_next_item() and under most case we could finish in
> memory, and hugely speed up mount (see BENCHMARK below).
>=20
> The only disadvantage is, this method introduce an incompatible feature=
,
> so existing fs can't use this feature directly.
> Either specify it at mkfs time, or use btrfs-progs offline convert tool=

> (*).
>=20
> *: Mkfs and convert tool are doing the same work, however I haven't
> decide if I should put this feature to btrfstune.
>=20
> [[Benchmark]]
> Physical device:	HDD (7200RPM)
> Nodesize:		4K  (to bump up tree height)
> Used size:		250G
> Total size:		500G
> Extent data size:	1M
>=20
> All file extents on disk is in 1M size, ensured by using fallocate.
>=20
> Without patchset:
> Use ftrace function graph:
>=20
>   3)               |  open_ctree [btrfs]() {
>   3)               |    btrfs_read_chunk_tree [btrfs]() {
>   3) * 69033.31 us |    }
>   3)               |    btrfs_verify_dev_extents [btrfs]() {
>   3) * 90376.15 us |    }
>   3)               |    btrfs_read_block_groups [btrfs]() {
>   2) $ 2733853 us  |    } /* btrfs_read_block_groups [btrfs] */
>   2) $ 3168384 us  |  } /* open_ctree [btrfs] */
>=20
>  btrfs_read_block_groups() takes 87% of the total mount time,
>=20
> With patchset, and use -O bg-tree mkfs option:
>   7)               |  open_ctree [btrfs]() {
>   7)               |    btrfs_read_chunk_tree [btrfs]() {
>   7) # 2448.562 us |    }
>   7)               |    btrfs_verify_dev_extents [btrfs]() {
>   7) * 19802.02 us |    }
>   7)               |    btrfs_read_block_groups [btrfs]() {
>   7) # 8610.397 us |    }
>   7) @ 113498.6 us |  }
>=20
>   open_ctree() time is only 3% of original mount time.
>   And btrfs_read_block_groups() only takes 7.6% of total open_ctree()
>   execution time.
>=20
> Changelog:
> RFC->v1:
>  - Fix memory leak for fs_info->bg_root at module unload time.
>  - Add sysfs features interface.
>  - Testing shows no regression, so no RFC tag now.
>=20
> Qu Wenruo (2):
>   btrfs: Refactor btrfs_read_block_groups()
>   btrfs: Introduce new incompat feature, BG_TREE
>=20
>  fs/btrfs/ctree.h                |   5 +-
>  fs/btrfs/disk-io.c              |  13 ++
>  fs/btrfs/extent-tree.c          | 300 ++++++++++++++++++++------------=

>  fs/btrfs/sysfs.c                |   2 +
>  include/uapi/linux/btrfs.h      |   1 +
>  include/uapi/linux/btrfs_tree.h |   3 +
>  6 files changed, 208 insertions(+), 116 deletions(-)
>=20


--CQGKURcnO3uLKCUqxnmXxkrRzrQlzVj99--

--gPFyJoFdvAdxMrTU25hEZyR1xLoVdl2W8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw0Un0ACgkQwj2R86El
/qh19ggApvwKGZ8UtX4saAv3kZzd5rW6NmjQviFzsXb91feHFE55XXdlkEZlsqjy
Mty0O12POzeYfXysFMBtzBNXkGbBQNxNWj2Yj3g5unxGLu9lMRVVJmlo2zeeG4vA
8Vwxuee7NrzXcroOTAPB8Wh301dLVvw6tvpFIeoYrdRRTtjbpLc4NjT7nKXeWsMZ
SkxLxoumDg3fBOv0Vv4CmphDZ+FoO6/28ncTSERlBUcovFqZ1Flb8OgrpFSJAkaz
0dFNKRYpv3YXnQcZWaVBjRvJY+2MKAV9/tMYsL6CsjR0vJCsUbHuY2QcnQiNIehz
QXT/J0FILnkdnBNV75+K1kfnXCtBjA==
=J0FP
-----END PGP SIGNATURE-----

--gPFyJoFdvAdxMrTU25hEZyR1xLoVdl2W8--
