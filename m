From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: New data=ordered code pushed out to btrfs-unstable
Date: Sun, 20 Jul 2008 08:19:14 -0400
Message-ID: <48832D42.6030204@redhat.com>
References: <1216398992.6932.36.camel@think.oraclecorp.com>	 <4880F87B.7020908@gmail.com>	 <1216411969.6932.70.camel@think.oraclecorp.com>	 <48811ABF.5010606@gmail.com> <1216428331.6932.82.camel@think.oraclecorp.com>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216428331.6932.82.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Fri, 2008-07-18 at 18:35 -0400, Ric Wheeler wrote:
>   
>> Chris Mason wrote:
>>     
>>> On Fri, 2008-07-18 at 16:09 -0400, Ric Wheeler wrote:
>>>
>>>       
>>>> Just to kick the tires, I tried the same test that I ran last week on 
>>>> ext4. Everything was going great, I decided to kill it after 6 million 
>>>> files or so and restart.
>>>>         
>
> Well, it looks like I neglected to push all the changesets, especially
> the last one that made it less racey.  So, I've just done another push,
> sorry.  For the fs_mark workload, it shouldn't change anything.
>
> This code still hasn't really survived an overnight run, hopefully this
> commit will.
>
> -chris
>
>
>   
The test is still running, but slowly, with a (slow) stream of messages 
about:

Jul 19 10:55:38 localhost kernel: INFO: task btrfs:448 blocked for more 
than 120 seconds.
Jul 19 10:55:38 localhost kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 19 10:55:38 localhost kernel: btrfs         D ffffffff8129c5b0     
0   448      2
Jul 19 10:55:38 localhost kernel:  ffff8100283dfc50 0000000000000046 
0000000000000000 ffffffffa0514254
Jul 19 10:55:38 localhost kernel:  ffff810012c061c0 ffffffff814b2280 
ffffffff814b2280 ffff81000b5ce0a0
Jul 19 10:55:38 localhost kernel:  0000000000000000 ffff81003f182cc0 
ffff81003fac0000 ffff81003f183010
Jul 19 10:55:38 localhost kernel: Call Trace:
Jul 19 10:55:38 localhost kernel:  [<ffffffffa0514254>] ? 
:btrfs:free_extent_state+0x69/0x6e
Jul 19 10:55:38 localhost kernel:  [<ffffffff8127ff47>] 
__mutex_lock_slowpath+0x6b/0xa2
Jul 19 10:55:38 localhost kernel:  [<ffffffff8127fdd2>] mutex_lock+0x2f/0x33
Jul 19 10:55:38 localhost kernel:  [<ffffffffa04f6e96>] 
:btrfs:maybe_lock_mutex+0x29/0x2b
Jul 19 10:55:38 localhost kernel:  [<ffffffffa04fae0c>] 
:btrfs:btrfs_alloc_reserved_extent+0x2c/0x67
Jul 19 10:55:38 localhost kernel:  [<ffffffffa0512106>] ? 
:btrfs:btrfs_lookup_ordered_extent+0x139/0x148
Jul 19 10:55:38 localhost kernel:  [<ffffffffa050635f>] 
:btrfs:btrfs_finish_ordered_io+0x102/0x2a8
Jul 19 10:55:38 localhost kernel:  [<ffffffffa0506666>] 
:btrfs:btrfs_writepage_end_io_hook+0x10/0x12
Jul 19 10:55:38 localhost kernel:  [<ffffffffa0516b62>] 
:btrfs:end_bio_extent_writepage+0xbe/0x28d
Jul 19 10:55:38 localhost kernel:  [<ffffffff810c6f5d>] bio_endio+0x2b/0x2d
Jul 19 10:55:38 localhost kernel:  [<ffffffffa0500d19>] 
:btrfs:end_workqueue_fn+0x103/0x110
Jul 19 10:55:38 localhost kernel:  [<ffffffffa051b43c>] 
:btrfs:worker_loop+0x63/0x13e
Jul 19 10:55:38 localhost kernel:  [<ffffffffa051b3d9>] ? 
:btrfs:worker_loop+0x0/0x13e
Jul 19 10:55:38 localhost kernel:  [<ffffffff810460e3>] kthread+0x49/0x76
Jul 19 10:55:38 localhost kernel:  [<ffffffff8100cda8>] child_rip+0xa/0x12
Jul 19 10:55:38 localhost kernel:  [<ffffffff8104609a>] ? kthread+0x0/0x76
Jul 19 10:55:38 localhost kernel:  [<ffffffff8100cd9e>] ? child_rip+0x0/0x12
Jul 19 10:55:38 localhost kernel:

ric

