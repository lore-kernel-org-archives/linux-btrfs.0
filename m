Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39164 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab2KBXXd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Nov 2012 19:23:33 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TUQaQ-00032N-Cu
	for linux-btrfs@vger.kernel.org; Sat, 03 Nov 2012 00:23:38 +0100
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Nov 2012 00:23:38 +0100
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Nov 2012 00:23:38 +0100
To: linux-btrfs@vger.kernel.org
From: Gabriel <g2p.code@gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS] Enhance btrfs fi df
Date: Fri, 2 Nov 2012 23:23:14 +0000 (UTC)
Message-ID: <k71kl2$7go$3@ger.gmane.org>
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
	<201211021218.29778.Martin@lichtvoll.de> <5093B658.3000007@gmail.com>
	<k715i0$7go$1@ger.gmane.org> <20121102220604.GC28864@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 02 Nov 2012 22:06:04 +0000, Hugo Mills wrote:

> On Fri, Nov 02, 2012 at 07:05:37PM +0000, Gabriel wrote:
>> On Fri, 02 Nov 2012 13:02:32 +0100, Goffredo Baroncelli wrote:
>> > On 2012-11-02 12:18, Martin Steigerwald wrote:
>> >> Metadata, DUP is displayed as 3,50GB on the device level and as 1,75GB
>> >> in total. I understand the logic behind this, but this could be a bit
>> >> confusing.
>> >> 
>> >> But it makes sense: Showing real allocation on device level makes
>> >> sense,
>> >> cause thats what really allocated on disk. Total makes some sense,
>> >> cause thats what is being used from the tree by BTRFS.
>> > 
>> > Yes, me too. At the first I was confused when you noticed this
>> > discrepancy. So I have to admit that it is not so obvious to understand.
>> > However we didn't find any way to make it more clear...
>> > 
>> >> It still looks confusing at first…
>> > We could use "Chunk(s) capacity" instead of total/size ? I would like an
>> > opinion from a "english people" point of view..
>> 
>> This is easy to fix, here's a mockup:
>> 
>> Metadata,DUP: Size: 1.75GB ×2, Used: 627.84MB ×2
>>    /dev/dm-0        3.50GB
> 
>    I've not considered the full semantics of all this yet -- I'll try
> to do that tomorrow. However, I note that the "×2" here could become
> non-integer with the RAID-5/6 code (which is due Real Soon Now). In
> the first RAID-5/6 code drop, it won't even be simple to calculate
> where there are different-sized devices in the filesystem. Putting an
> exact figure on that number is potentially going to be awkward. I
> think we're going to need kernel help for working out what that number
> should be, in the general case.

DUP can be nested below a device because it represents same-device
redundancy (purpose: survive smudges but not device failure).

On the other hand raid levels should occupy the same space on all
linked devices (a necessary consequence of the guarantee that RAID5
can survive the loss of any device and RAID6 any two devices).

The two probably won't need to be represented at the same time
except during a reshape, because I imagine DUP gets converted to
RAID (1 or 5) as soon as the second device is added.

A 1→2 reshape would look a bit like this (doing only the data column
and skipping totals):

InitialDevice
  Reserved           1.21TB
  Used               1.21TB
RAID1(InitialDevice, SecondDevice)
  Reserved   1.31TB + 100GB
  Used             2× 100GB

RAID5, RAID6: same with fractions, n+1⁄n and n+2⁄n.

>    Again, I'm raising minor points based on future capabilities, but I
> feel it's worth considering them at this stage, even if the correct
> answer is "yes, we'll do this now, and deal with any other problems
> later".
> 
>    Hugo.
> 
>>            Data   Metadata Metadata    System System              
>>            Single Single   DUP         Single DUP         Unallocated
>>                                                                
>> /dev/dm-16 1.31TB   8.00MB  56.00GB    4.00MB  16.00MB           0.00
>>            ====== ======== =========== ====== =========== ===========
>> Total      1.31TB   8.00MB  28.00GB ×2 4.00MB   8.00MB ×2        0.00
>> Used       1.31TB     0.00   5.65GB ×2   0.00 152.00KB ×2            
>> 
>> Also, I don't know if you could use libblkid, but it finds more 
>> descriptive names than dm-NN (thanks to some smart sorting logic).
>> 
>>


