Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:32872 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbcEBNTT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 09:19:19 -0400
Received: by mail-io0-f178.google.com with SMTP id f89so166796923ioi.0
        for <linux-btrfs@vger.kernel.org>; Mon, 02 May 2016 06:19:19 -0700 (PDT)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id vh5sm9812700igb.21.2016.05.02.06.19.17
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 02 May 2016 06:19:18 -0700 (PDT)
Subject: Re: commands like "du", "df", and "btrfs fs sync" hang
To: linux-btrfs@vger.kernel.org
References: <20160501090046.638fc2c6@jupiter.sol.kaishome.de>
 <pan$1c3f$713ccc59$ba5354e3$ceefdfd6@cox.net>
 <20160501185418.5a148cdd@jupiter.sol.kaishome.de>
 <pan$cd18$90efec60$149cab40$cd3d9864@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e3286f17-fc34-9b48-0256-cbc7dafe576a@gmail.com>
Date: Mon, 2 May 2016 09:19:13 -0400
MIME-Version: 1.0
In-Reply-To: <pan$cd18$90efec60$149cab40$cd3d9864@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-01 19:49, Duncan wrote:
> Kai Krakow posted on Sun, 01 May 2016 18:54:18 +0200 as excerpted:
>
>> It affects all file systems. The "btrfs fi sync" is used to finish my
>> rsync backup and ensure everything is written before I'm trying to
>> unmount it or the system goes back to sleep.
>>
>> "df" and friends also freeze on tmp (ramdisk) fs and vfat fs (my EFI
>> boot partition).
>
> That's just weird, there.  df on tmpfs triggers a stall as well?  Weird
> to the point I wonder if you're seeing a general block layer bug... only
> involving btrfs if btrfs is somehow fowling up the block layer for
> everyone else as well.  Whatever it is, it's obviously far different than
> my first guess, which now looks ridiculously wrong.  Oh, well...
The question is: is it actually on a ramdisk (with a separate filesystem 
on top of that), or is it on tmpfs?  The ramdisk method is used by some 
people because it lets you do some more interesting things, but tmpfs is 
much more efficient (in terms of both processing time, and RAM usage). 
If it's on a ramdisk, then it may be a block layer bug, but if it's on 
tmpfs, then it's a VFS layer bug instead.

That said, if something i8n BTRFS is causing stalls in the block layer, 
that would definately explain what is going on, as that can cause all 
I/O to stall across the whole system.
