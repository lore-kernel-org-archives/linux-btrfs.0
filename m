Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:53574 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761738AbaGRMNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jul 2014 08:13:06 -0400
Received: by mail-pa0-f50.google.com with SMTP id et14so5328427pad.37
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jul 2014 05:13:05 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: `btrfsck: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flags & 1)' failed.` in `btrfsck`
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <53C90CA8.2000104@aol.de>
Date: Fri, 18 Jul 2014 20:13:04 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <0BC9DE69-A088-4B5A-95F5-DF863C87C803@gmail.com>
References: <53C90CA8.2000104@aol.de>
To: Karl-Philipp Richter <krichter722@aol.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

There are some patches for fsck flighting, they  are integrated  in David's branches.
You can pull from David's latest branch, and see if it helps:

https://github.com/kdave/btrfs-progs  integration-20140704

Have a try and see if it helps anyway.

Thanks,
Wang

> Hi together,
> I'm experiencing the following issues when I invoke `btrfsck` on a
> sparse file image with a GPT and one (the only) btrfs partition attached
> to a loop device
> 
>    $ sudo btrfsck --repair --init-csum-tree --init-extent-tree -b
> /dev/loop0p1
>    Incorrect local backref count on 128510738432 root 5 owner 3849475
> offset 0 found 1 wanted 0 back 0xbab41270
>    backpointer mismatch on [128510738432 4096]
>    ref mismatch on [128510742528 12288] extent item 0, found 1
>    btrfsck: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flags
> & 1)' failed.
> 
>    $ sudo btrfsck --repair --init-csum-tree --init-extent-tree /dev/loop0p1
>    Incorrect local backref count on 128510726144 root 5 owner 3849470
> offset 0 found 1 wanted 0 back 0xbbcb9500
>    backpointer mismatch on [128510726144 12288]
>    ref mismatch on [128510738432 4096] extent item 0, found 1
>    adding new data backref on 128510738432 root 5 owner 3849475 offset
> 0 found 1
>    Backref 128510738432 root 5 owner 3849475 offset 0 num_refs 0 not
> found in extent tree
>    Incorrect local backref count on 128510738432 root 5 owner 3849475
> offset 0 found 1 wanted 0 back 0xbbcb9630
>    backpointer mismatch on [128510738432 4096]
>    ref mismatch on [128510742528 12288] extent item 0, found 1
>    btrfsck: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flags
> & 1)' failed.
> 
>    $ sudo btrfsck --repair /dev/loop0p1
>    Incorrect local backref count on 130861096960 root 5 owner 22733727
> offset 0 found 1 wanted 0 back 0xc7c7d170
>    backpointer mismatch on [130861096960 8192]
>    ref mismatch on [130861105152 8192] extent item 0, found 1
>    btrfsck: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flags
> & 1)' failed.
> 
>    $ sudo btrfsck --repair /dev/loop0p1
>    Backref 130861096960 root 5 owner 22733727 offset 0 num_refs 0 not
> found in extent tree
>    Incorrect local backref count on 130861096960 root 5 owner 22733727
> offset 0 found 1 wanted 0 back 0xc7f31170
>    backpointer mismatch on [130861096960 8192]
>    ref mismatch on [130861105152 8192] extent item 0, found 1
>    btrfsck: extent_io.c:612: free_extent_buffer: Assertion `!(eb->flags
> & 1)' failed.
> 
> I'm using `btrfs-progs` 24cf4d8c3ee924b474f68514e0167cc2e602a48d on
> Linux 3.16-rc5 (anything else, i.e. older versions, give me immediate
> error after start because errornous file system)
> 
> I'd like to know whether this (assertion) error is related to a bug or
> missing feature in btrfs-progs and might be fixed at some point or
> whether this might indicate a completely messed up btrfs.
> 
> Best regards,
> Karl-P. Richter
> 

