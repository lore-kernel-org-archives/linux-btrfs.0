Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23852 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753759AbdFWIyF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Jun 2017 04:54:05 -0400
Subject: Re: How to fix errors that check --mode lomem finds, but --mode
 normal doesn't?
To: Marc MERLIN <marc@merlins.org>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20170620152648.GB22987@merlins.org>
 <20170620153601.GE7140@carfax.org.uk> <20170620154429.GC22987@merlins.org>
 <20170620231202.GB5303@merlins.org>
 <CAJCQCtQMWKJwWjeM4zEb-W7-tjsZyfCo37YyT2xYi0fNTEzcUQ@mail.gmail.com>
 <20170621034352.GE5303@merlins.org> <20170621151339.GK5303@merlins.org>
 <13856431-9ee5-c13e-f2a8-860394f9aae4@cn.fujitsu.com>
 <20170622025330.GX5303@merlins.org>
 <e86db7c4-4953-7706-347d-983079177f37@cn.fujitsu.com>
 <20170623040601.akpyyvh3dgry6nn5@merlins.org>
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Message-ID: <90711a7c-92ff-e043-6d81-6bdadbfdbc3a@cn.fujitsu.com>
Date: Fri, 23 Jun 2017 16:54:01 +0800
MIME-Version: 1.0
In-Reply-To: <20170623040601.akpyyvh3dgry6nn5@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017年06月23日 12:06, Marc MERLIN wrote:
>> Well, there is only the output from extent tree.
>>
>> I was also expecting output from subvolue (11930) tree.
>>
>> It could be done by
>> # btrfs-debug-tree -t 11930 | grep -C 10 3886187384832
>>
I apologize if this was not made clear.

>> But please pay attention that, this dump may contain filenames, feel free to
>> mask the filenames.
>   
> There you go:
> gargamel:~# btrfs-debug-tree /dev/mapper/dsh | grep -C 10 3886187384832

Could you dump file tree (11930) by the following command.
# btrfs-debug-tree -t 11930 /dev/mapper/dsh | grep -C 10 3886187384832

I wonder if this extent was referenced by this file tree four times.

Hoping that this will not cause you too much trouble.


-- 
Thanks,
Lu


