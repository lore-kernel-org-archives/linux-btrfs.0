Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.tu-berlin.de ([130.149.7.33]:32678 "EHLO mail.tu-berlin.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752530AbdDJHz7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 03:55:59 -0400
Message-ID: <1491810948.1899.1.camel@campus.tu-berlin.de>
Subject: Re: BTRFS not mountable, recover won't work
From: Malte Eggers <m.eggers@campus.tu-berlin.de>
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Mon, 10 Apr 2017 09:55:48 +0200
In-Reply-To: <CAJCQCtRqidKACy7SAEzpEGLK1PbWQZgbesaLhLEVntMPz9aG5g@mail.gmail.com>
References: <1491758260.15056.2.camel@campus.tu-berlin.de>
         <CAJCQCtRqidKACy7SAEzpEGLK1PbWQZgbesaLhLEVntMPz9aG5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2017-04-09 at 15:25 -0600, Chris Murphy wrote:
> On Sun, Apr 9, 2017 at 11:17 AM, Malte Eggers
> <m.eggers@campus.tu-berlin.de> wrote:
> > Hi,
> > 
> > After suspending and waking up my laptop with the external hard
> > drive
> > connected, I could no longer access the files on it. So I unmounted
> > and
> > remounted it, only to discover that I could no longer mount it.
> 
> What kernel and btrfs-progs version? Anything older than 4.9 of
> either
> and I'd try something newer as a first step. This sounds to me like
> something dropped the ball: either fs freeze didn't happen (unlikely)
> or the drive lied about fsync succeeding, or FUA if supported, and
> dropped the data once power was cut to the drive. I'd check if there
> are firmware updates for the drive.
> 
> Curious about:
> 
> btrfs rescue super -v <dev>
> btrfs check <dev>
> 

Kernel version: 4.9.0-2-amd64
BTRFS version: v4.9.1

btrfs rescue super -v <dev> and btrfs check <dev> both result in the
same error:
parent transid verify failed on 108806144 wanted 32139 found 32104
parent transid verify failed on 108806144 wanted 32139 found 32104
parent transid verify failed on 108806144 wanted 32139 found 32104
parent transid verify failed on 108806144 wanted 32139 found 32104
Ignoring transid failure
volumes.c:1645: btrfs_chunk_readonly: BUG_ON `!ce` triggered, value 1
btrfs(+0x530d5)[0x560ede5090d5]
btrfs(btrfs_chunk_readonly+0x5a)[0x560ede50b3b3]
btrfs(btrfs_read_block_groups+0x1dc)[0x560ede500b0c]
btrfs(btrfs_setup_all_roots+0x336)[0x560ede4fc158]
btrfs(+0x4654c)[0x560ede4fc54c]
btrfs(open_ctree_fs_info+0xd7)[0x560ede4fc673]
btrfs(open_ctree+0x47)[0x560ede4fc6f2]
btrfs(btrfs_recover_superblocks+0x325)[0x560ede4ef051]
btrfs(main+0x12f)[0x560ede4cda6b]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f5e9f69f2b1]
btrfs(_start+0x2a)[0x560ede4cdaaa]
Aborted

I tried using the hard drive on my raspberry pi with raspbian and
kernel version 4.4, it doesn't give me a backtrace, but instead this:
https://pastebin.com/tUxSdysM

Which doesn't look like what is described in https://btrfs.wiki.kernel.
org/index.php/Restore and restoring specifying any of the blocks
doesn't work either.
