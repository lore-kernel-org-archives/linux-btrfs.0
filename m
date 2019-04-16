Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F30AC10F13
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 07:48:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BB852073F
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 07:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbfDPHsU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 03:48:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:50266 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725943AbfDPHsT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 03:48:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 50C0DAF24
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 07:48:18 +0000 (UTC)
Subject: Re: [PATCH 3/3] btrfs-progs: Handle error properly in
 btrfs_commit_transaction()
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190416071526.3576-1-wqu@suse.com>
 <20190416071526.3576-4-wqu@suse.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 mQINBFiKBz4BEADNHZmqwhuN6EAzXj9SpPpH/nSSP8YgfwoOqwrP+JR4pIqRK0AWWeWCSwmZ
 T7g+RbfPFlmQp+EwFWOtABXlKC54zgSf+uulGwx5JAUFVUIRBmnHOYi/lUiE0yhpnb1KCA7f
 u/W+DkwGerXqhhe9TvQoGwgCKNfzFPZoM+gZrm+kWv03QLUCr210n4cwaCPJ0Nr9Z3c582xc
 bCUVbsjt7BN0CFa2BByulrx5xD9sDAYIqfLCcZetAqsTRGxM7LD0kh5WlKzOeAXj5r8DOrU2
 GdZS33uKZI/kZJZVytSmZpswDsKhnGzRN1BANGP8sC+WD4eRXajOmNh2HL4P+meO1TlM3GLl
 EQd2shHFY0qjEo7wxKZI1RyZZ5AgJnSmehrPCyuIyVY210CbMaIKHUIsTqRgY5GaNME24w7h
 TyyVCy2qAM8fLJ4Vw5bycM/u5xfWm7gyTb9V1TkZ3o1MTrEsrcqFiRrBY94Rs0oQkZvunqia
 c+NprYSaOG1Cta14o94eMH271Kka/reEwSZkC7T+o9hZ4zi2CcLcY0DXj0qdId7vUKSJjEep
 c++s8ncFekh1MPhkOgNj8pk17OAESanmDwksmzh1j12lgA5lTFPrJeRNu6/isC2zyZhTwMWs
 k3LkcTa8ZXxh0RfWAqgx/ogKPk4ZxOXQEZetkEyTFghbRH2BIwARAQABtCNOaWtvbGF5IEJv
 cmlzb3YgPG5ib3Jpc292QHN1c2UuY29tPokCOAQTAQIAIgUCWIo48QIbAwYLCQgHAwIGFQgC
 CQoLBBYCAwECHgECF4AACgkQcb6CRuU/KFc0eg/9GLD3wTQz9iZHMFbjiqTCitD7B6dTLV1C
 ddZVlC8Hm/TophPts1bWZORAmYIihHHI1EIF19+bfIr46pvfTu0yFrJDLOADMDH+Ufzsfy2v
 HSqqWV/nOSWGXzh8bgg/ncLwrIdEwBQBN9SDS6aqsglagvwFD91UCg/TshLlRxD5BOnuzfzI
 Leyx2c6YmH7Oa1R4MX9Jo79SaKwdHt2yRN3SochVtxCyafDlZsE/efp21pMiaK1HoCOZTBp5
 VzrIP85GATh18pN7YR9CuPxxN0V6IzT7IlhS4Jgj0NXh6vi1DlmKspr+FOevu4RVXqqcNTSS
 E2rycB2v6cttH21UUdu/0FtMBKh+rv8+yD49FxMYnTi1jwVzr208vDdRU2v7Ij/TxYt/v4O8
 V+jNRKy5Fevca/1xroQBICXsNoFLr10X5IjmhAhqIH8Atpz/89ItS3+HWuE4BHB6RRLM0gy8
 T7rN6ja+KegOGikp/VTwBlszhvfLhyoyjXI44Tf3oLSFM+8+qG3B7MNBHOt60CQlMkq0fGXd
 mm4xENl/SSeHsiomdveeq7cNGpHi6i6ntZK33XJLwvyf00PD7tip/GUj0Dic/ZUsoPSTF/mG
 EpuQiUZs8X2xjK/AS/l3wa4Kz2tlcOKSKpIpna7V1+CMNkNzaCOlbv7QwprAerKYywPCoOSC
 7P25Ag0EWIoHPgEQAMiUqvRBZNvPvki34O/dcTodvLSyOmK/MMBDrzN8Cnk302XfnGlW/YAQ
 csMWISKKSpStc6tmD+2Y0z9WjyRqFr3EGfH1RXSv9Z1vmfPzU42jsdZn667UxrRcVQXUgoKg
 QYx055Q2FdUeaZSaivoIBD9WtJq/66UPXRRr4H/+Y5FaUZx+gWNGmBT6a0S/GQnHb9g3nonD
 jmDKGw+YO4P6aEMxyy3k9PstaoiyBXnzQASzdOi39BgWQuZfIQjN0aW+Dm8kOAfT5i/yk59h
 VV6v3NLHBjHVw9kHli3jwvsizIX9X2W8tb1SefaVxqvqO1132AO8V9CbE1DcVT8fzICvGi42
 FoV/k0QOGwq+LmLf0t04Q0csEl+h69ZcqeBSQcIMm/Ir+NorfCr6HjrB6lW7giBkQl6hhomn
 l1mtDP6MTdbyYzEiBFcwQD4terc7S/8ELRRybWQHQp7sxQM/Lnuhs77MgY/e6c5AVWnMKd/z
 MKm4ru7A8+8gdHeydrRQSWDaVbfy3Hup0Ia76J9FaolnjB8YLUOJPdhI2vbvNCQ2ipxw3Y3c
 KhVIpGYqwdvFIiz0Fej7wnJICIrpJs/+XLQHyqcmERn3s/iWwBpeogrx2Lf8AGezqnv9woq7
 OSoWlwXDJiUdaqPEB/HmGfqoRRN20jx+OOvuaBMPAPb+aKJyle8zABEBAAGJAh8EGAECAAkF
 AliKBz4CGwwACgkQcb6CRuU/KFdacg/+M3V3Ti9JYZEiIyVhqs+yHb6NMI1R0kkAmzsGQ1jU
 zSQUz9AVMR6T7v2fIETTT/f5Oout0+Hi9cY8uLpk8CWno9V9eR/B7Ifs2pAA8lh2nW43FFwp
 IDiSuDbH6oTLmiGCB206IvSuaQCp1fed8U6yuqGFcnf0ZpJm/sILG2ECdFK9RYnMIaeqlNQm
 iZicBY2lmlYFBEaMXHoy+K7nbOuizPWdUKoKHq+tmZ3iA+qL5s6Qlm4trH28/fPpFuOmgP8P
 K+7LpYLNSl1oQUr+WlqilPAuLcCo5Vdl7M7VFLMq4xxY/dY99aZx0ZJQYFx0w/6UkbDdFLzN
 upT7NIN68lZRucImffiWyN7CjH23X3Tni8bS9ubo7OON68NbPz1YIaYaHmnVQCjDyDXkQoKC
 R82Vf9mf5slj0Vlpf+/Wpsv/TH8X32ajva37oEQTkWNMsDxyw3aPSps6MaMafcN7k60y2Wk/
 TCiLsRHFfMHFY6/lq/c0ZdOsGjgpIK0G0z6et9YU6MaPuKwNY4kBdjPNBwHreucrQVUdqRRm
 RcxmGC6ohvpqVGfhT48ZPZKZEWM+tZky0mO7bhZYxMXyVjBn4EoNTsXy1et9Y1dU3HVJ8fod
 5UqrNrzIQFbdeM0/JqSLrtlTcXKJ7cYFa9ZM2AP7UIN9n1UWxq+OPY9YMOewVfYtL8M=
