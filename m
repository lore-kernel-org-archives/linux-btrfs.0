Return-Path: <SRS0=cHbd=PD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,LOTS_OF_MONEY,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 995F1C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Dec 2018 03:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 690F520989
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Dec 2018 03:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbeLZDoA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 25 Dec 2018 22:44:00 -0500
Received: from mout.gmx.net ([212.227.17.22]:45675 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbeLZDoA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Dec 2018 22:44:00 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0LeeNW-1h9MB34AqU-00qQru; Wed, 26
 Dec 2018 04:43:49 +0100
Subject: Btrfs_read_block_groups() delay (Was Re: BTRFS Mount Delay Time
 Graph)
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
To:     Nikolay Borisov <nborisov@suse.com>,
        "Wilson, Ellis" <ellisw@panasas.com>,
        BTRFS <linux-btrfs@vger.kernel.org>
References: <25a99c85-b048-a678-b61b-97dfc1338cb3@panasas.com>
 <b4183c50-a2a3-7470-3038-1e759a99369c@suse.com>
 <a511850e-c08b-d6c5-0471-e523eff73680@panasas.com>
 <558d3344-95de-da81-c385-a6623144d6ae@suse.com>
 <b10017eb-e696-7002-5fd3-91d3630523de@gmx.com>
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
Message-ID: <a7129251-5ce3-cafc-9f82-95eebba415bc@gmx.com>
Date:   Wed, 26 Dec 2018 11:43:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <b10017eb-e696-7002-5fd3-91d3630523de@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:4aPpwDNzv+wlKzIDXvS1qJo+VMCaq58wNhgSSYBaWqt7IP/jHv0
 Y6LIbOBf1bR0h+euzrrqNuxyPEiidUAYNmbwm94WCy2JLx9MPpk1A0t9JTOE/ieYq/8K3Nt
 lG0iVDE8szs/jTrZMxX0wI/Eqf5eAq1uriBtV2Q6JmCt+ZjkhfDW/Iv6Zkg3PnXE+2fEbM7
 86GRZK+oqfj20s/3f+Qcw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:zOHKibTQStM=:Lxk9C8RT3kneBNHbkklx+k
 hvByHGKT1tAPu/brcBdMpzFIQ5QoMHx+AW9S2cXX6RmPr6ctW5yxcZlChXuaNJwHwAkro4V2b
 QZ/UfEQd38c68jOcLMmp4XXKUWta7AggTMwfza4uKDNMEZXeNx8vZgy9po6KU5RoKQOPsQD2M
 JzLwNZdIKeC1stECsTq9keHfBfYK7n5DVv3YK2OTQfHeb9PpW+5AQacUaRvc3aSYnQmb3Rerw
 ovdysqy5YLExQqy6Z1nKSZPaJvTo5q3659CiFh9v55MLstBBHJhGIm93Gzims+BHsAv0glDO2
 Tb7OMGH/1iwewOnevMh1gNQoXbBOUi7HGmO3Ox/XpxclkEvLH3DptfyoatWULG+CXuU1PJvmr
 XReEgJS91h23khQKhuuHkvKFX369DC5ADnDyGeFJikI4vEzGbatL6Wu356Wj2n2Ql+wzt1kC5
 6YzzEomzozeCYFBBLZJPwSX1y3nwCyGWb8100fmDx64NKdks7POUy8Quh8eHqNY5y2ngs46iv
 s/g1+4GJySR7ivcxNOJD32rGcAr7UcDieCp02slNoyzFTMUDJxmED+sUI7YieQIFvuzyEulDI
 9LahhLCJdZJJ/+EP+Ur/ycVIBw6tzCR6zCcfljWCFM31lI2ADqrRhWAamkae/TSvzhQro6KjV
 qRk5qFu0x6l+548nGzHEKbXcKTzu01LX+ie7DP1QVxDXMmKnxhvJ0QiOApXGbpkXPUH8NqQeD
 zp1a5fgQnlGYa+NBq4RNQ3AOWQRCZgUeZ4a5puNqw/dCiNpJH0aOb/CdjvEH/9Rby7MeSlyxR
 DRRV96bthe2Cr4KEiIO+BEqoJTvwetQ1pNI6FS1DU2pI7lex/Mhme56c6B0QeZlRjIobOm/dg
 U0ohLoCVukZrcbweabRsdAs1LsHQy5dCl45lS0axMN4yrxzsNDuhuA8TDec0V0qVavKcpbNLS
 YeLZtXwwPTg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Now with a little larger fs (257G used, backed by HDD), the result is
much more obvious:

$ sudo perf ftrace -t function_graph \
                   -T open_ctree \
                   -T btrfs_read_block_groups \
                   -T check_chunk_block_group_mappings \
                   -T btrfs_read_chunk_tree \
                   -T btrfs_verify_dev_extents \
                   mount /dev/vdc /mnt/btrfs/

 3)               |  open_ctree [btrfs]() {
 3)               |    btrfs_read_chunk_tree [btrfs]() {
 3) * 69033.31 us |    }
 3)               |    btrfs_verify_dev_extents [btrfs]() {
 3) * 90376.15 us |    }
 3)               |    btrfs_read_block_groups [btrfs]() {
 2) $ 2733853 us  |    } /* btrfs_read_block_groups [btrfs] */
 2) $ 3168384 us  |  } /* open_ctree [btrfs] */

