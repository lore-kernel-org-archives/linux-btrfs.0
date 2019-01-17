Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA509C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 13:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91DBB20657
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 13:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfAQNZa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:25:30 -0500
Received: from mout.gmx.net ([212.227.15.18]:54649 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfAQNZa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 08:25:30 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MCLQ1-1gtETO0YEr-009BuQ; Thu, 17
 Jan 2019 14:25:20 +0100
Subject: Re: [PATCH v2 1/5] btrfs: Always output error message when key/level
 verification fails
To:     Johannes Thumshirn <jthumshirn@suse.de>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
References: <20190117101528.8675-1-wqu@suse.com>
 <20190117101528.8675-2-wqu@suse.com>
 <80247a76-7a61-da01-7453-234e9d897f0b@suse.de>
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
Message-ID: <da4f4d74-f497-3605-d111-ce6673e70b54@gmx.com>
Date:   Thu, 17 Jan 2019 21:25:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <80247a76-7a61-da01-7453-234e9d897f0b@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:mG4h/AAPw6ymFqC2x/LEFIajcrc3TJRtMtTpc1ZhMBYv3dKal0O
 SpFjDZIKZmCrAwGh1yhvqUPv/Enxd/boZj0CsCcRUKstNE7m4wmdtTFODlDB7PxKBhjC2DR
 6wt7yzKxFQlv5gY87MiXDtmqKvN5+LmKt9Yb5WvUuiuH2hBRhbPztau8zMe9cqAF73B1uEX
 cArqLBleAekOe2OzTWSJg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8xcJIBvKWyc=:Py2lT4DwtwZNffxLgc/53m
 v0HbjsfDDSQwafhttZVeGBiNAl/zSZkmrdidBpcvnhQyKMcI8hfTAHwMpeJ2zawLO/+NtKUZi
 oUsGbcUPjzu9vCnQOxx0ujdKf78h4sR9mftbKNkUOGBWDevxEljo90dWty8kxzynuhLhoodRn
 iE6ZD3cG3L1mKJYg8eGIuQ/tqBmWmf2RU6Sc8bMygEFB/HMrEi/IBujTiKHU+nPPVAAYfEdtu
 qxec98UEoKh9At/0CQVTvk3XisSE/D+zEdFvUJSHvPf5Cnw27I4995m2BymCDq5tRiEy55Bwb
 23nLmR2YLgtZ9Cc/IZ6Ou3esCKtsdqWwcuPo9yR9lWRTrbN4qPR0w+rZ496+qvmcaKW3DsZtJ
 LXYk7xYylytwJWwoqYvpwPfEkz8bp2rczJ+Ce3XBHVBo/zOnqN8fiUQ4C5l7ZNKQOfJ37ESrT
 XJoaiTc6TzxDLRJUkqzeBqfoTahTxamKD/bcm+63bfYQmxiL+0qgH4EOPwjthjSxVVd0ytLvi
 ItUVQPnVlQNa/UgJD7uy2PgnwpgFvC5HFKUYJzApuX+/cuHBHfJqyMwJ8pYnFNW/AQFF+iKGj
 Gaqbx401iys6aWtCusT3f/0z7qibN+8jtT5Vl+L6byatK48mmrOWI6G2VsbAHZR4WzNrulDJE
 Ahoxs+Duh/Sbs8rASVMdG2Ts1BkYo0g7IJoaLFa7YQXxhfd9Oznppl8/cr1DP5nnBlbO7FoBH
 fsuPvToYFcSq52i09XxjY1rT8aEUV5LLEh17lzLwuwZrHUh2XSTfzoDVIBi93wpbwLD49LlT0
 CQdNvXiI1+1po8o9aoOeibKrdxiKX5qdSzEmWvlveapOVFoMCUItlFxWx/860qTF1I4E3iQNj
 XbYubwnCBM+4WS5HoRY9StC3NJ8jyPGWND8RXoWS2gqdYKLavn8BosPkLByQ1YEM7YvqA34HG
 ZTt58KCMsKQ==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/1/17 下午9:14, Johannes Thumshirn wrote:
> On 17/01/2019 11:15, Qu Wenruo wrote:
>> @@ -449,9 +449,10 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
>>  		btrfs_item_key_to_cpu(eb, &found_key, 0);
>>  	ret = btrfs_comp_cpu_keys(first_key, &found_key);
>>  
>> -#ifdef CONFIG_BTRFS_DEBUG
>>  	if (ret) {
>> +#ifdef CONFIG_BTRFS_DEBUG
>>  		WARN_ON(1);
>> +#endif
>>  		btrfs_err(fs_info,
>>  "tree first key mismatch detected, bytenr=%llu parent_transid=%llu key expected=(%llu,%u,%llu) has=(%llu,%u,%llu)",
>>  			  eb->start, parent_transid, first_key->objectid,
>> @@ -459,7 +460,6 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
>>  			  found_key.objectid, found_key.type,
>>  			  found_key.offset);
>>  	}
>> -#endif
>>  	return ret;
>>  }
> 
> 
> Hmm I think the resulting code looks a bit odd now, doesn't it?
> if (ret) {
> #ifdef CONFIG_BTRFS_DEBUG
> 		WARN_ON(1);
> #endif
> 
> 	btrfs_err(fs_info,
> 
> 
> Why not something like:
> if (ret) {
> 	if (IS_ENABLED(CONFIG_BTRFS_DEBUG))
> 		WARN_ON(1);

Didn't know that macro, and indeed it looks much better.

> 	
> 	btrfs_err(fs_info,
> 
> Or even hide the if (IS_ENABLED(CONFIG_BTRFS_DEBUG)) WARN_ON(1); in a macro
> #define BTRFS_DEBUG_WARN_ON(x) do { 		\
> 	if (IS_ENABLED(CONFIG_BTRFS_DEBUG)) 	\
> 		WARN_ON((x));			\
> } while(0)

Although I'd say such WARN_ON() for DEBUG build will finally get moved
to any build.

Thanks,
Qu
> 
