Return-Path: <SRS0=ilb6=O5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FROM,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332DDC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Dec 2018 05:48:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00B6020815
	for <linux-btrfs@archiver.kernel.org>; Thu, 20 Dec 2018 05:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbeLTFsK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 20 Dec 2018 00:48:10 -0500
Received: from mout.gmx.net ([212.227.15.19]:43205 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726716AbeLTFsJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Dec 2018 00:48:09 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MAhWl-1gfacf0jtb-00BvmE; Thu, 20
 Dec 2018 06:47:59 +0100
Subject: Re: BTRFS Mount Delay Time Graph
To:     Nikolay Borisov <nborisov@suse.com>,
        "Wilson, Ellis" <ellisw@panasas.com>,
        BTRFS <linux-btrfs@vger.kernel.org>
References: <25a99c85-b048-a678-b61b-97dfc1338cb3@panasas.com>
 <b4183c50-a2a3-7470-3038-1e759a99369c@suse.com>
 <a511850e-c08b-d6c5-0471-e523eff73680@panasas.com>
 <558d3344-95de-da81-c385-a6623144d6ae@suse.com>
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
Message-ID: <b10017eb-e696-7002-5fd3-91d3630523de@gmx.com>
Date:   Thu, 20 Dec 2018 13:47:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <558d3344-95de-da81-c385-a6623144d6ae@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:TxDbJMbNqrCrkEH2ddHRpODjYIeExNLy9ITEDBzcQ3nwYogZ1Fp
 1PeDJ1bqrbo5wjyBVCTrUYsVmI3kwr+UFeMAO1b0xR1ph9UfAkoZ8U83kviicrRcHHf/qQ3
 6lWdwe0Y2GyZ0aY6dm6qe6GAXJNs87Yvyk3gy2HhldrXM+Cc09g5lE+zo6bSuH84UQc3zRW
 zCGCwwIrvJlmcH8SR35+g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2437VwEz0Kc=:+8cAp/CfCSZdcZW8WhKXg6
 n2KhBdQsW82ca1PbUtACPa3uZHa5TH16mBmSBb/yagb8MTFbjjaZHxqQn92BQLZAQoteGjQrh
 36Wval+EgH8v74iG2PqLgqJdI2p8wmJUlAEA/2mD00ZyqD3yjFcPqZddCFqrQBX44GxBkRF9Y
 Z4ibxCpMpYjFDI+uK/0T/WRLo2RuAzjGS81FdD8Px4fQOcxvycJdBJqrTTTJl824y7D5AA0D1
 XeObb3YZK5HDY1WgVhJStV+ARwRbeGj5NpuLxq7RiOT9J+F9k7VUlOMYVNVJwaclBe79daGry
 5KqKhNLaPu770MjHp9BzEkFJI99loSo7KVUfnwTjKjfhYV8M2SEAO6kdp4AwPb0x6msbDIQuN
 95e8uXWTnBq7yxL9+tAFY3DbNjsornKqzjnufse5YBDEKeZ1/ptrYXbtZiId4UpTWz1rZWuGW
 1+ZNS695c11q2WLkPOWKpRNdCMDvNOE8W60/QHY/02MNBg05q5ZVVnpyc2pNLPmDYqcAvNTMV
 aOqYreHRl4osL93jpdZxvQXiBFXoKBo4cNsdae5m2E5P3jSNmxxwcXtC6dBYqhe4Trqn8452U
 omON7TCEBuQIp9XtEP+9F9KnXqjv/amd50fWB7YJufurSbR8abJHme0eKbaBdo3QzmrGW2SGa
 P0R/pK/o6EoqDulji65G0sGLTLoeWs3KK4tsvKcuV9ZAmIQYeyc2+pGO4NSMLbzis9Of3QoTB
 eAMvd7gFoAtBYmNmFrDhegvKLps6eWrXKwReju+cxifKouFGxrMPfxFB0uipzXOdCBh5SipBt
 ToQKxTjupr5aAWhtRTCp/lgdzIDjf23TaUD1Xha1pdFCLZCh1vcmthrywSKFD8j3DYZgBOCe8
 xxQJBkZxFuN5kbMgaLe4E+2JUKw3JaBZwESo3ct2r/Jc/30R7NJWQugCghEggQhHw7kLaHJPC
 AuW65/W6z6Q==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/12/5 下午2:55, Nikolay Borisov wrote:
> 
> 
> On 4.12.18 г. 22:14 ч., Wilson, Ellis wrote:
>> On 12/4/18 8:07 AM, Nikolay Borisov wrote:
>>> On 3.12.18 г. 20:20 ч., Wilson, Ellis wrote:
>>>> With 14TB drives available today, it doesn't take more than a handful of
>>>> drives to result in a filesystem that takes around a minute to mount.
>>>> As a result of this, I suspect this will become an increasingly problem
>>>> for serious users of BTRFS as time goes on.  I'm not complaining as I'm
>>>> not a contributor so I have no room to do so -- just shedding some light
>>>> on a problem that may deserve attention as filesystem sizes continue to
>>>> grow.
>>> Would it be possible to provide perf traces of the longer-running mount
>>> time? Everyone seems to be fixated on reading block groups (which is
>>> likely to be the culprit) but before pointing finger I'd like concrete
>>> evidence pointed at the offender.
>>
>> I am glad to collect such traces -- please advise with commands that 
>> would achieve that.  If you just mean block traces, I can do that, but I 
>> suspect you mean something more BTRFS-specific.
> 
> A command that would be good is :
> 
> perf record --all-kernel -g mount /dev/vdc /media/scratch/


In fact, if we're just going to verify if it's btrfs_read_block_groups()
causing the biggest problem, we could use ftrace directly (wrapped by
"perf ftrace"):

perf ftrace -t function_graph -T open_ctree \
	-T btrfs_read_block_groups \
	mount $dev $mnt

The result will be super easy to read, something like:

 2)               |  open_ctree [btrfs]() {
 2)               |    btrfs_read_block_groups [btrfs]() {
 2) # 1726.598 us |    }
 2) * 21817.28 us |  }


Since I'm just using a small fs, with 4G data copied from /usr, we won't
populate extent tree with enough backrefs, thus
btrfs_read_block_groups() won't be a big problem. (only 7.9%)

However when I populate the fs with small inline files along with small
data extents, and 4K nodesize to bump up extent tree size, the same 4G
data would result a different story:

 3)               |  open_ctree [btrfs]() {
 3)               |    btrfs_read_block_groups [btrfs]() {
 3) # 4567.645 us |    }
 3) * 22520.95 us |  }

Now it's 20.3% of the total mount time.
I believe the percentage will just increase and go over 70% when the fs
is larger and larger.


So, Wilson, would you please use above "perf ftrace" command to get the
function duration?

Thanks,
Qu

> 
> of course replace device/mount path appropriately. This will result in a
> perf.data file which contains stacktraces of the hottest paths executed
> during invocation of mount. If you could send this file to the mailing
> list or upload it somwhere for interested people (me and perhaps) Qu to
> inspect would be appreciated.
> 
> If the file turned out way too big you can use
> 
> perf report --stdio  to create a text output and you could send that as
> well.
> 
>>
>> Best,
>>
>> ellis
>>
