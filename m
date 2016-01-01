Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33372 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbcAAQlX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jan 2016 11:41:23 -0500
Received: by mail-qk0-f182.google.com with SMTP id p186so29866346qke.0
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 08:41:22 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: btrfs scrub failing
From: John Center <jlcenter15@gmail.com>
In-Reply-To: <pan$1f21$8d293d0$5b6cd545$34c90ade@cox.net>
Date: Fri, 1 Jan 2016 11:41:20 -0500
Cc: linux-btrfs@vger.kernel.org
Message-Id: <26CBABB7-7744-4833-A37B-C2380304223F@gmail.com>
References: <CAPgWCbQ9HS1N=JCbbHuT9yyTz3JPAizA+DvOAR7_GX73CVix0g@mail.gmail.com> <pan$1f21$8d293d0$5b6cd545$34c90ade@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan,

> On Jan 1, 2016, at 12:55 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> John Center posted on Thu, 31 Dec 2015 11:20:28 -0500 as excerpted:
> 
>> I run a weekly scrub, using Marc Merlin's btrfs-scrub script.
>> Usually, it completes without a problem, but this week it failed.  I ran
>> the scrub manually & it stops shortly:
>> 
>> john@mariposa:~$ sudo /sbin/btrfs scrub start -BdR /dev/md124p2
>> ERROR: scrubbing /dev/md124p2 failed for device id 1:
>> ret=-1, errno=5 (Input/output error)
>> scrub device /dev/md124p2 (id 1) canceled
>> scrub started at Thu Dec 31 00:26:34 2015
>> and was aborted after 00:01:29 [...]
> 
>> My Ubuntu 14.04 workstation is using the 4.2 kernel (Wily).
>> I'm using btrfs-tools v4.3.1. [...]
> 
> A couple months ago, which would have made it around the 4.2 kernel 
> you're running (with 4.3 being current and 4.4 nearly out), there were a 
> number of similar scrub aborted reports on the list.
> 
I must have missed that, I'll check the list again to try & understand the issue better. 

> I don't recall seeing any directly related patches, but the reports died 
> down, whether because everybody having them had reported already, or 
> because a newer kernel fixed the problem, I'm not sure, as I never had 
> the problem myself[1].
> 
> So I'd suggest upgrading to either the current 4.3 kernel or the latest 
> 4.4-rc, and hopefully the problem will be gone.  If I'd had the problem 
> myself I could tell you for sure whether it went away for me with 4.3, 
> but as I didn't...
> 
Ok, I'll upgrade to 4.3 & see if that resolves the problem with scrubbing. I was wondering when I compiled the btrfs-tools if there would be a problem with them not being in sync with the major kernel version. 

If this doesn't resolve the problem, what would you recommend my next steps should be?  I've been hesitant to run too many of the btrfs-tools, mainly because I don't want to accidentally screw things up & I don't always know how to interpret the results. (I ran btrfs-debug-tree, hoping something obvious would show up.  Big mistake. 😋)

Thanks for your help!

    -John