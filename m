Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:50915 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754749Ab2HIGmE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2012 02:42:04 -0400
Message-ID: <50235BB8.7080000@gmx.net>
Date: Thu, 09 Aug 2012 08:42:00 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs panic in 3.5.0
References: <20120807174047.GE24635@merlins.org> <50215AFF.1080800@gmx.net> <20120807184736.GA22686@merlins.org> <20120809025211.GA12014@merlins.org>
In-Reply-To: <20120809025211.GA12014@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09.08.2012 04:52, Marc MERLIN wrote:
> On Tue, Aug 07, 2012 at 11:47:36AM -0700, Marc MERLIN wrote:
>> On Tue, Aug 07, 2012 at 08:14:23PM +0200, Arne Jansen wrote:
>>> On 08/07/2012 07:40 PM, Marc MERLIN wrote:
>>>> Unfortunately I only have a screenshot.
>>>>
>>>> Apparently the panic was in 
>>>> btrfs_set_lock_blocking_rw
>>>> with a RIP in btrfs_cow_block
>>>
>>> Can you please resolve btrfs_cow_block+0x3b to a line number?
>>>
>>> gdb btrfs.ko
>>> (gdb) info line *btrfs_cow_block+0x3b
>>
>> So, I'm not very good at this, sorry if I'm doing it wrong:
>> gandalfthegreat:~# gdb /lib/modules/3.5.0-amd64-preempt-noide-20120410/kernel/fs/btrfs/btrfs.ko
>> Reading symbols from /lib/modules/3.5.0-amd64-preempt-noide-20120410/kernel/fs/btrfs/btrfs.ko...(no debugging symbols found)...done.
>> (gdb) info line *btrfs_cow_block+0x3b
>> No line number information available for address 0x9a6e
>>
>> Mmmh, it seems that I'm missing a kernel option that adds symbols in modules?
>>
>> I can add it for my next kernel compile. Do you have the config option name
>> off hand?
>>
>> I put my module here if that helps:
>> http://marc.merlins.org/tmp/btrfs.ko
> 
> I felt bad for having a kernel without debug symbols it seems, so I looked
> at my kernel config and I do have:
> CONFIG_DEBUG_BUGVERBOSE=y
> CONFIG_DEBUG_INFO=y
> # CONFIG_DEBUG_INFO_REDUCED is not set
> 
> Any idea what else I'm missing to provide better debug info if I have a
> problem again?
> 
> And is it reasonably easy to take the .ko apparently without line numbers,
> like the one I gave you, and infer the line of code for a function offset?

The .ko is fine. It crashes here:

noinline int btrfs_cow_block(struct btrfs_trans_handle *trans,
                    struct btrfs_root *root, struct extent_buffer *buf,
                    struct extent_buffer *parent, int parent_slot,
                    struct extent_buffer **cow_ret)
{
        u64 search_start;
        int ret;

        if (trans->transaction != root->fs_info->running_transaction) {
                printk(KERN_CRIT "trans %llu running %llu\n",
                       (unsigned long long)trans->transid,
                       (unsigned long long)
                       root->fs_info->running_transaction->transid);
                                                          ^^

                WARN_ON(1);
        }

fs_info->running_transaction is probably NULL.


> 
> Thanks,
> Marc

