Return-Path: <SRS0=9Rtw=NG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E4FC6786E
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 12:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93FB120868
	for <linux-btrfs@archiver.kernel.org>; Fri, 26 Oct 2018 12:42:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93FB120868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbeJZVTm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 26 Oct 2018 17:19:42 -0400
Received: from mout.gmx.net ([212.227.15.19]:33731 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727582AbeJZVTl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Oct 2018 17:19:41 -0400
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LrvWY-1fb0bK32X0-013dfE; Fri, 26
 Oct 2018 14:42:37 +0200
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0LrvWY-1fb0bK32X0-013dfE; Fri, 26
 Oct 2018 14:42:37 +0200
Subject: Re: [PATCH 4/5] btrfs: Sink find_lock_delalloc_range's 'max_bytes'
 argument
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1540554201-11305-1-git-send-email-nborisov@suse.com>
 <1540554201-11305-5-git-send-email-nborisov@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <5e0d99aa-cbe3-2a64-d51a-a1d26b155357@gmx.com>
Date:   Fri, 26 Oct 2018 20:42:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1540554201-11305-5-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:hDgBdN+gudCU+yoaUquiM+6GOMVJhE63cWROi0qQAudFFGH3Xua
 TVUvRRRE/yqlVThETS7f8pkmfumv+l8meMjQwqTzgbJLBB/PplnAdf9SQX7apAsOEV5NCqs
 Irvru84wqwTTbGySDGDnWgSFxwGrcHxfk9incvhsNUQwKLyQXbxKcghJui0LXm3RvPBI2PU
 bqhuSL34rWmcqld2n6byQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:pgDXb7dHCIc=:eJ2T8xmIjksxoc+orz+35l
 7DAnpZ1vQ15plpZuLxbXHe//aNSwN0Js+R5aS8TtpHU78GjbTQt72rfmv6xbfpMTEhhvgER0m
 lqDkuEI34KNoPEFN6b3qDo7fhJndqOE88mkG/a+XPqZbN2RJLOvLZ8QXFUJvSfushMoSZe06h
 fQxMEt+TEG1mIpTWNwRxCZeIokW6OfvW+ScaJXiJ52H9pR+e49jJbxbGs66Ng/9AR0/ksZici
 ZmwrPiwwIvJBadvmomMJPad5a90x2T98qsit6uDV6fgRwq/nP3HUAeMP0A78uq6OgMyEkkBMi
 KflIR864iO6AhlucemAVb9GVvnIOsOJD78/W2Kq97U6skxSFGne/fhxp6KSYgfc79GEVHskOX
 rJ5Ju22t217IWYxA+JHz0JVtjldgMMYaZCfE7uX4VHp/gWer8oQm8EYB9lEWspDoUEE+kYZ0s
 LZsJ+1eE68cUwvfl/0cwWsPNBYTpYi8GH0YHCl/bQFYVLlnDU7JkqakUyGpE9nY1EjmiWo188
 kxgaQHW2GRLpIvQHsm2BaxK1iWq7wDSl6OBXG/PEThLTv4epDCTSXWqkQisEk0Ku679h4WlYY
 h2f3OZEiQHQTr8PKz7SWOFhnBRyWL4wBJjhhkr4JdbNu/TKD8FqhwEDs2OLWTUpqOX3hrfsWv
 vs96X7S4ErDO7Oovx6TBAAuZHiCLWoqkz8UohH/k4+6rVeioFWi5lfynOx/O3M/raVwfbv7lc
 ycRx2RKPvIvlKDdNnRe73BBfJ/fu2IikAFmNR+wsd/bXjlTebfc1xMFZ/kH8kFFqf3z5Q9ltG
 UWJ06RTH5DfTkKU1s0TQZOMc4BkMWr92PbdMUX5hhj8T3jsizg=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/26 下午7:43, Nikolay Borisov wrote:
> All callers of this function pass BTRFS_MAX_EXTENT_SIZE (128M) so let's
> reduce the argument count and make that a local variable. No functional
> changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>  fs/btrfs/extent_io.c             | 11 +++++------
>  fs/btrfs/extent_io.h             |  2 +-
>  fs/btrfs/tests/extent-io-tests.c | 10 +++++-----
>  3 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 6877a74c7469..1a9a521aefe5 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -1566,8 +1566,9 @@ static noinline int lock_delalloc_pages(struct inode *inode,
>  static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
>  				    struct extent_io_tree *tree,
>  				    struct page *locked_page, u64 *start,
> -				    u64 *end, u64 max_bytes)
> +				    u64 *end)
>  {
> +	u64 max_bytes = BTRFS_MAX_EXTENT_SIZE;
>  	u64 delalloc_start;
>  	u64 delalloc_end;
>  	u64 found;
> @@ -1647,10 +1648,9 @@ static noinline_for_stack u64 find_lock_delalloc_range(struct inode *inode,
>  u64 btrfs_find_lock_delalloc_range(struct inode *inode,
>  				    struct extent_io_tree *tree,
>  				    struct page *locked_page, u64 *start,
> -				    u64 *end, u64 max_bytes)
> +				    u64 *end)
>  {
> -	return find_lock_delalloc_range(inode, tree, locked_page, start, end,
> -			max_bytes);
> +	return find_lock_delalloc_range(inode, tree, locked_page, start, end);
>  }
>  #endif
>  
> @@ -3233,8 +3233,7 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
>  		nr_delalloc = find_lock_delalloc_range(inode, tree,
>  					       page,
>  					       &delalloc_start,
> -					       &delalloc_end,
> -					       BTRFS_MAX_EXTENT_SIZE);
> +					       &delalloc_end);
>  		if (nr_delalloc == 0) {
>  			delalloc_start = delalloc_end + 1;
>  			continue;
> diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
> index 369daa5d4f73..7ec4f93caf78 100644
> --- a/fs/btrfs/extent_io.h
> +++ b/fs/btrfs/extent_io.h
> @@ -549,7 +549,7 @@ int free_io_failure(struct extent_io_tree *failure_tree,
>  u64 btrfs_find_lock_delalloc_range(struct inode *inode,
>  				      struct extent_io_tree *tree,
>  				      struct page *locked_page, u64 *start,
> -				      u64 *end, u64 max_bytes);
> +				      u64 *end);
>  #endif
>  struct extent_buffer *alloc_test_extent_buffer(struct btrfs_fs_info *fs_info,
>  					       u64 start);
> diff --git a/fs/btrfs/tests/extent-io-tests.c b/fs/btrfs/tests/extent-io-tests.c
> index 9e0f4a01be14..8ea8c2aa6696 100644
> --- a/fs/btrfs/tests/extent-io-tests.c
> +++ b/fs/btrfs/tests/extent-io-tests.c
> @@ -107,7 +107,7 @@ static int test_find_delalloc(u32 sectorsize)
>  	start = 0;
>  	end = 0;
>  	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> -					 &end, max_bytes);
> +					 &end);
>  	if (!found) {
>  		test_err("should have found at least one delalloc");
>  		goto out_bits;
> @@ -138,7 +138,7 @@ static int test_find_delalloc(u32 sectorsize)
>  	start = test_start;
>  	end = 0;
>  	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> -					 &end, max_bytes);
> +					 &end);
>  	if (!found) {
>  		test_err("couldn't find delalloc in our range");
>  		goto out_bits;
> @@ -172,7 +172,7 @@ static int test_find_delalloc(u32 sectorsize)
>  	start = test_start;
>  	end = 0;
>  	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> -					 &end, max_bytes);
> +					 &end);
>  	if (found) {
>  		test_err("found range when we shouldn't have");
>  		goto out_bits;
> @@ -193,7 +193,7 @@ static int test_find_delalloc(u32 sectorsize)
>  	start = test_start;
>  	end = 0;
>  	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> -					 &end, max_bytes);
> +					 &end);
>  	if (!found) {
>  		test_err("didn't find our range");
>  		goto out_bits;
> @@ -234,7 +234,7 @@ static int test_find_delalloc(u32 sectorsize)
>  	 * tests expected behavior.
>  	 */
>  	found = btrfs_find_lock_delalloc_range(inode, &tmp, locked_page, &start,
> -					 &end, max_bytes);
> +					 &end);
>  	if (!found) {
>  		test_err("didn't find our range");
>  		goto out_bits;
> 
