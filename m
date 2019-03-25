Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFDE3C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 04:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A99D20828
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 04:27:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="SwRr3RsX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfCYE1i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 00:27:38 -0400
Received: from mout.gmx.net ([212.227.15.15]:60715 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbfCYE1i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 00:27:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553488049;
        bh=N67KDcm2ksvLr1dS8UvAzOHBT3qOJScVRXZxG+2HXXA=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=SwRr3RsX84miIA3dLvDgovz9yJMK4SJ2avEitjDU/bSuMmRyq61bJbNvg/wU6U6Ee
         ys8rfw4z+1lDZL5Gu7Lf+uoNYSyET/eN38J9khX1F6D0Yr0L3LLIbYYqnQIff5QMJb
         V/YAawP4cGgptEnFFvVJWVuZDdllC94EufqytKDE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MY7dI-1hUDvU19ge-00Uv9y; Mon, 25
 Mar 2019 05:27:29 +0100
Subject: Re: [PATCh v2 8/9] btrfs: tree-checker: Verify inode item
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
References: <20190320063717.31770-1-wqu@suse.com>
 <20190320063717.31770-9-wqu@suse.com>
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
Message-ID: <a8e3f871-370a-464b-a0ae-f4da93f0eed8@gmx.com>
Date:   Mon, 25 Mar 2019 12:27:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190320063717.31770-9-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Ro3KPi5TBYaVwMVLQCmoVLM2bXFzwY3UIYHY2s9BCWf9/R/Eavz
 li8rFPHNxT7QVpWrz/GOstALFm9HkCohSiMACGeb467PVVHoMYpMcp3m/euxv2FatBSxeaA
 jZKo8HaQb0aJjrJUHGvv3FgCHm2j9BLwmPFQ2vlrQGvTGouAex8hXDOnzt++0U+J0YG2OYm
 tdwwNCUdN4JrN9gL5wOoQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:fDjBw4BVSrQ=:CS7mXM+eoaRB9Uo5OH0Hfu
 OtMtHf3tD4eM1BDgxsXwMI7AVrhZkBuDtEDh+/RYN88D5LRppO3DFkZNFWWqkp4yZZln4PfY4
 4k35PNRGuHLRqJDP+WHaNZPHA0nuwrgf6R1TJAf8xvMegJ66wPGRl2sPcF6wbbjLADdh8eP68
 eOZu2W7IDwjm3SPdkdN9c5WHl840V4JyfxyZGQ7Mw84QDGEosPJEMFlRSxUkR6tDzDHApxPn7
 xRyL4XBAK9fQnwyqLEuYZKcLa45Ago308jnUoyL+FtRP6YIHQ+XBNplDzk0W6IhZPFg8nCp6u
 /BW9/mhhY4pxn8xp26vI1O4OI6XR/3wYWqu0/3873Fnugm0/PTHZmMnuZxHVOZg9ly2aPhY2v
 FE0+7WdJldQqbR7tNpYpxZ8rsgznwfgtscU42p7P1EONkJsA+XFAhz26XMqRbEQzL/b/q1eRA
 8yV+z2qRd7+5x4eNVEfkRi9PjXxB60VHgZ3N3X72t+2e7OP+GWu2cZY1L8qHgIkYOUAE4X+nP
 MRRD+E6upDHN3XDjVOmLgXnHmZmiEfbsNVtvjHkavdOM/q0eLQ05kH0OjXRfmyafXv1gFwLws
 neHcEsUwfsJoDRqdXQK/gn8iWa03hQEcJf/DJi9EmLmn9JNWgJdkawVwNMuUE9yvZf76RODtx
 LeaP3NY+rPMVZ+huzQ6dOLHKrYgv6wDnetfzkjNzQiCAr5IYOQXvUaIOA3V1PtOpfKEsEZVcJ
 JNHG+Yo8igeAMeaeXQ/XxfZP9H6Wtg/r6EsGKKW1WhIGrHSYGvDQkszn7HI6JXg24uIEcfJCb
 IaNOBqvdtpLMZaWo4F59kTUZC6MNnN+mxVjZUOMSf5UXzBkhxsPL4HE53fq3mMWmzPKPPp4wm
 A2O5ayPl+3QKJ/Ny+qJLUHPSpVFjXEJpNXoNVhHo/Ah5T74RkyJsE6H4gL83ubA955JhJ6TuP
 /M81q3o6ZOQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/20 =E4=B8=8B=E5=8D=882:37, Qu Wenruo wrote:
> There is a report in kernel bugzilla about mismatch file type in dir
> item and inode item.
>
> This inspires us to check inode mode in inode item.
>
> This patch will check the following members:
> - inode key objectid
>   Should be ROOT_DIR_DIR or [256, (u64)-256] or FREE_INO.
>
> - inode key offset
>   Should be 0
>
> - inode item generation
> - inode item transid
>   No newer than sb generation + 1.
>   The +1 is for log tree.
>
> - inode item mode
>   No unknown bits.
>   No invalid S_IF* bit.
>   NOTE: S_IFMT check is not enough, need to check every know type.
>
> - inode item nlink
>   Dir should have no more link than 1.
>
> - inode item flags
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

There is some bug report of kernel producing free space cache inode with
mode 0, which is invalid and can be detected by this patch.

Although the patch itself is good, I'm afraid we need to address the
invalid inode mode created by old kernel in btrfs-progs at least before
merging this patch into upstream.

Thankfully we still have one release cycle to handle it.

Thanks,
Qu

> ---
>  fs/btrfs/ctree.h        |  2 +
>  fs/btrfs/tree-checker.c | 99 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 101 insertions(+)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index b3642367a595..b0f19cc56485 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -1539,6 +1539,8 @@ do {                                              =
                     \
>  #define BTRFS_INODE_COMPRESS		(1 << 11)
>
>  #define BTRFS_INODE_ROOT_ITEM_INIT	(1 << 31)
> +#define BTRFS_INODE_FLAG_MASK		(((1 << 12) - 1) |\
> +					 BTRFS_INODE_ROOT_ITEM_INIT)
>
>  struct btrfs_map_token {
>  	const struct extent_buffer *eb;
> diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> index fef0cd8c90a5..fa0ad9e7de6e 100644
> --- a/fs/btrfs/tree-checker.c
> +++ b/fs/btrfs/tree-checker.c
> @@ -689,6 +689,102 @@ static int check_dev_item(struct btrfs_fs_info *fs=
_info,
>  	return -EUCLEAN;
>  }
>
> +/* Inode item error output has the same format as dir_item_err() */
> +#define inode_item_err(fs_info, eb, slot, fmt, ...)	\
> +	dir_item_err(fs_info, eb, slot, fmt, __VA_ARGS__)
> +
> +static int check_inode_item(struct btrfs_fs_info *fs_info,
> +			    struct extent_buffer *leaf,
> +			    struct btrfs_key *key, int slot)
> +{
> +	struct btrfs_inode_item *iitem;
> +	u64 super_gen =3D btrfs_super_generation(fs_info->super_copy);
> +	u32 valid_mask =3D (S_IFMT | S_ISUID | S_ISGID | S_ISVTX | 0777);
> +	u32 mode;
> +
> +	if ((key->objectid < BTRFS_FIRST_FREE_OBJECTID ||
> +	     key->objectid > BTRFS_LAST_FREE_OBJECTID) &&
> +	     key->objectid !=3D BTRFS_ROOT_TREE_DIR_OBJECTID &&
> +	     key->objectid !=3D BTRFS_FREE_INO_OBJECTID) {
> +		generic_err(fs_info, leaf, slot,
> +	"invalid key objectid: has %llu expect %llu or [%llu, %llu] or %llu",
> +			    key->objectid, BTRFS_ROOT_TREE_DIR_OBJECTID,
> +			    BTRFS_FIRST_FREE_OBJECTID,
> +			    BTRFS_LAST_FREE_OBJECTID,
> +			    BTRFS_FREE_INO_OBJECTID);
> +		goto error;
> +	}
> +	if (key->offset !=3D 0) {
> +		inode_item_err(fs_info, leaf, slot,
> +			"invalid key offset: has %llu expect 0",
> +			key->offset);
> +		goto error;
> +	}
> +	iitem =3D btrfs_item_ptr(leaf, slot, struct btrfs_inode_item);
> +
> +	/* Here we use super block generation + 1 to handle log tree */
> +	if (btrfs_inode_generation(leaf, iitem) > super_gen + 1) {
> +		inode_item_err(fs_info, leaf, slot,
> +			"invalid inode generation: has %llu expect (0, %llu]",
> +			       btrfs_inode_generation(leaf, iitem),
> +			       super_gen + 1);
> +		goto error;
> +	}
> +	/* Note for ROOT_TREE_DIR_ITEM, mkfs could make its transid as 0 */
> +	if (btrfs_inode_transid(leaf, iitem) > super_gen + 1) {
> +		inode_item_err(fs_info, leaf, slot,
> +			"invalid inode generation: has %llu expect [0, %llu]",
> +			       btrfs_inode_transid(leaf, iitem),
> +			       super_gen + 1);
> +		goto error;
> +	}
> +
> +	/*
> +	 * For size and nbytes it's better not to be too strict, as for dir
> +	 * item its size/nbytes can easily get wrong, but doesn't affect
> +	 * any thing of the fs. So here we skip the check.
> +	 */
> +
> +	mode =3D btrfs_inode_mode(leaf, iitem);
> +	if (mode & ~valid_mask) {
> +		inode_item_err(fs_info, leaf, slot,
> +			       "unknown mode bit detected: 0x%x",
> +			       mode & ~valid_mask);
> +		goto error;
> +	}
> +
> +	/*
> +	 * S_IFMT is not bit mapped so we can't completely rely is_power_of_2(=
),
> +	 * but is_power_of_2() can save us from checking FIFO/CHR/DIR/REG.
> +	 * Only needs to check BLK, LNK and SOCKS
> +	 */
> +	if (!is_power_of_2(mode & S_IFMT)) {
> +		if (!S_ISLNK(mode) && ! S_ISBLK(mode) && !S_ISSOCK(mode)) {
> +			inode_item_err(fs_info, leaf, slot,
> +			"invalid mode: has 0%o expect valid S_IF* bit(s)",
> +				       mode & S_IFMT);
> +			goto error;
> +		}
> +	}
> +	if (S_ISDIR(mode) && btrfs_inode_nlink(leaf, iitem) > 1) {
> +		inode_item_err(fs_info, leaf, slot,
> +			       "invalid nlink: has %u expect no more than 1 for dir",
> +			btrfs_inode_nlink(leaf, iitem));
> +		goto error;
> +	}
> +	if (btrfs_inode_flags(leaf, iitem) & ~BTRFS_INODE_FLAG_MASK) {
> +		inode_item_err(fs_info, leaf, slot,
> +			       "unknown flags detected: 0x%llx",
> +			       btrfs_inode_flags(leaf, iitem) &
> +			       ~BTRFS_INODE_FLAG_MASK);
> +		goto error;
> +	}
> +	return 0;
> +
> +error:
> +	return -EUCLEAN;
> +}
> +
>  /*
>   * Common point to switch the item-specific validation.
>   */
> @@ -722,6 +818,9 @@ static int check_leaf_item(struct btrfs_fs_info *fs_=
info,
>  	case BTRFS_DEV_ITEM_KEY:
>  		ret =3D check_dev_item(fs_info, leaf, key, slot);
>  		break;
> +	case BTRFS_INODE_ITEM_KEY:
> +		ret =3D check_inode_item(fs_info, leaf, key, slot);
> +		break;
>  	}
>  	return ret;
>  }
>
