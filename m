Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7004C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 14:39:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B73C2087C
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 14:39:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbfCYOjc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:39:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:50364 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726166AbfCYOjc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 10:39:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0CAE0ABDE;
        Mon, 25 Mar 2019 14:39:30 +0000 (UTC)
Subject: Re: [PATCH 5/7] btrfs: check/lowmem: Check and repair free space
 cache inode mode
To:     Su Yue <Damenly_Su@gmx.com>, linux-btrfs@vger.kernel.org
References: <20190325082253.19583-1-wqu@suse.com>
 <20190325082253.19583-6-wqu@suse.com>
 <9cba693d-bbc3-fe91-80f4-f7b34ea84aad@gmx.com>
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
Message-ID: <dfb0d74f-a5da-8bbb-cb21-2188c3ff737b@suse.de>
Date:   Mon, 25 Mar 2019 22:39:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <9cba693d-bbc3-fe91-80f4-f7b34ea84aad@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rJ3UzawiiGVoUQ8G0Ucf9llNP7TnsTS5n"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rJ3UzawiiGVoUQ8G0Ucf9llNP7TnsTS5n
Content-Type: multipart/mixed; boundary="4XKXcP5Fp2HHOYByNe8HPy7IvLvXap6ue";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Su Yue <Damenly_Su@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <dfb0d74f-a5da-8bbb-cb21-2188c3ff737b@suse.de>
Subject: Re: [PATCH 5/7] btrfs: check/lowmem: Check and repair free space
 cache inode mode
References: <20190325082253.19583-1-wqu@suse.com>
 <20190325082253.19583-6-wqu@suse.com>
 <9cba693d-bbc3-fe91-80f4-f7b34ea84aad@gmx.com>
In-Reply-To: <9cba693d-bbc3-fe91-80f4-f7b34ea84aad@gmx.com>

--4XKXcP5Fp2HHOYByNe8HPy7IvLvXap6ue
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/25 =E4=B8=8B=E5=8D=8810:36, Su Yue wrote:
>=20
>=20
> On 2019/3/25 4:22 PM, Qu Wenruo wrote:
>> Unlike inodes in fs roots, we don't really check the inode items in ro=
ot
>> tree, in fact we just skip everything other than ROOT_ITEM and ROOT_RE=
F.
>>
>> This makes invalid inode items sneak into root tree.
>> For example:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 item 9 key (256 INODE=
_ITEM 0) itemoff 13702 itemsize 160
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 generation 30 transid 30 size 65536 nbytes 15073=
28
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 block group 0 mode 0 links 1 uid 0 gid 0 rdev 0
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^ Should be 100600
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 sequence 23 flags
>> 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|PREALLOC)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 atime 0.0 (1970-01-01 08:00:00)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 ctime 1553491158.189771625 (2019-03-25 13:19:18)=

>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 mtime 0.0 (1970-01-01 08:00:00)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 otime 0.0 (1970-01-01 08:00:00)
>>
>> There is a report of such problem in the mail list.
>>
>> This patch will check and repair inode items of free space cache
>> inodes in
>> lowmem mode.
>>
>> Since free space cache inodes doesn't have INODE_REF but still has 1
>> link, we can't use check_inode_item() directly.
>> Instead we only check the inode mode, as that's the important part.
>>
>> The check and repair function: check_repair_free_space_inode() is also=

