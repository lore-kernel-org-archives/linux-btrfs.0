Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:60252 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752824AbeGBGQI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 02:16:08 -0400
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Marc MERLIN <marc@merlins.org>
CC: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <02ba7ad4-b618-85f0-a99f-c43b25d367de@cn.fujitsu.com>
 <20180629061001.kkmgvdgqfhz23kll@merlins.org>
 <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
 <20180629064354.kbaepro5ccmm6lkn@merlins.org>
 <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
 <20180702032259.GD5567@merlins.org>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
Date: Mon, 2 Jul 2018 14:22:20 +0800
MIME-Version: 1.0
In-Reply-To: <20180702032259.GD5567@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/02/2018 11:22 AM, Marc MERLIN wrote:
> On Mon, Jul 02, 2018 at 10:02:33AM +0800, Su Yue wrote:
>> Could you try follow dumps? They shouldn't cost much time.
>>
>> #btrfs inspect dump-tree -t 21872 <device> | grep -C 50 "374857
>> EXTENT_DATA "
>>
>> #btrfs inspect dump-tree -t 22911 <device> | grep -C 50 "374857
>> EXTENT_DATA "
> 
> Ok, that's 29MB, so it doesn't fit on pastebin:
> http://marc.merlins.org/tmp/dshelf2_inspect.txt
> 
Sorry Marc. After offline communication with Qu, both
of us think the filesystem is hard to repair.
The filesystem is too large to debug step by step.
Every time check and debug spent is too expensive.
And it already costs serveral days.

Sadly, I am afarid that you have to recreate filesystem
and reback up your data. :(

Sorry again and thanks for you reports and patient.

Su
> Marc
> 


