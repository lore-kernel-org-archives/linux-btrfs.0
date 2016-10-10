Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:35194 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750855AbcJJDoK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Oct 2016 23:44:10 -0400
Date: Mon, 10 Oct 2016 04:43:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs_direct_IO oops
Message-ID: <20161010034356.GY19539@ZenIV.linux.org.uk>
References: <20161008180806.fmpwtw4vcc7lzd36@codemonkey.org.uk>
 <20161008182903.GU19539@ZenIV.linux.org.uk>
 <20161008232008.nouzkd54kiquvpir@codemonkey.org.uk>
 <20161009151106.damzuhyjpdzq4x2w@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161009151106.damzuhyjpdzq4x2w@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 09, 2016 at 11:11:06AM -0400, Dave Jones wrote:
> idx = 0, offset = 0

== starts at slot 0, nothing put into it yet, but

> curbuf = 0, nrbufs = 1, buffers = 16
> [ffffffff9fa21100 ffffea00065f6d80 0 4096]

the underlying pipe has something stored into slot 0.  That definitely
should not happen.

> WARNING: CPU: 0 PID: 29610 at lib/iov_iter.c:327 sanity+0x102/0x150
> CPU: 0 PID: 29610 Comm: trinity-c9 Not tainted 4.8.0-think+ #8 
>  ffffc900007b7ae8
>  ffffffff9f3e2011
>  0000000000000000
>  0000000000000000

>  ffffffff9fc1e22b
>  ffffffff9f3fa2f2
>  ffffc900007b7b28
>  ffffffff9f08b010
> 
>  0000014734c3d60f
>  ffffffff9fc1e22b
>  0000000000000147
>  0000000000000010

*blink*

where have those come from?
 
> Call Trace:
>  [<ffffffff9f3e2011>] dump_stack+0x6c/0x9b
>  [<ffffffff9f3fa2f2>] ? sanity+0x102/0x150
>  [<ffffffff9f08b010>] __warn+0x110/0x130
>  [<ffffffff9f08b19c>] warn_slowpath_null+0x2c/0x40
>  [<ffffffff9f3fa2f2>] sanity+0x102/0x150
>  [<ffffffff9f3fe62e>] copy_page_to_iter+0x2be/0x480
>  [<ffffffff9f1932da>] ? pagecache_get_page+0xba/0x4f0
>  [<ffffffff9f195b85>] generic_file_read_iter+0x245/0xd30
>  [<ffffffff9f2764ed>] generic_file_splice_read+0xfd/0x230
>  [<ffffffff9f2763f0>] ? pipe_to_user+0x40/0x40
>  [<ffffffff9f275f08>] do_splice_to+0x98/0xd0
>  [<ffffffff9f276014>] splice_direct_to_actor+0xd4/0x2c0
>  [<ffffffff9f275660>] ? generic_pipe_buf_nosteal+0x10/0x10
>  [<ffffffff9f2762c5>] do_splice_direct+0xc5/0x110
>  [<ffffffff9f2381c2>] do_sendfile+0x242/0x470
>  [<ffffffff9f23929d>] SyS_sendfile64+0x7d/0xf0
>  [<ffffffff9f00279f>] do_syscall_64+0x7f/0x200
>  [<ffffffff9f9de5cb>] entry_SYSCALL64_slow_path+0x25/0x25
> ---[ end trace 2c7bd411d4aa0491 ]---

Very interesting.  Could you slap something like
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 0ce3411..1ef00e7 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -682,8 +682,9 @@ static void pipe_advance(struct iov_iter *i, size_t size)
 {
 	struct pipe_inode_info *pipe = i->pipe;
 	struct pipe_buffer *buf;
-	int idx = i->idx;
-	size_t off = i->iov_offset;
+	int old_idx = idx = i->idx;
+	size_t old_off = off = i->iov_offset;
+	size_t old_size = size;
 	
 	if (unlikely(i->count < size))
 		size = i->count;
@@ -713,6 +714,9 @@ static void pipe_advance(struct iov_iter *i, size_t size)
 			pipe->nrbufs--;
 		}
 	}
+	if (!sanity(i))
+		printk(KERN_ERR "buggered pipe_advance(%zd) [%d,%zd]",
+				old_size, old_idx, old_off);
 }
 
 void iov_iter_advance(struct iov_iter *i, size_t size)

in there and try to reproduce that one?