Message-ID: <fe9cb7fe-4485-fe34-82b9-6b5b5adfbdf6@suse.com>
Date:   Tue, 16 Apr 2019 10:48:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190416071526.3576-4-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 16.04.19 г. 10:15 ч., Qu Wenruo wrote:
> [BUG]
> When running fuzz-tests/003 and fuzz-tests/009, btrfs-progs will crash
> due to BUG_ON().
> 
> [CAUSE]
> We abused BUG_ON() in btrfs_commit_transaction(), which is one of the
> most error prone function for fuzzed images.
> 
> Currently to cleanup the aborted transaction, we only need to clean up
> the only per-transaction data: delayed refs.
> 
> This patch will introduce a new function, btrfs_destroy_delayed_refs()
> to cleanup delayed refs when we failed to commit transaction.
> 
> With that function, we will gently destroy per-trans delayed ref, and
> remove the BUG_ON()s in btrfs_commit_transaction().
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>


Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Though see below for a suggestion of further cleanup

> ---
>  delayed-ref.c | 24 ++++++++++++++++++++++++
>  delayed-ref.h |  5 +++++
>  extent-tree.c |  6 +++---
>  transaction.c | 20 ++++++++++++++------
>  4 files changed, 46 insertions(+), 9 deletions(-)
> 
> diff --git a/delayed-ref.c b/delayed-ref.c
> index 9974dbbd4c6b..69f8be34fe18 100644
> --- a/delayed-ref.c
> +++ b/delayed-ref.c
> @@ -605,3 +605,27 @@ free_ref:
>  
>  	return -ENOMEM;
>  }
> +
> +void btrfs_destroy_delayed_refs(struct btrfs_trans_handle *trans)
> +{
> +	struct btrfs_fs_info *fs_info = trans->fs_info;
> +	struct rb_node *node;
> +	struct btrfs_delayed_ref_root *delayed_refs;
> +
> +	delayed_refs = &trans->delayed_refs;
> +	if (RB_EMPTY_ROOT(&delayed_refs->href_root))
> +		return;
> +	while ((node = rb_first(&delayed_refs->href_root)) != NULL) {
> +		struct btrfs_delayed_ref_head *head;
> +		struct btrfs_delayed_ref_node *ref;
> +		struct rb_node *n;
> +
> +		head = rb_entry(node, struct btrfs_delayed_ref_head, href_node);
> +		while ((n = rb_first(&head->ref_tree)) != NULL) {
> +			ref = rb_entry(n, struct btrfs_delayed_ref_node,
> +				       ref_node);
> +			drop_delayed_ref(trans, delayed_refs, head, ref);
> +		}
> +		ASSERT(cleanup_ref_head(trans, fs_info, head) == 0);
> +	}
> +}
> diff --git a/delayed-ref.h b/delayed-ref.h
> index 30a68b2a278c..4ff3eaa929ba 100644
> --- a/delayed-ref.h
> +++ b/delayed-ref.h
> @@ -205,4 +205,9 @@ btrfs_delayed_node_to_tree_ref(struct btrfs_delayed_ref_node *node)
>  {
>  	return container_of(node, struct btrfs_delayed_tree_ref, node);
>  }
> +
> +int cleanup_ref_head(struct btrfs_trans_handle *trans,
> +		     struct btrfs_fs_info *fs_info,
> +		     struct btrfs_delayed_ref_head *head);
> +void btrfs_destroy_delayed_refs(struct btrfs_trans_handle *trans);
>  #endif
> diff --git a/extent-tree.c b/extent-tree.c
> index 1140ebfc61ff..e62ee8c2ba13 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -4085,9 +4085,9 @@ static void unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_ref
>  	delayed_refs->num_heads_ready++;
>  }
>  
> -static int cleanup_ref_head(struct btrfs_trans_handle *trans,
> -			    struct btrfs_fs_info *fs_info,
> -			    struct btrfs_delayed_ref_head *head)
> +int cleanup_ref_head(struct btrfs_trans_handle *trans,
> +		     struct btrfs_fs_info *fs_info,
> +		     struct btrfs_delayed_ref_head *head)

