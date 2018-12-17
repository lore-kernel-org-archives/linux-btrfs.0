Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 801C2C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 11:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58C90206A2
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 11:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbeLQLAo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 06:00:44 -0500
Received: from mout.gmx.net ([212.227.15.19]:58949 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726505AbeLQLAn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 06:00:43 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M7HGA-1hJY6E0UUQ-00x5xG; Mon, 17
 Dec 2018 12:00:37 +0100
Subject: Re: [PATCH v2 2/4] btrfs: Consolidate retval checking of core btree
 functions
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20181217083602.10166-3-nborisov@suse.com>
 <20181217094900.17575-1-nborisov@suse.com>
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
Message-ID: <d0fcbae0-5474-b19e-9412-37a3229917e7@gmx.com>
Date:   Mon, 17 Dec 2018 19:00:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181217094900.17575-1-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:cH2P16sglz8zIUbaz0jP8hgQDnx9UEheNrPKCmitp240kGHS7X3
 QpIOaFeymykgoCY/ZEOOaQd22n4muYRUZiApOt9bIRQp3CiN50Yl4nq4Q9sEIblrZDUdZ8r
 dAqbfzUc4UibOTcMkkwai8EvLNgYlPLquFq2dMA2U/djSv0TTtaOMY7r1jUIYJe1ZRfRgyW
 uXUuU+8Tpox4qEx23wViw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:4ANwn2OsUVQ=:az6L0NKmwP+zDx/XIAiNg2
 tz0Qzws/zhooplSzL8L8klxg4JkhiAi04cOymGL3w6d+Y9zoUu32271S5ESKGkSbscc9ebM7/
 HwxmP1ezwR193Adqggv7VfDkQa7GasV4H3KYSKggCVYnblq53/c0ubkZuWU7ou8R81WZEGeJ7
 0kw67nClLd4iGHrBFCkETLYN5BmqRnIWHH4GkddVh2BLXcwuVBaJRlsBYL91cbyOrPzroJ7Nn
 KzWPjAG0IgTQ02Zj+rlvriCH+qN//WkErsJWEKqF1k3wui5q+eb3jOKzy4NiSQ8uOssmQCH99
 9XJ6QTgPT8U/NRYz48FmtjxWWerctlcP8zQvPOT10S4yqXy3SSfHdbX8ZlUKYGjRFncijcOIw
 CkuvDvyUAvmdf84H1qEHN5eBL943xqIwoGSR1JDViFJMvvaniQT9WCiD9O2v6vCj4emSNqyF5
 XHL8J2TYge8VGY4lXMCdsMbs6MVCi85wulTmtKUy6sf3o89Z9yHRhCQ9S6le3WHO1Z959U8Ms
 r2SKSpARwzKbQl1Nyp6eRXT3XK27dGc2WSW8xaKcQLdKs5x5afczAj+rk8QZDgDZRfqfur5jV
 Zuvod5iRMW7guKi1lEWaEJhLAgniiV+HL6qj3GV/r/RNlKQQpcypLh8egC7PpkGoEGfArb9B8
 eePTnDJ84cq46EBlGyT1VBQQKMw+ggPR7aLvAvm/Wj3707pUx29Egoha67jN7dm8aswlSWu2N
 nUJarXhy++0CIiDQwAaLMx5d4j7NbfPQfDfkyxQwp8D6wqO29YhpFHaQYTW2oWDnmzBiTacu/
 +xH7oS8SrfmOZMnaWwVu3yUjKTvkkNs0yITqFJ8TwUvM+63rEC0bIU2fC7woEKG0hMBBr/1cO
 FsSbL8WZM3rIFLwiB/YJoZSVOlNLBvGDYvULJT4thMpPYGrXUBwAFwNdO8MNQL5Ll0mfiZPkD
 H3fYKFzk2yw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/12/17 下午5:49, Nikolay Borisov wrote:
> Core btree functions in btrfs generally return 0 when an item is found, 1 in
> case the sought item cannot be found and <0 when an error happens. Consolidate
> the checks for those conditions in one 'if () {} else if () {}' struct rather
> than 2 separate 'if () {}' statements. This emphasizes that the handling code
> pertains to a single function. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> 
> V2: 
>  * Properly describe return value convention in changelog no other changes. 
> 
>  fs/btrfs/inode.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index fe25f66a98d9..511d3b314af2 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6801,9 +6801,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
>  	if (ret < 0) {
>  		err = ret;
>  		goto out;
> -	}
> -
> -	if (ret != 0) {
> +	} else if (ret > 0) {
>  		if (path->slots[0] == 0)
>  			goto not_found;
>  		path->slots[0]--;
> @@ -6853,8 +6851,7 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
>  			if (ret < 0) {
>  				err = ret;
>  				goto out;
> -			}
> -			if (ret > 0)
> +			} else if (ret > 0)
>  				goto not_found;
>  			leaf = path->nodes[0];
>  		}
> 