For btrfs_read_chunk_tree() and btrfs_verify_dev_extents(), combined
they take less than 160ms.
While for btrfs_read_block_groups() it take 2.7s while the total mount
time is 3.1s, meaning btrfs_read_block_groups() is already taking 87% of
the mount time.


I'll try to make btrfs BLOCK_GROUP_ITEM into one separate tree to make
they iterate just like chunks tree, and see how it will end up.

Thanks,
Qu

On 2018/12/20 下午1:47, Qu Wenruo wrote:
> 
> 
> On 2018/12/5 下午2:55, Nikolay Borisov wrote:
>>
>>
>> On 4.12.18 г. 22:14 ч., Wilson, Ellis wrote:
>>
>> A command that would be good is :
>>
>> perf record --all-kernel -g mount /dev/vdc /media/scratch/
> 
> 
> In fact, if we're just going to verify if it's btrfs_read_block_groups()
> causing the biggest problem, we could use ftrace directly (wrapped by
> "perf ftrace"):
> 
> perf ftrace -t function_graph -T open_ctree \
> 	-T btrfs_read_block_groups \
> 	mount $dev $mnt
> 
> The result will be super easy to read, something like:
> 
>  2)               |  open_ctree [btrfs]() {
>  2)               |    btrfs_read_block_groups [btrfs]() {
>  2) # 1726.598 us |    }
>  2) * 21817.28 us |  }
> 
> 
> Since I'm just using a small fs, with 4G data copied from /usr, we won't
> populate extent tree with enough backrefs, thus
> btrfs_read_block_groups() won't be a big problem. (only 7.9%)
> 
> However when I populate the fs with small inline files along with small
> data extents, and 4K nodesize to bump up extent tree size, the same 4G
> data would result a different story:
> 
>  3)               |  open_ctree [btrfs]() {
>  3)               |    btrfs_read_block_groups [btrfs]() {
>  3) # 4567.645 us |    }
>  3) * 22520.95 us |  }
> 
> Now it's 20.3% of the total mount time.
> I believe the percentage will just increase and go over 70% when the fs
> is larger and larger.
> 
> 
> So, Wilson, would you please use above "perf ftrace" command to get the
> function duration?
> 
> Thanks,
> Qu
> 
>>
>> of course replace device/mount path appropriately. This will result in a
>> perf.data file which contains stacktraces of the hottest paths executed
>> during invocation of mount. If you could send this file to the mailing
>> list or upload it somwhere for interested people (me and perhaps) Qu to
>> inspect would be appreciated.
>>
>> If the file turned out way too big you can use
>>
>> perf report --stdio  to create a text output and you could send that as
>> well.
