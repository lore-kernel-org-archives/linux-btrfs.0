Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58322 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab2KBTbK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2012 15:31:10 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so1493851eaa.19
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 12:31:09 -0700 (PDT)
Message-ID: <50941FAC.1010803@gmail.com>
Date: Fri, 02 Nov 2012 20:31:56 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Gabriel <g2p.code@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH][BTRFS-PROGS] Enhance btrfs fi df
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it> <201211021218.29778.Martin@lichtvoll.de> <5093B658.3000007@gmail.com> <k715i0$7go$1@ger.gmane.org>
In-Reply-To: <k715i0$7go$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/02/2012 08:05 PM, Gabriel wrote:
> On Fri, 02 Nov 2012 13:02:32 +0100, Goffredo Baroncelli wrote:
>> On 2012-11-02 12:18, Martin Steigerwald wrote:
>>> Metadata, DUP is displayed as 3,50GB on the device level and as 1,75GB
>>> in total. I understand the logic behind this, but this could be a bit
>>> confusing.
>>>
>>> But it makes sense: Showing real allocation on device level makes
>>> sense,
>>> cause thats what really allocated on disk. Total makes some sense,
>>> cause thats what is being used from the tree by BTRFS.
>>
>> Yes, me too. At the first I was confused when you noticed this
>> discrepancy. So I have to admit that it is not so obvious to understand.
>> However we didn't find any way to make it more clear...
>>
>>> It still looks confusing at first…
>> We could use "Chunk(s) capacity" instead of total/size ? I would like an
>> opinion from a "english people" point of view..
> 
> This is easy to fix, here's a mockup:
> 
> Metadata,DUP: Size: 1.75GB ×2, Used: 627.84MB ×2
>    /dev/dm-0        3.50GB
> 
>            Data   Metadata Metadata    System System              
>            Single Single   DUP         Single DUP         Unallocated
>                                                                
> /dev/dm-16 1.31TB   8.00MB  56.00GB    4.00MB  16.00MB           0.00
>            ====== ======== =========== ====== =========== ===========
> Total      1.31TB   8.00MB  28.00GB ×2 4.00MB   8.00MB ×2        0.00
> Used       1.31TB     0.00   5.65GB ×2   0.00 152.00KB ×2     

Nice idea. Even tough I like the opposite:


           Data   Metadata Metadata    System System
           Single Single   DUP         Single DUP         Unallocated

/dev/dm-16 1.31TB   8.00MB  28.00GB x2 4.00MB   8.00MB x2        0.00
           ====== ======== =========== ====== =========== ===========
Total      1.31TB   8.00MB  28.00GB    4.00MB   8.00MB           0.00
Used       1.31TB     0.00   5.65GB      0.00 152.00KB


However how your solution will became when RAID5/RAID6 will arrive ? mmm
may be the solution is simpler: the "x2" factor is applied only to DUP
profile. The other profiles span different disks.

As another option, we can add a field/line which reports the RAID factor:


Metadata,DUP: Size: 1.75GB, Used: 627.84MB, Raid factor: 2x
   /dev/dm-0        3.50GB


            Data   Metadata Metadata   System System
            Single Single   DUP        Single DUP    Unallocated

/dev/dm-16  1.31TB   8.00MB  56.00GB 4.00MB  16.00MB        0.00
            ====== ======== ======== ====== ======== ===========
Raid factor      -        -       x2      -       x2           -
Total       1.31TB   8.00MB  28.00GB 4.00MB   8.00MB        0.00
Used        1.31TB     0.00   5.65GB   0.00 152.00KB





> 
> Also, I don't know if you could use libblkid, but it finds more 
> descriptive names than dm-NN (thanks to some smart sorting logic).

I don't think that it would be impossible to use libblkid, however it
would be difficult to find spaces for longer device name

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
