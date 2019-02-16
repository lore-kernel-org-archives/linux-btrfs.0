Return-Path: <SRS0=6oD6=QX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4836C43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 06:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B73B2222D9
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 06:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbfBPGtx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Feb 2019 01:49:53 -0500
Received: from mout.gmx.net ([212.227.15.19]:49309 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727363AbfBPGtx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Feb 2019 01:49:53 -0500
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0Lug4m-1h3axK01aa-00zrzc; Sat, 16
 Feb 2019 07:49:43 +0100
Subject: Re: [PATCH v5 00/12] btrfs: Enhancement to tree block validation
To:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190215105044.17619-1-wqu@suse.com>
 <2ebcb996-dd7a-2662-811a-5526fccb03b7@suse.com>
 <18beb5f9-48f5-e519-6abf-08bd1509cde5@gmx.com>
 <20190215171958.GG9874@twin.jikos.cz>
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
Message-ID: <15af63b6-1063-0bd9-a115-46380766372e@gmx.com>
Date:   Sat, 16 Feb 2019 14:49:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190215171958.GG9874@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:0DZL4H9/fnYihu0lu/lcLze92nWEYv79qxKTzM6eB+5RpFw2xwj
 XxalU1TdoOM259RJ4yp/2x5dqJrg/ZGLw9cvVxwcgJzq4R7JcnpC+jta1UpsL66qklbbGS7
 0DYfdIyFJ1eJ2sv3DQJnW4NwD1pwZlGa9aQg6AhjnXABdCWrayThYY282/YqEWgoA4P8LJp
 6ciTCJE5YRGNDFuqAM2zA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:l7/eG1qUrpA=:klof3YxY61+stmyh3ETp80
 gw+lpy20hUcv81lNa8bTXDJuR6HnEahQ8N8pb7gwX1wwx153SNnGkeqiiVG6cr1KEVuUiLkTb
 bm4T44sMed8kx6Wnh7QN2O49dxkjKgQJBIhJM9LYfe2GeadPutIWF1f4LW2XmsKX0vll6XRY8
 66p3s8wD6vbSG8b2h8Ttn77O0vjyuWN1b6Y89O6Kw2ZCtYXW2Ol9InGVJgjfB98gG0hR4pxGM
 Nf8fbk/8hdNyDmIxPpcex2pBDtgOaxQ6wiMbdAneT3Qti279aVeVrBxwWKz/EWDK1cjERvko/
 NUc/TVWmooIgXrpjnKOsb5cB41J5x/q3cdL42Fyggxi4bPl3rKDtRzWyPh+rg7AeEcsDqUwOC
 AC50YpzsEi8WUfrdZyzjj8zi/hbdlRvAQiucUV7xxy1rsm4ovigmC6AkZ+Y3T6X1t9QtLIr6O
 IYBlM4JHWGKF20JRyyIz0T16Z1+7qDFTZEz4NY0iflzoYypkD/LlPUn85oLDVHfkpL119RYyE
 snAEgdqcqWuGaHJNAOMJWDkOAsoMQ7SFSsuKXtBwykgS9zXrie2MlJEZss/jXz2StMmsLxAnT
 HUYr7q1BPyn65J59y/AQRbqTkNE7LsrVXM7qjyjUlU8KViPIBwyOMaphTI7tm7wmBBnjIK777
 8CaXNSAwVRV59FCS/7OZP09fdJb+Hnm2VpwCaLz4eghTS5ixoSW7lQVMmmpRebGO9jBzhY1s/
 3hJFh5lhSegIm5Qrqt5xJFf/z97cZRDcqJKDXPa5J/fxe0FJAcfjQEsUKrwKOQpwgaU7GQ7Zs
 F+Ae7U2EukCAlL5LzGNdtqzWcgKyvSNZZxve2PqF3bJGk4r08cmbk3h9DLwRYI06QBsBm5Fgk
 o8KVeINfVFCMdpDOALaGmkunMHukDiKnhVqLpNv9VM8AjGRltpdncWOvaEYwcpSANSvJ+8Akv
 1wLO06pvAmw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/2/16 上午1:19, David Sterba wrote:
> On Fri, Feb 15, 2019 at 09:18:03PM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/2/15 下午9:10, Nikolay Borisov wrote:
>>>
>>>
>>> On 15.02.19 г. 12:50 ч., Qu Wenruo wrote:
>>>> Patchset can be fetched from github:
>>>> https://github.com/adam900710/linux/tree/write_time_tree_checker
>>>> Which is based on v5.0-rc1 tag.
>>>> Also there is no conflict rebasing the patchset to misc-next.
>>>>
>>>> This patchset has the following 3 features:
>>>> - Tree block validation output enhancement
>>>>   * Output validation failure timing (write time or read time)
>>>>   * Always output tree block level/key mismatch error message
>>>>     This part is already submitted and reviewed.
>>>>
>>>> - Write time tree block validation check
>>>>   To catch memory corruption either from hardware or kernel.
>>>>   Example output would be:
>>>>
>>>>     BTRFS critical (device dm-3): corrupt leaf: root=2 block=1350630375424 slot=68, bad key order, prev (10510212874240 169 0) current (1714119868416 169 0)
>>>>     BTRFS error (device dm-3): write time tree block corruption detected
>>> This is not good.  Those two error messages should be collapsed into
>>> one. Otherwise it's hard to actually match them up.
>>
>> That shouldn't be a problem, since the error won't happen so frequently
>> there is no other error message that could interrupt these 2 lines.
>>
>>> Better output will
>>> be "Corrupt leaf detected during writing: root=..." and eliminate "write
>>> time tree block corruption detected" line. Is that feasible?
>>
>> Feasible, currently tree checker only get called in 3 locations:
>> 1) read time full checker
>> 2) mark dirty time basic checker
>> 3) write time full checker
>>
>> And they all have different internal bool to indicate the timing, so
>> it's possible to output the timing.
>>
>> But that needs to pass the internal bool down a long long way, for all
>> the output help to accept an extra string.
>> I'm not a big fan for that, and prefer a timing neutral tree checker.
> 
> I'd rather not merge the error messages, as we'll possibly add more
> sanity checks to various functions so there could be a list of problems
> and there's one final note about when it happened (read time/write
> time).
> 
> Matching the lines together is desirable though, so if the block number
> could be part of all messages, I hope this makes it usable for analysis.

This looks much better.
I'll change the timing line to show extra info to match them.

Thanks,
Qu
> 
> Reading btree_readpage_end_io_hook, the message should be under the err:
> label, as there are 3 other possible messages printed (bad block start,
> fsid and level).
> 
