Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B6A2C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 06:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDE2D20855
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 06:33:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="XPXpczCE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfDDGdm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 02:33:42 -0400
Received: from mout.gmx.net ([212.227.17.22]:36371 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726122AbfDDGdl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Apr 2019 02:33:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554359613;
        bh=JhLu+EFosKeubJgXOLy5nwzOqPFkJ682Wa/CCppvD4s=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=XPXpczCEJYTKPSkSLuaj5UFKUliJ9i8JQLStdX8p8gZvO2JyodV6XksgfkEVFjUgU
         bHxM9hv9w0ImGVrvPWtAxgXeAq38b539BzeC8Q5A1a41+uGSyF9D1sUtgrvkOYAK8Z
         gt5TbPCZukGJtxD1fJMJ+D/gxAUhAU8Ry78yzfNA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LvzF3-1gqg591jLx-017oeT; Thu, 04
 Apr 2019 08:33:33 +0200
Subject: Re: [PATCH 1/2] btrfs: tree-checker: Remove comprehensive root owner
 check
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190404034708.3399-1-wqu@suse.com>
 <20190404034708.3399-2-wqu@suse.com>
 <6a3d979f-aa45-422e-d415-0a7fbb26a06d@suse.com>
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
Message-ID: <814742c5-c6d5-7c33-d8a2-f634eac2ae94@gmx.com>
Date:   Thu, 4 Apr 2019 14:33:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <6a3d979f-aa45-422e-d415-0a7fbb26a06d@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ocBfaUUDuHVhvemluCuy8BuYo8ON597cSx7qBzaPDsKHXIYOUNZ
 urBWEFFniJRwV+D4Vs5m7ohmg6sEiOG14Zj9jdzbi3USbkMdUYKbsrZ6nrO8clR88K650GM
 Z/Kf/Xj1/DUG+XfpgCqn1YhRhZkoWtrirp5encle3jpdmzND58NXFTKiajCNZ1oL9L6/XJB
 UV6Nig29otPu6RD9rBdeQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:IWsdUrQIeSc=:0506DYeLbFFU5Evh8Asgf1
 OXOvyXSmeObiqzeygyzYXC5KTNpFhKDWn5Cl4csTEtF0HO4KAQ+y3yiotpM3sL7lbVCk0nC4V
 2qoGgnuDh+fOALRvKhLwRzRXIaTOgc6Q7ROpTN3WG6vwWSBIlvECjmbs+4a2R5BB3fCrUxao2
 WXF8M/ddRz18ZfG3kOIHforZOJ7jA1oLTw8myMG6xP7RMMJI2IJGByKmdwDWI9JgA+qa2ZXJy
 S1SaRGYfb7K1QUytOkMkKr9Zn4uQQkX+lp8y8vsSAJ+buuvO0RiwcuGtjXeBC9sT9RTmJQLGM
 rTCMUFLxi7xLWLqE9JtSrhuWPNmP4dw1ULtbHSScR0QdziBtO1oCtFlTh5QtpIQniY2aloVno
 bdFSne8dx/FQUmnG/T8v4GshcU+JEU69nmLqw5w/lxJJxsVA/NaCv4D6gY3gWGU0LLC6CkQfu
 8XcZtCu9x1fo2c3h1qD7vqACvFbiQK2bNpJKXLMp8I3J+Ogw4b3iPmvZeN1qGSpwX9BXbOaxa
 zXVyJEgsriln9leS3MPLTwxEqK8IbcXu7COeD4YXEs+zX4d+DsGxImHn4cu/UUobmfKUrf94T
 Ee+gfrwmLT4yLn22F84ZTuA1gtIA2oqkPqFpAhJq7mFVfOXyr6o8ifnAHvhf79cLUWmYUS0wF
 5z0qAeRm64SNdrNJhRXEvTFuOCJQmIqi6WvDZqoNFH3ZPr7n9ohUH6FeMnO5u4G/kLOhJQzqS
 F1AcLG8SjYHyaMS7oIjSUKABQemJppdOuBsp0DL7n2JjjU1kfw8KcVZRZ/98Xpf1VrhD7frI5
 5UUIGwR+TV3IYFhUrRjFtjZmGRl4oKKXGs0uQccDg7IaOzgu2OL1BmPPWYRic49WmfLripF+s
 kv9+9luomJYRyFP7CtvIGJcrcGWW5P5q1sJO79sf35sFv6/jw6tKogicFgFw5yaDJZXFOdyhg
 WEzDfqSkK+w==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/4/4 =E4=B8=8B=E5=8D=882:23, Nikolay Borisov wrote:
>
>
> On 4.04.19 =D0=B3. 6:47 =D1=87., Qu Wenruo wrote:
>> Commit 1ba98d086fe3 ("Btrfs: detect corruption when non-root leaf has
>> zero item") introduced comprehensive root owner checker.
>>
>> However it's pretty expensive tree search to locate the owner root,
>> especially when it get reused by mandatory read and write time
>> tree-checker.
>>
>> This patch will remove that check, and completely rely on owner based
>> empty leaf check, which is much faster and still works fine for most
>> case.
>>
>> And since we skip the old root owner check, now write time tree check
>> can be merged with btrfs_check_leaf_full().
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>
> This patch was sent yesterday, now it's sent again with no material
> changes whatsoever? What's the point?

This is the version to be applied on misc-next.

Thanks,
Qu

>
>> ---
>>  fs/btrfs/tree-checker.c | 24 ------------------------
>>  1 file changed, 24 deletions(-)
>>
>> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
>> index d2c3c1f8870d..e325d4df5c23 100644
>> --- a/fs/btrfs/tree-checker.c
>> +++ b/fs/btrfs/tree-checker.c
>> @@ -838,7 +838,6 @@ static int check_leaf(struct extent_buffer *leaf, b=
ool check_item_data)
>>  	 */
>>  	if (nritems =3D=3D 0 && !btrfs_header_flag(leaf, BTRFS_HEADER_FLAG_RE=
LOC)) {
>>  		u64 owner =3D btrfs_header_owner(leaf);
>> -		struct btrfs_root *check_root;
>>
>>  		/* These trees must never be empty */
>>  		if (owner =3D=3D BTRFS_ROOT_TREE_OBJECTID ||
>> @@ -852,29 +851,6 @@ static int check_leaf(struct extent_buffer *leaf, =
bool check_item_data)
>>  				    owner);
>>  			return -EUCLEAN;
>>  		}
>> -		key.objectid =3D owner;
>> -		key.type =3D BTRFS_ROOT_ITEM_KEY;
>> -		key.offset =3D (u64)-1;
>> -
>> -		check_root =3D btrfs_get_fs_root(fs_info, &key, false);
>> -		/*
>> -		 * The only reason we also check NULL here is that during
>> -		 * open_ctree() some roots has not yet been set up.
>> -		 */
>> -		if (!IS_ERR_OR_NULL(check_root)) {
>> -			struct extent_buffer *eb;
>> -
>> -			eb =3D btrfs_root_node(check_root);
>> -			/* if leaf is the root, then it's fine */
>> -			if (leaf !=3D eb) {
>> -				generic_err(leaf, 0,
>> -		"invalid nritems, have %u should not be 0 for non-root leaf",
>> -					nritems);
>> -				free_extent_buffer(eb);
>> -				return -EUCLEAN;
>> -			}
>> -			free_extent_buffer(eb);
>> -		}
>>  		return 0;
>>  	}
>>
>>
