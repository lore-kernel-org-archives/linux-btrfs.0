Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCDAC04EBF
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 13:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7274B2081C
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 13:31:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7274B2081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbeLDNbV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 08:31:21 -0500
Received: from mout.gmx.net ([212.227.17.20]:41691 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbeLDNbV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 08:31:21 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MRCCJ-1gvVun3nyx-00UYQ7; Tue, 04
 Dec 2018 14:31:08 +0100
Subject: Re: BTRFS Mount Delay Time Graph
To:     Nikolay Borisov <nborisov@suse.com>,
        "Wilson, Ellis" <ellisw@panasas.com>,
        BTRFS <linux-btrfs@vger.kernel.org>
References: <25a99c85-b048-a678-b61b-97dfc1338cb3@panasas.com>
 <b4183c50-a2a3-7470-3038-1e759a99369c@suse.com>
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
Message-ID: <1b3796ac-066b-ddea-6f8a-ca45817cb6ec@gmx.com>
Date:   Tue, 4 Dec 2018 21:31:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <b4183c50-a2a3-7470-3038-1e759a99369c@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:riBDE1e0SERsk1uNpk4yqF/UJVdaxwIZsvEfR00pbeRcJgC5ze0
 znKfrLdS5sbS7FkwaVpD+i0Ri1RIorURnAYg8akCKjFNKpZM0B3R0kH3itT0fpwLJ+1xSMf
 Cszm73ZWTK62a8XDK7K3BMm2qsHksFuxxJ0+ysSRMVNKnlQUE+8FRb0oCVGMBkITcPOypTC
 OGeIYjDK8hKTlMQt2oIIw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:i3z/bwAJwzQ=:REdnnvuo5JAG7OAUwbPR4f
 PT0clj3T2IOVO+SWYZ5mCsh8okAUxBk3JZc33/Ml4m8cHrkWgjaKFk2WIY5kbkjFKdoZO9i2x
 /UTpWStdy4oRuTN3b0+5jvMNjEpelChuBLiMHVIAlkwZ6gwVgWIXh5OJl+Mra+z2PuckjNwyj
 f8vPHYMxa74YnHXpx5Pro5DuwWPaaYD0Vas+mhdOdS2glqt3ZkOEYn+dvh2vsbD3OIesZokfo
 4MpbM759Yhmr+2OQsc+NerG+WqynVtgW+O1yOjfwIvdkQbVRGHc0koz9GKaqo2x9vU7bJPahl
 hMElqz7ExoBg3n9gUjVW6JR4YgjuQwS46h7weYHV7S3HPtFoDXqoY5JwC9B4IJypix+DY12p9
 aq40tU/lbfu7IY/Gv46QbmeL7QZOXyWPzwerFvKvnw+95lmj4rW5DHXFrm+aZJa737ivs13Hi
 recPQs607zxFe/GSFE8+JA4bsaR/ineCpQX2OhVB7UdqiG2VdTzUu1nT0jmNb+RW9J4PXiB6e
 EYpXb2RQHGBvpNszmyg2KlrQJ6DcMj3+bqkaXalhdJv9xT80rs1HSbGO9G3GH/9OPNIsPqwOl
 OwpHkjHoHhSzsP2NCBQTb16AIiYTgWCNhBjPQFZCvaBcSOZSToNWHxlHSNpAwepXjxRP4PFCQ
 mhx8HFWoThOrN1Bd+DXOMguAk9c4zVHtauO75oIANFuw2dR5Sd5ucZ7TZ7uidK76Ir0M6R+Hk
 xdnUNu9Emd6qUwyWsAa/ts/IEXTeDI4Ys/zZQ8IXNEox0nMbzW9Ro4h0ogiNO0LChL3WPcN3x
 XWFo+Jwtb2C7hrDkGFwCQRwZkowivXdRcLHym4/pkJdr68XAW0sPCbKMCzrihcZPDTlZ0Ho4Z
 R+PDfHECfNGctJkTwXogNN7e8jaARPSH1ICM6QOQGpuFFk5SXWGNsIFZ0zq7vyKduv5kovw3L
 dy/v2iI1iXg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/12/4 下午9:07, Nikolay Borisov wrote:
> 
> 
> On 3.12.18 г. 20:20 ч., Wilson, Ellis wrote:
>> Hi all,
>>
>> Many months ago I promised to graph how long it took to mount a BTRFS 
>> filesystem as it grows.  I finally had (made) time for this, and the 
>> attached is the result of my testing.  The image is a fairly 
>> self-explanatory graph, and the raw data is also attached in 
>> comma-delimited format for the more curious.  The columns are: 
>> Filesystem Size (GB), Mount Time 1 (s), Mount Time 2 (s), Mount Time 3 (s).
>>
>> Experimental setup:
>> - System:
>> Linux pgh-sa-1-2 4.20.0-rc4-1.g1ac69b7-default #1 SMP PREEMPT Mon Nov 26 
>> 06:22:42 UTC 2018 (1ac69b7) x86_64 x86_64 x86_64 GNU/Linux
>> - 6-drive RAID0 (mdraid, 8MB chunks) array of 12TB enterprise drives.
>> - 3 unmount/mount cycles performed in between adding another 250GB of data
>> - 250GB of data added each time in the form of 25x10GB files in their 
>> own directory.  Files generated in parallel each epoch (25 at the same 
>> time, with a 1MB record size).
>> - 240 repetitions of this performed (to collect timings in increments of 
>> 250GB between a 0GB and 60TB filesystem)
>> - Normal "time" command used to measure time to mount.  "Real" time used 
>> of the timings reported from time.
>> - Mount:
>> /dev/md0 on /btrfs type btrfs 
>> (rw,relatime,space_cache=v2,subvolid=5,subvol=/)
>>
>> At 60TB, we take 30s to mount the filesystem, which is actually not as 
>> bad as I originally thought it would be (perhaps as a result of using 
>> RAID0 via mdraid rather than native RAID0 in BTRFS).  However, I am open 
>> to comment if folks more intimately familiar with BTRFS think this is 
>> due to the very large files I've used.  I can redo the test with much 
>> more realistic data if people have legitimate reason to think it will 
>> drastically change the result.
>>
>> With 14TB drives available today, it doesn't take more than a handful of 
>> drives to result in a filesystem that takes around a minute to mount. 
>> As a result of this, I suspect this will become an increasingly problem 
>> for serious users of BTRFS as time goes on.  I'm not complaining as I'm 
>> not a contributor so I have no room to do so -- just shedding some light 
>> on a problem that may deserve attention as filesystem sizes continue to 
>> grow.
> 
> Would it be possible to provide perf traces of the longer-running mount
> time? Everyone seems to be fixated on reading block groups (which is
> likely to be the culprit) but before pointing finger I'd like concrete
> evidence pointed at the offender.

IIRC I submitted such analyse years ago.

Nowadays it may change due to chunk <-> bg <-> dev_extents cross checking.
So yes, it would be a good idea to show such percentage.

Thanks,
Qu

> 
>>
>> Best,
>>
>> ellis
>>
