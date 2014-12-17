Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-35-i2.italiaonline.it ([212.48.25.208]:43308 "EHLO
	smtp-35.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750953AbaLQTNC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 14:13:02 -0500
Message-ID: <5491D618.8070205@libero.it>
Date: Wed, 17 Dec 2014 20:14:32 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Fwd: Re: [RFC][BTRFS-PROGS] Improve output of mkfs.btrfs command
References: <5491D215.4060109@inwind.it>
In-Reply-To: <5491D215.4060109@inwind.it>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I forgoto to put in CC the mailing list


-------- Forwarded Message --------
Subject: Re: [RFC][BTRFS-PROGS] Improve output of mkfs.btrfs command
Date: Wed, 17 Dec 2014 19:57:25 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
To: Holger Hoffstätte <holger.hoffstaette@googlemail.com>

On 12/17/2014 04:08 PM, Holger Hoffstätte wrote:
> On Mon, 15 Dec 2014 21:02:53 +0100, Goffredo Baroncelli wrote:
> 
>> enclosed a patches set to improve the output of mkfs.btrfs command.
> 
> This is very nice! I do have a comment about the device list:
> 
>> ..
>>     UUID                                  ID    SIZE    PATH
>>     ------------------------------------  --  --------- -----------
>>     62121322-5666-4ecf-bc8e-c9b3d9f60db9   1   50.00GiB /dev/vdb
>>     6158cb13-3ae8-42b6-8603-660f1e5c8a7a   2   50.00GiB /dev/vdc
>>     b49516db-ddf5-4f54-8831-a4babc79e901   3   50.00GiB /dev/vdd
>>     00b03d81-7d29-4894-8050-9dd205f97c41   4   50.00GiB /dev/vde
>>     f119a2ec-5ef0-436c-805e-c1b0612b05ca   5   50.00GiB /dev/vdf
>>     adee4f58-e094-4bd4-8c56-941527524f8d   6   50.00GiB /dev/vdg
>>     a8299171-2024-4057-ba56-1f83bf6d7e2e   7   50.00GiB /dev/vdh
>>     b694e275-e454-4dbd-beb0-e33c388cffa2   8    2.00GiB /dev/vdi
>>     7cbe04b5-36cd-4ea7-be82-206d5487914e   9    2.00GiB /dev/vdj
>>     7c320654-675e-456b-ac23-cfb148b8ea57  10    2.00GiB /dev/vdk
>>
>>   Total disks size:                           356.01GiB
> 
> I'm not sure how others feel about this, but the first column of UUIDs
> contains almost no human-usable information (who remembers UUIDs?) but
> takes up a huge chunk of the screen real estate. I'd suggest to reorder
> the columns to be something like (ID, Size, Path, UUID). This puts more
> relevant information in reading-order.

UUIDs have a fixed size, SIZE is up to 10 chars, 
ID length should be less equal than 3 (up to 999 devices !); only path
has a variable length (think about LVM devices....). This is the reason to
put path at the end. Is the same logic that put the filename on the right
when doing ls -l...

I would like more feedback about that. I am open to swap the fields, but the 
"Total disks size" should be below the SIZE column"


> 
> I hope this isn't too much to ask :)
> 
> thanks
> Holger
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5


