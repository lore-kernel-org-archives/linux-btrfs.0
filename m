Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92CE7C0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 21:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A52C2081C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 21:29:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4A52C2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387932AbeKFGu7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 01:50:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:41050 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387638AbeKFGu7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Nov 2018 01:50:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A5F13B12A;
        Mon,  5 Nov 2018 21:29:16 +0000 (UTC)
Subject: Re: [PATCH 3/3] treewide: Fix missing declarations
To:     Rosen Penev <rosenp@gmail.com>, linux-btrfs@vger.kernel.org
References: <20181105190643.13578-1-rosenp@gmail.com>
 <20181105190643.13578-3-rosenp@gmail.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 xsFNBFiKBz4BEADNHZmqwhuN6EAzXj9SpPpH/nSSP8YgfwoOqwrP+JR4pIqRK0AWWeWCSwmZ
 T7g+RbfPFlmQp+EwFWOtABXlKC54zgSf+uulGwx5JAUFVUIRBmnHOYi/lUiE0yhpnb1KCA7f
 u/W+DkwGerXqhhe9TvQoGwgCKNfzFPZoM+gZrm+kWv03QLUCr210n4cwaCPJ0Nr9Z3c582xc
 bCUVbsjt7BN0CFa2BByulrx5xD9sDAYIqfLCcZetAqsTRGxM7LD0kh5WlKzOeAXj5r8DOrU2
 GdZS33uKZI/kZJZVytSmZpswDsKhnGzRN1BANGP8sC+WD4eRXajOmNh2HL4P+meO1TlM3GLl
 EQd2shHFY0qjEo7wxKZI1RyZZ5AgJnSmehrPCyuIyVY210CbMaIKHUIsTqRgY5GaNME24w7h
 TyyVCy2qAM8fLJ4Vw5bycM/u5xfWm7gyTb9V1TkZ3o1MTrEsrcqFiRrBY94Rs0oQkZvunqia
 c+NprYSaOG1Cta14o94eMH271Kka/reEwSZkC7T+o9hZ4zi2CcLcY0DXj0qdId7vUKSJjEep
 c++s8ncFekh1MPhkOgNj8pk17OAESanmDwksmzh1j12lgA5lTFPrJeRNu6/isC2zyZhTwMWs
 k3LkcTa8ZXxh0RfWAqgx/ogKPk4ZxOXQEZetkEyTFghbRH2BIwARAQABzSJOaWtvbGF5IEJv
 cmlzb3YgPG5ib3Jpc292QHN1c2UuZGU+wsF4BBMBAgAiBQJYijkSAhsDBgsJCAcDAgYVCAIJ
 CgsEFgIDAQIeAQIXgAAKCRBxvoJG5T8oV/B6D/9a8EcRPdHg8uLEPywuJR8URwXzkofT5bZE
 IfGF0Z+Lt2ADe+nLOXrwKsamhweUFAvwEUxxnndovRLPOpWerTOAl47lxad08080jXnGfYFS
 Dc+ew7C3SFI4tFFHln8Y22Q9075saZ2yQS1ywJy+TFPADIprAZXnPbbbNbGtJLoq0LTiESnD
 w/SUC6sfikYwGRS94Dc9qO4nWyEvBK3Ql8NkoY0Sjky3B0vL572Gq0ytILDDGYuZVo4alUs8
 LeXS5ukoZIw1QYXVstDJQnYjFxYgoQ5uGVi4t7FsFM/6ykYDzbIPNOx49Rbh9W4uKsLVhTzG
 BDTzdvX4ARl9La2kCQIjjWRg+XGuBM5rxT/NaTS78PXjhqWNYlGc5OhO0l8e5DIS2tXwYMDY
 LuHYNkkpMFksBslldvNttSNei7xr5VwjVqW4vASk2Aak5AleXZS+xIq2FADPS/XSgIaepyTV
 tkfnyreep1pk09cjfXY4A7qpEFwazCRZg9LLvYVc2M2eFQHDMtXsH59nOMstXx2OtNMcx5p8
 0a5FHXE/HoXz3p9bD0uIUq6p04VYOHsMasHqHPbsMAq9V2OCytJQPWwe46bBjYZCOwG0+x58
 fBFreP/NiJNeTQPOa6FoxLOLXMuVtpbcXIqKQDoEte9aMpoj9L24f60G4q+pL/54ql2VRscK
 d87BTQRYigc+ARAAyJSq9EFk28++SLfg791xOh28tLI6Yr8wwEOvM3wKeTfTZd+caVb9gBBy
 wxYhIopKlK1zq2YP7ZjTP1aPJGoWvcQZ8fVFdK/1nW+Z8/NTjaOx1mfrrtTGtFxVBdSCgqBB
 jHTnlDYV1R5plJqK+ggEP1a0mr/rpQ9dFGvgf/5jkVpRnH6BY0aYFPprRL8ZCcdv2DeeicOO
 YMobD5g7g/poQzHLLeT0+y1qiLIFefNABLN06Lf0GBZC5l8hCM3Rpb4ObyQ4B9PmL/KTn2FV
 Xq/c0scGMdXD2QeWLePC+yLMhf1fZby1vVJ59pXGq+o7XXfYA7xX0JsTUNxVPx/MgK8aLjYW
 hX+TRA4bCr4uYt/S3ThDRywSX6Hr1lyp4FJBwgyb8iv42it8KvoeOsHqVbuCIGRCXqGGiaeX
 Wa0M/oxN1vJjMSIEVzBAPi16tztL/wQtFHJtZAdCnuzFAz8ue6GzvsyBj97pzkBVacwp3/Mw
 qbiu7sDz7yB0d7J2tFBJYNpVt/Lce6nQhrvon0VqiWeMHxgtQ4k92Eja9u80JDaKnHDdjdwq
 FUikZirB28UiLPQV6PvCckgIiukmz/5ctAfKpyYRGfez+JbAGl6iCvHYt/wAZ7Oqe/3Cirs5
 KhaXBcMmJR1qo8QH8eYZ+qhFE3bSPH446+5oEw8A9v5oonKV7zMAEQEAAcLBXwQYAQIACQUC
 WIoHPgIbDAAKCRBxvoJG5T8oV1pyD/4zdXdOL0lhkSIjJWGqz7Idvo0wjVHSSQCbOwZDWNTN
 JBTP0BUxHpPu/Z8gRNNP9/k6i63T4eL1xjy4umTwJaej1X15H8Hsh+zakADyWHadbjcUXCkg
 OJK4NsfqhMuaIYIHbToi9K5pAKnV953xTrK6oYVyd/Rmkmb+wgsbYQJ0Ur1Ficwhp6qU1CaJ
 mJwFjaWaVgUERoxcejL4ruds66LM9Z1Qqgoer62ZneID6ovmzpCWbi2sfbz98+kW46aA/w8r
 7sulgs1KXWhBSv5aWqKU8C4twKjlV2XsztUUsyrjHFj91j31pnHRklBgXHTD/pSRsN0UvM26
 lPs0g3ryVlG5wiZ9+JbI3sKMfbdfdOeLxtL25ujs443rw1s/PVghphoeadVAKMPINeRCgoJH
 zZV/2Z/myWPRWWl/79amy/9MfxffZqO9rfugRBORY0ywPHLDdo9Kmzoxoxp9w3uTrTLZaT9M
 KIuxEcV8wcVjr+Wr9zRl06waOCkgrQbTPp631hToxo+4rA1jiQF2M80HAet65ytBVR2pFGZF
 zGYYLqiG+mpUZ+FPjxk9kpkRYz61mTLSY7tuFljExfJWMGfgSg1OxfLV631jV1TcdUnx+h3l
 Sqs2vMhAVt14zT8mpIuu2VNxcontxgVr1kzYA/tQg32fVRbGr449j1gw57BV9i0vww==
