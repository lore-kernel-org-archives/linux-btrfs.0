Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:49394 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753329AbcJKQZa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 12:25:30 -0400
Date: Tue, 11 Oct 2016 12:25:07 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs bio linked list corruption.
Message-ID: <20161011162507.5xaldh47ow7mba5m@codemonkey.org.uk>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <d61af3b4-4209-3fee-a201-e7847c340583@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d61af3b4-4209-3fee-a201-e7847c340583@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 11, 2016 at 11:54:09AM -0400, Chris Mason wrote:
 > 
 > 
 > On 10/11/2016 10:45 AM, Dave Jones wrote:
 > > This is from Linus' current tree, with Al's iovec fixups on top.
 > > 
 > > ------------[ cut here ]------------
 > > WARNING: CPU: 1 PID: 3673 at lib/list_debug.c:33 __list_add+0x89/0xb0
 > > list_add corruption. prev->next should be next (ffffe8ffff806648), but was ffffc9000067fcd8. (prev=ffff880503878b80).
 > > CPU: 1 PID: 3673 Comm: trinity-c0 Not tainted 4.8.0-think+ #13 
 > >  ffffc90000d87458 ffffffff8d32007c ffffc90000d874a8 0000000000000000
 > >  ffffc90000d87498 ffffffff8d07a6c1 0000002100000246 ffff88050388e880
 > >  ffff880503878b80 ffffe8ffff806648 ffffe8ffffc06600 ffff880502808008
 > > Call Trace:
 > > [<ffffffff8d32007c>] dump_stack+0x4f/0x73
 > > [<ffffffff8d07a6c1>] __warn+0xc1/0xe0
 > > [<ffffffff8d07a73a>] warn_slowpath_fmt+0x5a/0x80
 > > [<ffffffff8d33e689>] __list_add+0x89/0xb0
 > > [<ffffffff8d30a1c8>] blk_sq_make_request+0x2f8/0x350
 > 
 >        /*                                                                      
 >          * A task plug currently exists. Since this is completely lockless,     
 >          * utilize that to temporarily store requests until the task is         
 >          * either done or scheduled away.                                       
 >          */                                                                     
 >         plug = current->plug;                                                   
 >         if (plug) {                                                             
 >                 blk_mq_bio_to_request(rq, bio);                                 
 >                 if (!request_count)                                             
 >                         trace_block_plug(q);                                    
 >                                                                                 
 >                 blk_mq_put_ctx(data.ctx);                                       
 >                                                                                 
 >                 if (request_count >= BLK_MAX_REQUEST_COUNT) {                   
 >                         blk_flush_plug_list(plug, false);                       
 >                         trace_block_plug(q);                                    
 >                 }                                                               
 >                                                                                 
 >                 list_add_tail(&rq->queuelist, &plug->mq_list);                  
 >                 ^^^^^^^^^^^^^^^^^^^^^^
 > 
 > Dave, is this where we're crashing?  This seems strange.

According to objdump -S ..


ffffffff8130a1b7:       48 8b 70 50             mov    0x50(%rax),%rsi
                list_add_tail(&rq->queuelist, &ctx->rq_list);
ffffffff8130a1bb:       48 8d 50 48             lea    0x48(%rax),%rdx
ffffffff8130a1bf:       48 89 45 a8             mov    %rax,-0x58(%rbp)
ffffffff8130a1c3:       e8 38 44 03 00          callq  ffffffff8133e600 <__list_add>
        blk_mq_hctx_mark_pending(hctx, ctx);
ffffffff8130a1c8:       48 8b 45 a8             mov    -0x58(%rbp),%rax
ffffffff8130a1cc:       4c 89 ff                mov    %r15,%rdi

That looks like the list_add_tail from __blk_mq_insert_req_list

	Dave
