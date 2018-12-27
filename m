Return-Path: <SRS0=K5Ec=PE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B885C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 11:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D848208E4
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Dec 2018 11:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbeL0Lcu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Dec 2018 06:32:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:36772 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728754AbeL0Lcu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Dec 2018 06:32:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 793CBAD5D;
        Thu, 27 Dec 2018 11:32:46 +0000 (UTC)
Subject: Re: [PATCH 3/3] btrfs-progs: Create uuid tree with proper contents
To:     Su Yue <Damenly_Su@gmx.com>, linux-btrfs@vger.kernel.org
References: <20181227071333.10964-1-wqu@suse.com>
 <20181227071333.10964-4-wqu@suse.com>
 <48804351-b8b3-b876-529a-807d05259664@gmx.com>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0F1F1IFdlbnJ1byA8d3F1QHN1c2UuZGU+iQFUBBMBCAA+AhsDBQsJCAcCBhUICQoLAgQW
 AgMBAh4BAheAFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVgp0FCQlmAm4ACgkQwj2R86El
 /qilmgf/cUq9kFQo577ku5gc6rFpVg68ublBwjYpwjw0b//xo+Wo1wm+RRbUGs+djSZAqw12
 D4F3r0mBTI7abUCNWAbFkYZSAIFVi0DMkjypIVS7PSaEt04rM9VBTToE+YqU6WENeJ57R2p2
 +hI0wZrBwxObdsdaOtxWtsp3bmhIbdqxSKrtXuRawy4KnQYcLuGzOce9okdlbAE0W3KHm1gQ
 oNAe6FX8nC9qo14m8LqEbThYH+qj4iCMlN8HIfbSx4F3e7nHZ+UAMW+E/lnMRkIB9Df+JyVd
 /NlXzIjZAggcWsqpx6D4wyAuexKWkiGQeUeArUNihAwXjmyqWPGmjVyIh+oC6LkBDQRZ1YGv
 AQgAqlPrYeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4K
 Xk/kHw5hieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T
 7RZwB69uVSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9
 fNN8e9c0MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD
 /dt76Kp/o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgB
 CAAmFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVga8CGwwFCQPCZwAACgkQwj2R86El/qgN
 8Qf+M0vM2Idwm5txZZSs+/kSgcPxEwYmxUinnUJGyc0ZWYQXPl0cBetZon9El0naijGzNWvf
 HxIPB+ZFehk6Otgc78p1a3/xck/s1myFRLrmbbTJNoFiyL25ljcq0J8z5Zp4yuABL2RiLdaZ
 Pt/jfwjBHwGR+QKp6dD2qMrUWf9b7TFzYDMZXzZ2/eoIgtyjEelNBPrIgOFe24iKMjaGjd97
 fJuRcBMHdhUAxvXQF1oRtd83JvYJ5OtwTd8MgkEfl+fo7HwWkuHbzc70L4fFKv2BowqFdaHy
 mId1ijGPGr46tuZ5a4cw/zbaPYx6fJ4sK9tSv/6V1QPNUdqml6hm6pfs6A==
Message-ID: <7bb7781b-f91e-c592-efb2-adf420374063@suse.de>
Date:   Thu, 27 Dec 2018 19:32:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <48804351-b8b3-b876-529a-807d05259664@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JHl2BlOolVfdCRph7oS4hKNVRWHqHNcJ7"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JHl2BlOolVfdCRph7oS4hKNVRWHqHNcJ7
Content-Type: multipart/mixed; boundary="9RL2vs1HY3yG57t3b7a7pRZPS0DICd0pZ";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Su Yue <Damenly_Su@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <7bb7781b-f91e-c592-efb2-adf420374063@suse.de>
Subject: Re: [PATCH 3/3] btrfs-progs: Create uuid tree with proper contents
References: <20181227071333.10964-1-wqu@suse.com>
 <20181227071333.10964-4-wqu@suse.com>
 <48804351-b8b3-b876-529a-807d05259664@gmx.com>
In-Reply-To: <48804351-b8b3-b876-529a-807d05259664@gmx.com>

