From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: Updated performance results
Date: Wed, 16 Sep 2009 13:16:56 -0500
Message-ID: <4AB12B98.9050708@austin.ibm.com>
References: <4A7C32A4.9070106@austin.ibm.com> <20090807231240.GD3710@think> <4A9C0D19.5010108@austin.ibm.com> <20090911192955.GB2894@think> <4AAAC2B6.8040105@austin.ibm.com> <20090914135130.GE8839@think> <4AAEB89C.3040100@austin.ibm.com> <20090916005225.GG23965@think> <4AB1010F.70001@austin.ibm.com> <4AB12702.30601@austin.ibm.com> <20090916180719.GE2641@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090916180719.GE2641@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> On Wed, Sep 16, 2009 at 12:57:22PM -0500, Steven Pratt wrote:
>   
>> Steven Pratt wrote:
>>     
>>> Chris Mason wrote:
>>>       
>>>> On Mon, Sep 14, 2009 at 04:41:48PM -0500, Steven Pratt wrote:
>>>>         
>>>>> Only bit of bad news is I did get one error that crashed the system
>>>>> on single threaded nocow run. So that data point is missing.
>>>>> Output below:
>>>>>           
>>>> I hope I've got this fixed.  If you pull from the master branch of
>>>> btrfs-unstable there are fixes for async thread races.  The single
>>>> patch I sent before is included, but not enough.
>>>>         
>>> Glad you said that.  Keeps me from sending the email that said the
>>> patch didn't help :-)
>>>
>>> Steve
>>>       
>> Well, still getting oopses even with new code.
>>
>> Lots of:
>> Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] BUG: soft lockup -
>> CPU#10 stuck for 61s! [btrfs-endio-1:30250]
>> Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] Pid: 30250, comm:
>> btrfs-endio-1 Not tainted 2.6.31-autokern1 #1 IBM x3950-[88726RU]-
>> Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] RIP:
>> 0010:[<ffffffff81153920>]  [<ffffffff81153920>] crc32c+0x20/0x26
>>     
>
> If I'm reading this right, you've got a softlockup in crc32c?  Something
> has gone really wrong here.  Are you reusing datasets from old runs?
>   
 From the second machine a single bug:
