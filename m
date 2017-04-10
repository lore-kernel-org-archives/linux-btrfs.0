Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.tu-berlin.de ([130.149.7.33]:37837 "EHLO mail.tu-berlin.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751134AbdDJIhZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 04:37:25 -0400
Message-ID: <1491813428.1899.3.camel@campus.tu-berlin.de>
Subject: Re: BTRFS not mountable, recover won't work
From: Malte Eggers <m.eggers@campus.tu-berlin.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Date: Mon, 10 Apr 2017 10:37:08 +0200
In-Reply-To: <60ea5a28-cdd3-84d6-1dc6-0cbcbc28755c@cn.fujitsu.com>
References: <1491758260.15056.2.camel@campus.tu-berlin.de>
         <60ea5a28-cdd3-84d6-1dc6-0cbcbc28755c@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2017-04-10 at 16:18 +0800, Qu Wenruo wrote:
> 
> At 04/10/2017 01:17 AM, Malte Eggers wrote:
> > Hi,
> > 
> > After suspending and waking up my laptop with the external hard
> > drive
> > connected, I could no longer access the files on it. So I unmounted
> > and
> > remounted it, only to discover that I could no longer mount it.
> > 
> > 
> > This is the error (mounting with usebackuproot, same error
> > without):
> > 
> > [891667.002861] BTRFS info (device dm-0): trying to use backup root
> > at
> > mount time
> > [891667.002870] BTRFS info (device dm-0): disk space caching is
> > enabled
> > [891667.002876] BTRFS info (device dm-0): has skinny extents
> > [891667.016395] BTRFS error (device dm-0): parent transid verify
> > failed
> > on 108855296 wanted 32139 found 32104
> > [891667.017181] BTRFS error (device dm-0): parent transid verify
> > failed
> > on 108855296 wanted 32139 found 32104
> > [891667.017194] BTRFS error (device dm-0): failed to recover
> > balance:
> > -5
> 
> What about trying skip_balance mount option to skip balance
Tried that, same error
> 
> > [891667.078829] BTRFS error (device dm-0): open_ctree failed
> > 
> > 
> > btrfs restore and btrfs-find-root fail like this (on both debian
> > sid
> > and fedora 25):
> > 
> > parent transid verify failed on 108806144 wanted 32139 found 32104
> > parent transid verify failed on 108806144 wanted 32139 found 32104
> > parent transid verify failed on 108806144 wanted 32139 found 32104
> > parent transid verify failed on 108806144 wanted 32139 found 32104
> > Ignoring transid failure
> 
> Would you please paste the output of "btrfs-debug-tree -b 108806144 
> /dev/dm-0" ?
> 
> > volumes.c:1645: btrfs_chunk_readonly: BUG_ON `!ce` triggered, value
> > 1
> 
> This BUG_ON() means we can't find a corresponding chunk for given
> offset.
> 
> "btrfs-debug-tree -t chunk" would help, if it executes without
> problem.
btrfs-debug-tree produces the same error
> 
> If "btrfs-debug-tree" can't even open the fs, then "btrfs 
> inspect-internal dump-super -f /dev/dm-0" would help them.
dump-super finishes as it appears without error: https://pastebin.com/t
i8xuuR5
How would I proceed from here?
> Thanks,
> Qu
Thank you