--9RL2vs1HY3yG57t3b7a7pRZPS0DICd0pZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018/12/27 =E4=B8=8B=E5=8D=887:28, Su Yue wrote:
>=20
>=20
> On 2018/12/27 3:13 PM, Qu Wenruo wrote:
>> Commit 2a496a5b8b74 ("btrfs-progs: mkfs: precreate the uuid tree")
>> creates uuid tree at mkfs time.
>>
>> However it doesn't populate uuid tree correctly nor just create an emp=
ty
>> root.
>> It uses create_tree(), which just copies the content of fs root,
>> containing meaningless INODE_ITEM:
>>
>> v4.15 mkfs (no uuid tree creation) + kernel mount:
>> =C2=A0=C2=A0 uuid tree key (UUID_TREE ROOT_ITEM 0)
>> =C2=A0=C2=A0 leaf 30572544 items 1 free space 16250 generation 7 owner=
 UUID_TREE
>> =C2=A0=C2=A0 leaf 30572544 flags 0x1(WRITTEN) backref revision 1
>> =C2=A0=C2=A0 fs uuid 33ecddef-fc86-481a-93ce-846b01c11376
>> =C2=A0=C2=A0 chunk uuid 9e58f646-b0da-43ca-9c7d-8bbe3e120246
>> =C2=A0=C2=A0=C2=A0=C2=A0item 0 key (0x92457c59d31491be UUID_KEY_SUBVOL=
 0xef908b5e79aa76a1)
>> itemoff 16275 itemsize 8
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 subvol_id 5
>>
>> v4.19.1 mkfs (incorrect one), no kernel mount:
>> =C2=A0=C2=A0 uuid tree key (UUID_TREE ROOT_ITEM 0)
>> =C2=A0=C2=A0 leaf 30507008 items 2 free space 16061 generation 4 owner=
 UUID_TREE
>> =C2=A0=C2=A0 leaf 30507008 flags 0x1(WRITTEN) backref revision 1
>> =C2=A0=C2=A0 fs uuid 162f5333-9b5d-4217-877c-ddaeaa79398e
>> =C2=A0=C2=A0 chunk uuid 7bc2c5c6-a6d2-4eec-a513-142b549c6541
>> =C2=A0=C2=A0=C2=A0=C2=A0item 0 key (256 INODE_ITEM 0) itemoff 16123 it=
emsize 160
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 generation 3 transid 0 size=
 0 nbytes 16384
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 block group 0 mode 40755 li=
nks 1 uid 0 gid 0 rdev 0
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sequence 0 flags 0x0(none)
>> =C2=A0=C2=A0=C2=A0=C2=A0item 1 key (256 INODE_REF 256) itemoff 16111 i=
temsize 12
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 index 0 namelen 2 name: ..
>>
>> This patchset will fix it by populuating uuid tree properly:
>> (NOTE: due to tree-checker, kernel doesn't accept empty uuid tree, so =
we
>> =C2=A0 can only fix it by populating uuid tree correctly)
>>
>> w/ this patchset, no kernel mount:
>> =C2=A0=C2=A0 uuid tree key (UUID_TREE ROOT_ITEM 0)
>> =C2=A0=C2=A0 leaf 30507008 items 1 free space 16250 generation 4 owner=
 UUID_TREE
>> =C2=A0=C2=A0 leaf 30507008 flags 0x1(WRITTEN) backref revision 1
>> =C2=A0=C2=A0 fs uuid ae53079e-dbbc-409b-a565-5326c7b27731
>> =C2=A0=C2=A0 chunk uuid b5fb1bea-f20d-4af1-80f8-6ca3f0038d67
>> =C2=A0=C2=A0=C2=A0=C2=A0item 0 key (0x334ba6b032d89c07 UUID_KEY_SUBVOL=
 0x86cde09cb78bcca0)
>> itemoff 16275 itemsize 8
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 subvol_id 5
>>
>> For kernel, except tree-checker needs an non-empty uuid tree, both all=

>> above behavior won't cause problem, but it's always better to keep a
>> good standardized behavior.
>>
>> Furthermore, to avoid such problem from happening again, rename the
>> function create_tree() to create_empty_tree() and create_inode_tree(),=

