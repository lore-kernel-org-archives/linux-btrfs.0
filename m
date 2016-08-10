Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:36142 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540AbcHJCZl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 22:25:41 -0400
Received: by mail-oi0-f53.google.com with SMTP id f189so42326832oig.3
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Aug 2016 19:25:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <34532105-4411-2a21-a83d-e48f4311400a@techsquare.com>
References: <a70af895-6d3e-3b8a-eeb3-71d6609f8154@techsquare.com>
 <CAJCQCtReDSm46LVVZaiMO3oSRgi9EBQnY9+JkH6Fia1SFH4AWg@mail.gmail.com>
 <CAJCQCtSR6S_RQ5eMjQC9qwifEakme58uw11wHcewiDxqNfq_kw@mail.gmail.com> <34532105-4411-2a21-a83d-e48f4311400a@techsquare.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 9 Aug 2016 20:25:39 -0600
Message-ID: <CAJCQCtRJhvwS2w1iRTxZbQ0tyfDH6Ser1=DBH6w+2Rq4pguf2A@mail.gmail.com>
Subject: Re: BTRFS: error (device sda1) in btrfs_run_delayed_refs:2963:
 errno=-17 Object already exists
To: Matt McKinnon <matt@techsquare.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 9, 2016 at 6:29 PM, Matt McKinnon <matt@techsquare.com> wrote:
> Spoke too soon.  Do I need to continue to run with that mount option in
> place?

It shouldn't be necessary. Something's still wrong for some reason,
even with DUP metadata being CoW'd so someone else is going to have to
speak up what the problem is. And that btrfs check not only doesn't
come up clean but crashes suggests some confluence of things in kernel
4.3 and your hardware conspired to make the file system inconsistent
in a way that isn't immediately recovering the usual way. That is,
usebackuproots working suggests that there's a bug elsewhere in the
storage stack because normally that shouldn't be necessary -
something's happened out of order.

1 size 50.93TiB used 22.67TiB path /dev/sda1

What is the exact nature of this block device?

If getting this back up and running is urgent I suggest inquiring on
IRC what the next steps are.

In the meantime I'd get a btrfs-image (which is probably going to be
quite large given metadata is 60GiB), if that pukes then see if 'btrfs
inspect-internal dump-tree /dev/sda1 > dumptree.log' which may also
fail but before it fails might contain something useful. Obviously
btrfs check shouldn't crash so that's a bug already. What do you get
for free -m? It's known that btrfs check needs a lot of memory and
pretty much all the metadata needs to be read in, so... if you have an
SSD available it might make sense to setup a huge pile of swap on that
SSD and rerun btrfs check.



-- 
Chris Murphy
