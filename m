Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:59018 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751981AbeF2F2s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 01:28:48 -0400
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Marc MERLIN <marc@merlins.org>,
        <linux-btrfs@vger.kernel.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <03b45710-7190-8f2c-de8d-51f433d8b2cf@cn.fujitsu.com>
Date: Fri, 29 Jun 2018 13:35:06 +0800
MIME-Version: 1.0
In-Reply-To: <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/29/2018 01:07 PM, Qu Wenruo wrote:
> 
> 
> On 2018年06月29日 12:27, Marc MERLIN wrote:
>> Regular btrfs check --repair has a nice progress option. It wasn't
>> perfect, but it showed something.
>>
>> But then it also takes all your memory quicker than the linux kernel can
>> defend itself and reliably completely kills my 32GB server quicker than
>> it can OOM anything.
>>
>> lowmem repair seems to be going still, but it's been days and -p seems
>> to do absolutely nothing.
> 
> I'm a afraid you hit a bug in lowmem repair code.
> By all means, --repair shouldn't really be used unless you're pretty
> sure the problem is something btrfs check can handle.
> 
> That's also why --repair is still marked as dangerous.
> Especially when it's combined with experimental lowmem mode.
>
>>
>> My filesystem is "only" 10TB or so, albeit with a lot of files.
> 
> Unless you have tons of snapshots and reflinked (deduped) files, it
> shouldn't take so long.
> 
>>
>> 2 things that come to mind
>> 1) can lowmem have some progress working so that I know if I'm looking
>> at days, weeks, or even months before it will be done?
> 
> It's hard to estimate, especially when every cross check involves a lot
> of disk IO.
> 
> But at least, we could add such indicator to show we're doing something.
> Maybe we can account all roots in root tree first, before checking a
tree, report i/num_roots. So users can see the what is the check doing
something meaningful or silly dead looping.

Thanks,
Su

>>
>> 2) non lowmem is more efficient obviously when it doesn't completely
>> crash your machine, but could lowmem be given an amount of memory to use
>> for caching, or maybe use some heuristics based on RAM free so that it's
>> not so excrutiatingly slow?
> 
> IIRC recent commit has added the ability.
> a5ce5d219822 ("btrfs-progs: extent-cache: actually cache extent buffers")
> 
> That's already included in btrfs-progs v4.13.2.
> So it should be a dead loop which lowmem repair code can't handle.
> 
> Thanks,
> Qu
> 
>>
>> Thanks,
>> Marc
>>
> 


