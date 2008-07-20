From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: New data=ordered code pushed out to btrfs-unstable
Date: Sun, 20 Jul 2008 09:46:51 -0400
Message-ID: <488341CB.1010007@redhat.com>
References: <1216398992.6932.36.camel@think.oraclecorp.com>	 <4880F87B.7020908@gmail.com>	 <1216411969.6932.70.camel@think.oraclecorp.com>	 <48811ABF.5010606@gmail.com>	 <1216428331.6932.82.camel@think.oraclecorp.com>	 <48832D42.6030204@redhat.com> <1216560741.6932.83.camel@think.oraclecorp.com>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090405040208070202050004"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216560741.6932.83.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090405040208070202050004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Chris Mason wrote:
> On Sun, 2008-07-20 at 08:19 -0400, Ric Wheeler wrote:
>   
>> Chris Mason wrote:
>>     
>>> On Fri, 2008-07-18 at 18:35 -0400, Ric Wheeler wrote:
>>>   
>>>       
>>>> Chris Mason wrote:
>>>>     
>>>>         
>>>>> On Fri, 2008-07-18 at 16:09 -0400, Ric Wheeler wrote:
>>>>>
>>>>>       
>>>>>           
>>>>>> Just to kick the tires, I tried the same test that I ran last week on 
>>>>>> ext4. Everything was going great, I decided to kill it after 6 million 
>>>>>> files or so and restart.
>>>>>>         
>>>>>>             
>>> Well, it looks like I neglected to push all the changesets, especially
>>> the last one that made it less racey.  So, I've just done another push,
>>> sorry.  For the fs_mark workload, it shouldn't change anything.
>>>
>>> This code still hasn't really survived an overnight run, hopefully this
>>> commit will.
>>>
>>> -chris
>>>
>>>
>>>   
>>>       
>> The test is still running, but slowly, with a (slow) stream of messages 
>> about:
>>
>>     
>
> Could you please grab the sysrq-w if this is still running?
>
> -chris
>
>
>   
Attached....

ric



--------------090405040208070202050004
Content-Type: text/plain;
 name="btrsf_sysrq_w.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="btrsf_sysrq_w.txt"

