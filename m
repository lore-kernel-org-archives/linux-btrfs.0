Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36679 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753427AbdDZR2A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Apr 2017 13:28:00 -0400
Subject: Re: [PULL] Btrfs, updates for 4.12
To: <fdmanana@gmail.com>, David Sterba <dsterba@suse.com>
References: <cover.1492601450.git.dsterba@suse.com>
 <CAL3q7H6dNZ1SShz6iaHYeqMQ+PCAKPzetMuRm+8MVA-8h2E0MA@mail.gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <90cd8455-c226-799e-bab3-3d55b59d3db3@fb.com>
Date: Wed, 26 Apr 2017 13:26:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6dNZ1SShz6iaHYeqMQ+PCAKPzetMuRm+8MVA-8h2E0MA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/26/2017 11:06 AM, Filipe Manana wrote:
 
> Hi,
> 
> Did you actually ran xfstests with those readahead patches to
> preallocate radix tree nodes?
> 
> With those 2 patches applied (Chris' for-linus.4,12 branch) this
> breaks things and many btrfs specific tests (at least, since I can't
> get pass them) result in tons of traces like the following in a debug
> kernel:
> 
> [ 8180.696804] BUG: sleeping function called from invalid context at
> mm/slab.h:432
> [ 8180.703584] in_atomic(): 1, irqs_disabled(): 0, pid: 28583, name: btrfs
> [ 8180.724146] 2 locks held by btrfs/28583:
> [ 8180.726427]  #0:  (sb_writers#12){.+.+.+}, at: [<ffffffff811c1e33>]
> mnt_want_write_file+0x25/0x4d
> [ 8180.736742]  #1:  (&(&fs_info->reada_lock)->rlock){+.+.+.}, at:
> [<ffffffffa02306eb>] reada_add_block+0x2fe/0x6cd [btrfs]
> [ 8180.766321] Preemption disabled at:
> [ 8180.766326] [<ffffffff8107ac54>] preempt_count_add+0x65/0x68
> [ 8180.794837] CPU: 5 PID: 28583 Comm: btrfs Tainted: G        W
> 4.11.0-rc8-btrfs-next-39+ #1
> [ 8180.798818] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
> [ 8180.798818] Call Trace:
> [ 8180.798818]  dump_stack+0x68/0x92
> [ 8180.798818]  ? preempt_count_add+0x65/0x68
> [ 8180.798818]  ___might_sleep+0x20f/0x226
> [ 8180.798818]  __might_sleep+0x77/0x7e
> [ 8180.798818]  slab_pre_alloc_hook+0x32/0x4f
> [ 8180.798818]  kmem_cache_alloc+0x39/0x233
> [ 8180.798818]  ? radix_tree_node_alloc.constprop.12+0x9d/0xdf
> [ 8180.798818]  radix_tree_node_alloc.constprop.12+0x9d/0xdf
> [ 8180.798818]  __radix_tree_create+0xc3/0x143
> [ 8180.798818]  __radix_tree_insert+0x32/0xc0
> [ 8180.798818]  reada_add_block+0x318/0x6cd [btrfs]

So radix_tree_preload doesn't work the way I thought it did.  It populates a 
per-cpu pool of radix tree nodes so the allocation is sure not to fail.

But, when we go to actually allocate the node during radix_tree_insert:


static struct radix_tree_node *                                                 
radix_tree_node_alloc(gfp_t gfp_mask, struct radix_tree_node *parent,           
                        struct radix_tree_root *root,                           
                        unsigned int shift, unsigned int offset,                
                        unsigned int count, unsigned int exceptional)           
{                                                                               
        struct radix_tree_node *ret = NULL;                                     
                                                                                
        /*                                                                      
         * Preload code isn't irq safe and it doesn't make sense to use         
         * preloading during an interrupt anyway as all the allocations have    
         * to be atomic. So just do normal allocation when in interrupt.        
         */                                                                     
        if (!gfpflags_allow_blocking(gfp_mask) && !in_interrupt()) {            
                struct radix_tree_preload *rtp;                                 
                                                                                
                /*                                                              
                 * Even if the caller has preloaded, try to allocate from the   
                 * cache first for the new node to get accounted to the memory  
                 * cgroup.                                                      
                 */                                                             
                ret = kmem_cache_alloc(radix_tree_node_cachep,                  
                                       gfp_mask | __GFP_NOWARN);                
                if (ret)                                                        
                        goto out;                                               
                                                                                
                /*                                                              
                 * Provided the caller has preloaded here, we will always       
                 * succeed in getting a node here (and never reach              
                 * kmem_cache_alloc)                                            
                 */                                                             
                rtp = this_cpu_ptr(&radix_tree_preloads);                       
                if (rtp->nr) {                                                  
                        ret = rtp->nodes;                                       
                        rtp->nodes = ret->parent;                               
                        rtp->nr--;                                              
                }                                                               
                /*                                                              
                 * Update the allocation stack trace as this is more useful     
                 * for debugging.                                               
                 */                                                             
                kmemleak_update_trace(ret);                                     
                goto out;                                                       
        }                                                                       
        ret = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask);

We only jump into the preload pool if our gfp_mask for the root doesn't
allow blocking.  And even if we don't allow blocking we'll still hit the
pool as a last resort.

So I think the right answer is to keep the sleeping flag off the root and
also keep the preload GFP_KERNEL.

-chris


