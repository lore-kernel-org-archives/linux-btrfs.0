Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49326 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756830AbdELJlH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 May 2017 05:41:07 -0400
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Subject: severe performance regression in generic/027
Message-ID: <f73ca072-3a1d-83ad-12b3-0750429bf765@suse.com>
Date: Fri, 12 May 2017 12:41:04 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

I've been investigating a severe performance regression in generic/027 on 
latest master. Specifically I traced that back to the rm portion of the test. 
rm now takes 4  times longer to delete the same amount of files. After bisecting I 
identified the culprit as being 957780eb2788 ("Btrfs: introduce 
ticketed enospc infrastructure"). With this commit applied rm 
would take 65 seconds to delete around 10k files whereas before 
it would take 15 seconds. I guess this is only triggered in the 
case where there isn't much available metadata space since no one 
has complained so far. 

Further analysis showed that the extra time comes from the fact there 
are a lot more transaction commits happening with the ticketed enosp.
 Here are some stats obtained via systemtap instrumentation of flush_space: 

Good: 
btrfs_trans_commit: 1088
FLUSH_DELAYED_ITEMS_NR => 12281                                                 
FLUSH_DELAYED_ITEMS => 6151                                                     
FLUSH_DELALLOC => 6124                                                          
FLUSH_DELALLOC_WAIT => 6124                                                     
ALLOC_CHUNK => 6124                                                             
COMMIT_TRANS => 1087                                                            

BAD: 
btrfs_trans_commit: 4711                              
FLUSH_DELAYED_ITEMS_NR => 9606                                                  
FLUSH_DELAYED_ITEMS => 4709                                                     
FLUSH_DELALLOC => 4709                                                          
FLUSH_DELALLOC_WAIT => 4709                                                     
ALLOC_CHUNK => 4709                                                             
COMMIT_TRANS => 4709

So we do 4 times more transaction commits. I've also traced the 
2 branches in reserve_metadata_bytes (__reserve_metadata_bytes) respectively, 
and here are the numbers: 

Good: 
Failures: 9383 

Bad:
Failures: 1579

Those numbers count how many times have we took the 
if (ret && flush != BTRFS_RESERVE_NO_FLUSH) {

branch in the good case and how many times we executed 
the 'queue_work' function call in the bad case i.e. the 
numbers of time we have to flush_space. Here are the stack 
traces of btrfs_commit_trans: 

Good:
 0xffffffff81387ca0 : btrfs_commit_transaction+0x0/0xb40 [kernel]
 0xffffffff813726eb : flush_space+0x9b/0x4e0 [kernel]
 0xffffffff81372fe4 : reserve_metadata_bytes+0x2f4/0x710 [kernel]
 0xffffffff81373425 : btrfs_block_rsv_add+0x25/0x60 [kernel]
 0xffffffff81388bd3 : start_transaction+0x3f3/0x570 [kernel]
 0xffffffff813891fa : btrfs_start_transaction_fallback_global_rsv+0x2a/0x200 [kernel]
 0xffffffff81392785 : btrfs_unlink+0x35/0xb0 [kernel]
 0xffffffff811c0e0a : vfs_unlink+0xba/0x1a0 [kernel]
 0xffffffff811c5cdb : do_unlinkat+0x24b/0x2a0 [kernel]
 0xffffffff811c646b : SyS_unlinkat+0x1b/0x30 [kernel]
 0xffffffff816d0b40 : entry_SYSCALL_64_fastpath+0x23/0xc1 [kernel]

Naturally.

Bad: 

 0xffffffff81388b30 : btrfs_commit_transaction+0x0/0xb40 [kernel]
 0xffffffff81372d73 : flush_space+0x93/0x510 [kernel]
 0xffffffff813732f3 : btrfs_async_reclaim_metadata_space+0x103/0x460 [kernel]
 0xffffffff8106d86f : process_one_work+0x1cf/0x660 [kernel]
 0xffffffff8106dd4e : worker_thread+0x4e/0x490 [kernel]
 0xffffffff810745ae : kthread+0xfe/0x120 [kernel]
 0xffffffff816d1c0f : ret_from_fork+0x1f/0x40 [kernel]
 0xffffffff810744b0 : kthread+0x0/0x120 [kernel]

Also no surprises here, since flushing is alway async now. Further breaking 
down which site actually queued the btrfs_async_reclaim_metadata_space 
reveals the following: 

traces[                                                                         
 0xffffffff81373774 : __reserve_metadata_bytes+0x124/0xa80 [kernel]             
 0xffffffff813740f4 : reserve_metadata_bytes+0x24/0x1c0 [kernel]                
 0xffffffff813742b5 : btrfs_block_rsv_add+0x25/0x60 [kernel]                    
 0xffffffff81389a63 : start_transaction+0x3f3/0x570 [kernel]                    
 0xffffffff8138a08a : btrfs_start_transaction_fallback_global_rsv+0x2a/0x200 [kernel]
 0xffffffff81393615 : btrfs_unlink+0x35/0xb0 [kernel]                           
 0xffffffff811c0e0a : vfs_unlink+0xba/0x1a0 [kernel]                            
 0xffffffff811c5cdb : do_unlinkat+0x24b/0x2a0 [kernel]                          
 0xffffffff811c646b : SyS_unlinkat+0x1b/0x30 [kernel]                           
 0xffffffff816d19c0 : entry_SYSCALL_64_fastpath+0x23/0xc1 [kernel]              
] = 3905   

__reserve_metadata_bytes+0x124/0xa80 is the queue_work from the 
if (!ret && space_info->flags & BTRFS_BLOCK_GROUP_METADATA) branch
e.g. when we managed to do our reservation but still would like to 
do preemptive space flushing.


                                                                     
traces[                                                                         
 0xffffffff81373eed : __reserve_metadata_bytes+0x89d/0xa80 [kernel]             
 0xffffffff813740f4 : reserve_metadata_bytes+0x24/0x1c0 [kernel]                
 0xffffffff813742b5 : btrfs_block_rsv_add+0x25/0x60 [kernel]                    
 0xffffffff81389a63 : start_transaction+0x3f3/0x570 [kernel]                    
 0xffffffff8138a08a : btrfs_start_transaction_fallback_global_rsv+0x2a/0x200 [kernel]
 0xffffffff81393615 : btrfs_unlink+0x35/0xb0 [kernel]                           
 0xffffffff811c0e0a : vfs_unlink+0xba/0x1a0 [kernel]                            
 0xffffffff811c5cdb : do_unlinkat+0x24b/0x2a0 [kernel]                          
 0xffffffff811c646b : SyS_unlinkat+0x1b/0x30 [kernel]                           
 0xffffffff816d19c0 : entry_SYSCALL_64_fastpath+0x23/0xc1 [kernel]              
] = 1579

__reserve_metadata_bytes+0x89d/0xa80 this is the queue from the 
if (ret && flush != BTRFS_RESERVE_NO_FLUSH) { branch. E.g. when we 
failed to do our reservation. 

SO with the ticketed ENOSPC we actually have less reservation failures but 
ironically a lot more transaction commits. The end result being slower operations.

I'm also sharing two files which have a lot more debugging by printing
the space_info state during failure to do reservations in both the good 
case (pre enospc ticketed work) and the bad (after ticketed enospc) case: 

good: http://sprunge.us/QBSc
bad: http://sprunge.us/PaNI

I'm running out of ideas where this might be happening or how to further 
debug it. Any pointers would be much appreciated. I've had an off-list 
discussion with Josef re. this and one thing he suggested is that we 
might be hitting the ->failfast in use_block_rsv however in both 
cases that code was never triggered. All measurements have been made
only during the rm portion of the test and not the whole "Create files and 
delete them" phase. 


