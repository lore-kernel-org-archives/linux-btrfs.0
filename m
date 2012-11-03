Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50116 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab2KCMKz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Nov 2012 08:10:55 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2198963eek.19
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Nov 2012 05:10:53 -0700 (PDT)
Message-ID: <509509FE.4090702@gmail.com>
Date: Sat, 03 Nov 2012 13:11:42 +0100
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
[...]
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

I want to point out that we faced a lot of difficult to show that a
chunk has a capacity, and the space stored on the disk(s) is greater.
This leaded to show both the chunk (in term of Type and Profile [*]) and
the disk used.
The only thing that it will be a bit unclear is when the Profile is DUP,
because the disk usage is double of the space available.
For this reasons I am considering to put "2x" on the line related to the
disks.
Putting a "x2" In the total increase the confusion.

GB




[*] For type I means Data, Metadata, System and profile I means
DUP,Raid1/0/10/5/6,Single...


> 
> Also, I don't know if you could use libblkid, but it finds more 
> descriptive names than dm-NN (thanks to some smart sorting logic).
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
