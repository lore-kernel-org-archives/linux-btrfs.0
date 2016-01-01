Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:33830 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbcAASUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jan 2016 13:20:52 -0500
Received: by mail-qg0-f49.google.com with SMTP id 6so140052420qgy.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 10:20:52 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: btrfs scrub failing
From: John Center <jlcenter15@gmail.com>
In-Reply-To: <2990858.uJLD34QYPg@merkaba>
Date: Fri, 1 Jan 2016 13:20:49 -0500
Cc: linux-btrfs@vger.kernel.org
Message-Id: <91318630-E23C-495D-B70E-BB484B3721C6@gmail.com>
References: <CAPgWCbQ9HS1N=JCbbHuT9yyTz3JPAizA+DvOAR7_GX73CVix0g@mail.gmail.com> <pan$1f21$8d293d0$5b6cd545$34c90ade@cox.net> <26CBABB7-7744-4833-A37B-C2380304223F@gmail.com> <2990858.uJLD34QYPg@merkaba>
To: Martin Steigerwald <martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Martin,

Happy New Year!

> On Jan 1, 2016, at 12:41 PM, Martin Steigerwald <martin@lichtvoll.de> wrote:
> 
> Am Freitag, 1. Januar 2016, 11:41:20 CET schrieb John Center:
> 
> Happy New Year!
> 
>>> On Jan 1, 2016, at 12:55 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>> 
>>> A couple months ago, which would have made it around the 4.2 kernel 
>>> you're running (with 4.3 being current and 4.4 nearly out), there were a 
>>> number of similar scrub aborted reports on the list.
>> 
>> I must have missed that, I'll check the list again to try & understand the
>> issue better.
> 
> I had repeatedly failing scrubs as mentioned in another thread here, until I 
> used 4.4 kernel. With 4.3 kernel scrub also didn´t work. I didn´t use the 
> debug options you used above and I am not sure whether I had this scrub issue 
> with 4.2 already, so I am not sure it has been the same issue. But you may 
> need to run 4.4 kernel in order to get scrub working again.
> 
> See my thread "[4.3-rc4] scrubbing aborts before finishing" for details.
> 
I was afraid of this. I just read your thread. I generally try to stay away from kernels so new, but I may have to try it. Was there any reason you didn't go to 4.1 instead?  (I run win8.1 in VirtualBox 5.0.12, when I need to run somethings under Windows. I'd have to wait until 4.4 is released & supported to do that.)

Thanks. 

    -John