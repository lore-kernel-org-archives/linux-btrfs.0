Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA5F1C282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 07:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6461B21019
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 07:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbfAWHWt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 02:22:49 -0500
Received: from mout.gmx.net ([212.227.17.20]:59623 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbfAWHWt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 02:22:49 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MTwYX-1gdmox3IsT-00QghY; Wed, 23
 Jan 2019 08:22:39 +0100
Subject: Re: [Patch v5 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz
References: <20190123071518.2528-1-wqu@suse.com>
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
Message-ID: <d3cb5623-0d21-cd65-6dda-5c463536ee35@gmx.com>
Date:   Wed, 23 Jan 2019 15:22:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190123071518.2528-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mQXBJgLbQ8ZFv2hKZkq6gK8WozkMqS0nr"
X-Provags-ID: V03:K1:OJ8+8kDc9kgU1WXsKC5taIMPmuwCQ01FkyIci8ThFC7xDCjVwRL
 Bien4GMPJqdXOKyN/UWUcjWdg98Y2S5kdMMRzKr6IFl96yvFikDE44F1OBik98JtWP6Rvi4
 aq+okD/btkEWUnjPLbuJhLUrAVaYHvR/2989hUcOqrru13gDoiy2MSQevqdcJlM+F2Og1Gl
 1KTH/A9rBT70NseQWRXNA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Jz/zHiT/rjk=:tUSJg12z2sZODHyeTA2jgA
 pNws9yy3lOa761CLqnHP/Yfaww2zF9w9bN1GB/idUYh7RK7nXs1ud23QEZalI8qGO1H3yuWYV
 LQVZP0uAQ5UUMB64NRlzGURIwZu3OqfpdnESh30Kyi/jyG5WWUd/j3LM+5agVP7rRWQWd46zz
 Cx+qGM7nvqT6rqshctWAWLdUhnEhYxRY1emhrvj8dFmln95ggQhew+SUySpbdMSBxwaC5YSkJ
 UsLn9hIMvkH/oKKy92kjzwlX4a8inPij73zCSrxqbd52eaCsv+VA9KGZhLuVM1G7TOmXI+D+i
 VKgy0vPy40tm5i5hcXJsoZ4rNZI48YYqXmshtp47kFkVJDGZgFzCj8OftFGueS/3kSXpDxKYK
 oxDTHQBgFBm8NsjbRStCa52O2o1la48N/DbXB7ixiaP2qvmnLnoTi1zPdR03sfoGO0LYKag/y
 T/7QC1wzZLfTSfpTERHMsp/a5JTSBta/xLdrHO9lzl0C1JUva022shOh//JNxLNbOCAL5hmcT
 LQGdMTorVO0Z9zEWDHelFeg7GihyUW5er0i9AVAKEWR9H1wLLXt6KHKHSB53NFWgYdrmkq7QO
 bMTdNwAG1dBXAznLoepTd8nyqIUp4YprsIveNUh4R0h5nxPiCCQ+fEyxzSrRDxwNXufP6W4G+
 uoAKM2xx3OnVcXrB44QH7q/FDQUlNhjHkR0PQ0cFgNSrabd/bPapL9Br6BTXANDtHsidzzUtx
 N00hcs0NlFhvP+GLd9qqeX3z0aA+uLzVSjakaIfWToVax+DuXs95yipvJmqEvRymFUbO032PY
 5qTy5PVcVX0V+fSZ7kZqIV1tFW+WxMULd4iEX6q7Nz1dY4m2n4V8JLndkoCEbvxh6R8XeffbN
 3aOQTfyB1Bg9LeUYPaxgUBPj2Bf0PcJzl95/+VI7wjaowrYOVhWvnfX80ObUJk
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mQXBJgLbQ8ZFv2hKZkq6gK8WozkMqS0nr
Content-Type: multipart/mixed; boundary="nmxaWL51Hw46UF4pPTavn4VBfZC4EPP3l";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Message-ID: <d3cb5623-0d21-cd65-6dda-5c463536ee35@gmx.com>
Subject: Re: [Patch v5 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
References: <20190123071518.2528-1-wqu@suse.com>
In-Reply-To: <20190123071518.2528-1-wqu@suse.com>

--nmxaWL51Hw46UF4pPTavn4VBfZC4EPP3l
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/23 =E4=B8=8B=E5=8D=883:15, Qu Wenruo wrote:
> This patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/qgroup_delayed_subtree
>=20
> Which is based on v5.0-rc1.
>=20
> This patch address the heavy load subtree scan, but delaying it until
> we're going to modify the swapped tree block.
>=20
> The overall workflow is:
>=20
> 1) Record the subtree root block get swapped.
>=20
>    During subtree swap:
>    O =3D Old tree blocks
>    N =3D New tree blocks
>          reloc tree                         subvol tree X
>             Root                               Root
>            /    \                             /    \
>          NA     OB                          OA      OB
>        /  |     |  \                      /  |      |  \
>      NC  ND     OE  OF                   OC  OD     OE  OF
>=20
>   In these case, NA and OA is going to be swapped, record (NA, OA) into=

>   subvol tree X.
>=20
> 2) After subtree swap.
>          reloc tree                         subvol tree X
>             Root                               Root
>            /    \                             /    \
>          OA     OB                          NA      OB
>        /  |     |  \                      /  |      |  \
>      OC  OD     OE  OF                   NC  ND     OE  OF
>=20
> 3a) CoW happens for OB
>     If we are going to CoW tree block OB, we check OB's bytenr against
>     tree X's swapped_blocks structure.
>     It doesn't fit any one, nothing will happen.
>=20
> 3b) CoW happens for NA
>     Check NA's bytenr against tree X's swapped_blocks, and get a hit.
>     Then we do subtree scan on both subtree OA and NA.
>     Resulting 6 tree blocks to be scanned (OA, OC, OD, NA, NC, ND).
>=20
>     Then no matter what we do to subvol tree X, qgroup numbers will
>     still be correct.
>     Then NA's record get removed from X's swapped_blocks.
>=20
> 4)  Transaction commit
>     Any record in X's swapped_blocks get removed, since there is no
>     modification to swapped subtrees, no need to trigger heavy qgroup
>     subtree rescan for them.
>=20
> [[Benchmark]] (*)
> Hardware:
> 	VM 4G vRAM, 8 vCPUs,
> 	disk is using 'unsafe' cache mode,
> 	backing device is SAMSUNG 850 evo SSD.
> 	Host has 16G ram.
>=20
> Mkfs parameter:
> 	--nodesize 4K (To bump up tree size)
>=20
> Initial subvolume contents:
> 	4G data copied from /usr and /lib.
> 	(With enough regular small files)
>=20
> Snapshots:
> 	16 snapshots of the original subvolume.
> 	each snapshot has 3 random files modified.
>=20
> balance parameter:
> 	-m
>=20
> So the content should be pretty similar to a real world root fs layout.=

