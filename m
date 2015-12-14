Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35775 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbbLNRzw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 12:55:52 -0500
Received: by oiai186 with SMTP id i186so28782330oia.2
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 09:55:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <566E2934.1090207@cn.fujitsu.com>
References: <566b0cff.pXiyzYE4dYIOt31+%sivan606@gmail.com> <CAJCQCtTLrGin24rFGdvYV-JcegEgGEE7qK3gAYSd8K_SXFeu=g@mail.gmail.com>
 <566E2934.1090207@cn.fujitsu.com>
From: Ivan Sizov <sivan606@gmail.com>
Date: Mon, 14 Dec 2015 20:55:32 +0300
Message-ID: <CAMG9ccy_Du3WOm_yAak_L8UnuiBCcf=1f4ybGzTUxC5iFJfaiQ@mail.gmail.com>
Subject: Re: Will "btrfs check --repair" fix the mounting problem?
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-12-14 5:28 GMT+03:00 Qu Wenruo <quwenruo@cn.fujitsu.com>:
> Not completely sure, but it may be related to a regression in 4.2.
> The regression it self is already fixed, but is not backported to 4.2 as far
> as I know.
>
> So, I'd recommend to revert to 4.1 and see if things get better.
> Fortunately, btrfs already aborted the transaction before things get worse.

Nothing changed, mount also fails on 4.1.3.


>>> I checked the filesystem extents:
>>>
>>> $ sudo btrfs check --subvol-extents 5 /dev/sda1
>>> Print extent state for subvolume 5 on /dev/sda1
>>> UUID: 6de5c663-bc65-4120-8cf6-5309fd25aa7e
>>> checksum verify failed on 159708168192 found 3659C180 wanted 8EE67C14
>>> checksum verify failed on 159708168192 found 3659C180 wanted 8EE67C14
>>> bytenr mismatch, want=159708168192, have=16968404070778227820
>>> ERROR: while mapping refs: -5
>>> extent_io.c:582: free_extent_buffer: Assertion `eb->refs < 0` failed.
>>> btrfs(+0x51e9e)[0x56283f4bde9e]
>>> btrfs(free_extent_buffer+0xc0)[0x56283f4be9b0]
>>> btrfs(btrfs_free_fs_root+0x11)[0x56283f4aef11]
>>> btrfs(rb_free_nodes+0x21)[0x56283f4d7cc1]
>>> btrfs(close_ctree+0x194)[0x56283f4b0214]
>>> btrfs(cmd_check+0x486)[0x56283f49ace6]
>>> btrfs(main+0x82)[0x56283f47fad2]
>>> /lib64/libc.so.6(__libc_start_main+0xf0)[0x7f8cbea98580]
>>> btrfs(_start+0x29)[0x56283f47fbd9]
>>> $
>
>
> Did you tried it without the '--subvol-extents 5' options?
> And what's the output?

Yes, I tried it. The output is normal, nothing problem found (shows
UUID, then "checking extents" and that's all)!

> And it may be a good idea to run btrfs-find-root -a, trying to find a good
> copy of old btrfs root tree.
> It may cause miracle to make it RW again.

Thanks for advice. "btrfs-find-root -a" is running at the moment. What
should I do after its completion? Should I just try RW mounting of the
found root or it isn't safe?

> +1 for the advice if you just want to use back up things and get back to
> normal life.

I already backed up the most important data (the whole disk space is
1,82 TB). But I want to solve this strange problem.


-- 
Ivan Sizov
