Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40024 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbaHWFpr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Aug 2014 01:45:47 -0400
Received: by mail-lb0-f174.google.com with SMTP id c11so10373259lbj.33
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 22:45:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140823031055.GH3875@merlins.org>
References: <20140822155040.GU3875@merlins.org> <pan$a7366$366442ed$60aa89a1$c636b8e3@cox.net>
 <20140822184919.GE3875@merlins.org> <pan$644c4$e5e83b2d$34cd9e4d$75795b7@cox.net>
 <20140823031055.GH3875@merlins.org>
From: Naohiro Aota <nao.aota@gmail.com>
Date: Sat, 23 Aug 2014 14:45:25 +0900
Message-ID: <CAEe67=9gN2F58C2MJO0Ag-P7cRAux8+gcov0k5J2PwtNmi=MBg@mail.gmail.com>
Subject: Re: Unclean shutdowns cause google-chrome profile to be corrupted in
 various ways
To: Marc MERLIN <marc@merlins.org>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 23, 2014 at 12:10 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Sat, Aug 23, 2014 at 02:52:16AM +0000, Duncan wrote:
>> > For mysql, I got:
>> > InnoDB: Page directory corruption:
>> > infimum not pointed to 140708 11:53:58
>> > InnoDB: Page dump in ascii and hex (16384 bytes):
>> > len 16384; hex 00000000(16KB of 0's).
>>
>> Is that on ssd or spinning rust, and if ssd, do you run with trim/discard
>> and/or have you filled the device yet if not (since mkfs.btrfs trims the
>> device as part of the process)?  I'm wondering if that's 4 4 KiB btrfs
>> data blocks of trimmed and unwritten SSD?
>
> It's on SSD, I do have trim/discard, I never filled the device.
>
> But I could totally remove trim and see what happens. I'll do that.

I'm experiencing the same google-chrome profile corruption on my HDD too.
It almost always happen to me when the power got lost or kernel get panic.

Naohiro