>> without an @root parameter to avoid such problem.
>>
>> Fixes: 2a496a5b8b74 ("btrfs-progs: mkfs: precreate the uuid tree")
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> =C2=A0 disk-io.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 4 ++
>> =C2=A0 mkfs/common.c | 103 +++++++++++++++++++++++++++++++++++++++++++=
+++++++
>> =C2=A0 mkfs/common.h |=C2=A0=C2=A0 3 ++
>> =C2=A0 mkfs/main.c=C2=A0=C2=A0 |=C2=A0 36 +-----------------
>> =C2=A0 4 files changed, 112 insertions(+), 34 deletions(-)
>>
>> diff --git a/disk-io.c b/disk-io.c
>> index 5fafa144c0d3..2cb7f2097fc9 100644
>> --- a/disk-io.c
>> +++ b/disk-io.c
>> @@ -694,6 +694,8 @@ void btrfs_free_fs_info(struct btrfs_fs_info
>> *fs_info)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (fs_info->quota_root)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 free(fs_info->q=
uota_root);
>> +=C2=A0=C2=A0=C2=A0 if (fs_info->uuid_root)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 free(fs_info->uuid_root);
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 free(fs_info->tree_root);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 free(fs_info->extent_root);
>> @@ -964,6 +966,8 @@ void btrfs_release_all_roots(struct btrfs_fs_info
>> *fs_info)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 free_extent_buf=
fer(fs_info->log_root_tree->node);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (fs_info->chunk_root)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 free_extent_buf=
fer(fs_info->chunk_root->node);
>> +=C2=A0=C2=A0=C2=A0 if (fs_info->uuid_root)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 free_extent_buffer(fs_info=
->uuid_root->node);
>> =C2=A0 }
>> =C2=A0 =C2=A0 static void free_map_lookup(struct cache_extent *ce)
>> diff --git a/mkfs/common.c b/mkfs/common.c
>> index f7e3badcf2b9..1f5e1d03a6e3 100644
>> --- a/mkfs/common.c
>> +++ b/mkfs/common.c
>> @@ -23,6 +23,7 @@
>> =C2=A0 #include "disk-io.h"
>> =C2=A0 #include "volumes.h"
>> =C2=A0 #include "utils.h"
>> +#include "transaction.h"
>> =C2=A0 #include "mkfs/common.h"
>> =C2=A0 =C2=A0 static u64 reference_root_table[] =3D {
>> @@ -822,4 +823,106 @@ int test_minimum_size(const char *file, u64
>> min_dev_size)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>> =C2=A0 }
>> =C2=A0 +/*
>> + * Create a tree with all its content copied from @source
>> + *
>> + * Caller must ensure @source only has one leaf.
>> + */
>> +static int __create_tree(struct btrfs_trans_handle *trans,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 struct btrfs_root *root, u64 objectid)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D trans->fs_info;
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_key location;
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_root_item root_item;
>> +=C2=A0=C2=A0=C2=A0 struct extent_buffer *tmp;
>> +=C2=A0=C2=A0=C2=A0 u8 uuid[BTRFS_UUID_SIZE] =3D {0};
>> +=C2=A0=C2=A0=C2=A0 int ret;
>> +
>> +=C2=A0=C2=A0=C2=A0 ASSERT(btrfs_header_level(root->node) =3D=3D 0);
>> +
>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_copy_root(trans, root, root->node, &=
tmp, objectid);
>> +=C2=A0=C2=A0=C2=A0 if (ret)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>> +
>> +=C2=A0=C2=A0=C2=A0 memcpy(&root_item, &root->root_item, sizeof(root_i=
tem));
>> +=C2=A0=C2=A0=C2=A0 btrfs_set_root_bytenr(&root_item, tmp->start);
>> +=C2=A0=C2=A0=C2=A0 btrfs_set_root_level(&root_item, btrfs_header_leve=
l(tmp));
>> +=C2=A0=C2=A0=C2=A0 btrfs_set_root_generation(&root_item, trans->trans=
id);
>> +=C2=A0=C2=A0=C2=A0 /* clear uuid and o/ctime of source tree */
>> +=C2=A0=C2=A0=C2=A0 memcpy(root_item.uuid, uuid, BTRFS_UUID_SIZE);
>> +=C2=A0=C2=A0=C2=A0 btrfs_set_stack_timespec_sec(&root_item.otime, 0);=

>> +=C2=A0=C2=A0=C2=A0 btrfs_set_stack_timespec_sec(&root_item.ctime, 0);=

