Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:33934 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752711AbcJJNLb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 09:11:31 -0400
Date: Mon, 10 Oct 2016 09:11:22 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs_direct_IO oops
Message-ID: <20161010131122.cjmoof6yblwl7tak@codemonkey.org.uk>
References: <20161008180806.fmpwtw4vcc7lzd36@codemonkey.org.uk>
 <20161008182903.GU19539@ZenIV.linux.org.uk>
 <20161008232008.nouzkd54kiquvpir@codemonkey.org.uk>
 <20161009151106.damzuhyjpdzq4x2w@codemonkey.org.uk>
 <20161010034356.GY19539@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161010034356.GY19539@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 10, 2016 at 04:43:57AM +0100, Al Viro wrote:
 
 > Very interesting.  Could you slap something like
 > diff --git a/lib/iov_iter.c b/lib/iov_iter.c
 > index 0ce3411..1ef00e7 100644
 > --- a/lib/iov_iter.c
 > +++ b/lib/iov_iter.c
 > @@ -682,8 +682,9 @@ static void pipe_advance(struct iov_iter *i, size_t size)
 >  {
 >  	struct pipe_inode_info *pipe = i->pipe;
 >  	struct pipe_buffer *buf;
 > -	int idx = i->idx;
 > -	size_t off = i->iov_offset;
 > +	int old_idx = idx = i->idx;
 > +	size_t old_off = off = i->iov_offset;
 > +	size_t old_size = size;
 >  	
 >  	if (unlikely(i->count < size))
 >  		size = i->count;
 > @@ -713,6 +714,9 @@ static void pipe_advance(struct iov_iter *i, size_t size)
 >  			pipe->nrbufs--;
 >  		}
 >  	}
 > +	if (!sanity(i))
 > +		printk(KERN_ERR "buggered pipe_advance(%zd) [%d,%zd]",
 > +				old_size, old_idx, old_off);
 >  }
 >  
 >  void iov_iter_advance(struct iov_iter *i, size_t size)
 > 
 > in there and try to reproduce that one?

My compiler choked on that, but I fixed it up. The printk didn't
trigger though..


idx = 0, offset = 0
curbuf = 0, nrbufs = 1, buffers = 16
[ffffffffb9a21100 ffffea00126019c0 0 4096]
[          (null) ffffea0013746440 0 0]
[          (null) ffffea00132956c0 0 0]
[          (null) ffffea0013295700 0 0]
[          (null) ffffea0013295740 0 0]
[          (null) ffffea0013295780 0 0]
[          (null) ffffea00132957c0 0 0]
[          (null) ffffea0013595c00 0 0]
[          (null) ffffea0012b1b6c0 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
[          (null)           (null) 0 0]
------------[ cut here ]------------
WARNING: CPU: 1 PID: 13581 at lib/iov_iter.c:327 sanity+0x102/0x150
CPU: 1 PID: 13581 Comm: trinity-c17 Not tainted 4.8.0-think+ #9 
 ffffc90000963ae8
 ffffffffb93e22d1
 0000000000000000
 0000000000000000

 ffffffffb9c1e1cb
 ffffffffb93fa5b2
 ffffc90000963b28
 ffffffffb908b010

 00000147d43c0e7f
 ffffffffb9c1e1cb
 0000000000000147
 0000000000000010

Call Trace:
 [<ffffffffb93e22d1>] dump_stack+0x6c/0x9b
 [<ffffffffb93fa5b2>] ? sanity+0x102/0x150
 [<ffffffffb908b010>] __warn+0x110/0x130
 [<ffffffffb908b19c>] warn_slowpath_null+0x2c/0x40
 [<ffffffffb93fa5b2>] sanity+0x102/0x150
 [<ffffffffb93fe94e>] copy_page_to_iter+0x2be/0x480
 [<ffffffffb91cc8b1>] ? workingset_activation+0xc1/0x120
 [<ffffffffb91cc7f0>] ? workingset_refault+0x190/0x190
 [<ffffffffb9195b85>] generic_file_read_iter+0x245/0xd30
 [<ffffffffb92764ed>] generic_file_splice_read+0xfd/0x230
 [<ffffffffb92763f0>] ? pipe_to_user+0x40/0x40
 [<ffffffffb9275f08>] do_splice_to+0x98/0xd0
 [<ffffffffb9276014>] splice_direct_to_actor+0xd4/0x2c0
 [<ffffffffb9275660>] ? generic_pipe_buf_nosteal+0x10/0x10
 [<ffffffffb92762c5>] do_splice_direct+0xc5/0x110
 [<ffffffffb92381c2>] do_sendfile+0x242/0x470
 [<ffffffffb923929d>] SyS_sendfile64+0x7d/0xf0
 [<ffffffffb900279f>] do_syscall_64+0x7f/0x200
 [<ffffffffb99de8cb>] entry_SYSCALL64_slow_path+0x25/0x25
---[ end trace 6773f425063b7f84 ]---


