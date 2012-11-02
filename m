Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38154 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2KBMBr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2012 08:01:47 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1353859bkc.19
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 05:01:46 -0700 (PDT)
Message-ID: <5093B658.3000007@gmail.com>
Date: Fri, 02 Nov 2012 13:02:32 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        =?UTF-8?B?TWljaGFlbCBLasO2cmxpbmc=?= <michael@kjorling.se>,
        cwillu <cwillu@cwillu.com>, Chris Murphy <lists@colorremedies.com>
Subject: Re: [PATCH][BTRFS-PROGS] Enhance btrfs fi df
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it> (sfid-20121102_120303_604806_A6E2AC77) <201211021218.29778.Martin@lichtvoll.de>
In-Reply-To: <201211021218.29778.Martin@lichtvoll.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-11-02 12:18, Martin Steigerwald wrote:
> I can test on some other boxes next week, if you want to.

Yes please,

> 
> I just wonder about one thing:
> 
> 
> merkaba:[…]/btrfs-progs-unstable> ./btrfs fi df /
> Disk size:                18.62GB
> Disk allocated:           18.62GB
> Disk unallocated:            0.00
> Used:                     11.26GB
> Free (Estimated):          5.61GB       (Max: 5.61GB, min: 5.61GB)
> Data to disk ratio:          91 %
> 
> 
> merkaba:[…]/btrfs-progs-unstable> ./btrfs filesystem disk-usage /
> Data,Single: Size:15.10GB, Used:10.65GB
>    /dev/dm-0       15.10GB
> 
> Metadata,Single: Size:8.00MB, Used:0.00
>    /dev/dm-0        8.00MB
> 
> Metadata,DUP: Size:1.75GB, Used:627.84MB
>    /dev/dm-0        3.50GB
> 
> System,Single: Size:4.00MB, Used:0.00
>    /dev/dm-0        4.00MB
> 
> System,DUP: Size:8.00MB, Used:4.00KB
>    /dev/dm-0       16.00MB
> 
> Unallocated:
>    /dev/dm-0          0.00
> 
> 
> merkaba:[…]/btrfs-progs-unstable> ./btrfs filesystem disk-usage -t /
>           Data    Metadata Metadata System System             
>           Single  Single   DUP      Single DUP     Unallocated
>                                                               
> /dev/dm-0 15.10GB   8.00MB   3.50GB 4.00MB 16.00MB        0.00
>           ======= ======== ======== ====== ======= ===========
> Total     15.10GB   8.00MB   1.75GB 4.00MB  8.00MB        0.00
> Used      10.65GB     0.00 627.84MB   0.00  4.00KB            
> 
> 
> Metadata, DUP is displayed as 3,50GB on the device level and as 1,75GB
> in total. I understand the logic behind this, but this could be a bit
> confusing.
> 
> But it makes sense: Showing real allocation on device level makes sense,
> cause thats what really allocated on disk. Total makes some sense, cause
> thats what is being used from the tree by BTRFS.

Yes, me too. At the first I was confused when you noticed this
discrepancy. So I have to admit that it is not so obvious to understand.
However we didn't find any way to make it more clear...

> It still looks confusing at first…
We could use "Chunk(s) capacity" instead of total/size ? I would like an
opinion from a "english people" point of view..

GB


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