>> +=C2=A0=C2=A0=C2=A0 free_extent_buffer(tmp);
>> +
>> +=C2=A0=C2=A0=C2=A0 location.objectid =3D objectid;
>> +=C2=A0=C2=A0=C2=A0 location.type =3D BTRFS_ROOT_ITEM_KEY;
>> +=C2=A0=C2=A0=C2=A0 location.offset =3D 0;
>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_insert_root(trans, fs_info->tree_roo=
t,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &location, &root_item);
>> +
>> +=C2=A0=C2=A0=C2=A0 return ret;
>> +}
>> +
>> +/*
>> + * Create an *EMPTY* tree
>> + *
>> + * Caller must ensure at the time of calling, csum tree is still empt=
y
>> + */
>> +static int create_empty_tree(struct btrfs_trans_handle *trans, u64
>> objectid)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_root *csum_root =3D trans->fs_info->c=
sum_root;
>> +
>> +=C2=A0=C2=A0=C2=A0 ASSERT(btrfs_header_level(csum_root->node) =3D=3D =
0 &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_he=
ader_nritems(csum_root->node) =3D=3D 0);
>> +=C2=A0=C2=A0=C2=A0 return __create_tree(trans, csum_root, objectid);
>> +}
>> =C2=A0 +/*
>> + * Create a tree containing an root inode
>> + *
>> + * Caller must ensure at the time of calling, fs tree only contains 2=

>> items
>> + * (one for INODE_ITEM and one for INODE_REF)
>> + */
>> +int create_inode_tree(struct btrfs_trans_handle *trans, u64 objectid)=

>> +{
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_root *fs_root =3D trans->fs_info->fs_=
root;
>> +
>> +=C2=A0=C2=A0=C2=A0 ASSERT(btrfs_header_level(fs_root->node) =3D=3D 0 =
&&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_he=
ader_nritems(fs_root->node) =3D=3D 2);
>> +=C2=A0=C2=A0=C2=A0 return __create_tree(trans, fs_root, objectid);
>> +}
>> +
>> +int create_uuid_tree(struct btrfs_trans_handle *trans)
>> +{
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_fs_info *fs_info =3D trans->fs_info;
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_root *uuid_root =3D fs_info->uuid_roo=
t;
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_key key;
>> +=C2=A0=C2=A0=C2=A0 int ret;
>> +
>> +=C2=A0=C2=A0=C2=A0 if (!uuid_root) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D create_empty_tree(=
trans, BTRFS_UUID_TREE_OBJECTID);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret < 0) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 er=
rno =3D -ret;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 er=
ror("failed to create uuid root: %m");
>=20
> In personal taste, I don't like such assignment.
> Let the community say.

That's the new trend. I'm not a big fan either but it at least saves
some strerr(-ret) calls.

Thanks,
Qu

