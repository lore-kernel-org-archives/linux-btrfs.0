Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2538EC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 09:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B697F20675
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 09:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbeLQJJP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 04:09:15 -0500
Received: from mout.gmx.net ([212.227.17.22]:40139 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbeLQJJP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 04:09:15 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx102
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LbxQO-1hFobw1RLg-00jGgX; Mon, 17
 Dec 2018 10:09:09 +0100
Subject: Re: [PATCH 2/4] btrfs: Consolidate retval checking of core btree
 functions
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20181217083602.10166-1-nborisov@suse.com>
 <20181217083602.10166-3-nborisov@suse.com>
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
Message-ID: <3a4e1342-f764-6cee-b76c-e9f1b0167191@gmx.com>
Date:   Mon, 17 Dec 2018 17:09:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20181217083602.10166-3-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:q0FEVHs5IIsPOwgG3D5ugLOS0XJc3rQEvmNOWn+6R0eH3bFO/nq
 hsVjBuZYd7przPJHH1Zu+rs6vXL6LstZZidY4QuJU1HEMJWkJhQeQBdgQtppjqPuDbL3ogw
 KFJzI867aSvs5JeRMDfZn8vozbu8o1W2UwsxWUPdW45R1WcM5gkdv7cfQb0JSzPxPj6sc6O
 F2oEP3pYOlOGQsmH2K4Pg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3ifCc2jFwlY=:Poj7Os4c2ZSp9dXl1RD2zs
 L+FvaAF0sZsDT496l7UTEBlsXAqAxbaCQDfnNTmZqnU168MJatu5IYZwHcWm3a2obc1TGnUWU
 dTJcJXI2h/LCnfRoVw0+UR69ZkrYVvmgtVG+2zEPHjrcTKN/EEx+dsBLY555NjiTtNwgLrKd8
 wQOLmRq1b9k3cILLJd2UDCFmhBa6SbmlhgbsT7XDTR7pMTJLdY0icNluxTY/RL7fwIFlfOb7W
 IdNumfwxskZ7ykBbKDbwA9R+4UMGpC0WGPSSgRy7K1OuEX6L/ZuxQQq2lttgrBS/Jf/Kf0OSj
 T8829CB+dQ+cLcUKFVE+0Ti16HMVCEZeG21tdFL0mqLDWpUS53gKZY0MUdP+FGncjIvLYgRw8
 I+WhQzaHSMAcdNfIawOG1NcsEtgumjmFtAOZ6hDWe5bSPuZKcY8Ptn+gNjczMIrzEkcao2n7P
 j/0djO8cCdeHhJwIxCCdNTq9pOPDWp5Xw9APfLVprlK0ZEv7uYI4fedXoxcP17m/dRF9cBP0i
 Mgpq90u3r3fZF/KDEqWpD5x/A5nI1y05iNaXjZ6PP0G/SQKYtce1dw7COG6pWLgywkzgN6HH3
 SGhICzeuTH7695GUkQV5LdFQongEUc6cDu3cspZ1zqctZDZkR2nns7NbwHVeoLpDSWGBWrtve
 rQrcd7/dKNHCKKjPlrXmkdkh479s9rvV1cT1svYyY69hLce99cS8xwN46J9F9jgNXX7jvM9PD
 xTLuNlUBbTl0Eq3ohv0h97vieyp7W7eXvvKxORVkrPBDYeEvSvTA+sicqljDH9Rm1FtPC7kq5
 tyHwspMafqAoT2OMt/ndIGU6GBziZY2ng/tjv5MxMF461kfVSvuKiRD4ukxVZIpJpAOAg+V0f
 UlrVGZLJZNbAzQlcn5C2CP9r4QCxCgMvosCmSFQgAUikQqP7oaQwSoJt9D6tLcf5vjUk5muWC
 XAO6F2tSjvA==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/12/17 下午4:36, Nikolay Borisov wrote:
> Core btree functions in btrfs generally return 0 for error

Isn't 0 for key found? It's <0 for error.

 and 1 in case
> the sought item cannot be found. Consolidate the checks for those
> conditions in one 'if () {} else if () {}' struct rather than 2 separate
> 'if () {}' statements. This emphasizes that the handling code pertains
> to a single function. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
The code itself is OK, but the commit message is really confusing.

Thanks,
Qu

> ---
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