You can create a followup patch that removes the fs_info argument from
cleanup_ref_head to make it identical to the kernel version.

>  {
>  	struct btrfs_delayed_ref_root *delayed_refs;
>  
> diff --git a/transaction.c b/transaction.c
> index 8d15eb11c7b5..138e10f0d6cc 100644
> --- a/transaction.c
> +++ b/transaction.c
> @@ -17,6 +17,7 @@
>  #include "kerncompat.h"
>  #include "disk-io.h"
>  #include "transaction.h"
> +#include "delayed-ref.h"
>  
>  #include "messages.h"
>  
> @@ -165,7 +166,8 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  	 * consistent
>  	 */
>  	ret = btrfs_run_delayed_refs(trans, -1);
> -	BUG_ON(ret);
> +	if (ret < 0)
> +		goto error;
>  
>  	if (root->commit_root == root->node)
>  		goto commit_tree;
> @@ -182,21 +184,24 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  	root->root_item.level = btrfs_header_level(root->node);
>  	ret = btrfs_update_root(trans, root->fs_info->tree_root,
>  				&root->root_key, &root->root_item);
> -	BUG_ON(ret);
> +	if (ret < 0)
> +		goto error;
>  
>  commit_tree:
>  	ret = commit_tree_roots(trans, fs_info);
> -	BUG_ON(ret);
> +	if (ret < 0)
> +		goto error;
>  	/*
>  	 * Ensure that all committed roots are properly accounted in the
>  	 * extent tree
>  	 */
>  	ret = btrfs_run_delayed_refs(trans, -1);
> -	BUG_ON(ret);
> +	if (ret < 0)
> +		goto error;
>  	btrfs_write_dirty_block_groups(trans);
>  	__commit_transaction(trans, root);
>  	if (ret < 0)
> -		goto out;
> +		goto error;
>  	ret = write_ctree_super(trans);
>  	btrfs_finish_extent_commit(trans);
>  	kfree(trans);
> @@ -204,7 +209,10 @@ commit_tree:
>  	root->commit_root = NULL;
>  	fs_info->running_transaction = NULL;
>  	fs_info->last_trans_committed = transid;
> -out:
> +	return ret;
> +error:
> +	btrfs_destroy_delayed_refs(trans);
> +	free(trans);
>  	return ret;
>  }
>  
> 