>=20
> Others look nice to me.
>=20
> Thanks,
> Su
>=20
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn ret;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.objectid =3D BTRFS_UUI=
D_TREE_OBJECTID;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.type =3D BTRFS_ROOT_IT=
EM_KEY;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 key.offset =3D 0;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 uuid_root =3D btrfs_read_f=
s_root_no_cache(fs_info, &key);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(uuid_root)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 er=
rno =3D -PTR_ERR(uuid_root);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 er=
ror("failed to read uuid root: %m");
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn PTR_ERR(uuid_root);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->uuid_root =3D uui=
d_root;
>> +=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 ret =3D btrfs_uuid_tree_add(trans, fs_info->fs_roo=
t->root_item.uuid,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BTRFS_UUID_KEY_SUBVOL,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fs_info->fs_root->root_key.objectid);
>> +=C2=A0=C2=A0=C2=A0 if (ret < 0) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 errno =3D -ret;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error("failed to add uuid =
tree entry for fs root: %m");
>> +=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 return ret;
>> +}
>> diff --git a/mkfs/common.h b/mkfs/common.h
>> index 28912906d0a9..adb5d561c38d 100644
>> --- a/mkfs/common.h
>> +++ b/mkfs/common.h
>> @@ -75,4 +75,7 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64
>> data_profile,
>> =C2=A0 int test_status_for_mkfs(const char *file, bool force_overwrite=
);
>> =C2=A0 int test_dev_for_mkfs(const char *file, int force_overwrite);
>> =C2=A0 +int create_uuid_tree(struct btrfs_trans_handle *trans);
>> +int create_inode_tree(struct btrfs_trans_handle *trans, u64 objectid)=
;
>> +
>> =C2=A0 #endif
>> diff --git a/mkfs/main.c b/mkfs/main.c
>> index b6748f7fe853..ea3d1ae80e5e 100644
>> --- a/mkfs/main.c
>> +++ b/mkfs/main.c
>> @@ -309,38 +309,6 @@ static int create_raid_groups(struct
>> btrfs_trans_handle *trans,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>> =C2=A0 }
>> =C2=A0 -static int create_tree(struct btrfs_trans_handle *trans,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 st=
ruct btrfs_root *root, u64 objectid)
>> -{
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_key location;
>> -=C2=A0=C2=A0=C2=A0 struct btrfs_root_item root_item;
>> -=C2=A0=C2=A0=C2=A0 struct extent_buffer *tmp;
>> -=C2=A0=C2=A0=C2=A0 u8 uuid[BTRFS_UUID_SIZE] =3D {0};
>> -=C2=A0=C2=A0=C2=A0 int ret;
>> -
>> -=C2=A0=C2=A0=C2=A0 ret =3D btrfs_copy_root(trans, root, root->node, &=
tmp, objectid);
>> -=C2=A0=C2=A0=C2=A0 if (ret)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ret;
>> -
>> -=C2=A0=C2=A0=C2=A0 memcpy(&root_item, &root->root_item, sizeof(root_i=
tem));
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_root_bytenr(&root_item, tmp->start);
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_root_level(&root_item, btrfs_header_leve=
l(tmp));
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_root_generation(&root_item, trans->trans=
id);
>> -=C2=A0=C2=A0=C2=A0 /* clear uuid and o/ctime of source tree */
>> -=C2=A0=C2=A0=C2=A0 memcpy(root_item.uuid, uuid, BTRFS_UUID_SIZE);
>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_timespec_sec(&root_item.otime, 0);=

>> -=C2=A0=C2=A0=C2=A0 btrfs_set_stack_timespec_sec(&root_item.ctime, 0);=

>> -=C2=A0=C2=A0=C2=A0 free_extent_buffer(tmp);
>> -
>> -=C2=A0=C2=A0=C2=A0 location.objectid =3D objectid;
>> -=C2=A0=C2=A0=C2=A0 location.type =3D BTRFS_ROOT_ITEM_KEY;
>> -=C2=A0=C2=A0=C2=A0 location.offset =3D 0;
>> -=C2=A0=C2=A0=C2=A0 ret =3D btrfs_insert_root(trans, root->fs_info->tr=
ee_root,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &location, &root_item);
>> -
>> -=C2=A0=C2=A0=C2=A0 return ret;
>> -}
>> -
>> =C2=A0 static void print_usage(int ret)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 printf("Usage: mkfs.btrfs [options] dev=
 [ dev ... ]\n");
>> @@ -1203,13 +1171,13 @@ raid_groups:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 -=C2=A0=C2=A0=C2=A0 ret =3D create_tree(trans, root, BTRFS_DATA=
_RELOC_TREE_OBJECTID);
>> +=C2=A0=C2=A0=C2=A0 ret =3D create_inode_tree(trans, BTRFS_DATA_RELOC_=
TREE_OBJECTID);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error("unable t=
o create data reloc tree: %d", ret);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 -=C2=A0=C2=A0=C2=A0 ret =3D create_tree(trans, root, BTRFS_UUID=
_TREE_OBJECTID);
>> +=C2=A0=C2=A0=C2=A0 ret =3D create_uuid_tree(trans);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 warning(
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "unable to create uuid tree, will be cr=
eated after mount: %d",
>> ret);
>>
>=20


--9RL2vs1HY3yG57t3b7a7pRZPS0DICd0pZ--

--JHl2BlOolVfdCRph7oS4hKNVRWHqHNcJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlwkuFYACgkQwj2R86El
/qiUegf/a/ih3NBhOJCDyR4UBgwdrAkoeOw4TwKwcLGN66jiAo3GYfyH1krOXBd0
2l1yV5yWTsr3LOiorniSh+TROvcv/zeJg224OrIAvtBqrItX7GB6ZB0vUXFFiLql
JdiVHNA8Ras0BHo9FtRDoSNmFRO6vZdkDEWB7l7oLQAuTUPp9aq8ep53bKs9UwNM
SaQZrjQdbPb1JPWVfNgGpnfIrCAfVNlFkha1Z8DxTMuGtzRJT1NhfTrlGW0tV79N
GN1hao7V+gyGmIPJNku2BQMXUDub8KczFez21Amh8aDd7mvJQ6QlIMbdAVAoNuOS
Yu8XblrIFb9OI2BJmBBbF9Tbt7LUvw==
=62WU
-----END PGP SIGNATURE-----

--JHl2BlOolVfdCRph7oS4hKNVRWHqHNcJ7--
