Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:53974 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbcJIPMH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Oct 2016 11:12:07 -0400
Date: Sun, 9 Oct 2016 11:11:06 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs_direct_IO oops
Message-ID: <20161009151106.damzuhyjpdzq4x2w@codemonkey.org.uk>
References: <20161008180806.fmpwtw4vcc7lzd36@codemonkey.org.uk>
 <20161008182903.GU19539@ZenIV.linux.org.uk>
 <20161008232008.nouzkd54kiquvpir@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161008232008.nouzkd54kiquvpir@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 08, 2016 at 07:20:08PM -0400, Dave Jones wrote:
 > On Sat, Oct 08, 2016 at 07:29:03PM +0100, Al Viro wrote:
 >  > On Sat, Oct 08, 2016 at 02:08:06PM -0400, Dave Jones wrote:
 >  > > That code: matches this dissembly:
 >  > > 
 >  > >                 for (i = seg + 1; i < iter->nr_segs; i++) {
 >  > 
 >  > *whoa*
 >  > 
 >  > OK, that loop in check_direct_IO() should be done *ONLY* for
 >  > iovec iter - even for a bvec one it's completely bogus, and
 >  > for pipe ones it blows up immediately.
 >  > 
 >  > Sorry, I'd missed that bogosity - replace
 >  >         if (iov_iter_rw(iter) == WRITE)
 >  > 		return 0;
 >  > with
 >  > 	if (iov_iter_rw(iter) != READ || !iter_is_iovec(iter))
 >  > 		return 0;
 >  > in there; that should fix the damn thing.
 > 
 > Yep, seems to do the trick. Have been running the last six hours
 > without seeing it or anything similar since.

Overnight, I did hit another iov related warning..

idx = 0, offset = 0
curbuf = 0, nrbufs = 1, buffers = 16
[ffffffff9fa21100 ffffea00065f6d80 0 4096]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]

WARNING: CPU: 0 PID: 29610 at lib/iov_iter.c:327 sanity+0x102/0x150
CPU: 0 PID: 29610 Comm: trinity-c9 Not tainted 4.8.0-think+ #8 
 ffffc900007b7ae8
 ffffffff9f3e2011
 0000000000000000
 0000000000000000

 ffffffff9fc1e22b
 ffffffff9f3fa2f2
 ffffc900007b7b28
 ffffffff9f08b010

 0000014734c3d60f
 ffffffff9fc1e22b
 0000000000000147
 0000000000000010

Call Trace:
 [<ffffffff9f3e2011>] dump_stack+0x6c/0x9b
 [<ffffffff9f3fa2f2>] ? sanity+0x102/0x150
 [<ffffffff9f08b010>] __warn+0x110/0x130
 [<ffffffff9f08b19c>] warn_slowpath_null+0x2c/0x40
 [<ffffffff9f3fa2f2>] sanity+0x102/0x150
 [<ffffffff9f3fe62e>] copy_page_to_iter+0x2be/0x480
 [<ffffffff9f1932da>] ? pagecache_get_page+0xba/0x4f0
 [<ffffffff9f195b85>] generic_file_read_iter+0x245/0xd30
 [<ffffffff9f2764ed>] generic_file_splice_read+0xfd/0x230
 [<ffffffff9f2763f0>] ? pipe_to_user+0x40/0x40
 [<ffffffff9f275f08>] do_splice_to+0x98/0xd0
 [<ffffffff9f276014>] splice_direct_to_actor+0xd4/0x2c0
 [<ffffffff9f275660>] ? generic_pipe_buf_nosteal+0x10/0x10
 [<ffffffff9f2762c5>] do_splice_direct+0xc5/0x110
 [<ffffffff9f2381c2>] do_sendfile+0x242/0x470
 [<ffffffff9f23929d>] SyS_sendfile64+0x7d/0xf0
 [<ffffffff9f00279f>] do_syscall_64+0x7f/0x200
 [<ffffffff9f9de5cb>] entry_SYSCALL64_slow_path+0x25/0x25
---[ end trace 2c7bd411d4aa0491 ]---

