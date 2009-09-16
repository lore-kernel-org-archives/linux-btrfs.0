From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: Updated performance results
Date: Wed, 16 Sep 2009 12:57:22 -0500
Message-ID: <4AB12702.30601@austin.ibm.com>
References: <20090728202355.GC13940@think> <4A6F6951.9020304@austin.ibm.com> <20090805203526.GE12524@think> <4A7C32A4.9070106@austin.ibm.com> <20090807231240.GD3710@think> <4A9C0D19.5010108@austin.ibm.com> <20090911192955.GB2894@think> <4AAAC2B6.8040105@austin.ibm.com> <20090914135130.GE8839@think> <4AAEB89C.3040100@austin.ibm.com> <20090916005225.GG23965@think> <4AB1010F.70001@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Eric Whitney <eric.whitney@hp.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AB1010F.70001@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Steven Pratt wrote:
> Chris Mason wrote:
>> On Mon, Sep 14, 2009 at 04:41:48PM -0500, Steven Pratt wrote:
>>  
>>> Only bit of bad news is I did get one error that crashed the system
>>> on single threaded nocow run. So that data point is missing.
>>> Output below:
>>>     
>>
>> I hope I've got this fixed.  If you pull from the master branch of
>> btrfs-unstable there are fixes for async thread races.  The single
>> patch I sent before is included, but not enough.
>>   
> Glad you said that.  Keeps me from sending the email that said the 
> patch didn't help :-)
>
> Steve
Well, still getting oopses even with new code.

