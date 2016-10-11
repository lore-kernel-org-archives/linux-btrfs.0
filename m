Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50633 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753943AbcJKQZn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 12:25:43 -0400
Subject: Re: btrfs bio linked list corruption.
To: Dave Jones <davej@codemonkey.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
From: Chris Mason <clm@fb.com>
Message-ID: <d61af3b4-4209-3fee-a201-e7847c340583@fb.com>
Date: Tue, 11 Oct 2016 11:54:09 -0400
MIME-Version: 1.0
In-Reply-To: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/11/2016 10:45 AM, Dave Jones wrote:
> This is from Linus' current tree, with Al's iovec fixups on top.
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 3673 at lib/list_debug.c:33 __list_add+0x89/0xb0
> list_add corruption. prev->next should be next (ffffe8ffff806648), but was ffffc9000067fcd8. (prev=ffff880503878b80).
> CPU: 1 PID: 3673 Comm: trinity-c0 Not tainted 4.8.0-think+ #13 
>  ffffc90000d87458 ffffffff8d32007c ffffc90000d874a8 0000000000000000
>  ffffc90000d87498 ffffffff8d07a6c1 0000002100000246 ffff88050388e880
>  ffff880503878b80 ffffe8ffff806648 ffffe8ffffc06600 ffff880502808008
> Call Trace:
> [<ffffffff8d32007c>] dump_stack+0x4f/0x73
> [<ffffffff8d07a6c1>] __warn+0xc1/0xe0
> [<ffffffff8d07a73a>] warn_slowpath_fmt+0x5a/0x80
> [<ffffffff8d33e689>] __list_add+0x89/0xb0
> [<ffffffff8d30a1c8>] blk_sq_make_request+0x2f8/0x350

       /*                                                                      
         * A task plug currently exists. Since this is completely lockless,     
         * utilize that to temporarily store requests until the task is         
         * either done or scheduled away.                                       
         */                                                                     
        plug = current->plug;                                                   
        if (plug) {                                                             
                blk_mq_bio_to_request(rq, bio);                                 
                if (!request_count)                                             
                        trace_block_plug(q);                                    
                                                                                
                blk_mq_put_ctx(data.ctx);                                       
                                                                                
                if (request_count >= BLK_MAX_REQUEST_COUNT) {                   
                        blk_flush_plug_list(plug, false);                       
                        trace_block_plug(q);                                    
                }                                                               
                                                                                
                list_add_tail(&rq->queuelist, &plug->mq_list);                  
                ^^^^^^^^^^^^^^^^^^^^^^

Dave, is this where we're crashing?  This seems strange.

-chris
