Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64AAEC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 11:28:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27B6E205F4
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 11:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfANL2V (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 06:28:21 -0500
Received: from mout.gmx.net ([212.227.15.15]:40993 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbfANL2U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 06:28:20 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MLfH9-1gjpUY3VJ5-000tB0; Mon, 14
 Jan 2019 12:28:11 +0100
Subject: Re: [PATCH v2 4/6] btrfs: Introduce mount time chunk <-> dev extent
 mapping check
To:     fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20180801023721.32143-1-wqu@suse.com>
 <20180801023721.32143-5-wqu@suse.com>
 <CAL3q7H6cdn4G7ZDEQM-B9A8O5h=8QV3U2NsjTKs59FFMqPCC+g@mail.gmail.com>
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
Message-ID: <1723f2e3-a76d-f7de-5232-ed6d966ae42b@gmx.com>
Date:   Mon, 14 Jan 2019 19:28:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6cdn4G7ZDEQM-B9A8O5h=8QV3U2NsjTKs59FFMqPCC+g@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YE4YCmOtbbQM74a4IuUlaXpXX7qUbDIQ9"
X-Provags-ID: V03:K1:ZE3o2V+Ml2tDZJbY5yToJmH93ZAD0gRc68WvIMRb6evzbQORml3
 tAgNDqLrXzT14hudymf5AyUroFy5RmMXrp5l+cWDRDZFNSiM3g++vXmXjhjal3iJzyYNVvw
 WW30W3a1d0oJkE5Ot3aEARbI127AtWCqCGTgfas4sn3kyCS8P1dswUyqbfpz8rVhCIYytdq
 n7DAgzTpzRUzTbzXlYo8Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:/0W4z5cmdkY=:fVi49HIiizhL9PDvV5M6U1
 ajVUzMoNlgual4IuGyID3POl11C5zP/gABf4PQjhFGncaylQNn2qgEY8YCdCDpiL20g8aNCMJ
 EvUIe6vEb2VbcIWhwA0uhBO0RyH8RyF/IzF1g0rJR4JeWsjFsMrFfOIDuCmXbd+ecoDJA05RT
 zTsHVzkZmLJGJzGc8KQyrnWCDbfFR68GI8q8jL8u9PmoYCXE9iXmeDm3b90QbdcoF+YCE6ah6
 p8e+ehBPS+BHMUWMdWToV3bRZYcX1ViG09l9IyPxvpAhUUa3Fuqeq6n8tHkB6Pox3kWNgJCBs
 l8lAAjE08eN8SDorO8J31iiDHN13aUzfA3XPXKsm4q1y88mdJe0vqi0p/e0PnGvD3TA8vCipe
 JYpv1lp9nAAWGjw8mirbHK9o2hR4uwG6VBLUSItG8SozjmW9RMF1WbFTvTC/BtbGWO1/j4TmZ
 fqTr0PuVGwXhud1YKC8SCnESoJILUQJDlsEY5JD/g0sVuII5L2BbAouf6wi9dRahuGqH4UGLa
 HYfJW7I9kEcGygLDsnBB1JU+Zb1tvb114aJ2parCNgfoC0pHPBHW68Jjct2cBf40Iq/ED9L/6
 yA2+gO4xZNBucNvZ1VDHfjKhrtDd62SuxgvGQyDfkNUmC3RmSoAwPkM3uuDPqjezWRr97GCmy
 h17vRQm2qg0b+jNo114Ra+RxtTM3+F8ApwQ5ShbrCXyriY2jicZXttGOVlwqXG1xw6xbf+4Fr
 2cO/L6p/bP9pGM3RWqGCjC3KB/o95eekZZentrmZUbnphlx6voFARALvfCFzDOa8Ogi13VW/F
 EucPjmEFvWwnLwnbPyyyJXAOPQWolmGUyz2sxcc+dWaMqHv/GePNUqykfE5R6j+4j0jAm5HIW
 mQpVENlR441iRIQdz6d4iL4EJ0c/gYTnLYDod7sFZhq6wYfpHPwV8BPugYdIC4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YE4YCmOtbbQM74a4IuUlaXpXX7qUbDIQ9
Content-Type: multipart/mixed; boundary="djQvwc3bIHI6aZzzXbD26HV3KNRPRcAdp";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: fdmanana@gmail.com, Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <1723f2e3-a76d-f7de-5232-ed6d966ae42b@gmx.com>
Subject: Re: [PATCH v2 4/6] btrfs: Introduce mount time chunk <-> dev extent
 mapping check
References: <20180801023721.32143-1-wqu@suse.com>
 <20180801023721.32143-5-wqu@suse.com>
 <CAL3q7H6cdn4G7ZDEQM-B9A8O5h=8QV3U2NsjTKs59FFMqPCC+g@mail.gmail.com>
In-Reply-To: <CAL3q7H6cdn4G7ZDEQM-B9A8O5h=8QV3U2NsjTKs59FFMqPCC+g@mail.gmail.com>

--djQvwc3bIHI6aZzzXbD26HV3KNRPRcAdp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/14 =E4=B8=8B=E5=8D=887:09, Filipe Manana wrote:
> On Wed, Aug 1, 2018 at 3:39 AM Qu Wenruo <wqu@suse.com> wrote:
>>
>> This patch will introduce chunk <-> dev extent mapping check, to prote=
ct
>> us against invalid dev extents or chunks.
>>
>> Since chunk mapping is the fundamental infrastructure of btrfs, extra
>> check at mount time could prevent a lot of unexpected behavior (BUG_ON=
).
>>
>> Reported-by: Xu Wen <wen.xu@gatech.edu>
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D200403
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D200407
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>=20
> Btw, this makes at least one test case from btrfs-progs fail:
>=20
> root 17:12:02 /home/fdmanana/git/hub/btrfs-progs/tests ((v4.19.1))>
> TEST=3D021\* ./misc-tests.sh
>     [TEST/misc]   021-image-multi-devices
> failed: mount /dev/loop2 /home/fdmanana/git/hub/btrfs-progs/tests//mnt
> test failed for case 021-image-multi-devices

That is fixed by the following commits already in devel:
9996feb94d btrfs-progs: misc-tests/021: Do extra btrfs check before mount=
ing
a1a98ee7a8 btrfs-progs: image: Remove all existing dev extents for later
rebuild
e6c1fa297a btrfs-progs: volumes: Refactor btrfs_alloc_dev_extent() into
two functions
9a65b425bb btrfs-progs: image: Fix block group item flags when restoring
multi-device image to single device
ca73162b48 btrfs-progs: image: Refactor fixup_devices() to
fixup_chunks_and_devices()

And they are pretty early detected and merged, just after v4.19.1.

Thanks,
Qu





>=20
> dmesg/syslog has:
>=20
> [432229.206699] BTRFS error (device loop0): dev extent physical offset
> 22020096 devid 1 has no corresponding chunk
> [432229.207497] BTRFS error (device loop0): failed to find devid 1
> [432229.208281] BTRFS error (device loop0): failed to verify dev
> extents against chunks: -117
> [432229.246286] BTRFS error (device loop0): open_ctree failed
>=20
> Thanks.
>=20
>> ---
>>  fs/btrfs/disk-io.c |   7 ++
>>  fs/btrfs/volumes.c | 183 ++++++++++++++++++++++++++++++++++++++++++++=
+
>>  fs/btrfs/volumes.h |   2 +
>>  3 files changed, 192 insertions(+)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 205092dc9390..068ca7498e94 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -3075,6 +3075,13 @@ int open_ctree(struct super_block *sb,
>>         fs_info->generation =3D generation;
>>         fs_info->last_trans_committed =3D generation;
>>
>> +       ret =3D btrfs_verify_dev_extents(fs_info);
>> +       if (ret) {
>> +               btrfs_err(fs_info,
>> +                         "failed to verify dev extents against chunks=
: %d",
>> +                         ret);
>> +               goto fail_block_groups;
>> +       }
>>         ret =3D btrfs_recover_balance(fs_info);
>>         if (ret) {
>>                 btrfs_err(fs_info, "failed to recover balance: %d", re=
t);
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index e6a8e4aabc66..467a589854fa 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -6440,6 +6440,7 @@ static int read_one_chunk(struct btrfs_fs_info *=
fs_info, struct btrfs_key *key,
>>         map->stripe_len =3D btrfs_chunk_stripe_len(leaf, chunk);
>>         map->type =3D btrfs_chunk_type(leaf, chunk);
>>         map->sub_stripes =3D btrfs_chunk_sub_stripes(leaf, chunk);
>> +       map->verified_stripes =3D 0;
>>         for (i =3D 0; i < num_stripes; i++) {
>>                 map->stripes[i].physical =3D
>>                         btrfs_stripe_offset_nr(leaf, chunk, i);
>> @@ -7295,3 +7296,185 @@ void btrfs_reset_fs_info_ptr(struct btrfs_fs_i=
nfo *fs_info)
>>                 fs_devices =3D fs_devices->seed;
>>         }
>>  }
>> +
>> +static u64 calc_stripe_length(u64 type, u64 chunk_len, int num_stripe=
s)
>> +{
>> +       int index =3D btrfs_bg_flags_to_raid_index(type);
>> +       int ncopies =3D btrfs_raid_array[index].ncopies;
>> +       int data_stripes;
>> +
>> +       switch (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
>> +       case BTRFS_BLOCK_GROUP_RAID5:
>> +               data_stripes =3D num_stripes - 1;
>> +               break;
>> +       case BTRFS_BLOCK_GROUP_RAID6:
>> +               data_stripes =3D num_stripes - 2;
>> +               break;
>> +       default:
>> +               data_stripes =3D num_stripes / ncopies;
>> +               break;
>> +       }
>> +       return div_u64(chunk_len, data_stripes);
>> +}
>> +static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
>> +                                u64 chunk_offset, u64 devid,
>> +                                u64 physical_offset, u64 physical_len=
)
>> +{
>> +       struct extent_map_tree *em_tree =3D &fs_info->mapping_tree.map=
_tree;
>> +       struct extent_map *em;
>> +       struct map_lookup *map;
>> +       u64 stripe_len;
>> +       bool found =3D false;
>> +       int ret =3D 0;
>> +       int i;
>> +
>> +       read_lock(&em_tree->lock);
>> +       em =3D lookup_extent_mapping(em_tree, chunk_offset, 1);
>> +       read_unlock(&em_tree->lock);
>> +
>> +       if (!em) {
>> +               ret =3D -EUCLEAN;
>> +               btrfs_err(fs_info,
>> +               "dev extent (%llu, %llu) doesn't have corresponding ch=
unk",
>> +                         devid, physical_offset);
>> +               goto out;
>> +       }
>> +
>> +       map =3D em->map_lookup;
>> +       stripe_len =3D calc_stripe_length(map->type, em->len, map->num=
_stripes);
>> +       if (physical_len !=3D stripe_len) {
>> +               btrfs_err(fs_info,
>> +"dev extent (%llu, %llu) length doesn't match with chunk %llu, have %=
llu expect %llu",
>> +                         devid, physical_offset, em->start, physical_=
len,
>> +                         stripe_len);
>> +               ret =3D -EUCLEAN;
>> +               goto out;
>> +       }
>> +
>> +       for (i =3D 0; i < map->num_stripes; i++) {
>> +               if (map->stripes[i].dev->devid =3D=3D devid &&
>> +                   map->stripes[i].physical =3D=3D physical_offset) {=

>> +                       found =3D true;
>> +                       if (map->verified_stripes >=3D map->num_stripe=
s) {
>> +                               btrfs_err(fs_info,
>> +                       "too many dev extent for chunk %llu is detecte=
d",
>> +                                         em->start);
>> +                               ret =3D -EUCLEAN;
>> +                               goto out;
>> +                       }
>> +                       map->verified_stripes++;
>> +                       break;
>> +               }
>> +       }
>> +       if (!found) {
>> +               ret =3D -EUCLEAN;
>> +               btrfs_err(fs_info,
>> +                       "dev extent (%llu, %llu) has no corresponding =
chunk",
>> +                       devid, physical_offset);
>> +       }
>> +out:
>> +       free_extent_map(em);
>> +       return ret;
>> +}
>> +
>> +static int verify_chunk_dev_extent_mapping(struct btrfs_fs_info *fs_i=
nfo)
>> +{
>> +       struct extent_map_tree *em_tree =3D &fs_info->mapping_tree.map=
_tree;
>> +       struct extent_map *em;
>> +       struct rb_node *node;
>> +       int ret =3D 0;
>> +
>> +       read_lock(&em_tree->lock);
>> +       for (node =3D rb_first(&em_tree->map); node; node =3D rb_next(=
node)) {
>> +               em =3D rb_entry(node, struct extent_map, rb_node);
>> +               if (em->map_lookup->num_stripes !=3D
>> +                   em->map_lookup->verified_stripes) {
>> +                       btrfs_err(fs_info,
>> +                       "chunk %llu has missing dev extent, have %d ex=
pect %d",
>> +                                 em->start, em->map_lookup->verified_=
stripes,
>> +                                 em->map_lookup->num_stripes);
>> +                       ret =3D -EUCLEAN;
>> +                       goto out;
>> +               }
>> +       }
>> +out:
>> +       read_unlock(&em_tree->lock);
>> +       return ret;
>> +}
>> +
>> +/*
>> + * Ensure all dev extents are mapped to correct chunk.
>> + * Or later chunk allocation/free would cause unexpected behavior.
>> + *
>> + * NOTE: This will iterate through the whole device tree, which shoul=
d be
>> + * at the same size level of chunk tree.
>> + * This would increase mount time by a tiny fraction.
>> + */
>> +int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
>> +{
>> +       struct btrfs_path *path;
>> +       struct btrfs_root *root =3D fs_info->dev_root;
>> +       struct btrfs_key key;
>> +       int ret =3D 0;
>> +
>> +       key.objectid =3D 1;
>> +       key.type =3D BTRFS_DEV_EXTENT_KEY;
>> +       key.offset =3D 0;
>> +
>> +       path =3D btrfs_alloc_path();
>> +       if (!path)
>> +               return -ENOMEM;
>> +
>> +       path->reada =3D READA_FORWARD;
>> +       ret =3D btrfs_search_slot(NULL, root, &key, path, 0, 0);
>> +       if (ret < 0)
>> +               goto out;
>> +
>> +       if (path->slots[0] >=3D btrfs_header_nritems(path->nodes[0])) =
{
>> +               ret =3D btrfs_next_item(root, path);
>> +               if (ret < 0)
>> +                       goto out;
>> +               /* No dev extents at all? Not good */
>> +               if (ret > 0) {
>> +                       ret =3D -EUCLEAN;
>> +                       goto out;
>> +               }
>> +       }
>> +       while (1) {
>> +               struct extent_buffer *leaf =3D path->nodes[0];
>> +               struct btrfs_dev_extent *dext;
>> +               int slot =3D path->slots[0];
>> +               u64 chunk_offset;
>> +               u64 physical_offset;
>> +               u64 physical_len;
>> +               u64 devid;
>> +
>> +               btrfs_item_key_to_cpu(leaf, &key, slot);
>> +               if (key.type !=3D BTRFS_DEV_EXTENT_KEY)
>> +                       break;
>> +               devid =3D key.objectid;
>> +               physical_offset =3D key.offset;
>> +
>> +               dext =3D btrfs_item_ptr(leaf, slot, struct btrfs_dev_e=
xtent);
>> +               chunk_offset =3D btrfs_dev_extent_chunk_offset(leaf, d=
ext);
>> +               physical_len =3D btrfs_dev_extent_length(leaf, dext);
>> +
>> +               ret =3D verify_one_dev_extent(fs_info, chunk_offset, d=
evid,
>> +                                           physical_offset, physical_=
len);
>> +               if (ret < 0)
>> +                       goto out;
>> +               ret =3D btrfs_next_item(root, path);
>> +               if (ret < 0)
>> +                       goto out;
>> +               if (ret > 0) {
>> +                       ret =3D 0;
>> +                       break;
>> +               }
>> +       }
>> +
>> +       /* Ensure all chunks have corresponding dev extents */
>> +       ret =3D verify_chunk_dev_extent_mapping(fs_info);
>> +out:
>> +       btrfs_free_path(path);
>> +       return ret;
>> +}
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index 6d4f38ad9f5c..4301bf2d0534 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -345,6 +345,7 @@ struct map_lookup {
>>         u64 stripe_len;
>>         int num_stripes;
>>         int sub_stripes;
>> +       int verified_stripes; /* For mount time dev extent verificatio=
n */
>>         struct btrfs_bio_stripe stripes[];
>>  };
>>
>> @@ -559,5 +560,6 @@ void btrfs_set_fs_info_ptr(struct btrfs_fs_info *f=
s_info);
>>  void btrfs_reset_fs_info_ptr(struct btrfs_fs_info *fs_info);
>>  bool btrfs_check_rw_degradable(struct btrfs_fs_info *fs_info,
>>                                         struct btrfs_device *failing_d=
ev);
>> +int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info);
>>
>>  #endif
>> --
>> 2.18.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"=
 in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
>=20


--djQvwc3bIHI6aZzzXbD26HV3KNRPRcAdp--

--YE4YCmOtbbQM74a4IuUlaXpXX7qUbDIQ9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw8ckQACgkQwj2R86El
/qinWAf/WF9S/dDOFnrgRDrXfGLERmN6H46/rrUJjicoFqmnKhrYGpDA7JjeWSNw
Ur1wKWWmyTx23r/sI8617hKQgEwWKgUlBLruHQ+jed/0Xhd5XA5QEvyMtnuoBQAx
AgoyFQ+iOpJ4XZ8qp8OYkf5CiJlH29CeUOQK5imjGGvAQ8M5Qhj33QypRKqJdZWW
5R9Co+Pmu4iJXJJxetOmRF3zt3a2p2wCbLVXKSRbJkDCx45wJqLTGeTuD/X8Hlkm
RRm+R8f0NyS+7Umdlx+0tsC/x5eI2Xn+p8Qu7b/YJdQ3An1oGgPG6sGwT/kLlnDc
BRS1rzO5ldtVh8n00As2NcoyhLohLA==
=X7vJ
-----END PGP SIGNATURE-----

--YE4YCmOtbbQM74a4IuUlaXpXX7qUbDIQ9--
