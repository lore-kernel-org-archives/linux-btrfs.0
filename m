Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5840C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 08:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C1F0208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 08:51:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C1F0208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbeK0TsP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 14:48:15 -0500
Received: from mout.gmx.net ([212.227.17.21]:46537 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729598AbeK0TsP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 14:48:15 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M1SLt-1fYVWW257J-00tSWM; Tue, 27
 Nov 2018 09:51:02 +0100
Subject: Re: [PATCH v2 1/5] btrfs-progs: image: Refactor fixup_devices() to
 fixup_chunks_and_devices()
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181127083828.23861-1-wqu@suse.com>
 <20181127083828.23861-2-wqu@suse.com>
 <e40b8c45-2c16-35c0-c583-ca33c1500b97@suse.com>
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
Message-ID: <c9f75bee-67f8-79a8-d66c-cffc9c828264@gmx.com>
Date:   Tue, 27 Nov 2018 16:50:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <e40b8c45-2c16-35c0-c583-ca33c1500b97@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:I+9jJREDhGAnhay4tW7itHzt8+DUgaRXYmgVGVQHuXypFyGSXnB
 9Vso7XGtADWJxxQpYIvuJkgsAdGtqbdQU2QWvwEmhB97aFie5FDia4HtoAMwv/B8qfxK1eD
 szEVp0ROxVdfGnFJkgJbwymrFDddxexD5K1nQbFkppRYn1WudqN42YfB3UZpdF5Z9lQDt2K
 NIZQfYyo2RJ4ryPpOo39w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:1HAkURYygkU=:b4Q+CwoDoERv62Z0H2WTer
 Er0DAARzelwuMG9OklU5enou1Zd93la90xiU1J6visfUdJh1nNZ5d+s4s6UCWUrX7cwDFbhgn
 ZIfwQOtCXQsmMHqerofGuaW3DRJKnGqpK9s3544rjq62G2sJqVN+KLSCU5n554Y3c1ffR9gLB
 9SeqVlbB/4WJbdPKqDggHxtbTJ3586iFHB0jhR877caQ+hMpW4AKvBt7GG4X9eMCw9YgUnYCL
 HA5zxf8jUBmU4nindNMOz5asOOOBHoBzhEH0MSHeVMFFd/zofFgiAO/6+ojPr+kVozudRDKSh
 uit3pdSUTA18cSthQZC3lDS0Y2bWuhu5VyfKAwfeWXhzGkvE0CW682tU+eOzkdpV0W497o9fL
 w6Jua32gO+RaqWbj0Ic8mIIhyW1m36ZzS9wiYB+BoIuZze9djiMDN/bQP2jQEUUHMSmYakSzx
 m33TC3XaXvDXu8S3eNX2p5+n7CMC3X/juoh3dgd/xB442Acy7c0/D8qjgPuEDbWDVb7kjed+c
 OWs47RC2CNbKPGnz9+Eduakr+HcewyMrRcJJt9hQU3a8XRO/NbV6tbgvoslqOpDOA+lx4rZ/R
 4QrmL6VRJ3Wmjh/dnVf5bF0CA0n/z4zLYzUNaKqvBxTo2R/zhrzal6cw/D4vuP7incL4bY9DV
 FwYo57hp8hgpQ6rSGgS7Q4WaYPEeuOd9AiXpzBpbBI2Qf8ftL1ppuSvqviVt9ZwrLhI9pyTAW
 sLP603QPjISLCN20tFo9JY2y5sV9vtyjDGrKgUvd7bEb+msk5JSEiHE4B4dtbZVBwD1bw70UC
 KgQlaT4N3EibtjlSy/MNiMF7iU4T7RR7VSTvflzr6AQ7y1pLtpjcTFXShP4SB6wbCBIH20shG
 nOw2xEZAXpreTLxPxU64qEYZnlfPFhZh3f0jrbDERGyztecgftUoJRC48J2N5e
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/27 下午4:46, Nikolay Borisov wrote:
> 
> 
> On 27.11.18 г. 10:38 ч., Qu Wenruo wrote:
>> Current fixup_devices() will only remove DEV_ITEMs and reset DEV_ITEM
>> size.
>> Later we need to do more fixup works, so change the name to
>> fixup_chunks_and_devices() and refactor the original device size fixup
>> to fixup_device_size().
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
> However, one minor nit below.
> 
>> ---
>>  image/main.c | 52 ++++++++++++++++++++++++++++++++++++----------------
>>  1 file changed, 36 insertions(+), 16 deletions(-)
>>
>> diff --git a/image/main.c b/image/main.c
>> index c680ab19de6c..bbfcf8f19298 100644
>> --- a/image/main.c
>> +++ b/image/main.c
>> @@ -2084,28 +2084,19 @@ static void remap_overlapping_chunks(struct mdrestore_struct *mdres)
>>  	}
>>  }
>>  
>> -static int fixup_devices(struct btrfs_fs_info *fs_info,
>> -			 struct mdrestore_struct *mdres, off_t dev_size)
>> +static int fixup_device_size(struct btrfs_trans_handle *trans,
>> +			     struct mdrestore_struct *mdres,
>> +			     off_t dev_size)
>>  {
>> -	struct btrfs_trans_handle *trans;
>> +	struct btrfs_fs_info *fs_info = trans->fs_info;
>>  	struct btrfs_dev_item *dev_item;
>>  	struct btrfs_path path;
>> -	struct extent_buffer *leaf;
>>  	struct btrfs_root *root = fs_info->chunk_root;
>>  	struct btrfs_key key;
>> +	struct extent_buffer *leaf;
> 
> nit: Unnecessary change

Doesn't it look better when all btrfs_ prefix get batched together? :)

Thanks,
Qu

> 
>>  	u64 devid, cur_devid;
>>  	int ret;
>>  
>> -	if (btrfs_super_log_root(fs_info->super_copy)) {
>> -		warning(
>> -		"log tree detected, its generation will not match superblock");
>> -	}
>> -	trans = btrfs_start_transaction(fs_info->tree_root, 1);
>> -	if (IS_ERR(trans)) {
>> -		error("cannot starting transaction %ld", PTR_ERR(trans));
>> -		return PTR_ERR(trans);
>> -	}
>> -
>>  	dev_item = &fs_info->super_copy->dev_item;
>>  
>>  	devid = btrfs_stack_device_id(dev_item);
>> @@ -2123,7 +2114,7 @@ again:
>>  	ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
>>  	if (ret < 0) {
>>  		error("search failed: %d", ret);
>> -		exit(1);
>> +		return ret;
>>  	}
>>  
>>  	while (1) {
>> @@ -2170,12 +2161,41 @@ again:
>>  	}
>>  
>>  	btrfs_release_path(&path);
>> +	return 0;
>> +}
>> +
>> +static int fixup_chunks_and_devices(struct btrfs_fs_info *fs_info,
>> +			 struct mdrestore_struct *mdres, off_t dev_size)
>> +{
>> +	struct btrfs_trans_handle *trans;
>> +	int ret;
>> +
>> +	if (btrfs_super_log_root(fs_info->super_copy)) {
>> +		warning(
>> +		"log tree detected, its generation will not match superblock");
>> +	}
>> +	trans = btrfs_start_transaction(fs_info->tree_root, 1);
>> +	if (IS_ERR(trans)) {
>> +		error("cannot starting transaction %ld", PTR_ERR(trans));
>> +		return PTR_ERR(trans);
>> +	}
>> +
>> +	ret = fixup_device_size(trans, mdres, dev_size);
>> +	if (ret < 0)
>> +		goto error;
>> +
>>  	ret = btrfs_commit_transaction(trans, fs_info->tree_root);
>>  	if (ret) {
>>  		error("unable to commit transaction: %d", ret);
>>  		return ret;
>>  	}
>>  	return 0;
>> +error:
>> +	error(
>> +"failed to fix chunks and devices mapping, the fs may not be mountable: %s",
>> +		strerror(-ret));
>> +	btrfs_abort_transaction(trans, ret);
>> +	return ret;
>>  }
>>  
>>  static int restore_metadump(const char *input, FILE *out, int old_restore,
>> @@ -2282,7 +2302,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
>>  			return 1;
>>  		}
>>  
>> -		ret = fixup_devices(info, &mdrestore, st.st_size);
>> +		ret = fixup_chunks_and_devices(info, &mdrestore, st.st_size);
>>  		close_ctree(info->chunk_root);
>>  		if (ret)
>>  			goto out;
>>
