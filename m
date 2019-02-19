Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B97CC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 09:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65BDB21738
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 09:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfBSJca (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 04:32:30 -0500
Received: from mout.gmx.net ([212.227.17.21]:43755 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbfBSJc3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 04:32:29 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M1jKo-1hAfFw2vGM-00th5g; Tue, 19
 Feb 2019 10:31:56 +0100
Subject: Re: [PATCH] btrfs: factor our read/write stage off csum_tree_block()
 into its callers
To:     Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>
References: <20190219090202.9715-1-jthumshirn@suse.de>
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
Message-ID: <65c038e3-f228-52f0-ebc4-5414d5ccddad@gmx.com>
Date:   Tue, 19 Feb 2019 17:31:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190219090202.9715-1-jthumshirn@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:pfnH7HviOM65MxU/52CKF1qxTDFEw5hUphP1EHNOorek34ZGyhN
 Lqw7RbNnOv2AIs/luZrmiKY/HxPYcuKlu+K6RDbNX7bl7f6SvsoG633pD4mW31xTp9lLeQh
 su0UUzMrHOcpxH9wPoPopFwUoy9c+JVvnz8KUV74QISEkLg06oktuZFDNo5aLakYU6rNBE7
 HrwSfko8MOpTmdoGU+Dbg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:aIs19JRokjU=:9jlySa/R7ei/ZfIE5jnxuI
 BkgIwBHN8YPQOWI9D4YLGY+5g6EvX2QOyFnSlk3dDtw8Kf5TQYxgIiEglCqxP+9xrEeI+hiCX
 SPzVU6IEY7fAC3yYlfWKsKyu7xN8vdWsL2KX4q5Jn76wonrZwfc66p41PjtxnKIHK4FLg85Bx
 WDoH0ICNGVGyUW64htvQodLZNCAjZxdnAE/eagS32smWOnvhsdbMFg3OygrF6fXEorWrIpBPS
 DHMy41aUFrukOPEV7L5GU6TuJUdth/V2Iw46A9rKECBVJn7y3mKQMEAnxZcbJUprBU+VHNZmh
 nuPzxklR787u+V/KFFBFVtxuEj4X1yDmmHcKQApvnxfHD8X/u4mxdK/hR7Vap3hqLeC+6+W7r
 e8jMtAA6eXBWUiBhy71SUlu2nldlBFcnQB+PJ3umgzWxQUnJyHylsPWqXQ/jwdNUgVfA7fkFo
 PYMxp6DuKb7PVJRC1v3N79lTAWsNVrF61ONkwmjJZ6nXsbbxGUFWr9q/LJhT/0KXeX3wH/KF8
 me022z2HYYHgeUSqC/3aXvM82iAGqGvQ8XCWcyn4p+7naCYd9bm+zbB2522Xw+ii1Kr50eH71
 Cqsjj6KbDTKLg5rBsinhB/g8eparPZ+pr1C7ql/B1NqmVsuVdb9fyQ7HOIiz51JcVxtFFWF1V
 6i2m+2ZNbk/WTYr0C7B2/ay3Vf+e+8Du9uebsBN5Zq4/GVVIPs7Xr5jKK3BLvSCLhKrms5La8
 As2oXphU9zTh+63W6mZ5g2WS0ncD+uFe8mjN/yt8pW+MeLXcIyBvzbFcbsoTBo98Yv3STgPGz
 pg5jP+XjE9FMWHL9/WBYFIJ470X/trylhSJuKaBQXWsvtXwUy7vZT4X+VLHl+kaoZNV8gciKg
 MLHrjd2blnKC7vA0Xrq2h54iDPCWFeX18i02zXk0luNFAU7GSWI8rMxAhocAJlf8J5/awQfSw
 fN8PkHKWU+Q==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/2/19 下午5:02, Johannes Thumshirn wrote:
> Currently csum_tree_block() does two things, first it as it's name
> suggests it calculates the checksum for a tree-block. But it also writes
> this checksum to disk or reads an extent_buffer from disk and compares the
> checksum with the calculated checksum, depending on the verify argument.
> 
> Furthermore one of the two callers passes in '1' for the verify argument,
> the other one passes in '0'.
> 
> For clarity and less layering violations, factor out the second stage in
> csum_tree_block()'s callers.
> 
> Suggested-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

Looks good.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/disk-io.c | 51 +++++++++++++++++++++++++++------------------------
>  1 file changed, 27 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 5216e7b3f9ad..5330123b0fe3 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -263,12 +263,9 @@ void btrfs_csum_final(u32 crc, u8 *result)
>   * compute the csum for a btree block, and either verify it or write it
>   * into the csum field of the block.
>   */
> -static int csum_tree_block(struct btrfs_fs_info *fs_info,
> -			   struct extent_buffer *buf,
> -			   int verify)
> +static int csum_tree_block(struct extent_buffer *buf,
> +			   u8 *result)
>  {
> -	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
> -	char result[BTRFS_CSUM_SIZE];
>  	unsigned long len;
>  	unsigned long cur_len;
>  	unsigned long offset = BTRFS_CSUM_SIZE;
> @@ -300,23 +297,6 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
>  
>  	btrfs_csum_final(crc, result);
>  
> -	if (verify) {
> -		if (memcmp_extent_buffer(buf, result, 0, csum_size)) {
> -			u32 val;
> -			u32 found = 0;
> -			memcpy(&found, result, csum_size);
> -
> -			read_extent_buffer(buf, &val, 0, csum_size);
> -			btrfs_warn_rl(fs_info,
> -				"%s checksum verify failed on %llu wanted %X found %X level %d",
> -				fs_info->sb->s_id, buf->start,
> -				val, found, btrfs_header_level(buf));
> -			return -EUCLEAN;
> -		}
> -	} else {
> -		write_extent_buffer(buf, result, 0, csum_size);
> -	}
> -
>  	return 0;
>  }
>  
> @@ -533,6 +513,8 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
>  {
>  	u64 start = page_offset(page);
>  	u64 found_start;
> +	u8 result[BTRFS_CSUM_SIZE];
> +	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
>  	struct extent_buffer *eb;
>  
>  	eb = (struct extent_buffer *)page->private;
> @@ -552,7 +534,11 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
>  	ASSERT(memcmp_extent_buffer(eb, fs_info->fs_devices->metadata_uuid,
>  			btrfs_header_fsid(), BTRFS_FSID_SIZE) == 0);
>  
> -	return csum_tree_block(fs_info, eb, 0);
> +	if (WARN_ON(csum_tree_block(eb, result)))
> +		return -EUCLEAN;
> +
> +	write_extent_buffer(eb, result, 0, csum_size);
> +	return 0;
>  }
>  
>  static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
> @@ -595,7 +581,9 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>  	struct extent_buffer *eb;
>  	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
>  	struct btrfs_fs_info *fs_info = root->fs_info;
> +	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
>  	int ret = 0;
> +	char result[BTRFS_CSUM_SIZE];
>  	int reads_done;
>  
>  	if (!page->private)
> @@ -642,10 +630,25 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
>  	btrfs_set_buffer_lockdep_class(btrfs_header_owner(eb),
>  				       eb, found_level);
>  
> -	ret = csum_tree_block(fs_info, eb, 1);
> +	ret = csum_tree_block(eb, result);
>  	if (ret)
>  		goto err;
>  
> +	if (memcmp_extent_buffer(eb, result, 0, csum_size)) {
> +		u32 val;
> +		u32 found = 0;
> +
> +		memcpy(&found, result, csum_size);
> +
> +		read_extent_buffer(eb, &val, 0, csum_size);
> +		btrfs_warn_rl(fs_info,
> +			      "%s checksum verify failed on %llu wanted %x found %x level %d",
> +			      fs_info->sb->s_id, eb->start,
> +			      val, found, btrfs_header_level(eb));
> +		ret = -EUCLEAN;
> +		goto err;
> +	}
> +
>  	/*
>  	 * If this is a leaf block and it is corrupt, set the corrupt bit so
>  	 * that we don't try and read the other copies of this block, just
> 
