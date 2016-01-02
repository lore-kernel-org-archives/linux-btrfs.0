Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:36542 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbcABBEp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jan 2016 20:04:45 -0500
Received: by mail-lb0-f172.google.com with SMTP id oh2so138500564lbb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 17:04:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$ddf92$7633f36c$14118b68$b87353e3@cox.net>
References: <CAPgWCbQ9HS1N=JCbbHuT9yyTz3JPAizA+DvOAR7_GX73CVix0g@mail.gmail.com>
	<pan$1f21$8d293d0$5b6cd545$34c90ade@cox.net>
	<26CBABB7-7744-4833-A37B-C2380304223F@gmail.com>
	<pan$ddf92$7633f36c$14118b68$b87353e3@cox.net>
Date: Fri, 1 Jan 2016 20:04:43 -0500
Message-ID: <CAPgWCbTntO5q1acH+MkF7QsGUv3wWqqDXKmBy6pJiQU0OFO-Pg@mail.gmail.com>
Subject: Re: btrfs scrub failing
From: John Center <jlcenter15@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Duncan,

On Fri, Jan 1, 2016 at 12:05 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> John Center posted on Fri, 01 Jan 2016 11:41:20 -0500 as excerpted:
>
>> If this doesn't resolve the problem, what would you recommend my next
>> steps should be?  I've been hesitant to run too many of the btrfs-tools,
>> mainly because I don't want to accidentally screw things up & I don't
>> always know how to interpret the results. (I ran btrfs-debug-tree,
>> hoping something obvious would show up.  Big mistake. 😋)
>
> LOLed at that debug-tree remark.  Been there (with other tools) myself.
>
> Well, I'm hoping someone who had the problem can confirm whether it's
> fixed in current kernels (scrub is one of those userspace commands that's
> mostly just a front-end to the kernel code which does the real work, so
> kernel version is the important thing for scrub).  I'm guessing so, and
> that you'll find the problem gone in 4.3.
>
> We'll cross the not-gone bridge if we get to it, but again, if the other
> people who had the similar problem can confirm whether it disappeared for
> them with the new kernel, it would help a lot, as there were enough such
> reports that if it's the same problem and still there for everyone (which
> I doubt as I expect there'd still be way more posts about it if so, but
> confirmation's always good), nothing to do but wait for a fix, while if
> not, and you still have your problem, then it's a different issue and the
> devs will need to work with you on a fix specific to your problem.
>
Ok, I'm at the next bridge. :-(  I upgraded the kernel to 4.4rc7 from
the Ubuntu Mainline archive & I just ran the scrub:

john@mariposa:~$ sudo /sbin/btrfs scrub start -BdR /dev/md125p2
ERROR: scrubbing /dev/md125p2 failed for device id 1: ret=-1, errno=5
(Input/output error)
scrub device /dev/md125p2 (id 1) canceled
scrub started at Fri Jan  1 19:38:21 2016 and was aborted after 00:02:34
data_extents_scrubbed: 111031
tree_extents_scrubbed: 104061
data_bytes_scrubbed: 2549907456
tree_bytes_scrubbed: 1704935424
read_errors: 0
csum_errors: 0
verify_errors: 0
no_csum: 1573
csum_discards: 0
super_errors: 0
malloc_errors: 0
uncorrectable_errors: 0
unverified_errors: 0
corrected_errors: 0
last_physical: 4729667584

I checked dmesg & this appeared:

[11428.983355] BTRFS error (device md125p2): parent transid verify
failed on 241287168 wanted 33554449 found 17
[11431.028399] BTRFS error (device md125p2): parent transid verify
failed on 241287168 wanted 33554449 found 17

Where do I go from here?

Thanks for your help.

    -John
