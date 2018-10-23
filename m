Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64EE3C46475
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 10:31:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 255C12075D
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 10:31:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 255C12075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbeJWSx7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 14:53:59 -0400
Received: from mout.gmx.net ([212.227.15.18]:40229 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbeJWSx7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 14:53:59 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M08eS-1fKaww0PtM-00uM6E; Tue, 23
 Oct 2018 12:31:07 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx003
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0M08eS-1fKaww0PtM-00uM6E; Tue, 23
 Oct 2018 12:31:07 +0200
Subject: Re: [PATCH 03/13] btrfs-progs: lowmem: fix false alert if extent item
 has been repaired
To:     Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20181023094147.7906-1-suy.fnst@cn.fujitsu.com>
 <20181023094147.7906-4-suy.fnst@cn.fujitsu.com>
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
Message-ID: <3363e342-9acc-95d4-cf70-2872fc8b6258@gmx.com>
Date:   Tue, 23 Oct 2018 18:30:58 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181023094147.7906-4-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:wpZ9UQJjYycVTIE87XrPUh0TL5BBr+w/8y9AlblH/1+6hZvXlqp
 gstyJTUUIqTSChn8oePQJXPTgzzoXk9PocTpT1DgdPyXpq+mmjkjxpEMaeBmrwqgza3wihw
 ClQdZnQ/DpRSEe7e03AXE/Tw7UBXxg0ua/XBPkSHD6UZgEtNKHdNVIEt3tQuZouRUNBnO5i
 dHuUNjGOlsYO9noQJqSjQ==
X-UI-Out-Filterresults: notjunk:1;V01:K0:YzlfQ5bQdS4=:dvxSNye3IhiMnerSd6shyK
 4IThpaJ/H8tZ6OMhgQ2FCGj9CLN8uimzf9Llg22z1hzNyzH8LvBzQYY1eDemyfY1u3nSUoOKN
 JzepvM9Z589Naof11r6Lrle17mlbki1S0HLHez5FAb04Ae8ZNrDp6Z23C2iV64e5dQCPdN2xq
 Yi2o0RzGQEh8SmqtklqKfcqQQ5dcjsDvb7O7UvEHP8rCGPp9WcEHcUJL7lX0IpXfSMIX49L1C
 ezYRBq9syn7IYyiD71hMq3W+nsSa9cZw/c3uSfuoHIVYLKFJgO6yhFYTRIi3zctp2QVFpw7Z+
 xgxo+9u4ogSXMbCvmVvHRM9oZRSfsBVCIUHzPoCrdl9Ougv2/TqWIcDnl9UBeWPwFyzK2y6ad
 NJ5gQrzCHsl5dQ+CpTzbqJRzOjp/iX9gYy+XWS4uk42X/dIodAP4kE/nQqfVYszKnEt7a7c5e
 UmkG2lXPQ5N3L1d4kRC8cZfjYj40MVSGqFbblaU6y/xlOCxtBHCWAvigVl0x+14YbvnsfHpah
 2JVfSrd923wu50dykRX4yoISTondfRaYdQ3FdlteBgRN0NAK1nwPETuWP4+8aucj/9Qcm77xt
 iXo8zVpNP9W3I7gaHlP3a5ZzwstrIHkzaEYn7nwBBYfum75NQfXJrkTed7iSI91TCWFFzehCI
 bvAcz4sUfbkjISXcgOOaNVpgHn6fL8tsFh0S4O1vf6bEUHNcrgpgd966ho/uoHNvsd/1xsRYC
 3LVxrCk2BFVifqvofkMkZhlVv9ZB+Z8wJBdPqC5QhuH2gOWROYW8c0ALXARgw4mjgH0W5nbr7
 Q2+F4VUMjQaxCbZ8UAYRzz1P8eOi/eJS2gbYE13Ky9RTwaM3xc=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/23 下午5:41, Su Yue wrote:
> Previously, @err are assigned immediately after check but before
> repair.
> repair_extent_item()'s return value also confuses the caller. If
> error has been repaired and returns 0, check_extent_item() will try
> to continue check the nonexistent and cause flase alerts.
> 
> Here make repair_extent_item()'s return codes only represents status
> of the extent item, error bits are passed by pointer.
> Move the change of @err after repair.
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
> ---
>  check/mode-lowmem.c | 106 ++++++++++++++++++++++++++++----------------
>  1 file changed, 68 insertions(+), 38 deletions(-)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 76e7be81ceb1..769b3141de8b 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -3788,35 +3788,35 @@ out:
>  /*
>   * Only delete backref if REFERENCER_MISSING now
>   *
> - * Returns <0   the extent was deleted
> - * Returns >0   the backref was deleted but extent still exists, returned value
> - *               means error after repair
> + * Returns <0   the whole extent item was deleted
> + * Returns >0   the backref was deleted but extent still exists, @err_ret
> + *		will be set to be error bits after repair.

Well, I have to admit the parameter list is really human friendly from
the initial design.

In fact, the only real user of @err is just that "if ((err &
(REFERENCER_MISSING | REFERENCER_MISMATCH)) == 0)" line.

We can in fact get rid of that @err parameter and do that check at the
only caller of repair_extent_item().


And then redefine the return value.

Like "Return < 0 if we failed to repair backref for the extent.
Return 0 if we repaired the backref for the extent".

[snip]
>  
> -	if (err && repair) {
> +	if (tmp_err && repair) {
>  		ret = repair_extent_item(fs_info->extent_root, path,
>  			 key.objectid, num_bytes, parent, root_objectid,
> -			 owner, owner_offset, ret);
> -		if (ret < 0)

If follow my above method, here the code can be a little easier:
	if (tmp_err && repair) {
		if (!(tmp_err & (REFERENCER_MISSING |
		    REFENCER_MISMATCH)) {
			err |= tmp_err;
			goto next;
		}
		ret = repair_extent_item(...);
		if (ret < 0)
			err |= tmp_err;
	} else if (tmp_err) {
		err |= tmp_err;
	}

Without the need to passing @err into repair_extent_item() nor modifying
@err in that function.

Thanks,
Qu

> +			 owner, owner_offset, &tmp_err);
> +		err |= tmp_err;
> +
> +		if (tmp_err & FATAL_ERROR || ret < 0)
>  			goto out;
> -		if (ret) {
> +		/*
> +		 * the error has been repaired which means the extent item
> +		 * is still existed with other backrefs, go to check next.
> +		 */> +		if (ret > 0) {
> +			eb = path->nodes[0];
> +			slot = path->slots[0];
> +			ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
> +			item_size = btrfs_item_size_nr(eb, slot);
>  			goto next;
> -			err = ret;
>  		}
> +	} else {
> +		err |= tmp_err;
>  	}
>  
> -	ptr += btrfs_extent_inline_ref_size(type);
> +	ptr_offset += btrfs_extent_inline_ref_size(type);
>  	goto next;
>  
>  out:
> 
