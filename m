Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33999 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbcABEtQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jan 2016 23:49:16 -0500
Received: by mail-lf0-f41.google.com with SMTP id y184so253052771lfc.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 20:49:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPgWCbSaorwvW39Y-Uz7j-k97f4jFdkfDTqVK3kt-9-PgrfkTg@mail.gmail.com>
References: <CAPgWCbQ9HS1N=JCbbHuT9yyTz3JPAizA+DvOAR7_GX73CVix0g@mail.gmail.com>
	<pan$1f21$8d293d0$5b6cd545$34c90ade@cox.net>
	<26CBABB7-7744-4833-A37B-C2380304223F@gmail.com>
	<pan$ddf92$7633f36c$14118b68$b87353e3@cox.net>
	<CAPgWCbTntO5q1acH+MkF7QsGUv3wWqqDXKmBy6pJiQU0OFO-Pg@mail.gmail.com>
	<CAPgWCbSaorwvW39Y-Uz7j-k97f4jFdkfDTqVK3kt-9-PgrfkTg@mail.gmail.com>
Date: Fri, 1 Jan 2016 23:49:14 -0500
Message-ID: <CAPgWCbS3Sse-RgWhAMXHw7Q7iBBqUMFzXzK2g3hapXCjTamXtA@mail.gmail.com>
Subject: Re: btrfs scrub failing
From: John Center <jlcenter15@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Last thing for tonight, I tried to run btrfs-debug-tree & direct the
output to a file.  It crashed during the run with the following
errors:

john@mariposa:~$ sudo btrfs-debug-tree /dev/md125p2 >>
/media/data1/btrfs-debug-tree-01012016.txt
parent transid verify failed on 519273742336 wanted 1036426 found 1036428
parent transid verify failed on 519273742336 wanted 1036426 found 1036428
parent transid verify failed on 519273742336 wanted 1036426 found 1036428
parent transid verify failed on 519273742336 wanted 1036426 found 1036428
Ignoring transid failure
parent transid verify failed on 519271792640 wanted 1036425 found 1036428
parent transid verify failed on 519271792640 wanted 1036425 found 1036428
parent transid verify failed on 519271792640 wanted 1036425 found 1036428
parent transid verify failed on 519271792640 wanted 1036425 found 1036428
Ignoring transid failure
parent transid verify failed on 519274119168 wanted 1036426 found 1036428
parent transid verify failed on 519274119168 wanted 1036426 found 1036428
parent transid verify failed on 519274119168 wanted 1036426 found 1036428
parent transid verify failed on 519274119168 wanted 1036426 found 1036428
Ignoring transid failure
parent transid verify failed on 519274135552 wanted 1036426 found 1036428
parent transid verify failed on 519274135552 wanted 1036426 found 1036428
parent transid verify failed on 519274135552 wanted 1036426 found 1036428
parent transid verify failed on 519274135552 wanted 1036426 found 1036428
Ignoring transid failure
print-tree.c:1108: btrfs_print_tree: Assertion failed.
btrfs-debug-tree[0x418d99]
btrfs-debug-tree(btrfs_print_tree+0x2c0)[0x41ad4c]
btrfs-debug-tree(btrfs_print_tree+0x2dc)[0x41ad68]
btrfs-debug-tree(main+0x9a5)[0x432589]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7ff0629ccec5]
btrfs-debug-tree[0x4070e9]

Hopefully this will help the developers.

    -John


