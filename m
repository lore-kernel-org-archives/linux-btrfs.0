Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52064 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932945AbbLOBmx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 20:42:53 -0500
Subject: Re: Will "btrfs check --repair" fix the mounting problem?
To: Ivan Sizov <sivan606@gmail.com>
References: <566b0cff.pXiyzYE4dYIOt31+%sivan606@gmail.com>
 <CAJCQCtTLrGin24rFGdvYV-JcegEgGEE7qK3gAYSd8K_SXFeu=g@mail.gmail.com>
 <566E2934.1090207@cn.fujitsu.com>
 <CAMG9ccy_Du3WOm_yAak_L8UnuiBCcf=1f4ybGzTUxC5iFJfaiQ@mail.gmail.com>
CC: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <566F7007.4040503@cn.fujitsu.com>
Date: Tue, 15 Dec 2015 09:42:31 +0800
MIME-Version: 1.0
In-Reply-To: <CAMG9ccy_Du3WOm_yAak_L8UnuiBCcf=1f4ybGzTUxC5iFJfaiQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Ivan Sizov wrote on 2015/12/14 20:55 +0300:
> 2015-12-14 5:28 GMT+03:00 Qu Wenruo <quwenruo@cn.fujitsu.com>:
>> Not completely sure, but it may be related to a regression in 4.2.
>> The regression it self is already fixed, but is not backported to 4.2 as far
>> as I know.
>>
>> So, I'd recommend to revert to 4.1 and see if things get better.
>> Fortunately, btrfs already aborted the transaction before things get worse.
>
> Nothing changed, mount also fails on 4.1.3.
>
>
>>>> I checked the filesystem extents:
>>>>
>>>> $ sudo btrfs check --subvol-extents 5 /dev/sda1
>>>> Print extent state for subvolume 5 on /dev/sda1
>>>> UUID: 6de5c663-bc65-4120-8cf6-5309fd25aa7e
>>>> checksum verify failed on 159708168192 found 3659C180 wanted 8EE67C14
>>>> checksum verify failed on 159708168192 found 3659C180 wanted 8EE67C14
>>>> bytenr mismatch, want=159708168192, have=16968404070778227820
>>>> ERROR: while mapping refs: -5
>>>> extent_io.c:582: free_extent_buffer: Assertion `eb->refs < 0` failed.
>>>> btrfs(+0x51e9e)[0x56283f4bde9e]
>>>> btrfs(free_extent_buffer+0xc0)[0x56283f4be9b0]
>>>> btrfs(btrfs_free_fs_root+0x11)[0x56283f4aef11]
>>>> btrfs(rb_free_nodes+0x21)[0x56283f4d7cc1]
>>>> btrfs(close_ctree+0x194)[0x56283f4b0214]
>>>> btrfs(cmd_check+0x486)[0x56283f49ace6]
>>>> btrfs(main+0x82)[0x56283f47fad2]
>>>> /lib64/libc.so.6(__libc_start_main+0xf0)[0x7f8cbea98580]
>>>> btrfs(_start+0x29)[0x56283f47fbd9]
>>>> $
>>
>>
>> Did you tried it without the '--subvol-extents 5' options?
>> And what's the output?
>
> Yes, I tried it. The output is normal, nothing problem found (shows
> UUID, then "checking extents" and that's all)!

Then, it means it hit an assertion and no backtrace support is compiled.
So I consider that's the same with your backtrace.

>
>> And it may be a good idea to run btrfs-find-root -a, trying to find a good
>> copy of old btrfs root tree.
>> It may cause miracle to make it RW again.
>
> Thanks for advice. "btrfs-find-root -a" is running at the moment. What
> should I do after its completion? Should I just try RW mounting of the
> found root or it isn't safe?

You'll see output like the following:
Well block 29491200(gen: 5 level: 0) seems good, and it matches superblock
Well block 29376512(gen: 4 level: 0) seems good, but generation/level 
doesn't match, want gen: 5 level: 0

The match one is not what you're looking for.
Try the one whose generation is a little smaller than match one.

Then use btrfsck to test if it's OK:
$ btrfsck -r <BYTENR> /dev/sda1

Try 2~5 times with bytenr whose generation is near the match one.
If you're in good luck, you will find one doesn't crash btrfsck.

And if that doesn't produce much error, then you can try btrfsck 
--repair -r <BYTENR> to fix it and try mount.

>
>> +1 for the advice if you just want to use back up things and get back to
>> normal life.
>
> I already backed up the most important data (the whole disk space is
> 1,82 TB). But I want to solve this strange problem.

At least the direct cause is quite straightforward:

 >>>> checksum verify failed on 159708168192 found 3659C180 wanted 8EE67C14
 >>>> checksum verify failed on 159708168192 found 3659C180 wanted 8EE67C14
 >>>> bytenr mismatch, want=159708168192, have=16968404070778227820

The tree block at bytenr 159708168192 is damaged.
Its csum mismatched, and bytenr doesn't match either.
Maybe the tree is damaged.
(And apparently, btrfs abort transaction didn't do its job well)

But hard to find out the root cause though.


If you still want to try btrfs converted from ext*, I'd recommend to use 
next release of btrfs-progs, and kernel 4.4 or 4.1.

Thanks,
Qu



