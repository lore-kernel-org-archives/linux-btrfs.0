Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38237 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752425AbcCCCCx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2016 21:02:53 -0500
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <56D3A56A.20809@cn.fujitsu.com> <20160229153352.GE2334@torres.zugschlus.de>
 <56D4E621.3010604@cn.fujitsu.com> <20160301065448.GJ2334@torres.zugschlus.de>
 <56D54393.8060307@cn.fujitsu.com> <56D54F2F.5050205@cn.fujitsu.com>
 <20160301161659.GR2334@torres.zugschlus.de>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56D79B38.6060501@cn.fujitsu.com>
Date: Thu, 3 Mar 2016 10:02:32 +0800
MIME-Version: 1.0
In-Reply-To: <20160301161659.GR2334@torres.zugschlus.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the output.

At least for mprofile enospc error, the problem itself is very 
straightforward, just unable to alloc tree block.

I'll check the codes to see if we can improve it, by finding out why we 
can't alloc a new chunk to resolve the problem.

But I'm still a little concerned about the dprofile case, as this time, 
dprofile doesn't trigger a ENOSPC and my debug info is not triggered.

Thanks,
Qu

Marc Haber wrote on 2016/03/01 17:16 +0100:
> Hi,
>
> On Tue, Mar 01, 2016 at 04:13:35PM +0800, Qu Wenruo wrote:
>> Oh, I'm sorry that the output is not necessary, it's better to use the newer
>> patch:
>> https://patchwork.kernel.org/patch/8462881/
>>
>> With the newer patch, you will need to use enospc_debug mount option to get
>> the debug information.
>
> I'll copy the log this time in the body of the message so that it gets
> through to the list. Let me know if you'd prefer an attachment.
>
> This time, I didn't see the busy kernel threads, and I now see ENOSPC
> during the mprofiles part of the manual balance.
>
> Hope this helps.
>
> Greetings
> Marc
>


