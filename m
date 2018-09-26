Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A3DC43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 14:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F32020842
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 14:17:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F32020842
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbeIZUal (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 16:30:41 -0400
Received: from mout.gmx.net ([212.227.15.19]:35311 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbeIZUal (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 16:30:41 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LpL4H-1fb2Tb2g8D-00f8sY; Wed, 26
 Sep 2018 16:17:19 +0200
Subject: Re: [PATCH v3 0/7] btrfs: qgroup: Reduce dirty extents for metadata
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180911053818.10191-1-wqu@suse.com>
 <20180926140611.GH3255@twin.jikos.cz>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <826bce7c-fec1-9315-0362-f67b53d55673@gmx.com>
Date:   Wed, 26 Sep 2018 22:17:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20180926140611.GH3255@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="dzfjLz3R8aOqwcrtV2LPsCtowtzuzlxuV"
X-Provags-ID: V03:K1:lgWwcEdRjNqD5py6ag9oEEL39sLFkbdg3ikXL7QMmxQ+VBIKwgK
 V3kbcqPEuUFL1fMMrYOhvK1DBp1dfMz2WvhetsQ+a/yecxcEiAaXSn0keYQa2uVtJWhH+Hh
 lNtz1EkzVlpfkKhWuQ/giUpp/NggW9L7qQ0n6nBsVg3HGaqPEcRi7AyIQl7+r9iEWXR1nnx
 /S5SVY7zRq5LHGD7SteRA==
X-UI-Out-Filterresults: notjunk:1;V01:K0:+TYVGoq7zEQ=:d7BfyR6EeBkbb8X4/6FZmB
 PotYpAkYC/jdpkN8/Vnpzq1mNSI/h9B76iXA2MZJaCypBfuWT98C/81NIgaASYJpApyMe5DV+
 Y42deYosSYXLEe31eOAU73zYrS2Zm+YITPGtEg1cmvjnJlvydk0ssa5VFlCVgtzTb3VilzfSq
 +vkAxIpOmcn2fFVKsdSwkSsu/hCONn+V5VbMVhwLX/0GrccymQ5fI7q8m8exliKNcpONowE3R
 xcIxspdz52WpHPckt80zNQiVuzV0X6ECiHEKoJWA1g1tTXe0m8RJyGWGS+66zqrPXVITJ9o6O
 zoLh8QPL18hGr6C+01UyNhZzx8O5SmQ1BrEltdmmVKsAHvZtOxCV1LZnSeEIFI+A1UX/JWocx
 bGHAUBSb6Ou1feJrIKarHqMjOq1citFfEfsbDgYyP1eYqzh9bOxixao1qDapD7lkghAb4j5cd
 BTM2OO1EcVSYyVFvt7qZac3TYYc3RchsBGUiSukHXWyxPWZx7Q7/LHFdPk7ndH1MLDOdNa5vH
 BzerTwUIvI/c3Rb59SybKVjm79J7YuQ/eK+7UaSRcf/IWD95BhmG/llvBMQ9RnxSq0scjytA0
 f2j2TUadlmO7cKs6ebFpR3WFvy7B2DeEY6pfULx73GWj+5+KkWuw6MyS+bEvjla0SLq6BpNTE
 O4pX0+kEDRbmh9kRajxXcOhJ8h9TAAgpG7jXHoTNpaQfJiAcsu/jGIufj0fCn7NR5NaNzsayj
 i2SGxtY6qMEjbx92SWUcSbXbXELCp2PyRmWb9XiS665dkcr6yrurBUv/MCgXuDQzLI1tFsN2U
 SVMCp+gYEX/LKaBZ87gJZBn2E6WWQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--dzfjLz3R8aOqwcrtV2LPsCtowtzuzlxuV
Content-Type: multipart/mixed; boundary="KqEMPalziV2O4E8R2KLFW0eA8ngwohvqx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <826bce7c-fec1-9315-0362-f67b53d55673@gmx.com>
Subject: Re: [PATCH v3 0/7] btrfs: qgroup: Reduce dirty extents for metadata
References: <20180911053818.10191-1-wqu@suse.com>
 <20180926140611.GH3255@twin.jikos.cz>
In-Reply-To: <20180926140611.GH3255@twin.jikos.cz>

--KqEMPalziV2O4E8R2KLFW0eA8ngwohvqx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/9/26 =E4=B8=8B=E5=8D=8810:06, David Sterba wrote:
> On Tue, Sep 11, 2018 at 01:38:11PM +0800, Qu Wenruo wrote:
>> This patchset can be fetched from github:
>> https://github.com/adam900710/linux/tree/qgroup_balance_skip_trees
>> The base commit is v4.19-rc1 tag.
>=20
> I want to merge this patchset to 4.20, it's been in for-next for some
> time and it addresses a problem that gets reported very often.
>=20
> I'm still doing some tests, there are minor issues that are not
> blocking, more code review is always welcome.
>=20
>> There are a lot of reports of system hang for balance on quota enabled=

>> fs.
>> It's most obvious for large fs.
>>
>> The hang is caused by tons of unmodified extents marked as qgroup dirt=
y.
>> Such unmodified/unrelated sources include:
>> 1) Unmodified subtree
>> 2) Subtree drop for reloc tree
>> (BTW, other sources includes unmodified file extent items)
>>
>> E.g.
>> OO =3D Old tree blocks from file tree
>> NN =3D New tree blocks from reloc tree
>>
>>         file tree                              reloc tree
>>            OO (a)                                  NN (a)
>>           /  \                                    /  \
>>     (b) OO    OO (c)                        (b) NN    NN (c)
>>        / \   / \                               / \   / \
>>      OO  OO OO  OO                           OO  OO OO  NN
>>     (d) (e) (f) (g)                         (d) (e) (f) (g)
>>
>> In above case, balance will modify nodeptr in OO(a) to point NN(b) and=

>> NN(c), and modify NN(a) to point to OO(B) and OO(c).
>>
>> Before this patch, quota will mark the whole subtree from its parent
>> down to the leaves as dirty.
>> So btrfs quota need to trace all tree block from (a) to (g).
>=20
> I find the use of 'trace' a bit confusing as there are the trace events=
,
> but as it's already used in the qgroup code I think it can stay as is.

I'm pretty open to rename the word "trace".

Any recommendation for a newer name?

>=20
>> However tree blocks (d) (e) (f) are shared between both trees, thus
>> there is no need to trace those 3 tree blocks.
>>
>> This patchset will change how this work by only tracing modified tree
>> blocks in reloc tree, and their counter parts in file tree.
>>
>> With this patch, we could skip tree blocks OO(d)~OO(f) in above exampl=
e,
>> thus reduce some some overhead caused by qgroup.
>>
>> The improvement is mostly related to metadata relocation.
>>
>> Also, for metadata relocation, we don't really need to trace data
>> extents as they're not modified at all.
>>
>>
>> [[Benchmark]]
> [...]
>=20
> Thanks for the benchmarks, it would be good to add the information to
> the patch that's bringing the performance improvement.

Could do that.

However the current improved (from around 10 * nr_relocated to 6~7 *
nr_relocated) is the final result of the last 4 patches.

I'm not pretty sure if any single patch could bring obvious improvement.

>=20
>> Hardware:
>> 	VM 4G vRAM, 8 vCPUs,
>> 	disk is using 'unsafe' cache mode,
>> 	backing device is SAMSUNG 850 evo SSD.
>> 	Host has 16G ram.
>>
>> Mkfs parameter:
>> 	--nodesize 4K (To bump up tree size)
>>
>> Initial subvolume contents:
>> 	4G data copied from /usr and /lib.
>> 	(With enough regular small files)
>>
>> Snapshots:
>> 	16 snapshots of the original subvolume.
>> 	each snapshot has 3 random files modified.
>>
>> balance parameter:
>> 	-m
>>
>> So the content should be pretty similar to a real world root fs layout=
=2E
>>
>>                      | v4.19-rc1    | w/ patchset    | diff (*)
>> ---------------------------------------------------------------
>> relocated extents    | 22874        | 22856          | +0.1%
>> qgroup dirty extents | 225251       | 140431         | -37.7%
>> time (sys)           | 40.161s      | 20.574s        | -48.7%
>> time (real)          | 42.163s      | 25.173s        | -40.3%
>>
>> *: (val_new - val_old) / val_old * 100%
>>
>> And the difference is becoming more and more obvious if more snapshots=

>> are created.
>>
>> If we increase the number of snapshots to 64 (4 times the number of
>> references, and 64 snapshots is already not recommended to use with
>> quota)
>>
>>                      | v4.19-rc1    | w/ patchset    | diff (*)
>> ---------------------------------------------------------------
>> relocated extents    | 22462        | 22467          | +0.0%
>> qgroup dirty extents | 314380       | 140826         | -55.2%
>> time (sys)           | 158.033s     | 74.292s        | -53.0%
>> time (real)          | 197.395s     | 90.529s        | -67.6%
>>
>> For larger fs the saving should be even more obvious.
>>
>> Changelog:
>> v2:
>>   Rename "tree reloc tree" to "reloc tree".
>>   Add patch "Don't trace subtree if we're dropping reloc tree" into th=
e
>>   patchset.
>>   Fix wrong btrfs_bin_search() call, which leads to unexpected ENOENT
>>   error for btrfs_qgroup_trace_extent_swap(). Now use dst_path->slots[=
]
>>   directly.
>>  =20
>> v3:
>>   Add new patch to avoid unnecessary data extents trace for metadata
>>   relocation.
>>   Better delayed ref time root owner detection to avoid unnecessary tr=
ee
>>   block tracing.
>>   Add benchmark result for the patchset.
>>
>> Qu Wenruo (7):
>>   btrfs: qgroup: Introduce trace event to analyse the number of dirty
>>     extents accounted
>>   btrfs: qgroup: Introduce function to trace two swaped extents
>>   btrfs: qgroup: Introduce function to find all new tree blocks of rel=
oc
>>     tree
>>   btrfs: qgroup: Use generation aware subtree swap to mark dirty exten=
ts
>>   btrfs: qgroup: Don't trace subtree if we're dropping reloc tree
>>   btrfs: delayed-ref: Introduce new parameter for
>>     btrfs_add_delayed_tree_ref() to reduce unnecessary qgroup tracing
>>   btrfs: qgroup: Only trace data extents in leaves if we're relocating=

>>     data block group
>>
>>  fs/btrfs/delayed-ref.c       |   5 +-
>>  fs/btrfs/delayed-ref.h       |   1 +
>>  fs/btrfs/extent-tree.c       |  25 ++-
>>  fs/btrfs/qgroup.c            | 347 ++++++++++++++++++++++++++++++++++=
+
>>  fs/btrfs/qgroup.h            |  11 ++
>>  fs/btrfs/relocation.c        |  15 +-
>>  include/trace/events/btrfs.h |  21 +++
>>  7 files changed, 405 insertions(+), 20 deletions(-)
>>
>> --=20
>> 2.18.0


--KqEMPalziV2O4E8R2KLFW0eA8ngwohvqx--

--dzfjLz3R8aOqwcrtV2LPsCtowtzuzlxuV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlurlOkACgkQwj2R86El
/qj7XwgAreCzqOjIHz91CVXLonpqaBWYBfm+2Stknqlc771tLgPrUKhZKifNJWpJ
/aYU0e8Oc2t940AMQT3CHprVUohXT5U+9SHsKyT6eGEmS0Uv7UU+bgXkw6bXD66G
cdZxNpPubrDuGll2xKbYXntv79AFUtwPOwbjSZyfRXefKyZI4Dq+DCNsLc/RUJvi
a3i1cKcpYtkS/98/lvCBAngfwV25dtPIwUg2/L6ZzY9GnSGph5HS3PlTd4klD8Sz
KKoi66fNkhnzeHgL/OowyhbqVOBXLzqw/9C8vBUQ6IvTfAm0D0lsQTZSjyF6qTCy
WavVCLcUFd9zzecYpaoEp+BFfln/dQ==
=Xwi6
-----END PGP SIGNATURE-----

--dzfjLz3R8aOqwcrtV2LPsCtowtzuzlxuV--
