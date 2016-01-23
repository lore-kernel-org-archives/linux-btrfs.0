Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36296 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbcAWUu6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 15:50:58 -0500
Received: by mail-io0-f177.google.com with SMTP id g73so121917083ioe.3
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jan 2016 12:50:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2928754.CoMICLlXAW@chaos-desktop>
References: <2928754.CoMICLlXAW@chaos-desktop>
Date: Sat, 23 Jan 2016 13:50:58 -0700
Message-ID: <CAJCQCtTRxL9tqrcP2z=Y7Se7fyeooXpEh6ByFv=n+UeuhsS2ZQ@mail.gmail.com>
Subject: Re: btrfs receive fails
From: Chris Murphy <lists@colorremedies.com>
To: Stephan Olbrich <stephan@albapasser.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 23, 2016 at 12:44 PM, Stephan Olbrich <stephan@albapasser.de> wrote:
> Hi,
>
> I have three btrfs volumes. I do daily snapshots and transfer them to another
> drive. This works fine for two of the volumes, for the 3. one the send works
> fine but the receive sometimes fails with the following output:
>
> ERROR: unlink o128782-4421-0 failed. No such file or directory
>
> The o128782-4421-0 is different each time but it is always "o" and then some
> numbers.
> My current workaround is to do the send with another parent (-p)
>
> The problematic volume is my data partition and usually not much happening
> there besides the owncloud-client writing some status files (sqlite database).
>
> # uname -a
> Linux chaos-desktop 4.2.1-040201-generic #201509211431 SMP Mon Sep 21 18:34:44
> UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>
> # btrfs --version
> btrfs-progs v4.0


I suggest first seeing if the problem is reproducible with btrfs-progs
4.3.1 or 4.4, since there have been receive bug fixes since v4.0
(which is now kinda old) and most of the receive code is in the user
space tools as I understand it. If that doesn't fix it, then I'd try
two more things in parallel, one is -vvv on both the send and receive
commands to see if that can help determine if the problem is on the
send or receive side. Maybe someone will recognize the problem. And
then also update the kernel to 4.4.0, 4.3.3, or 4.2.8 (in order of
preference) because almost inevitably you're going to be asked to
upgrade the kernel version to see if it's reproducible there.


-- 
Chris Murphy