>> exported for original mode.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>> =C2=A0 check/mode-common.h |=C2=A0 1 +
>> =C2=A0 check/mode-lowmem.c | 45 ++++++++++++++++++++++++++++++++++++++=
+++++++
>> =C2=A0 check/mode-lowmem.h |=C2=A0 2 ++
>> =C2=A0 3 files changed, 48 insertions(+)
>>
>> diff --git a/check/mode-common.h b/check/mode-common.h
>> index 8895747adf1d..855f83617854 100644
>> --- a/check/mode-common.h
>> +++ b/check/mode-common.h
>> @@ -24,6 +24,7 @@
>> =C2=A0 #include <sys/stat.h>
>> =C2=A0 #include "ctree.h"
>>
>> +#define FREE_SPACE_CACHE_INODE_MODE=C2=A0=C2=A0=C2=A0 (0100600)
>> =C2=A0 /*
>> =C2=A0=C2=A0 * Use for tree walk to walk through trees whose leaves/no=
des can be
>> shared
>> =C2=A0=C2=A0 * between different trees. (Namely subvolume/fs trees)
>> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
>> index f37c3b42e6b6..cdb9b66a63a3 100644
>> --- a/check/mode-lowmem.c
>> +++ b/check/mode-lowmem.c
>> @@ -5091,6 +5091,40 @@ out:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return err;
>> =C2=A0 }
>>
>> +/*
>> + * For free space inodes, we can't call check_inode_item() as free sp=
ace
>> + * cache inode doesn't have INODE_REF.
>> + * We just check its inode mode.
>> + */
>> +int check_repair_free_space_inode(struct btrfs_fs_info *fs_info,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_path *path)
>> +{
>=20
>=20
> In personal taste, I prefer check_free_space_inode() to
> follow existed code.
>=20
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_inode_item *iitem;
>> +=C2=A0=C2=A0=C2=A0 struct btrfs_key key;
>> +=C2=A0=C2=A0=C2=A0 u32 mode;
>> +=C2=A0=C2=A0=C2=A0 int ret =3D 0;
>> +
>> +=C2=A0=C2=A0=C2=A0 btrfs_item_key_to_cpu(path->nodes[0], &key, path->=
slots[0]);
>> +=C2=A0=C2=A0=C2=A0 ASSERT(key.type =3D=3D BTRFS_INODE_ITEM_KEY && is_=
fstree(key.objectid));
>> +=C2=A0=C2=A0=C2=A0 iitem =3D btrfs_item_ptr(path->nodes[0], path->slo=
ts[0],
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_inode_item);
>> +=C2=A0=C2=A0=C2=A0 mode =3D btrfs_inode_mode(path->nodes[0], iitem);
>> +=C2=A0=C2=A0=C2=A0 if (mode !=3D FREE_SPACE_CACHE_INODE_MODE) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 error(
>> +=C2=A0=C2=A0=C2=A0 "free space cache inode %llu has invalid mode: has=
 0%o expect 0%o",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ke=
y.objectid, mode, FREE_SPACE_CACHE_INODE_MODE);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -EUCLEAN;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (repair) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t =3D repair_imode_lowmem(fs_info->tree_root,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 path);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (ret < 0)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return ret;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn ret;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 return ret;
>> +}
>> +
>> =C2=A0 /*
>> =C2=A0=C2=A0 * Check all fs/file tree in low_memory mode.
>> =C2=A0=C2=A0 *
>> @@ -5130,6 +5164,17 @@ int check_fs_roots_lowmem(struct btrfs_fs_info
>> *fs_info)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 btrfs_item_key_=
to_cpu(node, &key, slot);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (key.objecti=
d > BTRFS_LAST_FREE_OBJECTID)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 goto out;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (key.type =3D=3D BTRFS_=
INODE_ITEM_KEY &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 is=
_fstree(key.objectid)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
t =3D check_repair_free_space_inode(fs_info, &path);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*=
 Check if we still have a valid path to continue */
>=20
> 'path.nodes[0]' is quite interesting :).
> What about the situation btrfs_search_slot() succeed but failed to
> commit a transaction?

As long as path.nodes[0] exists, we still have a valid path of root
tree, check can continue going.

For that valid path but failed commit case, I believe the most possible
problem would be a corrupted extent tree. And in that case, we can still
continue checking fs tree.

Thanks,
Qu

>=20
>=20
> ---
> Su
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (ret < 0 && path.nodes[0]) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 err |=3D ret;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 goto next;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if=
 (ret < 0 && !path.nodes[0])
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 goto out;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (key.type =3D=
=3D BTRFS_ROOT_ITEM_KEY &&
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 fs_root_objectid(key.objectid)) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 if (key.objectid =3D=3D BTRFS_TREE_RELOC_OBJECTID) {
>> diff --git a/check/mode-lowmem.h b/check/mode-lowmem.h
>> index e0ab30b770d5..d2983fd12eb4 100644
>> --- a/check/mode-lowmem.h
>> +++ b/check/mode-lowmem.h
>> @@ -67,5 +67,7 @@
>>
>> =C2=A0 int check_fs_roots_lowmem(struct btrfs_fs_info *fs_info);
>> =C2=A0 int check_chunks_and_extents_lowmem(struct btrfs_fs_info *fs_in=
fo);
>> +int check_repair_free_space_inode(struct btrfs_fs_info *fs_info,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct btrfs_path *path);
>>
>> =C2=A0 #endif
>>
>=20


--4XKXcP5Fp2HHOYByNe8HPy7IvLvXap6ue--

--rJ3UzawiiGVoUQ8G0Ucf9llNP7TnsTS5n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyY6BYACgkQwj2R86El
/qhhlwf/fPiA9jRg7BwYNcZeQMokjp3HqLUQIerQWQE6rDkyExKqVLM6LcUootRa
pAa9y29vtLO6ZlIpWrYTmBbKZhyot744bV12sAIHiCuu4YeSV7006BCmpu9OA85z
l2CjS8EMFu8ouJiV27wWaFcumOpv+FW2rzVbwF5l2c7heq9luVgONIIbnXhRa2jt
pedOps8aFh9cZnzDVemxOPy7aqYplktgBIpTzr1ZazCv3OUZziWqK2MD/yXzmYqu
JIhTpCL5Tz6oPvlkx2N+eCJ+TFdWlEuN/R7GSJJxmOQmbZENRKxW+XzdbsgfRNKF
c+w2eWK9Tu06cUt43bs0/kxW4bhgKw==
=EkRl
-----END PGP SIGNATURE-----

--rJ3UzawiiGVoUQ8G0Ucf9llNP7TnsTS5n--