Sep 16 11:53:42 btrfs2 kernel: [ 3769.298240] ------------[ cut here 
]------------
Sep 16 11:53:42 btrfs2 kernel: [ 3769.298550] kernel BUG at 
fs/btrfs/extent-tree.c:4097!
Sep 16 11:53:42 btrfs2 kernel: [ 3769.298550] invalid opcode: 0000 [#1] SMP
Sep 16 11:53:42 btrfs2 kernel: [ 3769.298550] last sysfs file: 
/sys/devices/system/cpu/cpu15/cache/index1/shared_cpu_map
Sep 16 11:53:42 btrfs2 kernel: [ 3769.298550] CPU 9
Sep 16 11:53:42 btrfs2 kernel: [ 3769.298550] Modules linked in: 
ipmi_devintf ipmi_si ipmi_msghandler btrfs zlib_deflate oprofile autofs4 
nfs lockd nfs_acl auth_rpc
gss sunrpc dm_multipath video output sbs sbshc battery ac parport_pc lp 
parport sg joydev serio_raw acpi_memhotplug rtc_cmos rtc_core rtc_lib 
button tg3 libphy i2c_
piix4 i2c_core pcspkr dm_snapshot dm_zero dm_mirror dm_region_hash 
dm_log dm_mod lpfc scsi_transport_fc aic94xx libsas libata 
scsi_transport_sas sd_mod scsi_mod ext
3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Sep 16 11:53:42 btrfs2 kernel: [ 3769.298550] Pid: 2106, comm: 
btrfs-endio-wri Not tainted 2.6.31-autokern1 #1 IBM x3950-[88726RU]-
Sep 16 11:53:42 btrfs2 kernel: [ 3769.298550] RIP: 
0010:[<ffffffffa0386fb3>]  [<ffffffffa0386fb3>] 
alloc_reserved_file_extent+0x8d/0x1c3 [btrfs]
Sep 16 11:53:42 btrfs2 kernel: [ 3769.298550] RSP: 
0018:ffff88002758faf0  EFLAGS: 00010282
Sep 16 11:53:42 btrfs2 kernel: [ 3769.298550] RAX: 00000000ffffffef RBX: 
ffff880136434000 RCX: 0000000000000002
Sep 16 11:53:42 btrfs2 kernel: [ 3769.298550] RDX: 0000000000000001 RSI: 
0000000000000000 RDI: ffff8800a7040370
Sep 16 11:53:42 btrfs2 kernel: [ 3769.298550] RBP: ffff88002758fb60 R08: 
ffff88002758f958 R09: ffff88002758f950
Sep 16 11:53:42 btrfs2 kernel: [ 3769.298550] R10: 0000000000000004 R11: 
ffff8800a7040370 R12: 000000000000001d
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550] R13: ffff8800b79e6910 R14: 
0000000000000000 R15: 0000000000000000
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550] FS:  
0000000000000000(0000) GS:ffff88002813e000(0000) knlGS:0000000000000000
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550] CS:  0010 DS: 0018 ES: 
0018 CR0: 000000008005003b
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550] CR2: 00007f1f6915a000 CR3: 
000000013dd4e000 CR4: 00000000000006e0
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550] DR0: 0000000000000000 DR1: 
0000000000000000 DR2: 0000000000000000
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550] DR3: 0000000000000000 DR6: 
00000000ffff0ff0 DR7: 0000000000000400
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550] Process btrfs-endio-wri 
(pid: 2106, threadinfo ffff88002758e000, task ffff88013b94c100)
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550] Stack:
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  ffff8800709fc760 
0000000000000856 0000000000000005 0000000000000000
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550] <0> ffff8801329d5000 
ffff880102242de0 000000b22758fb60 ffffffffa0386190
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550] <0> 00000035329d5000 
ffff880128291440 ffff880108302340 0000000000000001
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550] Call Trace:
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffffa0386190>] ? 
update_reserved_extents+0xa7/0xbe [btrfs]
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffffa038b430>] 
run_one_delayed_ref+0x382/0x42f [btrfs]
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffffa038c0b1>] 
run_clustered_refs+0x237/0x2b4 [btrfs]
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffffa03c1665>] ? 
btrfs_find_ref_cluster+0xdc/0x115 [btrfs]
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffffa038c1da>] 
btrfs_run_delayed_refs+0xac/0x195 [btrfs]
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffffa0395a76>] 
__btrfs_end_transaction+0x59/0xfe [btrfs]
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffffa0395b36>] 
btrfs_end_transaction+0xb/0xd [btrfs]
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffffa039b29b>] 
btrfs_finish_ordered_io+0x23c/0x265 [btrfs]
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffffa039b2d9>] 
btrfs_writepage_end_io_hook+0x15/0x17 [btrfs]
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffffa03ae901>] 
end_bio_extent_writepage+0xa5/0x132 [btrfs]
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffff810e5733>] 
bio_endio+0x26/0x28
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffffa039266e>] 
end_workqueue_fn+0x111/0x11e [btrfs]
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffffa03b6490>] 
worker_loop+0x12a/0x3ea [btrfs]
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffffa03b6366>] ? 
worker_loop+0x0/0x3ea [btrfs]
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffff810544e4>] 
kthread+0x8f/0x97
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffff8100ca1a>] 
child_rip+0xa/0x20
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffff81054455>] ? 
kthread+0x0/0x97
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550]  [<ffffffff8100ca10>] ? 
child_rip+0x0/0x20
Sep 16 11:53:43 btrfs2 kernel: [ 3769.298550] Code: 08 4c 8d 45 d4 41 8d 
44 24 18 48 8b 73 20 48 8b 4d 18 41 b9 01 00 00 00 48 8b 7d b8 4c 89 ea 
89 45 d4 e8 93 e3 f
f ff 85 c0 74 04 <0f> 0b eb fe 49 63 75 40 4d 8b 65 00 49 83 cf 01 4c 89 
e7 48 6b


Steve

> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

