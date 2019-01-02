Return-Path: <SRS0=VtQK=PK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C07C43387
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 08:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 474A621871
	for <linux-btrfs@archiver.kernel.org>; Wed,  2 Jan 2019 08:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbfABI5v (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 2 Jan 2019 03:57:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:35010 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728915AbfABI5u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Jan 2019 03:57:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7B618AD9C
        for <linux-btrfs@vger.kernel.org>; Wed,  2 Jan 2019 08:57:47 +0000 (UTC)
Subject: Re: [PATCH] btrfs-progs: Update backup roots when writing super
 blocks
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181225052845.26322-1-wqu@suse.com>
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
Message-ID: <d50be952-a062-5a44-c8f8-48b4077bb441@suse.com>
Date:   Wed, 2 Jan 2019 10:57:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181225052845.26322-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 25.12.18 г. 7:28 ч., Qu Wenruo wrote:
> The code is mostly ported from kernel with minimal change.
> 
> Since btrfs-progs doesn't support replaying log, there is some code
> unnecessary for btrfs-progs, but to keep the code the same, that
> unnecessary code is kept as it.
> 
> Now "btrfs check --repair" will update backup roots correctly.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  disk-io.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 78 insertions(+)
> 
> diff --git a/disk-io.c b/disk-io.c
> index 133835a4d063..f28a6b526391 100644
> --- a/disk-io.c
> +++ b/disk-io.c
> @@ -1621,6 +1621,83 @@ write_err:
>  	return ret;
>  }
>  
> +/*
> + * copy all the root pointers into the super backup array.
> + * this will bump the backup pointer by one when it is
> + * done
> + */
> +static void backup_super_roots(struct btrfs_fs_info *info)
> +{
> +	struct btrfs_root_backup *root_backup;
> +	int next_backup;
> +	int last_backup;
> +
> +	last_backup = find_best_backup_root(info->super_copy);

Slightly offtopic: but find_best_backup_root only partially resembles
it's kernel counterpart - find_newest_super_backup. And it's missing the
code for handling wraparound. So in kernel space if the newest root is
at index 3 and index 0 backup also has the same gen then we switch the
index to 0, why is this needed? In any case I think
'find_best_backup_root' in progs should be renamed to
'find_newest_super_backup' and copied from kernel space.

> +	next_backup = (last_backup + 1) % BTRFS_NUM_BACKUP_ROOTS;

This logic is different than the kernel one which does:
last_backup = (next_backup + BTRFS_NUM_BACKUP_ROOTS - 1) %
                BTRFS_NUM_BACKUP_ROOTS;

So in the kernel when info->backup_root_index == 0 then the newest
backup root is going to be written at position 3, the next one in pos 1,
the next in pos 2 and so on. OTOH in userspace we might potentially
start writing at 1 (which doesn't seem problematic per se). So why the
difference in logic?

> +
> +	/* just overwrite the last backup if we're at the same generation */
> +	root_backup = info->super_copy->super_roots + last_backup;
> +	if (btrfs_backup_tree_root_gen(root_backup) ==
> +	    btrfs_header_generation(info->tree_root->node))
> +		next_backup = last_backup;
> +
> +	root_backup = info->super_copy->super_roots + next_backup;
> +
> +	/*
> +	 * make sure all of our padding and empty slots get zero filled
> +	 * regardless of which ones we use today
> +	 */
> +	memset(root_backup, 0, sizeof(*root_backup));
> +	btrfs_set_backup_tree_root(root_backup, info->tree_root->node->start);
> +	btrfs_set_backup_tree_root_gen(root_backup,
> +			       btrfs_header_generation(info->tree_root->node));
> +	btrfs_set_backup_tree_root_level(root_backup,
> +			       btrfs_header_level(info->tree_root->node));
> +
> +	btrfs_set_backup_chunk_root(root_backup, info->chunk_root->node->start);
> +	btrfs_set_backup_chunk_root_gen(root_backup,
> +			       btrfs_header_generation(info->chunk_root->node));
> +	btrfs_set_backup_chunk_root_level(root_backup,
> +			       btrfs_header_level(info->chunk_root->node));
> +
> +	btrfs_set_backup_extent_root(root_backup, info->extent_root->node->start);
> +	btrfs_set_backup_extent_root_gen(root_backup,
> +			       btrfs_header_generation(info->extent_root->node));
> +	btrfs_set_backup_extent_root_level(root_backup,
> +			       btrfs_header_level(info->extent_root->node));
> +	/*
> +	 * we might commit during log recovery, which happens before we set
> +	 * the fs_root.  Make sure it is valid before we fill it in.
> +	 */
> +	if (info->fs_root && info->fs_root->node) {
> +		btrfs_set_backup_fs_root(root_backup,
> +					 info->fs_root->node->start);
> +		btrfs_set_backup_fs_root_gen(root_backup,
> +			       btrfs_header_generation(info->fs_root->node));
> +		btrfs_set_backup_fs_root_level(root_backup,
> +			       btrfs_header_level(info->fs_root->node));
> +	}
> +
> +	btrfs_set_backup_dev_root(root_backup, info->dev_root->node->start);
> +	btrfs_set_backup_dev_root_gen(root_backup,
> +			       btrfs_header_generation(info->dev_root->node));
> +	btrfs_set_backup_dev_root_level(root_backup,
> +				       btrfs_header_level(info->dev_root->node));
> +
> +	btrfs_set_backup_csum_root(root_backup, info->csum_root->node->start);
> +	btrfs_set_backup_csum_root_gen(root_backup,
> +			       btrfs_header_generation(info->csum_root->node));
> +	btrfs_set_backup_csum_root_level(root_backup,
> +			       btrfs_header_level(info->csum_root->node));
> +
> +	btrfs_set_backup_total_bytes(root_backup,
> +			     btrfs_super_total_bytes(info->super_copy));
> +	btrfs_set_backup_bytes_used(root_backup,
> +			     btrfs_super_bytes_used(info->super_copy));
> +	btrfs_set_backup_num_devices(root_backup,
> +			     btrfs_super_num_devices(info->super_copy));
> +};
> +
>  int write_all_supers(struct btrfs_fs_info *fs_info)
>  {
>  	struct list_head *head = &fs_info->fs_devices->devices;
> @@ -1630,6 +1707,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info)
>  	int ret;
>  	u64 flags;
>  
> +	backup_super_roots(fs_info);
>  	sb = fs_info->super_copy;
>  	dev_item = &sb->dev_item;
>  	list_for_each_entry(dev, head, dev_list) {
> 
