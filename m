From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V2] btrfs: implement delayed inode items operation
Date: Tue, 22 Feb 2011 17:58:20 +0800
Message-ID: <4D6388BC.8050705@cn.fujitsu.com>
References: <4D5CB6B8.2060804@cn.fujitsu.com> <1297991261-sup-6831@think> <4D5E36FC.2050401@cn.fujitsu.com> <1298031538-sup-7751@think> <4D5E6F88.1070005@cn.fujitsu.com> <1298039644-sup-69@think>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
	Ito <t-itoh@jp.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1298039644-sup-69@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 18 Feb 2011 09:35:12 -0500, Chris Mason wrote:
>>>> On Thu, 17 Feb 2011 20:09:00 -0500, Chris Mason wrote:
>>>>> Excerpts from Miao Xie's message of 2011-02-17 00:48:40 -0500:
>>>>>> Compare with Ext3/4, the performance of file creation and deletion on btrfs
>>>>>> is very poor. the reason is that btrfs must do a lot of b+ tree insertions,
>>>>>> such as inode item, directory name item, directory name index and so on.
>>>>>>
>>>>>> If we can do some delayed b+ tree insertion or deletion, we can improve the
>>>>>> performance, so we made this patch which implemented delayed directory name
>>>>>> index insertion/deletion and delayed inode update.
>>>>>
>>>>> This work is really cool, thanks for doing it.  I'm starting a run on
>>>>> this tonight and if all goes well I'll review in detail and try to queue
>>>>> it along with the per-subvolume storage bits for .39.
>>>>
>>>> There is a hang-up problem in this patch, that is the task which does delayed item
>>>> balance and the task which commits the transaction will wait for each other, and
>>>> the filesystem will hang up. This is reported by Tsutomu Itoh.
>>>>
>>>> I have made the third version of this patch, will post it later.
>>>
>>> BUG: spinlock cpu recursion on CPU#2, btrfs-delayed-m/2762
>>>    lock: ffff88004f47bfb0, .magic: dead4ead, .owner: btrfs-delayed-m/2763, .owner_cpu: 2
>>> Pid: 2762, comm: btrfs-delayed-m Not tainted 2.6.38-rc4-josef+ #209
>>> Call Trace:
>>>    [<ffffffff812621f1>] ? spin_bug+0x9c/0xa3
>>>    [<ffffffff8126225b>] ? do_raw_spin_lock+0x63/0x13c
>>>    [<ffffffff815c31c5>] ? _raw_spin_lock+0xe/0x10
>>>    [<ffffffffa004e5e3>] ? btrfs_try_spin_lock+0x2a/0x86 [btrfs]
>>>    [<ffffffffa000ddc1>] ? btrfs_search_slot+0x5dd/0x73d [btrfs]
>>>    [<ffffffffa001e77e>] ? btrfs_lookup_inode+0x2f/0x91 [btrfs]
>>>    [<ffffffff815c21b2>] ? mutex_lock+0x31/0x48
>>>    [<ffffffffa0061ac8>] ? btrfs_update_delayed_inode+0x73/0x11e [btrfs]
>>>    [<ffffffffa0025454>] ? start_transaction+0x19f/0x1e3 [btrfs]
>>>    [<ffffffffa0062026>] ? btrfs_async_run_delayed_node_done+0xd6/0x180 [btrfs]
>>>    [<ffffffff8107c0e9>] ? process_timeout+0x0/0x10
>>>    [<ffffffffa004a44f>] ? worker_loop+0x17e/0x49f [btrfs]
>>>    [<ffffffffa004a2d1>] ? worker_loop+0x0/0x49f [btrfs]
>>>    [<ffffffffa004a2d1>] ? worker_loop+0x0/0x49f [btrfs]
>>>    [<ffffffff81089d9c>] ? kthread+0x82/0x8a
>>>    [<ffffffff810347d4>] ? kernel_thread_helper+0x4/0x10
>>>    [<ffffffff81089d1a>] ? kthread+0x0/0x8a
>>>    [<ffffffff810347d0>] ? kernel_thread_helper+0x0/0x10
>>>
>>>
>>> I hit this one overnight with spinlock debugging on.  Is it the same
>>> problem you've fixed?
>>
>> I haven't hit this bug, could you tell me the reproduce steps?
>
> I just ran dbench 50.  But I have spinlock debugging turned on
> (CONFIG_DEBUG_SPINLOCK).  Looks like the patch probably forgot to unlock
> or release a path, I'll take a quick look.

I got it. I use GFP_NOFS to allocate memory space when holding spin lock.
It may cause the task to sleep. I have fixed it, the new patch is under
test.

Thanks!
Miao

>
> -chris
>

