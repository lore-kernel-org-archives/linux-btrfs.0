Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59241 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751962AbbEUAVw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 May 2015 20:21:52 -0400
Message-ID: <555D251E.7080801@cn.fujitsu.com>
Date: Thu, 21 May 2015 08:21:50 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, WorMzy Tykashi <wormzy.tykashi@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <lukas.lueg@gmail.com>
Subject: Re: [PATCH 4/4] btrfs-progs: Add extra chunk item check to avoid
 btrfs-progs crash.
References: <1431508536-7275-1-git-send-email-quwenruo@cn.fujitsu.com> <1431508536-7275-5-git-send-email-quwenruo@cn.fujitsu.com> <20150513161823.GQ23255@twin.jikos.cz> <CALOYprV-dyji_5UFm3K-qmw0K2i5u7d14rwX7OPMFS29aY9ZVA@mail.gmail.com> <555BD45F.6070509@cn.fujitsu.com> <20150520122049.GH23255@twin.jikos.cz>
In-Reply-To: <20150520122049.GH23255@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: [PATCH 4/4] btrfs-progs: Add extra chunk item check to 
avoid btrfs-progs crash.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年05月20日 20:20

> On Wed, May 20, 2015 at 08:25:03AM +0800, Qu Wenruo wrote:
>> Yes, I also find the problem and already sent the fixing patch:
>> https://patchwork.kernel.org/patch/6411191/
>>
>> The problem is that my previous check patch is too restrict, making DUP
>> chunk with only 1 stripe invalid.
>>
>> Fixing patch will allow degraded chunk to exist and fix the bug.
>
> Next time please mention that in the changelog or at least as a side
> note that it fixes the broken test or that fixes some previous commit.
>
Sorry, my fault.

I'll pay more attention on such patch.

Thanks for pointing it out.
Qu
