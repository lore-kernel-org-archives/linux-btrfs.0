Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:57637 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751071AbdIEIFX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Sep 2017 04:05:23 -0400
Subject: Re: btrfs check --repair now runs in minutes instead of hours?
 aborting
To: Marc MERLIN <marc@merlins.org>
Cc: quwenruo@cn.fujitsu.com, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
References: <20170905010531.rfvun5isjwrb5ur5@merlins.org>
 <75b0ebd3-41ea-7f45-bec4-f7d9ec6efee1@gmx.com>
 <20170905025556.GA6392@merlins.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <92e0486d-a7b5-01f8-5ef4-6773f8939bec@gmx.com>
Date: Tue, 5 Sep 2017 16:05:04 +0800
MIME-Version: 1.0
In-Reply-To: <20170905025556.GA6392@merlins.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月05日 10:55, Marc MERLIN wrote:
> On Tue, Sep 05, 2017 at 09:21:55AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2017年09月05日 09:05, Marc MERLIN wrote:
>>> Ok, I don't want to sound like I'm complaining :) but I updated
>>> btrfs-progs to top of tree in git, installed it, and ran it on an 8TiB
>>> filesystem that used to take 12H or so to check.
>>
>> How much space allocated for that 8T fs?
>> If metadata is not that large, 10min is valid.
>>
>> Here fi df output could help.
> 
> gargamel:~# btrfs fi df /mnt/btrfs_pool1
> Data, single: total.60TiB, used.54TiB
> System, DUP: total2.00MiB, used=1.19MiB
> Metadata, DUP: totalX.00GiB, used.69GiB

Wait for a minute.

Is that .69GiB means 706 MiB? Or my email client/GMX screwed up the 
format (again)?
This output format must be changed, at least to 0.69 GiB, or 706 MiB.

I'll fix this first.

> GlobalReserve, single: totalQ2.00MiB, used=0.00B
> 
>> And, without --repair, how much time it takes to run?
> 
> Well, funny that you ask, it's now been running for hours, still waiting...
>   
> Just before, I ran lowmem, and it was pretty quick too (didn't time it,
> but less than 1h):

You mean lowmem is actually FASTER than original mode?
That's very surprising.

Is there any special operation done for that btrfs?
Like offline dedupe or tons of reflinks?

IIRC original mode did a quite slow check for tons of reflink, which may 
be related.

BTW, how many subvolumes do you have in the fs?

> gargamel:/var/local/src/btrfs-progs# btrfs check --mode=wmem
> /dev/mapper/dshelf1
> Checking filesystem on /dev/mapper/dshelf1
> UUID: 36f5079e-ca6c-4855-8639-ccb82695c18d
> checking extents
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> checking csums
> checking root refs
> found 11674263330816 bytes used, no error found
> total csum bytes: 11384482936
> total tree bytes: 13738737664
> total fs tree bytes: 758988800
> total extent tree bytes: 482623488
> btree space waste bytes: 1171475737
> file data blocks allocated: 12888981110784
>   referenced 12930453286912
> 
> Now, this is good news for my filesystem being probably clean (previous
> versions of lowmem before my git update found issues that were unclear, but
> apparently errors in the code, and this version finds nothing)
> 
> But I'm not sure why --repair would be fast, and not --repair would be slow?

This looks like a bug. My first guess is related to number of 
subvolumes/reflinks, but I'm not sure since I don't have many real-world 
btrfs.

I'll take sometime to look into it.

Thanks for the very interesting report,
Qu

> 
> Marc
> 
