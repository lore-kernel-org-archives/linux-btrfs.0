Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36376 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbcAASbt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jan 2016 13:31:49 -0500
Received: by mail-qk0-f174.google.com with SMTP id q19so55512057qke.3
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 10:31:49 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: btrfs scrub failing
From: John Center <jlcenter15@gmail.com>
In-Reply-To: <pan$ddf92$7633f36c$14118b68$b87353e3@cox.net>
Date: Fri, 1 Jan 2016 13:31:46 -0500
Cc: linux-btrfs@vger.kernel.org
Message-Id: <44C91D93-6A84-4B12-A5CF-0AFB1FD1C09B@gmail.com>
References: <CAPgWCbQ9HS1N=JCbbHuT9yyTz3JPAizA+DvOAR7_GX73CVix0g@mail.gmail.com> <pan$1f21$8d293d0$5b6cd545$34c90ade@cox.net> <26CBABB7-7744-4833-A37B-C2380304223F@gmail.com> <pan$ddf92$7633f36c$14118b68$b87353e3@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan,

> On Jan 1, 2016, at 12:05 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> John Center posted on Fri, 01 Jan 2016 11:41:20 -0500 as excerpted:
> 
>> Ok, I'll upgrade to 4.3 & see if that resolves the problem with
>> scrubbing.
>> I was wondering when I compiled the btrfs-tools if there would be a
>> problem with them not being in sync with the major kernel version.
> 
> FWIW newer (or older either, as long as not too old and you don't need 
> any of the features not in the older, and you're not trying to fix 
> problems only the newer can deal with) versions of btrfs-progs should be 
> fine.  As a rule of thumb I recommend staying at least current to kernel 
> version, but that's a rule of thumb, primarily to prevent getting /too/ 
> old, only.  Both the btrfs-progs userspace and the kernel itself are 
> normally designed to be able to work with both older and newer versions 
> of the other one.
> 
> So userspace not being in sync with the kernel version shouldn't be a 
> problem.
> 
Ok, good to know. 

> Well, I'm hoping someone who had the problem can confirm whether it's 
> fixed in current kernels (scrub is one of those userspace commands that's 
> mostly just a front-end to the kernel code which does the real work, so 
> kernel version is the important thing for scrub).  I'm guessing so, and 
> that you'll find the problem gone in 4.3.
> 
I wasn't aware of this. Good to know. 

> We'll cross the not-gone bridge if we get to it, but again, if the other 
> people who had the similar problem can confirm whether it disappeared for 
> them with the new kernel, it would help a lot, as there were enough such 
> reports that if it's the same problem and still there for everyone (which 
> I doubt as I expect there'd still be way more posts about it if so, but 
> confirmation's always good), nothing to do but wait for a fix, while if 
> not, and you still have your problem, then it's a different issue and the 
> devs will need to work with you on a fix specific to your problem.
> 
Ok, understood. 

Thanks & Happy New Year!

    -John