On Fri, Jan 1, 2016 at 11:04 PM, John Center <jlcenter15@gmail.com> wrote:
> Hi Duncan,
>
> Doing some more digging, I ran btrfs-image & found the following
> errors.  I'm not sure how useful this is, or what this means in terms
> of the other btrfs-tools messages.  Maybe more clues?
>
> Thanks.
>
>     -John
>
> john@mariposa:~$ sudo btrfs-image -c9 -t4 /dev/md125p2
> /media/data1/btrfs.image-01012016
> WARNING: The device is mounted. Make sure the filesystem is quiescent.
> parent transid verify failed on 337676075008 wanted 1036368 found 1036377
> parent transid verify failed on 337676075008 wanted 1036368 found 1036377
> parent transid verify failed on 337676075008 wanted 1036368 found 1036377
> parent transid verify failed on 337676075008 wanted 1036368 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337674846208 wanted 1036370 found 1036377
> parent transid verify failed on 337674846208 wanted 1036370 found 1036377
> parent transid verify failed on 337674846208 wanted 1036370 found 1036377
> parent transid verify failed on 337674846208 wanted 1036370 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337675403264 wanted 1036370 found 1036377
> parent transid verify failed on 337675403264 wanted 1036370 found 1036377
> parent transid verify failed on 337675403264 wanted 1036370 found 1036377
> parent transid verify failed on 337675403264 wanted 1036370 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337681907712 wanted 1036375 found 1036377
> parent transid verify failed on 337681907712 wanted 1036375 found 1036377
> parent transid verify failed on 337681907712 wanted 1036375 found 1036377
> parent transid verify failed on 337681907712 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337646354432 wanted 1036368 found 1036377
> parent transid verify failed on 337646354432 wanted 1036368 found 1036377
> parent transid verify failed on 337646354432 wanted 1036368 found 1036377
> parent transid verify failed on 337646354432 wanted 1036368 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337679597568 wanted 1036373 found 1036377
> parent transid verify failed on 337679597568 wanted 1036373 found 1036377
> parent transid verify failed on 337679597568 wanted 1036373 found 1036377
> parent transid verify failed on 337679597568 wanted 1036373 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337679613952 wanted 1036373 found 1036377
> parent transid verify failed on 337679613952 wanted 1036373 found 1036377
> parent transid verify failed on 337679613952 wanted 1036373 found 1036377
> parent transid verify failed on 337679613952 wanted 1036373 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337679745024 wanted 1036372 found 1036377
> parent transid verify failed on 337679745024 wanted 1036372 found 1036377
> parent transid verify failed on 337679745024 wanted 1036372 found 1036377
> parent transid verify failed on 337679745024 wanted 1036372 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682022400 wanted 1036369 found 1036377
> parent transid verify failed on 337682022400 wanted 1036369 found 1036377
> parent transid verify failed on 337682022400 wanted 1036369 found 1036377
> parent transid verify failed on 337682022400 wanted 1036369 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337679712256 wanted 1036373 found 1036377
> parent transid verify failed on 337679712256 wanted 1036373 found 1036377
> parent transid verify failed on 337679712256 wanted 1036373 found 1036377
> parent transid verify failed on 337679712256 wanted 1036373 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337647927296 wanted 1036368 found 1036377
> parent transid verify failed on 337647927296 wanted 1036368 found 1036377
> parent transid verify failed on 337647927296 wanted 1036368 found 1036377
> parent transid verify failed on 337647927296 wanted 1036368 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337683251200 wanted 1036372 found 1036377
> parent transid verify failed on 337683251200 wanted 1036372 found 1036377
> parent transid verify failed on 337683251200 wanted 1036372 found 1036377
> parent transid verify failed on 337683251200 wanted 1036372 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337683398656 wanted 1036372 found 1036377
> parent transid verify failed on 337683398656 wanted 1036372 found 1036377
> parent transid verify failed on 337683398656 wanted 1036372 found 1036377
> parent transid verify failed on 337683398656 wanted 1036372 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682432000 wanted 1036369 found 1036377
> parent transid verify failed on 337682432000 wanted 1036369 found 1036377
> parent transid verify failed on 337682432000 wanted 1036369 found 1036377
> parent transid verify failed on 337682432000 wanted 1036369 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337633558528 wanted 1036368 found 1036377
> parent transid verify failed on 337633558528 wanted 1036368 found 1036377
> parent transid verify failed on 337633558528 wanted 1036368 found 1036377
> parent transid verify failed on 337633558528 wanted 1036368 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682513920 wanted 1036371 found 1036377
> parent transid verify failed on 337682513920 wanted 1036371 found 1036377
> parent transid verify failed on 337682513920 wanted 1036371 found 1036377
> parent transid verify failed on 337682513920 wanted 1036371 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337687429120 wanted 1036374 found 1036377
> parent transid verify failed on 337687429120 wanted 1036374 found 1036377
> parent transid verify failed on 337687429120 wanted 1036374 found 1036377
> parent transid verify failed on 337687429120 wanted 1036374 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682300928 wanted 1036375 found 1036377
> parent transid verify failed on 337682300928 wanted 1036375 found 1036377
> parent transid verify failed on 337682300928 wanted 1036375 found 1036377
> parent transid verify failed on 337682300928 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337683775488 wanted 1036372 found 1036377
> parent transid verify failed on 337683775488 wanted 1036372 found 1036377
> parent transid verify failed on 337683775488 wanted 1036372 found 1036377
> parent transid verify failed on 337683775488 wanted 1036372 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337680465920 wanted 1036373 found 1036377
> parent transid verify failed on 337680465920 wanted 1036373 found 1036377
> parent transid verify failed on 337680465920 wanted 1036373 found 1036377
> parent transid verify failed on 337680465920 wanted 1036373 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337680531456 wanted 1036373 found 1036377
> parent transid verify failed on 337680531456 wanted 1036373 found 1036377
> parent transid verify failed on 337680531456 wanted 1036373 found 1036377
> parent transid verify failed on 337680531456 wanted 1036373 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337642536960 wanted 1036370 found 1036377
> parent transid verify failed on 337642536960 wanted 1036370 found 1036377
> parent transid verify failed on 337642536960 wanted 1036370 found 1036377
> parent transid verify failed on 337642536960 wanted 1036370 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337677352960 wanted 1036371 found 1036377
> parent transid verify failed on 337677352960 wanted 1036371 found 1036377
> parent transid verify failed on 337677352960 wanted 1036371 found 1036377
> parent transid verify failed on 337677352960 wanted 1036371 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682448384 wanted 1036375 found 1036377
> parent transid verify failed on 337682448384 wanted 1036375 found 1036377
> parent transid verify failed on 337682448384 wanted 1036375 found 1036377
> parent transid verify failed on 337682448384 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682530304 wanted 1036375 found 1036377
> parent transid verify failed on 337682530304 wanted 1036375 found 1036377
> parent transid verify failed on 337682530304 wanted 1036375 found 1036377
> parent transid verify failed on 337682530304 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682546688 wanted 1036375 found 1036377
> parent transid verify failed on 337682546688 wanted 1036375 found 1036377
> parent transid verify failed on 337682546688 wanted 1036375 found 1036377
> parent transid verify failed on 337682546688 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682563072 wanted 1036375 found 1036377
> parent transid verify failed on 337682563072 wanted 1036375 found 1036377
> parent transid verify failed on 337682563072 wanted 1036375 found 1036377
> parent transid verify failed on 337682563072 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682579456 wanted 1036375 found 1036377
> parent transid verify failed on 337682579456 wanted 1036375 found 1036377
> parent transid verify failed on 337682579456 wanted 1036375 found 1036377
> parent transid verify failed on 337682579456 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682595840 wanted 1036375 found 1036377
> parent transid verify failed on 337682595840 wanted 1036375 found 1036377
> parent transid verify failed on 337682595840 wanted 1036375 found 1036377
> parent transid verify failed on 337682595840 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682612224 wanted 1036375 found 1036377
> parent transid verify failed on 337682612224 wanted 1036375 found 1036377
> parent transid verify failed on 337682612224 wanted 1036375 found 1036377
> parent transid verify failed on 337682612224 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682759680 wanted 1036375 found 1036377
> parent transid verify failed on 337682759680 wanted 1036375 found 1036377
> parent transid verify failed on 337682759680 wanted 1036375 found 1036377
> parent transid verify failed on 337682759680 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682808832 wanted 1036375 found 1036377
> parent transid verify failed on 337682808832 wanted 1036375 found 1036377
> parent transid verify failed on 337682808832 wanted 1036375 found 1036377
> parent transid verify failed on 337682808832 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682874368 wanted 1036375 found 1036377
> parent transid verify failed on 337682874368 wanted 1036375 found 1036377
> parent transid verify failed on 337682874368 wanted 1036375 found 1036377
> parent transid verify failed on 337682874368 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682907136 wanted 1036375 found 1036377
> parent transid verify failed on 337682907136 wanted 1036375 found 1036377
> parent transid verify failed on 337682907136 wanted 1036375 found 1036377
> parent transid verify failed on 337682907136 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682956288 wanted 1036375 found 1036377
> parent transid verify failed on 337682956288 wanted 1036375 found 1036377
> parent transid verify failed on 337682956288 wanted 1036375 found 1036377
> parent transid verify failed on 337682956288 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682972672 wanted 1036375 found 1036377
> parent transid verify failed on 337682972672 wanted 1036375 found 1036377
> parent transid verify failed on 337682972672 wanted 1036375 found 1036377
> parent transid verify failed on 337682972672 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337682989056 wanted 1036375 found 1036377
> parent transid verify failed on 337682989056 wanted 1036375 found 1036377
> parent transid verify failed on 337682989056 wanted 1036375 found 1036377
> parent transid verify failed on 337682989056 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337683005440 wanted 1036375 found 1036377
> parent transid verify failed on 337683005440 wanted 1036375 found 1036377
> parent transid verify failed on 337683005440 wanted 1036375 found 1036377
> parent transid verify failed on 337683005440 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337683054592 wanted 1036375 found 1036377
> parent transid verify failed on 337683054592 wanted 1036375 found 1036377
> parent transid verify failed on 337683054592 wanted 1036375 found 1036377
> parent transid verify failed on 337683054592 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337683070976 wanted 1036375 found 1036377
> parent transid verify failed on 337683070976 wanted 1036375 found 1036377
> parent transid verify failed on 337683070976 wanted 1036375 found 1036377
> parent transid verify failed on 337683070976 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337683087360 wanted 1036375 found 1036377
> parent transid verify failed on 337683087360 wanted 1036375 found 1036377
> parent transid verify failed on 337683087360 wanted 1036375 found 1036377
> parent transid verify failed on 337683087360 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337683136512 wanted 1036375 found 1036377
> parent transid verify failed on 337683136512 wanted 1036375 found 1036377
> parent transid verify failed on 337683136512 wanted 1036375 found 1036377
> parent transid verify failed on 337683136512 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337683333120 wanted 1036375 found 1036377
> parent transid verify failed on 337683333120 wanted 1036375 found 1036377
> parent transid verify failed on 337683333120 wanted 1036375 found 1036377
> parent transid verify failed on 337683333120 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337684938752 wanted 1036375 found 1036377
> parent transid verify failed on 337684938752 wanted 1036375 found 1036377
> parent transid verify failed on 337684938752 wanted 1036375 found 1036377
> parent transid verify failed on 337684938752 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337685790720 wanted 1036375 found 1036377
> parent transid verify failed on 337685790720 wanted 1036375 found 1036377
> parent transid verify failed on 337685790720 wanted 1036375 found 1036377
> parent transid verify failed on 337685790720 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337685823488 wanted 1036375 found 1036377
> parent transid verify failed on 337685823488 wanted 1036375 found 1036377
> parent transid verify failed on 337685823488 wanted 1036375 found 1036377
> parent transid verify failed on 337685823488 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337686315008 wanted 1036375 found 1036377
> parent transid verify failed on 337686315008 wanted 1036375 found 1036377
> parent transid verify failed on 337686315008 wanted 1036375 found 1036377
> parent transid verify failed on 337686315008 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337684987904 wanted 1036369 found 1036377
> parent transid verify failed on 337684987904 wanted 1036369 found 1036377
> parent transid verify failed on 337684987904 wanted 1036369 found 1036377
> parent transid verify failed on 337684987904 wanted 1036369 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337690689536 wanted 1036375 found 1036377
> parent transid verify failed on 337690689536 wanted 1036375 found 1036377
> parent transid verify failed on 337690689536 wanted 1036375 found 1036377
> parent transid verify failed on 337690689536 wanted 1036375 found 1036377
> Ignoring transid failure
> parent transid verify failed on 337687707648 wanted 1036372 found 1036377
> parent transid verify failed on 337687707648 wanted 1036372 found 1036377
> parent transid verify failed on 337687707648 wanted 1036372 found 1036377
> parent transid verify failed on 337687707648 wanted 1036372 found 1036377
> Ignoring transid failure
>
>
>
> On Fri, Jan 1, 2016 at 8:04 PM, John Center <jlcenter15@gmail.com> wrote:
>> Hi Duncan,
>>
>> On Fri, Jan 1, 2016 at 12:05 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>>> John Center posted on Fri, 01 Jan 2016 11:41:20 -0500 as excerpted:
>>>
>>>> If this doesn't resolve the problem, what would you recommend my next
>>>> steps should be?  I've been hesitant to run too many of the btrfs-tools,
>>>> mainly because I don't want to accidentally screw things up & I don't
>>>> always know how to interpret the results. (I ran btrfs-debug-tree,
>>>> hoping something obvious would show up.  Big mistake. 😋)
>>>
>>> LOLed at that debug-tree remark.  Been there (with other tools) myself.
>>>
>>> Well, I'm hoping someone who had the problem can confirm whether it's
>>> fixed in current kernels (scrub is one of those userspace commands that's
>>> mostly just a front-end to the kernel code which does the real work, so
>>> kernel version is the important thing for scrub).  I'm guessing so, and
>>> that you'll find the problem gone in 4.3.
>>>
>>> We'll cross the not-gone bridge if we get to it, but again, if the other
>>> people who had the similar problem can confirm whether it disappeared for
>>> them with the new kernel, it would help a lot, as there were enough such
>>> reports that if it's the same problem and still there for everyone (which
>>> I doubt as I expect there'd still be way more posts about it if so, but
>>> confirmation's always good), nothing to do but wait for a fix, while if
>>> not, and you still have your problem, then it's a different issue and the
>>> devs will need to work with you on a fix specific to your problem.
>>>
>> Ok, I'm at the next bridge. :-(  I upgraded the kernel to 4.4rc7 from
>> the Ubuntu Mainline archive & I just ran the scrub:
>>
>> john@mariposa:~$ sudo /sbin/btrfs scrub start -BdR /dev/md125p2
>> ERROR: scrubbing /dev/md125p2 failed for device id 1: ret=-1, errno=5
>> (Input/output error)
>> scrub device /dev/md125p2 (id 1) canceled
>> scrub started at Fri Jan  1 19:38:21 2016 and was aborted after 00:02:34
>> data_extents_scrubbed: 111031
>> tree_extents_scrubbed: 104061
>> data_bytes_scrubbed: 2549907456
>> tree_bytes_scrubbed: 1704935424
>> read_errors: 0
>> csum_errors: 0
>> verify_errors: 0
>> no_csum: 1573
>> csum_discards: 0
>> super_errors: 0
>> malloc_errors: 0
>> uncorrectable_errors: 0
>> unverified_errors: 0
>> corrected_errors: 0
>> last_physical: 4729667584
>>
>> I checked dmesg & this appeared:
>>
>> [11428.983355] BTRFS error (device md125p2): parent transid verify
>> failed on 241287168 wanted 33554449 found 17
>> [11431.028399] BTRFS error (device md125p2): parent transid verify
>> failed on 241287168 wanted 33554449 found 17
>>
>> Where do I go from here?
>>
>> Thanks for your help.
>>
>>     -John