Jul 20 09:44:02 localhost kernel: btrfs         D ffffffff8129c5b0     0   454      2
Jul 20 09:44:02 localhost kernel:  ffff810036d3f890 0000000000000046 0000000000000000 ffff81003edf61e0
Jul 20 09:44:02 localhost kernel:  ffff81003edf61f0 ffffffff814b2280 ffffffff814b2280 0000000000000204
Jul 20 09:44:02 localhost kernel:  0000000000000001 ffff810025950000 ffff81003fac5980 ffff810025950350
Jul 20 09:44:02 localhost kernel: Call Trace:
Jul 20 09:44:02 localhost kernel:  [<ffffffff81011a3d>] ? read_tsc+0x9/0x1c
Jul 20 09:44:02 localhost kernel:  [<ffffffff8127f7ea>] io_schedule+0x63/0xa5
Jul 20 09:44:02 localhost kernel:  [<ffffffff810756ad>] sync_page+0x3c/0x40
Jul 20 09:44:02 localhost kernel:  [<ffffffff8127fbdf>] __wait_on_bit_lock+0x45/0x79
Jul 20 09:44:02 localhost kernel:  [<ffffffff81075671>] ? sync_page+0x0/0x40
Jul 20 09:44:02 localhost kernel:  [<ffffffff8107565d>] __lock_page+0x63/0x6a
Jul 20 09:44:02 localhost kernel:  [<ffffffff81046444>] ? wake_bit_function+0x0/0x2a
Jul 20 09:44:02 localhost kernel:  [<ffffffff810758a5>] find_lock_page+0x66/0x93
Jul 20 09:44:02 localhost kernel:  [<ffffffff81076167>] find_or_create_page+0x27/0x79
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0514900>] :btrfs:alloc_extent_buffer+0xee/0x23b
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04ffc3b>] :btrfs:read_tree_block+0x37/0x62
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04f5db1>] :btrfs:btrfs_search_slot+0x179b/0x18d7
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04fdb3d>] :btrfs:btrfs_lookup_file_extent+0x38/0x3a
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0509231>] :btrfs:btrfs_drop_extents+0xd4/0xa8c
Jul 20 09:44:02 localhost kernel:  [<ffffffff8102a42d>] ? wake_up_process+0x10/0x12
Jul 20 09:44:02 localhost kernel:  [<ffffffff812800c4>] ? __mutex_unlock_slowpath+0x31/0x39
Jul 20 09:44:02 localhost kernel:  [<ffffffff8127fd88>] ? mutex_unlock+0xe/0x10
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04f6ec1>] ? :btrfs:maybe_unlock_mutex+0x29/0x2b
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04fae36>] ? :btrfs:btrfs_alloc_reserved_extent+0x56/0x67
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0512106>] ? :btrfs:btrfs_lookup_ordered_extent+0x139/0x148
Jul 20 09:44:02 localhost kernel:  [<ffffffffa05063a9>] :btrfs:btrfs_finish_ordered_io+0x14c/0x2a8
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0506666>] :btrfs:btrfs_writepage_end_io_hook+0x10/0x12
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0516b62>] :btrfs:end_bio_extent_writepage+0xbe/0x28d
Jul 20 09:44:02 localhost kernel:  [<ffffffff810c6f5d>] bio_endio+0x2b/0x2d
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0500d19>] :btrfs:end_workqueue_fn+0x103/0x110
Jul 20 09:44:02 localhost kernel:  [<ffffffffa051b43c>] :btrfs:worker_loop+0x63/0x13e
Jul 20 09:44:02 localhost kernel:  [<ffffffffa051b3d9>] ? :btrfs:worker_loop+0x0/0x13e
Jul 20 09:44:02 localhost kernel:  [<ffffffff810460e3>] kthread+0x49/0x76
Jul 20 09:44:02 localhost kernel:  [<ffffffff8100cda8>] child_rip+0xa/0x12
Jul 20 09:44:02 localhost kernel:  [<ffffffff8104609a>] ? kthread+0x0/0x76
Jul 20 09:44:02 localhost kernel:  [<ffffffff8100cd9e>] ? child_rip+0x0/0x12
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: btrfs-cleaner D ffffffff8129c5b0     0   456      2
Jul 20 09:44:02 localhost kernel:  ffff81003d959a10 0000000000000046 0000000000000000 ffff8100154bdea0
Jul 20 09:44:02 localhost kernel:  ffff8100154bdea0 ffffffff814b2280 ffffffff814b2280 0000000000000002
Jul 20 09:44:02 localhost kernel:  0000000000000034 ffff810025952cc0 ffff81003fb62cc0 ffff810025953010
Jul 20 09:44:02 localhost kernel: Call Trace:
Jul 20 09:44:02 localhost kernel:  [<ffffffff8127ff47>] __mutex_lock_slowpath+0x6b/0xa2
Jul 20 09:44:02 localhost kernel:  [<ffffffff8127fdd2>] mutex_lock+0x2f/0x33
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04f6e96>] :btrfs:maybe_lock_mutex+0x29/0x2b
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04fabbd>] :btrfs:btrfs_alloc_extent+0x31/0xa8
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04fac9e>] :btrfs:btrfs_alloc_free_block+0x6a/0x1ac
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04f08e3>] :btrfs:__btrfs_cow_block+0x19b/0x6cb
Jul 20 09:44:02 localhost kernel:  [<ffffffffa05140dc>] ? :btrfs:__free_extent_buffer+0x41/0x46
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04f1552>] :btrfs:btrfs_cow_block+0x1a9/0x1b8
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04f47eb>] :btrfs:btrfs_search_slot+0x1d5/0x18d7
Jul 20 09:44:02 localhost kernel:  [<ffffffffa050b48b>] ? :btrfs:btrfs_node_key+0x7f/0x87
Jul 20 09:44:02 localhost kernel:  [<ffffffffa05140dc>] ? :btrfs:__free_extent_buffer+0x41/0x46
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04f375e>] ? :btrfs:btrfs_free_path+0x25/0x2a
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04fce84>] :btrfs:btrfs_update_root+0x48/0xd5
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0502b08>] :btrfs:drop_dirty_roots+0xa8/0x1e8
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0502cde>] :btrfs:btrfs_clean_old_snapshots+0x96/0xa3
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04ff973>] :btrfs:cleaner_kthread+0xe1/0x163
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04ff892>] ? :btrfs:cleaner_kthread+0x0/0x163
Jul 20 09:44:02 localhost kernel:  [<ffffffff810460e3>] kthread+0x49/0x76
Jul 20 09:44:02 localhost kernel:  [<ffffffff8100cda8>] child_rip+0xa/0x12
Jul 20 09:44:02 localhost kernel:  [<ffffffff8104609a>] ? kthread+0x0/0x76
Jul 20 09:44:02 localhost kernel:  [<ffffffff8100cd9e>] ? child_rip+0x0/0x12
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: btrfs-transac D ffffffff8129c5b0     0   457      2
Jul 20 09:44:02 localhost kernel:  ffff810028201da0 0000000000000046 0000000000000000 0000000000000000
Jul 20 09:44:02 localhost kernel:  0000000201055280 ffffffff814b2280 ffffffff814b2280 0000000000000000
Jul 20 09:44:02 localhost kernel:  ffffffffffffffff ffff810025954320 ffff81003fb24320 ffff810025954670
Jul 20 09:44:02 localhost kernel: Call Trace:
Jul 20 09:44:02 localhost kernel:  [<ffffffff8127fab7>] schedule_timeout+0x22/0xb4
Jul 20 09:44:02 localhost kernel:  [<ffffffff8103c77a>] ? lock_timer_base+0x26/0x4a
Jul 20 09:44:02 localhost kernel:  [<ffffffff810465d3>] ? prepare_to_wait+0x57/0x60
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0502f1b>] :btrfs:btrfs_commit_transaction+0x230/0x604
Jul 20 09:44:02 localhost kernel:  [<ffffffff8104640c>] ? autoremove_wake_function+0x0/0x38
Jul 20 09:44:02 localhost kernel:  [<ffffffff8103c3ee>] ? process_timeout+0x0/0xb
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04ff801>] :btrfs:transaction_kthread+0x176/0x207
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04ff68b>] ? :btrfs:transaction_kthread+0x0/0x207
Jul 20 09:44:02 localhost kernel:  [<ffffffff810460e3>] kthread+0x49/0x76
Jul 20 09:44:02 localhost kernel:  [<ffffffff8100cda8>] child_rip+0xa/0x12
Jul 20 09:44:02 localhost kernel:  [<ffffffff8104609a>] ? kthread+0x0/0x76
Jul 20 09:44:02 localhost kernel:  [<ffffffff8100cd9e>] ? child_rip+0x0/0x12
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: fs_mark       D ffff81000101ea10     0  1294    492
Jul 20 09:44:02 localhost kernel:  ffff8100264e5928 0000000000000082 0000000001017be0 ffff81003edf61e0
Jul 20 09:44:02 localhost kernel:  ffff81003edf61f0 ffffffff814b2280 ffffffff814b2280 0000000000000204
Jul 20 09:44:02 localhost kernel:  0000000000000001 ffff81003c7e2cc0 ffff81003b215980 ffff81003c7e3010
Jul 20 09:44:02 localhost kernel: Call Trace:
Jul 20 09:44:02 localhost kernel:  [<ffffffff81011a3d>] ? read_tsc+0x9/0x1c
Jul 20 09:44:02 localhost kernel:  [<ffffffff8104b2d3>] ? getnstimeofday+0x3a/0x96
Jul 20 09:44:02 localhost kernel:  [<ffffffff8127f7ea>] io_schedule+0x63/0xa5
Jul 20 09:44:02 localhost kernel:  [<ffffffff810756ad>] sync_page+0x3c/0x40
Jul 20 09:44:02 localhost kernel:  [<ffffffff8127fbdf>] __wait_on_bit_lock+0x45/0x79
Jul 20 09:44:02 localhost kernel:  [<ffffffff81075671>] ? sync_page+0x0/0x40
Jul 20 09:44:02 localhost kernel:  [<ffffffff8107565d>] __lock_page+0x63/0x6a
Jul 20 09:44:02 localhost kernel:  [<ffffffff81046444>] ? wake_bit_function+0x0/0x2a
Jul 20 09:44:02 localhost kernel:  [<ffffffff8102a40e>] ? default_wake_function+0xd/0xf
Jul 20 09:44:02 localhost kernel:  [<ffffffff810758a5>] find_lock_page+0x66/0x93
Jul 20 09:44:02 localhost kernel:  [<ffffffff81076167>] find_or_create_page+0x27/0x79
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0514900>] :btrfs:alloc_extent_buffer+0xee/0x23b
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04ffc3b>] :btrfs:read_tree_block+0x37/0x62
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04f5db1>] :btrfs:btrfs_search_slot+0x179b/0x18d7
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0507664>] ? :btrfs:btrfs_set_bit_hook+0x89/0x94
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04fe5a4>] :btrfs:btrfs_lookup_inode+0x2c/0x90
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0505cce>] :btrfs:btrfs_update_inode+0x4c/0xba
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0509f25>] :btrfs:dirty_and_release_pages+0x33c/0x371
Jul 20 09:44:02 localhost kernel:  [<ffffffff810815fe>] ? __inc_zone_page_state+0x25/0x27
Jul 20 09:44:02 localhost kernel:  [<ffffffff81076191>] ? find_or_create_page+0x51/0x79
Jul 20 09:44:02 localhost kernel:  [<ffffffffa050a683>] :btrfs:btrfs_file_write+0x729/0x946
Jul 20 09:44:02 localhost kernel:  [<ffffffff810a2b55>] vfs_write+0xae/0x157
Jul 20 09:44:02 localhost kernel:  [<ffffffff810a2cc2>] sys_write+0x47/0x6f
Jul 20 09:44:02 localhost kernel:  [<ffffffff8100c102>] tracesys+0xd5/0xda
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: fs_mark       D ffffffff8129c5b0     0  1295    492
Jul 20 09:44:02 localhost kernel:  ffff8100259af928 0000000000000086 0000000000000000 ffff81003edf61e0
Jul 20 09:44:02 localhost kernel:  ffff81003edf61f0 ffffffff814b2280 ffffffff814b2280 0000000000000204
Jul 20 09:44:02 localhost kernel:  0000000000000001 ffff81003c7e1660 ffff81003fac5980 ffff81003c7e19b0
Jul 20 09:44:02 localhost kernel: Call Trace:
Jul 20 09:44:02 localhost kernel:  [<ffffffff81011a3d>] ? read_tsc+0x9/0x1c
Jul 20 09:44:02 localhost kernel:  [<ffffffff8127f7ea>] io_schedule+0x63/0xa5
Jul 20 09:44:02 localhost kernel:  [<ffffffff810756ad>] sync_page+0x3c/0x40
Jul 20 09:44:02 localhost kernel:  [<ffffffff8127fbdf>] __wait_on_bit_lock+0x45/0x79
Jul 20 09:44:02 localhost kernel:  [<ffffffff81075671>] ? sync_page+0x0/0x40
Jul 20 09:44:02 localhost kernel:  [<ffffffff8107565d>] __lock_page+0x63/0x6a
Jul 20 09:44:02 localhost kernel:  [<ffffffff81046444>] ? wake_bit_function+0x0/0x2a
Jul 20 09:44:02 localhost kernel:  [<ffffffff8102a40e>] ? default_wake_function+0xd/0xf
Jul 20 09:44:02 localhost kernel:  [<ffffffff810758a5>] find_lock_page+0x66/0x93
Jul 20 09:44:02 localhost kernel:  [<ffffffff81076167>] find_or_create_page+0x27/0x79
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0514900>] :btrfs:alloc_extent_buffer+0xee/0x23b
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04ffc3b>] :btrfs:read_tree_block+0x37/0x62
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04f5db1>] :btrfs:btrfs_search_slot+0x179b/0x18d7
Jul 20 09:44:02 localhost kernel:  [<ffffffff810263d3>] ? activate_task+0x5f/0x82
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0507664>] ? :btrfs:btrfs_set_bit_hook+0x89/0x94
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04fe5a4>] :btrfs:btrfs_lookup_inode+0x2c/0x90
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0505cce>] :btrfs:btrfs_update_inode+0x4c/0xba
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0509f25>] :btrfs:dirty_and_release_pages+0x33c/0x371
Jul 20 09:44:02 localhost kernel:  [<ffffffff810815fe>] ? __inc_zone_page_state+0x25/0x27
Jul 20 09:44:02 localhost kernel:  [<ffffffff81076191>] ? find_or_create_page+0x51/0x79
Jul 20 09:44:02 localhost kernel:  [<ffffffffa050a683>] :btrfs:btrfs_file_write+0x729/0x946
Jul 20 09:44:02 localhost kernel:  [<ffffffff810a2b55>] vfs_write+0xae/0x157
Jul 20 09:44:02 localhost kernel:  [<ffffffff810a2cc2>] sys_write+0x47/0x6f
Jul 20 09:44:02 localhost kernel:  [<ffffffff8100c102>] tracesys+0xd5/0xda
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: fs_mark       D ffffffff8129c5b0     0  1297    492
Jul 20 09:44:02 localhost kernel:  ffff810038737928 0000000000000082 0000000000000000 ffff81003edf61e0
Jul 20 09:44:02 localhost kernel:  ffff81003edf61f0 ffffffff814b2280 ffffffff814b2280 0000000000000204
Jul 20 09:44:02 localhost kernel:  0000000000000001 ffff81003c7e4320 ffff81003fa42cc0 ffff81003c7e4670
Jul 20 09:44:02 localhost kernel: Call Trace:
Jul 20 09:44:02 localhost kernel:  [<ffffffff81011a3d>] ? read_tsc+0x9/0x1c
Jul 20 09:44:02 localhost kernel:  [<ffffffff8127f7ea>] io_schedule+0x63/0xa5
Jul 20 09:44:02 localhost kernel:  [<ffffffff810756ad>] sync_page+0x3c/0x40
Jul 20 09:44:02 localhost kernel:  [<ffffffff8127fbdf>] __wait_on_bit_lock+0x45/0x79
Jul 20 09:44:02 localhost kernel:  [<ffffffff81075671>] ? sync_page+0x0/0x40
Jul 20 09:44:02 localhost kernel:  [<ffffffff8107565d>] __lock_page+0x63/0x6a
Jul 20 09:44:02 localhost kernel:  [<ffffffff81046444>] ? wake_bit_function+0x0/0x2a
Jul 20 09:44:02 localhost kernel:  [<ffffffff8102a40e>] ? default_wake_function+0xd/0xf
Jul 20 09:44:02 localhost kernel:  [<ffffffff810758a5>] find_lock_page+0x66/0x93
Jul 20 09:44:02 localhost kernel:  [<ffffffff81076167>] find_or_create_page+0x27/0x79
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0514900>] :btrfs:alloc_extent_buffer+0xee/0x23b
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04ffc3b>] :btrfs:read_tree_block+0x37/0x62
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04f5db1>] :btrfs:btrfs_search_slot+0x179b/0x18d7
Jul 20 09:44:02 localhost kernel:  [<ffffffff810263d3>] ? activate_task+0x5f/0x82
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0507664>] ? :btrfs:btrfs_set_bit_hook+0x89/0x94
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04fe5a4>] :btrfs:btrfs_lookup_inode+0x2c/0x90
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0505cce>] :btrfs:btrfs_update_inode+0x4c/0xba
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0509f25>] :btrfs:dirty_and_release_pages+0x33c/0x371
Jul 20 09:44:02 localhost kernel:  [<ffffffff810815fe>] ? __inc_zone_page_state+0x25/0x27
Jul 20 09:44:02 localhost kernel:  [<ffffffff81076191>] ? find_or_create_page+0x51/0x79
Jul 20 09:44:02 localhost kernel:  [<ffffffffa050a683>] :btrfs:btrfs_file_write+0x729/0x946
Jul 20 09:44:02 localhost kernel:  [<ffffffff810a2b55>] vfs_write+0xae/0x157
Jul 20 09:44:02 localhost kernel:  [<ffffffff810a2cc2>] sys_write+0x47/0x6f
Jul 20 09:44:02 localhost kernel:  [<ffffffff8100c102>] tracesys+0xd5/0xda
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: pdflush       D ffff81003edf776c     0  1298      2
Jul 20 09:44:02 localhost kernel:  ffff81001abdf870 0000000000000046 00000000001cdd1c ffff810001055280
Jul 20 09:44:02 localhost kernel:  ffff8100010552f0 ffffffff814b2280 ffffffff814b2280 ffffffff8102cd09
Jul 20 09:44:02 localhost kernel:  ffff810001055280 ffff810036dd0000 ffff810038615980 ffff810036dd0350
Jul 20 09:44:02 localhost kernel: Call Trace:
Jul 20 09:44:02 localhost kernel:  [<ffffffff8102cd09>] ? enqueue_task_fair+0x1cc/0x1d8
Jul 20 09:44:02 localhost kernel:  [<ffffffff810263d3>] ? activate_task+0x5f/0x82
Jul 20 09:44:02 localhost kernel:  [<ffffffff8102a3f0>] ? try_to_wake_up+0x1cc/0x1dd
Jul 20 09:44:02 localhost kernel:  [<ffffffff8127ff47>] __mutex_lock_slowpath+0x6b/0xa2
Jul 20 09:44:02 localhost kernel:  [<ffffffff8127fdd2>] mutex_lock+0x2f/0x33
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04f6e96>] :btrfs:maybe_lock_mutex+0x29/0x2b
Jul 20 09:44:02 localhost kernel:  [<ffffffffa04f9a4a>] :btrfs:btrfs_reserve_extent+0x2c/0x79
Jul 20 09:44:02 localhost kernel:  [<ffffffffa05040fe>] :btrfs:cow_file_range+0x11d/0x23b
Jul 20 09:44:02 localhost kernel:  [<ffffffff81029c18>] ? __wake_up+0x43/0x4f
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0504408>] :btrfs:run_delalloc_range+0x1ec/0x1ff
Jul 20 09:44:02 localhost kernel:  [<ffffffff8104b2d3>] ? getnstimeofday+0x3a/0x96
Jul 20 09:44:02 localhost kernel:  [<ffffffffa05173b4>] :btrfs:__extent_writepage+0x142/0x58e
Jul 20 09:44:02 localhost kernel:  [<ffffffff810753a4>] ? find_get_pages_tag+0x3d/0x8e
Jul 20 09:44:02 localhost kernel:  [<ffffffff81081685>] ? __dec_zone_page_state+0x25/0x27
Jul 20 09:44:02 localhost kernel:  [<ffffffff8107c3a1>] write_cache_pages+0x1c5/0x314
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0517272>] ? :btrfs:__extent_writepage+0x0/0x58e
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0507433>] ? :btrfs:btrfs_submit_bio_hook+0x6a/0x8d
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0514ad5>] :btrfs:extent_writepages+0x32/0x52
Jul 20 09:44:02 localhost kernel:  [<ffffffffa05053c0>] ? :btrfs:btrfs_get_extent+0x0/0x731
Jul 20 09:44:02 localhost kernel:  [<ffffffffa0504be4>] :btrfs:btrfs_writepages+0x23/0x25
Jul 20 09:44:02 localhost kernel:  [<ffffffff8107c53d>] do_writepages+0x28/0x38
Jul 20 09:44:02 localhost kernel:  [<ffffffff810bfa09>] __writeback_single_inode+0x16d/0x2cc
Jul 20 09:44:02 localhost kernel:  [<ffffffff810bff73>] sync_sb_inodes+0x20b/0x2d0
Jul 20 09:44:02 localhost kernel:  [<ffffffff810c02c1>] writeback_inodes+0xa8/0x100
Jul 20 09:44:02 localhost kernel:  [<ffffffff8107c693>] wb_kupdate+0xa3/0x119
Jul 20 09:44:02 localhost kernel:  [<ffffffff8107d12b>] pdflush+0x13a/0x1e2
Jul 20 09:44:02 localhost kernel:  [<ffffffff8107c5f0>] ? wb_kupdate+0x0/0x119
Jul 20 09:44:02 localhost kernel:  [<ffffffff8107cff1>] ? pdflush+0x0/0x1e2
Jul 20 09:44:02 localhost kernel:  [<ffffffff810460e3>] kthread+0x49/0x76
Jul 20 09:44:02 localhost kernel:  [<ffffffff8100cda8>] child_rip+0xa/0x12
Jul 20 09:44:02 localhost kernel:  [<ffffffff8104609a>] ? kthread+0x0/0x76
Jul 20 09:44:02 localhost kernel:  [<ffffffff8100cd9e>] ? child_rip+0x0/0x12
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: Sched Debug Version: v0.07, 2.6.26-rc8 #2
Jul 20 09:44:02 localhost kernel: now at 518642612.496596 msecs
Jul 20 09:44:02 localhost kernel:   .sysctl_sched_latency                    : 80.000000
Jul 20 09:44:02 localhost kernel:   .sysctl_sched_min_granularity            : 16.000000
Jul 20 09:44:02 localhost kernel:   .sysctl_sched_wakeup_granularity         : 40.000000
Jul 20 09:44:02 localhost kernel:   .sysctl_sched_child_runs_first           : 0.000001
Jul 20 09:44:02 localhost kernel:   .sysctl_sched_features                   : 895
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: cpu#0, 1995.005 MHz
Jul 20 09:44:02 localhost kernel:   .nr_running                    : 0
Jul 20 09:44:02 localhost kernel:   .load                          : 0
Jul 20 09:44:02 localhost kernel:   .nr_switches                   : 71261106
Jul 20 09:44:02 localhost kernel:   .nr_load_updates               : 27274704
Jul 20 09:44:02 localhost kernel:   .nr_uninterruptible            : -78315
Jul 20 09:44:02 localhost kernel:   .jiffies                       : 4813309908
Jul 20 09:44:02 localhost kernel:   .next_balance                  : 4813.309926
Jul 20 09:44:02 localhost kernel:   .curr->pid                     : 0
Jul 20 09:44:02 localhost kernel:   .clock                         : 518642176.001405
Jul 20 09:44:02 localhost kernel:   .cpu_load[0]                   : 0
Jul 20 09:44:02 localhost kernel:   .cpu_load[1]                   : 0
Jul 20 09:44:02 localhost kernel:   .cpu_load[2]                   : 0
Jul 20 09:44:02 localhost kernel:   .cpu_load[3]                   : 0
Jul 20 09:44:02 localhost kernel:   .cpu_load[4]                   : 0
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: cfs_rq[0]:
Jul 20 09:44:02 localhost kernel:   .exec_clock                    : 7005810.076980
Jul 20 09:44:02 localhost kernel:   .MIN_vruntime                  : 0.000001
Jul 20 09:44:02 localhost kernel:   .min_vruntime                  : 6147843.087706
Jul 20 09:44:02 localhost kernel:   .max_vruntime                  : 0.000001
Jul 20 09:44:02 localhost kernel:   .spread                        : 0.000000
Jul 20 09:44:02 localhost kernel:   .spread0                       : 0.000000
Jul 20 09:44:02 localhost kernel:   .nr_running                    : 0
Jul 20 09:44:02 localhost kernel:   .load                          : 0
Jul 20 09:44:02 localhost kernel:   .bkl_count                     : 14719
Jul 20 09:44:02 localhost kernel:   .nr_spread_over                : 7741
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: runnable tasks:
Jul 20 09:44:02 localhost kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jul 20 09:44:02 localhost kernel: ----------------------------------------------------------------------------------------------------------
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: cpu#1, 1995.005 MHz
Jul 20 09:44:02 localhost kernel:   .nr_running                    : 0
Jul 20 09:44:02 localhost kernel:   .load                          : 0
Jul 20 09:44:02 localhost kernel:   .nr_switches                   : 42388973
Jul 20 09:44:02 localhost kernel:   .nr_load_updates               : 28769596
Jul 20 09:44:02 localhost kernel:   .nr_uninterruptible            : 50302
Jul 20 09:44:02 localhost kernel:   .jiffies                       : 4813309908
Jul 20 09:44:02 localhost kernel:   .next_balance                  : 4813.309909
Jul 20 09:44:02 localhost kernel:   .curr->pid                     : 0
Jul 20 09:44:02 localhost kernel:   .clock                         : 518642612.065756
Jul 20 09:44:02 localhost kernel:   .cpu_load[0]                   : 0
Jul 20 09:44:02 localhost kernel:   .cpu_load[1]                   : 0
Jul 20 09:44:02 localhost kernel:   .cpu_load[2]                   : 0
Jul 20 09:44:02 localhost kernel:   .cpu_load[3]                   : 0
Jul 20 09:44:02 localhost kernel:   .cpu_load[4]                   : 0
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: cfs_rq[1]:
Jul 20 09:44:02 localhost kernel:   .exec_clock                    : 16582705.318450
Jul 20 09:44:02 localhost kernel:   .MIN_vruntime                  : 0.000001
Jul 20 09:44:02 localhost kernel:   .min_vruntime                  : 15388918.205634
Jul 20 09:44:02 localhost kernel:   .max_vruntime                  : 0.000001
Jul 20 09:44:02 localhost kernel:   .spread                        : 0.000000
Jul 20 09:44:02 localhost kernel:   .spread0                       : 9241075.117928
Jul 20 09:44:02 localhost kernel:   .nr_running                    : 0
Jul 20 09:44:02 localhost kernel:   .load                          : 0
Jul 20 09:44:02 localhost kernel:   .bkl_count                     : 193
Jul 20 09:44:02 localhost kernel:   .nr_spread_over                : 27573
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: runnable tasks:
Jul 20 09:44:02 localhost kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jul 20 09:44:02 localhost kernel: ----------------------------------------------------------------------------------------------------------
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: cpu#2, 1995.005 MHz
Jul 20 09:44:02 localhost kernel:   .nr_running                    : 0
Jul 20 09:44:02 localhost kernel:   .load                          : 0
Jul 20 09:44:02 localhost kernel:   .nr_switches                   : 39917429
Jul 20 09:44:02 localhost kernel:   .nr_load_updates               : 25998516
Jul 20 09:44:02 localhost kernel:   .nr_uninterruptible            : 15705
Jul 20 09:44:02 localhost kernel:   .jiffies                       : 4813309908
Jul 20 09:44:02 localhost kernel:   .next_balance                  : 4813.310214
Jul 20 09:44:02 localhost kernel:   .curr->pid                     : 0
Jul 20 09:44:02 localhost kernel:   .clock                         : 518642613.020210
Jul 20 09:44:02 localhost kernel:   .cpu_load[0]                   : 0
Jul 20 09:44:02 localhost kernel:   .cpu_load[1]                   : 0
Jul 20 09:44:02 localhost kernel:   .cpu_load[2]                   : 0
Jul 20 09:44:02 localhost kernel:   .cpu_load[3]                   : 0
Jul 20 09:44:02 localhost kernel:   .cpu_load[4]                   : 0
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: cfs_rq[2]:
Jul 20 09:44:02 localhost kernel:   .exec_clock                    : 9940727.805654
Jul 20 09:44:02 localhost kernel:   .MIN_vruntime                  : 0.000001
Jul 20 09:44:02 localhost kernel:   .min_vruntime                  : 12393575.348627
Jul 20 09:44:02 localhost kernel:   .max_vruntime                  : 0.000001
Jul 20 09:44:02 localhost kernel:   .spread                        : 0.000000
Jul 20 09:44:02 localhost kernel:   .spread0                       : 6245732.260921
Jul 20 09:44:02 localhost kernel:   .nr_running                    : 0
Jul 20 09:44:02 localhost kernel:   .load                          : 0
Jul 20 09:44:02 localhost kernel:   .bkl_count                     : 34065
Jul 20 09:44:02 localhost kernel:   .nr_spread_over                : 16750
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: runnable tasks:
Jul 20 09:44:02 localhost kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jul 20 09:44:02 localhost kernel: ----------------------------------------------------------------------------------------------------------
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: cpu#3, 1995.005 MHz
Jul 20 09:44:02 localhost kernel:   .nr_running                    : 1
Jul 20 09:44:02 localhost kernel:   .load                          : 1024
Jul 20 09:44:02 localhost kernel:   .nr_switches                   : 25820539
Jul 20 09:44:02 localhost kernel:   .nr_load_updates               : 13456598
Jul 20 09:44:02 localhost kernel:   .nr_uninterruptible            : 8078
Jul 20 09:44:02 localhost kernel:   .jiffies                       : 4813309908
Jul 20 09:44:02 localhost kernel:   .next_balance                  : 4813.310373
Jul 20 09:44:02 localhost kernel:   .curr->pid                     : 1296
Jul 20 09:44:02 localhost kernel:   .clock                         : 518642612.330033
Jul 20 09:44:02 localhost kernel:   .cpu_load[0]                   : 1024
Jul 20 09:44:02 localhost kernel:   .cpu_load[1]                   : 1024
Jul 20 09:44:02 localhost kernel:   .cpu_load[2]                   : 1024
Jul 20 09:44:02 localhost kernel:   .cpu_load[3]                   : 1034
Jul 20 09:44:02 localhost kernel:   .cpu_load[4]                   : 2696
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: cfs_rq[3]:
Jul 20 09:44:02 localhost kernel:   .exec_clock                    : 17045588.380304
Jul 20 09:44:02 localhost kernel:   .MIN_vruntime                  : 0.000001
Jul 20 09:44:02 localhost kernel:   .min_vruntime                  : 19226002.041556
Jul 20 09:44:02 localhost kernel:   .max_vruntime                  : 0.000001
Jul 20 09:44:02 localhost kernel:   .spread                        : 0.000000
Jul 20 09:44:02 localhost kernel:   .spread0                       : 13078158.953850
Jul 20 09:44:02 localhost kernel:   .nr_running                    : 1
Jul 20 09:44:02 localhost kernel:   .load                          : 1024
Jul 20 09:44:02 localhost kernel:   .bkl_count                     : 48
Jul 20 09:44:02 localhost kernel:   .nr_spread_over                : 28934
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: runnable tasks:
Jul 20 09:44:02 localhost kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jul 20 09:44:02 localhost kernel: ----------------------------------------------------------------------------------------------------------
Jul 20 09:44:02 localhost kernel: R        fs_mark  1296  19226457.303075    107813   120  19226457.303075  10746386.107069  41986340.222076
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: cpu#4, 1995.005 MHz
Jul 20 09:44:02 localhost kernel:   .nr_running                    : 1
Jul 20 09:44:02 localhost kernel:   .load                          : 1024
Jul 20 09:44:02 localhost kernel:   .nr_switches                   : 30275090
Jul 20 09:44:02 localhost kernel:   .nr_load_updates               : 28100553
Jul 20 09:44:02 localhost kernel:   .nr_uninterruptible            : -3629
Jul 20 09:44:02 localhost kernel:   .jiffies                       : 4813309908
Jul 20 09:44:02 localhost kernel:   .next_balance                  : 4813.309925
Jul 20 09:44:02 localhost kernel:   .curr->pid                     : 7565
Jul 20 09:44:02 localhost kernel:   .clock                         : 518642609.252071
Jul 20 09:44:02 localhost kernel:   .cpu_load[0]                   : 1024
Jul 20 09:44:02 localhost kernel:   .cpu_load[1]                   : 512
Jul 20 09:44:02 localhost kernel:   .cpu_load[2]                   : 256
Jul 20 09:44:02 localhost kernel:   .cpu_load[3]                   : 128
Jul 20 09:44:02 localhost kernel:   .cpu_load[4]                   : 64
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: cfs_rq[4]:
Jul 20 09:44:02 localhost kernel:   .exec_clock                    : 9006184.598040
Jul 20 09:44:02 localhost kernel:   .MIN_vruntime                  : 0.000001
Jul 20 09:44:02 localhost kernel:   .min_vruntime                  : 19352708.170150
Jul 20 09:44:02 localhost kernel:   .max_vruntime                  : 0.000001
Jul 20 09:44:02 localhost kernel:   .spread                        : 0.000000
Jul 20 09:44:02 localhost kernel:   .spread0                       : 13204865.082444
Jul 20 09:44:02 localhost kernel:   .nr_running                    : 1
Jul 20 09:44:02 localhost kernel:   .load                          : 1024
Jul 20 09:44:02 localhost kernel:   .bkl_count                     : 114562
Jul 20 09:44:02 localhost kernel:   .nr_spread_over                : 25372
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: runnable tasks:
Jul 20 09:44:02 localhost kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jul 20 09:44:02 localhost kernel: ----------------------------------------------------------------------------------------------------------
Jul 20 09:44:02 localhost kernel: R           bash  7565  19352708.431556        64   120  19352708.431556       375.114878     15210.511594
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: cpu#5, 1995.005 MHz
Jul 20 09:44:02 localhost kernel:   .nr_running                    : 0
Jul 20 09:44:02 localhost kernel:   .load                          : 0
Jul 20 09:44:02 localhost kernel:   .nr_switches                   : 25041469
Jul 20 09:44:02 localhost kernel:   .nr_load_updates               : 10540411
Jul 20 09:44:02 localhost kernel:   .nr_uninterruptible            : 6025
Jul 20 09:44:02 localhost kernel:   .jiffies                       : 4813309908
Jul 20 09:44:02 localhost kernel:   .next_balance                  : 4813.309917
Jul 20 09:44:02 localhost kernel:   .curr->pid                     : 0
Jul 20 09:44:02 localhost kernel:   .clock                         : 518642500.281853
Jul 20 09:44:02 localhost kernel:   .cpu_load[0]                   : 0
Jul 20 09:44:02 localhost kernel:   .cpu_load[1]                   : 0
Jul 20 09:44:02 localhost kernel:   .cpu_load[2]                   : 0
Jul 20 09:44:02 localhost kernel:   .cpu_load[3]                   : 0
Jul 20 09:44:02 localhost kernel:   .cpu_load[4]                   : 0
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: cfs_rq[5]:
Jul 20 09:44:02 localhost kernel:   .exec_clock                    : 18945577.721976
Jul 20 09:44:02 localhost kernel:   .MIN_vruntime                  : 0.000001
Jul 20 09:44:02 localhost kernel:   .min_vruntime                  : 17445164.740748
Jul 20 09:44:02 localhost kernel:   .max_vruntime                  : 0.000001
Jul 20 09:44:02 localhost kernel:   .spread                        : 0.000000
Jul 20 09:44:02 localhost kernel:   .spread0                       : 11297321.653042
Jul 20 09:44:02 localhost kernel:   .nr_running                    : 0
Jul 20 09:44:02 localhost kernel:   .load                          : 0
Jul 20 09:44:02 localhost kernel:   .bkl_count                     : 140
Jul 20 09:44:02 localhost kernel:   .nr_spread_over                : 32646
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: runnable tasks:
Jul 20 09:44:02 localhost kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jul 20 09:44:02 localhost kernel: ----------------------------------------------------------------------------------------------------------
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: cpu#6, 1995.005 MHz
Jul 20 09:44:02 localhost kernel:   .nr_running                    : 1
Jul 20 09:44:02 localhost kernel:   .load                          : 1024
Jul 20 09:44:02 localhost kernel:   .nr_switches                   : 25186630
Jul 20 09:44:02 localhost kernel:   .nr_load_updates               : 25914529
Jul 20 09:44:02 localhost kernel:   .nr_uninterruptible            : -651
Jul 20 09:44:02 localhost kernel:   .jiffies                       : 4813309908
Jul 20 09:44:02 localhost kernel:   .next_balance                  : 4813.310898
Jul 20 09:44:02 localhost kernel:   .curr->pid                     : 7519
Jul 20 09:44:02 localhost kernel:   .clock                         : 518642612.823659
Jul 20 09:44:02 localhost kernel:   .cpu_load[0]                   : 1024
Jul 20 09:44:02 localhost kernel:   .cpu_load[1]                   : 960
Jul 20 09:44:02 localhost kernel:   .cpu_load[2]                   : 700
Jul 20 09:44:02 localhost kernel:   .cpu_load[3]                   : 424
Jul 20 09:44:02 localhost kernel:   .cpu_load[4]                   : 234
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: cfs_rq[6]:
Jul 20 09:44:02 localhost kernel:   .exec_clock                    : 8165979.471723
Jul 20 09:44:02 localhost kernel:   .MIN_vruntime                  : 0.000001
Jul 20 09:44:02 localhost kernel:   .min_vruntime                  : 18564134.692409
Jul 20 09:44:02 localhost kernel:   .max_vruntime                  : 0.000001
Jul 20 09:44:02 localhost kernel:   .spread                        : 0.000000
Jul 20 09:44:02 localhost kernel:   .spread0                       : 12416291.604703
Jul 20 09:44:02 localhost kernel:   .nr_running                    : 1
Jul 20 09:44:02 localhost kernel:   .load                          : 1024
Jul 20 09:44:02 localhost kernel:   .bkl_count                     : 97911
Jul 20 09:44:02 localhost kernel:   .nr_spread_over                : 23450
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: runnable tasks:
Jul 20 09:44:02 localhost kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jul 20 09:44:02 localhost kernel: ----------------------------------------------------------------------------------------------------------
Jul 20 09:44:02 localhost kernel: R       rsyslogd  7519  18564057.144539        12   120  18564057.159138         8.740093     60065.906714
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: cpu#7, 1995.005 MHz
Jul 20 09:44:02 localhost kernel:   .nr_running                    : 1
Jul 20 09:44:02 localhost kernel:   .load                          : 1024
Jul 20 09:44:02 localhost kernel:   .nr_switches                   : 16256847
Jul 20 09:44:02 localhost kernel:   .nr_load_updates               : 9220260
Jul 20 09:44:02 localhost kernel:   .nr_uninterruptible            : 2494
Jul 20 09:44:02 localhost kernel:   .jiffies                       : 4813309908
Jul 20 09:44:02 localhost kernel:   .next_balance                  : 4813.309929
Jul 20 09:44:02 localhost kernel:   .curr->pid                     : 2276
Jul 20 09:44:02 localhost kernel:   .clock                         : 518642612.688616
Jul 20 09:44:02 localhost kernel:   .cpu_load[0]                   : 1024
Jul 20 09:44:02 localhost kernel:   .cpu_load[1]                   : 896
Jul 20 09:44:02 localhost kernel:   .cpu_load[2]                   : 592
Jul 20 09:44:02 localhost kernel:   .cpu_load[3]                   : 338
Jul 20 09:44:02 localhost kernel:   .cpu_load[4]                   : 181
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: cfs_rq[7]:
Jul 20 09:44:02 localhost kernel:   .exec_clock                    : 3818337.932701
Jul 20 09:44:02 localhost kernel:   .MIN_vruntime                  : 0.000001
Jul 20 09:44:02 localhost kernel:   .min_vruntime                  : 3942804.142761
Jul 20 09:44:02 localhost kernel:   .max_vruntime                  : 0.000001
Jul 20 09:44:02 localhost kernel:   .spread                        : 0.000000
Jul 20 09:44:02 localhost kernel:   .spread0                       : -2205038.944945
Jul 20 09:44:02 localhost kernel:   .nr_running                    : 1
Jul 20 09:44:02 localhost kernel:   .load                          : 1024
Jul 20 09:44:02 localhost kernel:   .bkl_count                     : 334
Jul 20 09:44:02 localhost kernel:   .nr_spread_over                : 3856
Jul 20 09:44:02 localhost kernel: 
Jul 20 09:44:02 localhost kernel: runnable tasks:
Jul 20 09:44:02 localhost kernel:             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Jul 20 09:44:02 localhost kernel: ----------------------------------------------------------------------------------------------------------
Jul 20 09:44:02 localhost kernel: R       rsyslogd  2276   3942727.173146       995   120   3942727.173146      4353.976778  19992207.965777
Jul 20 09:44:02 localhost kernel: 

--------------090405040208070202050004--