Lots of:
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] BUG: soft lockup - CPU#10 
stuck for 61s! [btrfs-endio-1:30250]
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] Pid: 30250, comm: 
btrfs-endio-1 Not tainted 2.6.31-autokern1 #1 IBM x3950-[88726RU]-
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] RIP: 
0010:[<ffffffff81153920>]  [<ffffffff81153920>] crc32c+0x20/0x26
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] RSP: 
0018:ffff88013a857cc8  EFLAGS: 00000217
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] RAX: 0000000000000040 RBX: 
ffff88013a857cc8 RCX: ffff88013d8022c0
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] RDX: 0000000000000010 RSI: 
ffff88001d349ff0 RDI: 0000000041703e71
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] RBP: ffffffff8100c4ee R08: 
0000000000000000 R09: 0000000000000000
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] R10: ffff88013a857d30 R11: 
0000000000000002 R12: ffff88013a857d10
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] R13: 0000000000000002 R14: 
ffff88013a857cb0 R15: ffffffff8100c38e
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] FS:  
0000000000000000(0000) GS:ffff880028159000(0000) knlGS:0000000000000000
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] CS:  0010 DS: 0018 ES: 
0018 CR0: 000000008005003b
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] CR2: 0000000000000043 CR3: 
00000001368f7000 CR4: 00000000000006e0
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] Call Trace:
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754]  [<ffffffff8115397e>] ? 
chksum_update+0x10/0x18
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754]  [<ffffffff81150084>] ? 
crypto_shash_update+0x1a/0x1c
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754]  [<ffffffff81175c34>] ? 
crc32c+0x4c/0x60
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754]  [<ffffffffa0391d0f>] ? 
get_state_private+0x38/0x6f [btrfs]
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754]  [<ffffffffa0376688>] ? 
btrfs_csum_data+0xd/0xf [btrfs]
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754]  [<ffffffffa037fefc>] ? 
btrfs_readpage_end_io_hook+0x158/0x27b [btrfs]
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754]  [<ffffffffa0392a46>] ? 
end_bio_extent_readpage+0xb8/0x1c0 [btrfs]
Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754]  [<ffffffff810e5733>] ? 
bio_endio+0x26/0x28
Sep 16 11:07:27 btrfs1 kernel: [ 1862.947656]  [<ffffffffa037666e>] ? 
end_workqueue_fn+0x111/0x11e [btrfs]
Sep 16 11:07:27 btrfs1 kernel: [ 1862.947823]  [<ffffffffa039a490>] ? 
worker_loop+0x12a/0x3ea [btrfs]
Sep 16 11:07:27 btrfs1 kernel: [ 1862.947823]  [<ffffffffa039a366>] ? 
worker_loop+0x0/0x3ea [btrfs]
Sep 16 11:07:27 btrfs1 kernel: [ 1862.948800]  [<ffffffff810544e4>] ? 
kthread+0x8f/0x97
Sep 16 11:07:27 btrfs1 kernel: [ 1862.948800]  [<ffffffff8100ca1a>] ? 
child_rip+0xa/0x20
Sep 16 11:07:27 btrfs1 kernel: [ 1862.948800]  [<ffffffff81054455>] ? 
kthread+0x0/0x97
Sep 16 11:07:27 btrfs1 kernel: [ 1862.948800]  [<ffffffff8100ca10>] ? 
child_rip+0x0/0x20


Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] Pid: 31421, comm: 
btrfs-endio-wri Not tainted 2.6.31-autokern1 #1 IBM x3950-[88726RU]-
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] RIP: 
0010:[<ffffffffa036afb3>]  [<ffffffffa036afb3>] 
alloc_reserved_file_extent+0x8d/0x1c3 [btrfs]
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] RSP: 
0018:ffff8800aa555af0  EFLAGS: 00010282
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] RAX: 00000000ffffffef RBX: 
ffff88013b55e000 RCX: 0000000000000002
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] RDX: 0000000000000001 RSI: 
0000000000000000 RDI: ffff88012f20a9a0
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] RBP: ffff8800aa555b60 R08: 
ffff8800aa555888 R09: ffff8800aa555880
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] R10: ffff880077937400 R11: 
00000000fffffffa R12: 000000000000001d
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] R13: ffff880077937400 R14: 
0000000000000000 R15: 0000000000000000
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] FS:  
0000000000000000(0000) GS:ffff88002804b000(0000) knlGS:0000000000000000
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] CS:  0010 DS: 0018 ES: 
0018 CR0: 000000008005003b
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] CR2: 00000000007c0000 CR3: 
000000013e038000 CR4: 00000000000006f0
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] Process btrfs-endio-wri 
(pid: 31421, threadinfo ffff8800aa554000, task ffff8801395447a0)
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] Stack:
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621]  ffff880077937400 
0000000000000a7c 0000000000000005 0000000000000000
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] <0> ffff880101d0c800 
ffff8801140bbd20 000000b2aa555b60 ffffffffa036a190
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] <0> 000000350000091d 
ffff8801090fdd40 ffff88013a4e9d40 0000000000000001
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621] Call Trace:
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621]  [<ffffffffa036a190>] ? 
update_reserved_extents+0xa7/0xbe [btrfs]
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621]  [<ffffffffa036f430>] 
run_one_delayed_ref+0x382/0x42f [btrfs]
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621]  [<ffffffff8100c4ee>] ? 
apic_timer_interrupt+0xe/0x20
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621]  [<ffffffffa03700b1>] 
run_clustered_refs+0x237/0x2b4 [btrfs]
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621]  [<ffffffffa03a5665>] ? 
btrfs_find_ref_cluster+0xdc/0x115 [btrfs]
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621]  [<ffffffffa03701da>] 
btrfs_run_delayed_refs+0xac/0x195 [btrfs]
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621]  [<ffffffffa0379a76>] 
__btrfs_end_transaction+0x59/0xfe [btrfs]
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621]  [<ffffffffa0379b36>] 
btrfs_end_transaction+0xb/0xd [btrfs]
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621]  [<ffffffffa037f29b>] 
btrfs_finish_ordered_io+0x23c/0x265 [btrfs]
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621]  [<ffffffffa037f2d9>] 
btrfs_writepage_end_io_hook+0x15/0x17 [btrfs]
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621]  [<ffffffffa0392901>] 
end_bio_extent_writepage+0xa5/0x132 [btrfs]
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621]  [<ffffffff810e5733>] 
bio_endio+0x26/0x28
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621]  [<ffffffffa037666e>] 
end_workqueue_fn+0x111/0x11e [btrfs]
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621]  [<ffffffffa039a490>] 
worker_loop+0x12a/0x3ea [btrfs]
Sep 16 11:54:47 btrfs1 kernel: [ 4703.082621]  [<ffffffffa039a366>] ? 
worker_loop+0x0/0x3ea [btrfs]
Sep 16 11:54:48 btrfs1 kernel: [ 4703.082621]  [<ffffffff810544e4>] 
kthread+0x8f/0x97
Sep 16 11:54:48 btrfs1 kernel: [ 4703.082621]  [<ffffffff8100ca1a>] 
child_rip+0xa/0x20
Sep 16 11:54:48 btrfs1 kernel: [ 4703.082621]  [<ffffffff81054455>] ? 
kthread+0x0/0x97
Sep 16 11:54:48 btrfs1 kernel: [ 4703.082621]  [<ffffffff8100ca10>] ? 
child_rip+0x0/0x20
Sep 16 11:54:48 btrfs1 kernel: [ 4703.082621] Code: 08 4c 8d 45 d4 41 8d 
44 24 18 48 8b 73 20 48 8b 4d 18 41 b9 01 00 00 00 48 8b 7d b8 4c 89 ea
 89 45 d4 e8 93 e3 ff ff 85 c0 74 04 <0f> 0b eb fe 49 63 75 40 4d 8b 65 
00 49 83 cf 01 4c 89 e7 48 6b



Happened on 2 machines.


Steve




>
>> -chris
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>   
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

