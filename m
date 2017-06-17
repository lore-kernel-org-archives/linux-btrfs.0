Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54130 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751942AbdFQN24 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Jun 2017 09:28:56 -0400
Subject: Re: [PATCH v3] btrfs: fiemap: Cache and merge fiemap extent before
 submit it to user
To: Adam Borowski <kilobyte@angband.pl>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
References: <20170407024315.30685-1-quwenruo@cn.fujitsu.com>
 <20170616123352.GF25451@twin.jikos.cz>
 <92aae99b-2c1a-2c66-1291-a0ef73c58b16@gmx.com>
 <20170617083058.7z67mw4622oa7ajo@angband.pl>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <48fbf1c1-6b7b-a886-2355-bac5ec3f79ba@gmx.com>
Date: Sat, 17 Jun 2017 21:28:30 +0800
MIME-Version: 1.0
In-Reply-To: <20170617083058.7z67mw4622oa7ajo@angband.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年06月17日 16:30, Adam Borowski wrote:
> On Sat, Jun 17, 2017 at 03:43:18PM +0800, Qu Wenruo wrote:
>> On 2017年06月16日 20:33, David Sterba wrote:
>>> I see a lot of warnings from btrfs/094
>>>
>>> [13458.628334] BTRFS warning (device sdb6): unhandled fiemap cache detected: offset=581632 phys=13078528 len=4096 flags=0x800
>>
>> Strangely, I can't reproduce it either on my original branch (v4.12 with
>> this patch), or torvalds/master (this patch is already merged with your
>> renaming)
> 
> I for one get this a lot even in regular use.  Somehow, it always has Comm:
> dpkg, despite the vast majority of activity on the system obviously not
> being dpkg.

Is that with 0x800 flag? Or some other flag?
I'm trying fallocated file with my original branch, but still no chance 
to reproduce it though.

> 
>> However I tried all btrfs/09*,  nothing happened.
>>
>> Is some other out-of-tree patch causing the problem?
>> If so, which branch are you testing? I think I could help to fix it.
> 
> For me, linus/master with a handful of not possibly relevant patches
> (in fs/btrfs/ I have dedupe and defrag on files opened ro, raid5/6 warning,
> raid5/6 incompat flag clearing).

linus/master without any extra patch is still the same?
And which commit?
I'm using 1439ccf73d9c07654fdd5b4969fd53c2feb8684d, at least it doesn't 
cause any warning the related test case, and I tried several combination 
with preallocated and written and hole, still no chance.

I also ran btrfs/* with my patch applied on v4.11-rc2 (sorry, that's the 
correct original patch base), and except some known bug, it doesn't 
cause anything special.

Thanks,
Qu

> 
> 
> Meow!
> 
