Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34765 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbbLLUQm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Dec 2015 15:16:42 -0500
Received: by ioae126 with SMTP id e126so9846490ioa.1
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Dec 2015 12:16:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMG9ccx6ahFfnsq3DHUzemYjQwuTHD46nL1SqPsjeDNL4KTRWg@mail.gmail.com>
References: <566b0cff.pXiyzYE4dYIOt31+%sivan606@gmail.com>
	<CAJCQCtTLrGin24rFGdvYV-JcegEgGEE7qK3gAYSd8K_SXFeu=g@mail.gmail.com>
	<CAMG9ccx6ahFfnsq3DHUzemYjQwuTHD46nL1SqPsjeDNL4KTRWg@mail.gmail.com>
Date: Sat, 12 Dec 2015 13:16:41 -0700
Message-ID: <CAJCQCtTckg3dA-YiswCHGo0rH7UQtObLCHb=H=mERG256SdjyQ@mail.gmail.com>
Subject: Re: Will "btrfs check --repair" fix the mounting problem?
From: Chris Murphy <lists@colorremedies.com>
To: Ivan Sizov <sivan606@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 12, 2015 at 3:34 AM, Ivan Sizov <sivan606@gmail.com> wrote:
> 2015-12-11 21:24 GMT+03:00 Chris Murphy <lists@colorremedies.com>:
>> I would not repair it if the risk of it getting worse is bad for your data.
>>
>> Note the wiki says this feature is not well tested and is reported to
>> not work reliably.
>> https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3
>>
>> Qu is working on patches to fix some of these problems, I don't know
>> the status of any of that. I just did a conversion myself the other
>> day with kernel 4.4.0rc3 and btrfs-progs 4.3.1 and that worked without
>> error. But there were also no big files at all (it was just a clean OS
>> installation). I immediately took a snapshot of that, and btrfs
>> send/receive it to a new Btrfs volume, and then discarded the
>> converted one entirely.
>>
>> The trace looks like it's mounting read-only? If it can be mounted
>> read only, get the important data off the volume if it's not already
>> backed up, and then blow it away. I personally wouldn't bother with
>> repairing it.
>
> What is the better way to get data? send/receive works only with RO
> snapshots. Is there another way to preserve subvolumes and CoW
> structure (a lot of files was copied between subvols using "cp
> --reflink=always")? Or just rsync'ing files is all what I can do?

cp -a or rsync -a is all I can think of. To start to get it back to
normal, you can use duperemove. While that doesn't create subvolumes,
it'll at least find duplicate extents and use reflinks for those. So
it's in effect the same thing you have now, just lacking the subvolume
structure.

-- 
Chris Murphy