>=20
> And after file system population, there is no other activity, so it
> should be the best case scenario.
>=20
>                      | v4.20-rc1            | w/ patchset    | diff
> -----------------------------------------------------------------------=

> relocated extents    | 22615                | 22457          | -0.1%
> qgroup dirty extents | 163457               | 121606         | -25.6%
> time (sys)           | 22.884s              | 18.842s        | -17.6%
> time (real)          | 27.724s              | 22.884s        | -17.5%
>=20
> *: Due to a bug in v5.0-rc1, balancing metadata with snapshots is
> unacceptably slow even with quota disabled. So the result is from
> v4.20-rc1.
>=20
> changelog:
> v2:
> - Rebase to v4.20-rc1.
>=20
> - Instead commit transaction after each reloc tree merge, delay it unti=
l
>   merge_reloc_roots() finishes.
>   This provides a more natural behavior, and reduce the unnecessary
>   transaction commits.
>=20
> v3:
> - Fix backref walk deadlock by not triggering it at all.
>   This also removes the need for @exec_post refactor and replace the
>   patch to allow @old_root unpopulated.
>=20
> - Include the patch that fixes the unexpected data rsv free.
>=20
> v3.1:
> - Rebased to v4.20-rc1.
>   Minor conflicts with some cleanup code.
>=20
> v4:
> - Renaming members from "file_*" to "subv_*".
>   Members like "file_bytenr" is pretty confusing, renaming it to
>   "subv_bytenr" avoid the confusion.
>=20
> - Use btrfs_root::reloc_dirty_list to replace dynamic memory allocation=

