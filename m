Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:55464 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752082AbeF2G0d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 02:26:33 -0400
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Marc MERLIN <marc@merlins.org>
CC: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <02ba7ad4-b618-85f0-a99f-c43b25d367de@cn.fujitsu.com>
 <20180629061001.kkmgvdgqfhz23kll@merlins.org>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
Date: Fri, 29 Jun 2018 14:32:44 +0800
MIME-Version: 1.0
In-Reply-To: <20180629061001.kkmgvdgqfhz23kll@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/29/2018 02:10 PM, Marc MERLIN wrote:
> On Fri, Jun 29, 2018 at 02:02:19PM +0800, Su Yue wrote:
>> I have figured out the bug is lowmem check can't deal with shared tree block
>> in reloc tree. The fix is simple, you can try the follow repo:
>>
>> https://github.com/Damenly/btrfs-progs/tree/tmp1
> 
> Not sure if I undertand that you meant, here.
> 
Sorry for my unclear words.
Simply speaking, I suggest you to stop current running check.
Then, clone above branch to compile binary then run
'btrfs check --mode=lowmem $dev'.

>> Please run lowmem check "without =--repair" first to be sure whether
>> your filesystem is fine.
>   
> The filesystem is not fine, it caused btrfs balance to hang, whether
> balance actually broke it further or caused the breakage, I can't say.
> 
> Then mount hangs, even with recovery, unless I use ro.
> 
> This filesystem is trash to me and will require over a week to rebuild
> manually if I can't repair it.

Understood your anxiety, a log of check without '--repair' will help
us to make clear what's wrong with your filesystem.

Thanks,
Su
> Running check without repair for likely several days just to know that
> my filesystem is not clear (I already know this) isn't useful :)
> Or am I missing something?
> 
>> Though the bug and phenomenon are clear enough, before sending my patch,
>> I have to make a test image. I have spent a week to study btrfs balance
>> but it seems a liitle hard for me.
> 
> thanks for having a look, either way.
> 
> Marc
> 


