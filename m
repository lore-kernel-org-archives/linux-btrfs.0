Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35244C04EB9
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 12:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE40A20838
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 12:32:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE40A20838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729501AbeLFMcH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 07:32:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:37814 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728482AbeLFMcH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 07:32:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8E06FAD8F;
        Thu,  6 Dec 2018 12:32:04 +0000 (UTC)
Subject: Re: [PATCH 01/10] btrfs: add btrfs_delete_ref_head helper
To:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     Josef Bacik <jbacik@fb.com>
References: <20181203152038.21388-1-josef@toxicpanda.com>
 <20181203152038.21388-2-josef@toxicpanda.com>
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
Message-ID: <ad910339-556f-d554-634b-9b7f70b4371e@suse.com>
Date:   Thu, 6 Dec 2018 14:32:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181203152038.21388-2-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 3.12.18 г. 17:20 ч., Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> We do this dance in cleanup_ref_head and check_ref_cleanup, unify it
> into a helper and cleanup the calling functions.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> Reviewed-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/delayed-ref.c | 14 ++++++++++++++
>  fs/btrfs/delayed-ref.h |  3 ++-
>  fs/btrfs/extent-tree.c | 22 +++-------------------
>  3 files changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index 9301b3ad9217..b3e4c9fcb664 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -400,6 +400,20 @@ struct btrfs_delayed_ref_head *btrfs_select_ref_head(
>  	return head;
>  }
>  
> +void btrfs_delete_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
> +			   struct btrfs_delayed_ref_head *head)
> +{
> +	lockdep_assert_held(&delayed_refs->lock);
> +	lockdep_assert_held(&head->lock);
> +
> +	rb_erase_cached(&head->href_node, &delayed_refs->href_root);
> +	RB_CLEAR_NODE(&head->href_node);
> +	atomic_dec(&delayed_refs->num_entries);
> +	delayed_refs->num_heads--;
> +	if (head->processing == 0)
> +		delayed_refs->num_heads_ready--;
> +}
> +
>  /*
>   * Helper to insert the ref_node to the tail or merge with tail.
>   *
> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> index 8e20c5cb5404..d2af974f68a1 100644
> --- a/fs/btrfs/delayed-ref.h
> +++ b/fs/btrfs/delayed-ref.h
> @@ -261,7 +261,8 @@ static inline void btrfs_delayed_ref_unlock(struct btrfs_delayed_ref_head *head)
>  {
>  	mutex_unlock(&head->mutex);
>  }
> -
> +void btrfs_delete_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
> +			   struct btrfs_delayed_ref_head *head);
>  
>  struct btrfs_delayed_ref_head *btrfs_select_ref_head(
>  		struct btrfs_delayed_ref_root *delayed_refs);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index d242a1174e50..c36b3a42f2bb 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2474,12 +2474,9 @@ static int cleanup_ref_head(struct btrfs_trans_handle *trans,
>  		spin_unlock(&delayed_refs->lock);
>  		return 1;
>  	}
> -	delayed_refs->num_heads--;
> -	rb_erase_cached(&head->href_node, &delayed_refs->href_root);
> -	RB_CLEAR_NODE(&head->href_node);
> +	btrfs_delete_ref_head(delayed_refs, head);
>  	spin_unlock(&head->lock);
>  	spin_unlock(&delayed_refs->lock);
> -	atomic_dec(&delayed_refs->num_entries);
>  
>  	trace_run_delayed_ref_head(fs_info, head, 0);
>  
> @@ -6984,22 +6981,9 @@ static noinline int check_ref_cleanup(struct btrfs_trans_handle *trans,
>  	if (!mutex_trylock(&head->mutex))
>  		goto out;
>  
> -	/*
> -	 * at this point we have a head with no other entries.  Go
> -	 * ahead and process it.
> -	 */
> -	rb_erase_cached(&head->href_node, &delayed_refs->href_root);
> -	RB_CLEAR_NODE(&head->href_node);
> -	atomic_dec(&delayed_refs->num_entries);
> -
> -	/*
> -	 * we don't take a ref on the node because we're removing it from the
> -	 * tree, so we just steal the ref the tree was holding.
> -	 */
> -	delayed_refs->num_heads--;
> -	if (head->processing == 0)
> -		delayed_refs->num_heads_ready--;
> +	btrfs_delete_ref_head(delayed_refs, head);
>  	head->processing = 0;
> +
>  	spin_unlock(&head->lock);
>  	spin_unlock(&delayed_refs->lock);
>  
> 
