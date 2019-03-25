Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB5AC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 14:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A19F20879
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 14:37:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="YdgmXLhQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfCYOhE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:37:04 -0400
Received: from mout.gmx.net ([212.227.15.18]:41267 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbfCYOhE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 10:37:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553524616;
        bh=HGXadN1s8h1wPx6z+mWLCGodLH5QULqoIGvvHpjKFYc=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=YdgmXLhQYLfS0WOvUoW8mGvdI4YIVonSOxAG0WxFC3ESBxcsc4JcYo4ijmCmhyd8e
         ST0CO2GhmGTyEDWOimrtg+XqUuq/KBkhdeJ+d0cnWCldqaSXH6bV4MGomlQeWJoIcD
         X9Zl2IkOIt1ef7u67N61ZWINbuHgLmxE27OHNcy8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([173.82.105.236]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MaZrd-1hO2jG23Dd-00KAVk; Mon, 25
 Mar 2019 15:36:56 +0100
Subject: Re: [PATCH 5/7] btrfs: check/lowmem: Check and repair free space
 cache inode mode
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190325082253.19583-1-wqu@suse.com>
 <20190325082253.19583-6-wqu@suse.com>
From:   Su Yue <Damenly_Su@gmx.com>
Message-ID: <9cba693d-bbc3-fe91-80f4-f7b34ea84aad@gmx.com>
Date:   Mon, 25 Mar 2019 22:36:48 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <20190325082253.19583-6-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:m+Q/6bueIwBW1FSJGmX/XyCpa1w5OALIOsEqAl8AjiRM5tBBFeD
 nUF3YHVv5ZZ409onklOoG3m3KinRxFPhqPlkMCqqmWezUogk9UYlvXU02ZbS0Jh8mJgS9PD
 s0rBcOzAa/DfSCEPrlm43MhPA1Zc/aJ5MPzxiZPB9Ay+rsg6gUdXRN8Sldvnwh11uPrjwiG
 iaXYlmnDgJfC3SNFeuvvQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:g4/joSl9AMU=:cD2CFgDLOMn4uKNYK1zid8
 Vdd2I6cSltKrigUrpbIcTQ5MkwS2k+dE+qSdYfrjEZU/CxEDZ7iUszAbK3w4OpTGBBFD396Qy
 uqLrkbpKlDjzIzYQP1aroRrp83ycM5/VAyLx5Fn0KSi84TyPPj+oL8TzxpSJIRaYGWZagLJi2
 R3evDz43MebczpZ4RyzheCHvB7yt38kkVQJH+MoMNnWz7DKqdDAZChvEY73AdOnuYMaLalYav
 MZ+8GF/8pHXujjZDVu5wjmDQhjA/QjpYIlYecD1cZ1/B7pHd10Jg8AC8lpyrg5JuPaF8hXVbJ
 KWN3b70R+0CtB+VmH7M4onjbYK1AYGqM3zzXXk7g/G0WG9e48VP/9+xX4G10moqZIyn1Xodwx
 Uoiv5cvsEkKy8H6dVxQ4zFtl9l9s22huDFe1FNymH9uzWwe06Pbaw1lj+Oi9SfjphwEiz/4n4
 IjDfRBswhXxjOR5P+p29TXMXRDrKZ66/U6OpbPrlHsOtm5qGwQqHglNyMm3F4UyPBxTCrx524
 Lykvxmtr11bUlsc1kJjeTJVAqVxm2X+R4rruGtXM/ntBGhC/jKxwCM4OGH7nrX8AjWsPi2wqe
 RFEuE2HjaJPtTC5g9LxosFlMIqjvilAxHr4yIJ60zvUPyAxCwx6D3V10V95vzK+mH7Mt6f+wW
 Ces697UvpKNeKjNdQGs2WzfUu9DOm3c0PyadcjaPEy0mQvMISj0XNXilEHbZ4+Pbv/hco71EJ
 dlkosW6ipWTTu7CNXxvXPJrSGwPDbXqlTCKucytvokn/AIKvdHiAPn63tpv+XYxEdM3v3U6hV
 +po6myG0eAsD8BAsa8rI+PJBnpr4B9nybWYe0v/yf42dJ3B3tk4OY4w6xZhqKsWvK3bBtg5Og
 92RoRNcUvtZHu2mJDCr2iJD3bnFuhPSYfpbNqGDg/UMqhkHZ2lI4Lw0vwXi8XcSxXkmeU+xhB
 1JurUfCoY8w==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/25 4:22 PM, Qu Wenruo wrote:
> Unlike inodes in fs roots, we don't really check the inode items in root
> tree, in fact we just skip everything other than ROOT_ITEM and ROOT_REF.
>
> This makes invalid inode items sneak into root tree.
> For example:
>          item 9 key (256 INODE_ITEM 0) itemoff 13702 itemsize 160
>                  generation 30 transid 30 size 65536 nbytes 1507328
>                  block group 0 mode 0 links 1 uid 0 gid 0 rdev 0
> 				   ^ Should be 100600
>                  sequence 23 flags 0x1b(NODATASUM|NODATACOW|NOCOMPRESS|P=
REALLOC)
>                  atime 0.0 (1970-01-01 08:00:00)
>                  ctime 1553491158.189771625 (2019-03-25 13:19:18)
>                  mtime 0.0 (1970-01-01 08:00:00)
>                  otime 0.0 (1970-01-01 08:00:00)
>
> There is a report of such problem in the mail list.
>
> This patch will check and repair inode items of free space cache inodes =
in
> lowmem mode.
>
> Since free space cache inodes doesn't have INODE_REF but still has 1
> link, we can't use check_inode_item() directly.
> Instead we only check the inode mode, as that's the important part.
>
> The check and repair function: check_repair_free_space_inode() is also
> exported for original mode.
>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   check/mode-common.h |  1 +
>   check/mode-lowmem.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>   check/mode-lowmem.h |  2 ++
>   3 files changed, 48 insertions(+)
>
> diff --git a/check/mode-common.h b/check/mode-common.h
> index 8895747adf1d..855f83617854 100644
> --- a/check/mode-common.h
> +++ b/check/mode-common.h
> @@ -24,6 +24,7 @@
>   #include <sys/stat.h>
>   #include "ctree.h"
>
> +#define FREE_SPACE_CACHE_INODE_MODE	(0100600)
>   /*
>    * Use for tree walk to walk through trees whose leaves/nodes can be s=
hared
>    * between different trees. (Namely subvolume/fs trees)
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index f37c3b42e6b6..cdb9b66a63a3 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -5091,6 +5091,40 @@ out:
>   	return err;
>   }
>
> +/*
> + * For free space inodes, we can't call check_inode_item() as free spac=
e
> + * cache inode doesn't have INODE_REF.
> + * We just check its inode mode.
> + */
> +int check_repair_free_space_inode(struct btrfs_fs_info *fs_info,
> +				  struct btrfs_path *path)
> +{


In personal taste, I prefer check_free_space_inode() to
follow existed code.

> +	struct btrfs_inode_item *iitem;
> +	struct btrfs_key key;
> +	u32 mode;
> +	int ret =3D 0;
> +
> +	btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
> +	ASSERT(key.type =3D=3D BTRFS_INODE_ITEM_KEY && is_fstree(key.objectid)=
);
> +	iitem =3D btrfs_item_ptr(path->nodes[0], path->slots[0],
> +			       struct btrfs_inode_item);
> +	mode =3D btrfs_inode_mode(path->nodes[0], iitem);
> +	if (mode !=3D FREE_SPACE_CACHE_INODE_MODE) {
> +		error(
> +	"free space cache inode %llu has invalid mode: has 0%o expect 0%o",
> +			key.objectid, mode, FREE_SPACE_CACHE_INODE_MODE);
> +		ret =3D -EUCLEAN;
> +		if (repair) {
> +			ret =3D repair_imode_lowmem(fs_info->tree_root,
> +						  path);
> +			if (ret < 0)
> +				return ret;
> +			return ret;
> +		}
> +	}
> +	return ret;
> +}
> +
>   /*
>    * Check all fs/file tree in low_memory mode.
>    *
> @@ -5130,6 +5164,17 @@ int check_fs_roots_lowmem(struct btrfs_fs_info *f=
s_info)
>   		btrfs_item_key_to_cpu(node, &key, slot);
>   		if (key.objectid > BTRFS_LAST_FREE_OBJECTID)
>   			goto out;
> +		if (key.type =3D=3D BTRFS_INODE_ITEM_KEY &&
> +		    is_fstree(key.objectid)) {
> +			ret =3D check_repair_free_space_inode(fs_info, &path);
> +			/* Check if we still have a valid path to continue */

'path.nodes[0]' is quite interesting :).
What about the situation btrfs_search_slot() succeed but failed to
commit a transaction?


=2D--
Su
> +			if (ret < 0 && path.nodes[0]) {
> +				err |=3D ret;
> +				goto next;
> +			}
> +			if (ret < 0 && !path.nodes[0])
> +				goto out;
> +		}
>   		if (key.type =3D=3D BTRFS_ROOT_ITEM_KEY &&
>   		    fs_root_objectid(key.objectid)) {
>   			if (key.objectid =3D=3D BTRFS_TREE_RELOC_OBJECTID) {
> diff --git a/check/mode-lowmem.h b/check/mode-lowmem.h
> index e0ab30b770d5..d2983fd12eb4 100644
> --- a/check/mode-lowmem.h
> +++ b/check/mode-lowmem.h
> @@ -67,5 +67,7 @@
>
>   int check_fs_roots_lowmem(struct btrfs_fs_info *fs_info);
>   int check_chunks_and_extents_lowmem(struct btrfs_fs_info *fs_info);
> +int check_repair_free_space_inode(struct btrfs_fs_info *fs_info,
> +				  struct btrfs_path *path);
>
>   #endif
>
