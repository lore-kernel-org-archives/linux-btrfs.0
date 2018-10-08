Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93ADC00449
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 10:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A43AF2064E
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 10:13:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A43AF2064E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbeJHRYi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 13:24:38 -0400
Received: from mout.gmx.net ([212.227.17.22]:45071 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbeJHRYh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 13:24:37 -0400
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MX19U-1gF0Rg1z6K-00VxGq; Mon, 08
 Oct 2018 12:13:29 +0200
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MX19U-1gF0Rg1z6K-00VxGq; Mon, 08
 Oct 2018 12:13:29 +0200
Subject: Re: [PATCH 1/5] btrfs-progs: lowmem check: Add check for overlapping
 dev extents
To:     Su Yue <suy.fnst@cn.fujitsu.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181008070025.27035-1-wqu@suse.com>
 <20181008070025.27035-2-wqu@suse.com>
 <6c0fe25b-39aa-6422-14bd-cc5e83832afc@cn.fujitsu.com>
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
Message-ID: <c2c4f609-079d-022c-b699-4764a1f949b2@gmx.com>
Date:   Mon, 8 Oct 2018 18:13:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <6c0fe25b-39aa-6422-14bd-cc5e83832afc@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:cjqPYVVEoXAI/RapQiqz+v6zFTdXzN64gAd6nMRK7GcEIsrflGO
 c/2fd41UnMSEx/1nU3VBPc3ubIwh4F9R/yVqEnJZ9QlXKKEycocqGxdjn7vqY13Qmaxl8D5
 B510N4c7ky5jwzetD2AB9mLatypb2c5jVOoRaYOb+0nI4MyQOoN3HdyD4plf//VjivhcuU9
 6TfrGZJ1rkW4nDaVuS8Hg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:eds0fjkVNus=:TTK6Pz6j7Fb61VdpILW9py
 1nViK/vAouoD6a9Uux4Rmjk4nx7A4t37sxwqF1g+1AYKOW2IddJFwWWw6VeBSmSAH/DLh+r8A
 aWAVcmyUNr2ljd1L/g7uJglR+ew9rR95x0BG0nzBVzhs48SbJP3Fr9KVq2sc3epOWlPwSIlGq
 LRyH5BTzCQF27Vt9PMJ5jj/UQExgFgEMSEac9KOSNW2n2r7TwTb/dyyCL+nuQ9qknjZm4LZLZ
 LQbEUX3XZ3HZO4Xe774ifMR8poPskA38smOImOiHq3rF9z3xi0YoAlx7f200ZMBGGiEOvvM2p
 wdRqzxj87zwR/cv1nLGRlfQR7qg8oW4E6UvCD7BANLyDH8PJW7qyQYUYRcZqsnNVtJ/SPErxw
 aeeaCPIKnyHxjEfp/9HFgutEeUPF6c6bCZ0QYYxeHOOXl6N77i/GX/1OTf3xjvC3npXVW1B1F
 C8k6PngT2RomnrgZ+NznpvCc0wwpu5tqNJPdTltl7sq0BPaml+TrbVFWsVp58JMbz2rPTt86W
 cKLDUY96TpxeHWol2lkrdSGt5YAcH6xCzPwALH2bhW8V5SmxVvS30Oq+QKsNzOB6Q+/HUkb3j
 2QcnP3TVTbpe+H+tMoNU1+grDBE3vdVUwNpebt+KfyLSnCONexdWZqakktu77/O33ONwJcamg
 /pA+gOmARZTLZMoJ/l6EPWLl5RXpoV/Lo6EMGvs4smcJgIUc56i6J6vedOoJkiihpUc6JDAbs
 QLDHNDiv6C8YiM8sx6c1XyLUyjoXMW45ZfGhBBasJIbZcbcnUHMGssk3M51SwfGITv/lycq9j
 HR4K3Z94Dluy7i+Sef7d7yYEogym9KnC0eWa+rtyDmgufONtyw=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/10/8 下午5:28, Su Yue wrote:
> 
> 
> On 10/8/18 3:00 PM, Qu Wenruo wrote:
>> Add such check at check_dev_item(), since at that timing we're also
>> iterating dev extents for dev item accounting.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   check/mode-lowmem.c | 32 ++++++++++++++++++++++++++++++--
>>   1 file changed, 30 insertions(+), 2 deletions(-)
>>
>> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
>> index 1bce44f5658a..d387423639e6 100644
>> --- a/check/mode-lowmem.c
>> +++ b/check/mode-lowmem.c
>> @@ -4065,6 +4065,8 @@ static int check_dev_item(struct btrfs_fs_info
>> *fs_info,
>>       u64 dev_id;
>>       u64 used;
>>       u64 total = 0;
>> +    u64 prev_devid = 0;
>> +    u64 prev_dev_ext_end = 0;
> 
> Those two new variables aren't assigned anymore in the patch...

Oh, what I'm doing... (palm face

I'll fix this with the test case bug.

Thanks for reviewing,
Qu

> 
> Thanks,
> Su
>>       int ret;
>>         dev_item = btrfs_item_ptr(eb, slot, struct btrfs_dev_item);
>> @@ -4086,8 +4088,16 @@ static int check_dev_item(struct btrfs_fs_info
>> *fs_info,
>>           return REFERENCER_MISSING;
>>       }
>>   -    /* Iterate dev_extents to calculate the used space of a device */
>> +    /*
>> +     * Iterate dev_extents to calculate the used space of a device
>> +     *
>> +     * Also make sure no dev extents overlap and end beyond device
>> boundary
>> +     */
>>       while (1) {
>> +        u64 devid;
>> +        u64 physical_offset;
>> +        u64 physical_len;
>> +
>>           if (path.slots[0] >= btrfs_header_nritems(path.nodes[0]))
>>               goto next;
>>   @@ -4099,7 +4109,25 @@ static int check_dev_item(struct
>> btrfs_fs_info *fs_info,
>>             ptr = btrfs_item_ptr(path.nodes[0], path.slots[0],
>>                        struct btrfs_dev_extent);
>> -        total += btrfs_dev_extent_length(path.nodes[0], ptr);
>> +        devid = key.objectid;
>> +        physical_offset = key.offset;
>> +        physical_len = btrfs_dev_extent_length(path.nodes[0], ptr);
>> +
>> +        if (prev_devid == devid && physical_offset < prev_dev_ext_end) {
>> +            error(
>> +"dev extent devid %llu offset %llu len %llu overlap with previous dev
>> extent end %llu",
>> +                  devid, physical_offset, physical_len,
>> +                  prev_dev_ext_end);
>> +            return ACCOUNTING_MISMATCH;
>> +        }
>> +        if (physical_offset + physical_len > total_bytes) {
>> +            error(
>> +"dev extent devid %llu offset %llu len %llu is beyond device boundary
>> %llu",
>> +                  devid, physical_offset, physical_len,
>> +                  total_bytes);
>> +            return ACCOUNTING_MISMATCH;
>> +        }
>> +        total += physical_len;
>>   next:
>>           ret = btrfs_next_item(dev_root, &path);
>>           if (ret)
>>
> 
> 