>   One less point of failure, and no need to worry about GFP_KERNEL/NOFS=
=2E
>   Furthermore, it's easier to manipulate list than rb tree.
>=20
> v5:
> - Use Josef's superior qgroup deadlock fix.
>   No performance regression now.
>=20
> - A new patch to allow delayed subtree rescan to insert empty old_roots=
=2E

I should double check the cover letter.
This part is incorrect, please just ignore it.

Thanks,
Qu

>=20
> - Fix a possible race due to wrong rb_tree node initialization out of
>   critical section.
>=20
> - A lot of coding style fixes:
>   * naming change from "file"/"subv" to "subvol"
>   * {} for any else if branch
>   * avoid err/ret confusion by introducing "tmp_ret"
>   * proper errno for non-uptodate extent buffer
>   * struct member re-ordering to avoid unnecessary padding
>   * avoid single letter variable name
>   * less redundant emphasizing
>   * move certain devel-only warning under CONFIG_BTRFS_DEBUG
>   * replace cool-sounding 'hack' with 'optimization'
>   * remove unnecessary inline prefix for btrfs_qgroup_init_swapped_bloc=
ks
>   * keep an empty line before #endif
>=20
>=20
> Josef Bacik (1):
>   btrfs: honor path->skip_locking in backref code
>=20
> Qu Wenruo (6):
>   btrfs: qgroup: Move reserved data account from btrfs_delayed_ref_head=

>     to btrfs_qgroup_extent_record
>   btrfs: relocation: Delay reloc tree deletion after merge_reloc_roots(=
)
>   btrfs: qgroup: Refactor btrfs_qgroup_trace_subtree_swap()
>   btrfs: qgroup: Introduce per-root swapped blocks infrastructure
>   btrfs: qgroup: Use delayed subtree rescan for balance
>   btrfs: qgroup: Cleanup old subtree swap code
>=20
>  fs/btrfs/backref.c           |  16 +-
>  fs/btrfs/ctree.c             |   8 +
>  fs/btrfs/ctree.h             |  29 +++
>  fs/btrfs/delayed-ref.c       |  15 +-
>  fs/btrfs/delayed-ref.h       |  11 --
>  fs/btrfs/disk-io.c           |   2 +
>  fs/btrfs/extent-tree.c       |   3 -
>  fs/btrfs/qgroup.c            | 339 +++++++++++++++++++++++++++--------=

>  fs/btrfs/qgroup.h            | 120 +++++++++++--
>  fs/btrfs/relocation.c        | 101 ++++++++---
>  fs/btrfs/transaction.c       |   1 +
>  include/trace/events/btrfs.h |  29 ---
>  12 files changed, 502 insertions(+), 172 deletions(-)
>=20


--nmxaWL51Hw46UF4pPTavn4VBfZC4EPP3l--

--mQXBJgLbQ8ZFv2hKZkq6gK8WozkMqS0nr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxIFjoACgkQwj2R86El
/qhsLAf/aIiYmbE7cP0fwV7O9xjJ2HYjapLlOMa5JCPxoEBvQkuf5DMioRfLECG2
e2Wf2qgysp4CW9S94er53foLz9lhVxw4EQLDu1JaoUioYV/xboLStoQf9w40a8qg
PwuuvJl0aYOPHhSSq7IAZkyEsIUCDFXXHaxfiQiTgPvjJBmrfsqM6nIeU2E9bya4
kLiGrdhtZdgiBfSblcTL1fJDFpFDszxSFCoVOb/80lcRtmy7rK6MFVa2ncO4Hq/l
1s50EO3v903suu9UgAlpq1yNNVFh5dJuKdhjkR4Jj5nv81M1Iows97DBbTV94Cwq
RNz8lWyPD+uGROGNChsQNV7FqDvdpw==
=tKeM
-----END PGP SIGNATURE-----

--mQXBJgLbQ8ZFv2hKZkq6gK8WozkMqS0nr--
