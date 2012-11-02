Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47647 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350Ab2KBUkQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Nov 2012 16:40:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TUO2P-0002tG-IB
	for linux-btrfs@vger.kernel.org; Fri, 02 Nov 2012 21:40:21 +0100
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 21:40:21 +0100
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 21:40:21 +0100
To: linux-btrfs@vger.kernel.org
From: Gabriel <g2p.code@gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS] Enhance btrfs fi df
Date: Fri, 2 Nov 2012 20:40:01 +0000 (UTC)
Message-ID: <k71b30$7go$2@ger.gmane.org>
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
	<201211021218.29778.Martin@lichtvoll.de> <5093B658.3000007@gmail.com>
	<k715i0$7go$1@ger.gmane.org> <50941FAC.1010803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 02 Nov 2012 20:31:56 +0100, Goffredo Baroncelli wrote:

> On 11/02/2012 08:05 PM, Gabriel wrote:
>> On Fri, 02 Nov 2012 13:02:32 +0100, Goffredo Baroncelli wrote:
>>> On 2012-11-02 12:18, Martin Steigerwald wrote:
>>>> Metadata, DUP is displayed as 3,50GB on the device level and as
>>>> 1,75GB in total. I understand the logic behind this, but this could
>>>> be a bit confusing.
>>>>
>>>> But it makes sense: Showing real allocation on device level makes
>>>> sense,
>>>> cause thats what really allocated on disk. Total makes some sense,
>>>> cause thats what is being used from the tree by BTRFS.
>>>
>>> Yes, me too. At the first I was confused when you noticed this
>>> discrepancy. So I have to admit that it is not so obvious to
>>> understand.
>>> However we didn't find any way to make it more clear...
>>>
>>>> It still looks confusing at first…
>>> We could use "Chunk(s) capacity" instead of total/size ? I would like
>>> an opinion from a "english people" point of view..
>> 
>> This is easy to fix, here's a mockup:
>> 
>> Metadata,DUP: Size: 1.75GB ×2, Used: 627.84MB ×2
>>    /dev/dm-0        3.50GB
>> 
>>            Data   Metadata Metadata    System System Single Single  
>>            DUP         Single DUP         Unallocated
>>                                                                
>> /dev/dm-16 1.31TB   8.00MB  56.00GB    4.00MB  16.00MB           0.00
>>            ====== ======== =========== ====== =========== ===========
>> Total      1.31TB   8.00MB  28.00GB ×2 4.00MB   8.00MB ×2        0.00
>> Used       1.31TB     0.00   5.65GB ×2   0.00 152.00KB ×2
> 
> Nice idea. Even tough I like the opposite:
> 
> 
>            Data   Metadata Metadata    System System Single Single   DUP
>                    Single DUP         Unallocated
> 
> /dev/dm-16 1.31TB   8.00MB  28.00GB x2 4.00MB   8.00MB x2        0.00
>            ====== ======== =========== ====== =========== ===========
> Total      1.31TB   8.00MB  28.00GB    4.00MB   8.00MB           0.00
> Used       1.31TB     0.00   5.65GB      0.00 152.00KB
> 
> 
> However how your solution will became when RAID5/RAID6 will arrive ? mmm
> may be the solution is simpler: the "x2" factor is applied only to DUP
> profile. The other profiles span different disks.

That problem solved itself :)

> As another option, we can add a field/line which reports the RAID
> factor:
> 
> Metadata,DUP: Size: 1.75GB, Used: 627.84MB, Raid factor: 2x
>    /dev/dm-0        3.50GB
> 
> 
>             Data   Metadata Metadata   System System Single Single   DUP
>                    Single DUP    Unallocated
> 
> /dev/dm-16  1.31TB   8.00MB  56.00GB 4.00MB  16.00MB        0.00
>             ====== ======== ======== ====== ======== ===========
> Raid factor      -        -       x2      -       x2           -
> Total       1.31TB   8.00MB  28.00GB 4.00MB   8.00MB        0.00 Used   
>     1.31TB     0.00   5.65GB   0.00 152.00KB

All fine options. Though if you remove the ×2 on the totals line,
you should compute it instead (it looks like a tally, both sides
of the == line should be equal).

Now that I've started bikeshedding, here is something that I would
find pretty much ideal:

            Data    Metadata           System             Unallocated              

VolGroup/Btrfs
  Reserved   1.31TB 8.00MB + 2×28.00MB 16.00MB + 2×4.00MB           -
  Used       1.31TB          2× 5.65GB         2×152.00KB           -
            ======= ================== ================== ===========
Total
  Reserved   1.31TB            56.00GB            24.00MB           -
  Used       1.31TB            11.30GB           304.00KB           -
  Free      12.34GB            44.70GB            23.70MB           -



>> Also, I don't know if you could use libblkid, but it finds more
>> descriptive names than dm-NN (thanks to some smart sorting logic).
> 
> I don't think that it would be impossible to use libblkid, however
> it would be difficult to find spaces for longer device name

I suggest cutting out the /dev and putting a line break after the
name. The extra info makes it more human-friendly, and the line
break may complicate machine parsing but the non-tabular format is
better at that anyway.