Message-ID: <f965feba-fce7-b562-d59f-e05e3aac9252@suse.com>
Date:   Mon, 5 Nov 2018 23:29:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181105190643.13578-3-rosenp@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 5.11.18 г. 21:06 ч., Rosen Penev wrote:
> Found using -Wmissing-prototypes in GCC.
> 
> This should improve LTO behavior.
> 
> Note that set_free_space_tree_thresholds is an unused function. Adding
> inline seems to remove the unused function warning.
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>


I had a series that did exactly this but since you came in first:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  btrfs.c              |  2 +-
>  check/mode-lowmem.c  |  2 +-
>  extent-tree.c        |  2 +-
>  free-space-tree.c    | 12 ++++++------
>  libbtrfsutil/stubs.c |  1 +
>  utils-lib.c          |  2 ++
>  utils.h              |  1 +
>  7 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/btrfs.c b/btrfs.c
> index 2d39f2c..78c468d 100644
> --- a/btrfs.c
> +++ b/btrfs.c
> @@ -210,7 +210,7 @@ static int handle_global_options(int argc, char **argv)
>  	return shift;
>  }
>  
> -void handle_special_globals(int shift, int argc, char **argv)
> +static void handle_special_globals(int shift, int argc, char **argv)
>  {
>  	int has_help = 0;
>  	int has_full = 0;
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 14bbc9e..94123c1 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -953,7 +953,7 @@ out:
>   * returns 0 means success.
>   * returns not 0 means on error;
>   */
> -int repair_ternary_lowmem(struct btrfs_root *root, u64 dir_ino, u64 ino,
> +static int repair_ternary_lowmem(struct btrfs_root *root, u64 dir_ino, u64 ino,
>  			  u64 index, char *name, int name_len, u8 filetype,
>  			  int err)
>  {
> diff --git a/extent-tree.c b/extent-tree.c
> index cd98633..8c9cdef 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -3749,7 +3749,7 @@ static void __get_extent_size(struct btrfs_root *root, struct btrfs_path *path,
>   * Return >0 for not found.
>   * Return <0 for err
>   */
> -int btrfs_search_overlap_extent(struct btrfs_root *root,
> +static int btrfs_search_overlap_extent(struct btrfs_root *root,
>  				struct btrfs_path *path, u64 bytenr, u64 len)
>  {
>  	struct btrfs_key key;
> diff --git a/free-space-tree.c b/free-space-tree.c
> index 6641cdf..6ef5792 100644
> --- a/free-space-tree.c
> +++ b/free-space-tree.c
> @@ -24,7 +24,7 @@
>  #include "bitops.h"
>  #include "internal.h"
>  
> -void set_free_space_tree_thresholds(struct btrfs_block_group_cache *cache,
> +static inline void set_free_space_tree_thresholds(struct btrfs_block_group_cache *cache,
>  				    u64 sectorsize)
>  {
>  	u32 bitmap_range;
> @@ -202,7 +202,7 @@ static void le_bitmap_set(unsigned long *map, unsigned int start, int len)
>  	}
>  }
>  
> -int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
> +static int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
>  				  struct btrfs_block_group_cache *block_group,
>  				  struct btrfs_path *path)
>  {
> @@ -341,7 +341,7 @@ out:
>  	return ret;
>  }
>  
> -int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
> +static int convert_free_space_to_extents(struct btrfs_trans_handle *trans,
>  				  struct btrfs_block_group_cache *block_group,
>  				  struct btrfs_path *path)
>  {
> @@ -780,7 +780,7 @@ out:
>  	return ret;
>  }
>  
> -int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
> +static int __remove_from_free_space_tree(struct btrfs_trans_handle *trans,
>  				  struct btrfs_block_group_cache *block_group,
>  				  struct btrfs_path *path, u64 start, u64 size)
>  {
> @@ -960,7 +960,7 @@ out:
>  	return ret;
>  }
>  
> -int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
> +static int __add_to_free_space_tree(struct btrfs_trans_handle *trans,
>  			     struct btrfs_block_group_cache *block_group,
>  			     struct btrfs_path *path, u64 start, u64 size)
>  {
> @@ -1420,7 +1420,7 @@ out:
>  	return ret;
>  }
>  
> -struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
> +static struct btrfs_root *btrfs_create_tree(struct btrfs_trans_handle *trans,
>  				     struct btrfs_fs_info *fs_info,
>  				     u64 objectid)
>  {
> diff --git a/libbtrfsutil/stubs.c b/libbtrfsutil/stubs.c
> index 9b9e037..c530e40 100644
> --- a/libbtrfsutil/stubs.c
> +++ b/libbtrfsutil/stubs.c
> @@ -19,6 +19,7 @@
>  
>  #include <stdlib.h>
>  #include <errno.h>
> +#include "stubs.h"
>  
>  void *reallocarray(void *ptr, size_t nmemb, size_t size)
>  {
> diff --git a/utils-lib.c b/utils-lib.c
> index 044f93f..2ac421b 100644
> --- a/utils-lib.c
> +++ b/utils-lib.c
> @@ -5,6 +5,8 @@
>  #include <sys/ioctl.h>
>  #include <ioctl.h>
>  
> +#include "utils.h"
> +
>  #if BTRFS_FLAT_INCLUDES
>  #include "ctree.h"
>  #else
> diff --git a/utils.h b/utils.h
> index b6c00cf..7c5eb79 100644
> --- a/utils.h
> +++ b/utils.h
> @@ -29,6 +29,7 @@
>  #include "sizes.h"
>  #include "messages.h"
>  #include "ioctl.h"
> +#include "fsfeatures.h"
>  
>  #define BTRFS_SCAN_MOUNTED	(1ULL << 0)
>  #define BTRFS_SCAN_LBLKID	(1ULL << 1)
> 
