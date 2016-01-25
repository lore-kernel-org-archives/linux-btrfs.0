Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36213 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbcAYMTS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 07:19:18 -0500
Received: by mail-ig0-f169.google.com with SMTP id z14so33915396igp.1
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Jan 2016 04:19:17 -0800 (PST)
Subject: Re: btrfs receive fails
To: Chris Murphy <lists@colorremedies.com>,
        Stephan Olbrich <stephan@albapasser.de>
References: <2928754.CoMICLlXAW@chaos-desktop>
 <CAJCQCtTRxL9tqrcP2z=Y7Se7fyeooXpEh6ByFv=n+UeuhsS2ZQ@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56A6128E.1020403@gmail.com>
Date: Mon, 25 Jan 2016 07:18:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTRxL9tqrcP2z=Y7Se7fyeooXpEh6ByFv=n+UeuhsS2ZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-23 15:50, Chris Murphy wrote:
> On Sat, Jan 23, 2016 at 12:44 PM, Stephan Olbrich <stephan@albapasser.de> wrote:
>> Hi,
>>
>> I have three btrfs volumes. I do daily snapshots and transfer them to another
>> drive. This works fine for two of the volumes, for the 3. one the send works
>> fine but the receive sometimes fails with the following output:
>>
>> ERROR: unlink o128782-4421-0 failed. No such file or directory
>>
>> The o128782-4421-0 is different each time but it is always "o" and then some
>> numbers.
>> My current workaround is to do the send with another parent (-p)
>>
>> The problematic volume is my data partition and usually not much happening
>> there besides the owncloud-client writing some status files (sqlite database).
>>
>> # uname -a
>> Linux chaos-desktop 4.2.1-040201-generic #201509211431 SMP Mon Sep 21 18:34:44
>> UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>>
>> # btrfs --version
>> btrfs-progs v4.0
>
>
> I suggest first seeing if the problem is reproducible with btrfs-progs
> 4.3.1 or 4.4, since there have been receive bug fixes since v4.0
> (which is now kinda old) and most of the receive code is in the user
> space tools as I understand it. If that doesn't fix it, then I'd try
> two more things in parallel, one is -vvv on both the send and receive
> commands to see if that can help determine if the problem is on the
> send or receive side. Maybe someone will recognize the problem. And
> then also update the kernel to 4.4.0, 4.3.3, or 4.2.8 (in order of
> preference) because almost inevitably you're going to be asked to
> upgrade the kernel version to see if it's reproducible there.
>
>
Building further on that, there are some times that something in the 
metadata for a file can cause send/receive to fail.  Using -vv on the 
receive side should give you enough info to narrow down which file if 
this is indeed the case, at which point you can fix the file by either 
copying it to another filesystem and back again, or reinstalling 
whichever package it belongs to.  It's worth noting that if something 
like this is happening, it's probably multiple files with this issue, 
not just one, so it may take multiple tries to get things working again.
