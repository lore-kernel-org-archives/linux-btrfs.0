From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Re: Single disk performance
Date: Tue, 30 Jun 2009 10:26:59 -0500
Message-ID: <4A4A2EC3.6070402@austin.ibm.com>
References: <4A44DB23.5000400@austin.ibm.com> <20090626205659.GD3951@think>	 <4A458373.4010603@austin.ibm.com> <20090629124149.GF3951@think>	 <4A4A2358.6090708@austin.ibm.com> <3d0408630906300810v64f67379h16650d1cfd481085@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Yan Zheng <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630906300810v64f67379h16650d1cfd481085@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Yan Zheng wrote:
> 2009/6/30 Steven Pratt <slpratt@austin.ibm.com>:
>   
>> Chris Mason wrote:
>>     
>>> On Fri, Jun 26, 2009 at 09:26:59PM -0500, Steven Pratt wrote:
>>>
>>>       
>>>> Chris Mason wrote:
>>>>
>>>>         
>>>>> On Fri, Jun 26, 2009 at 09:28:51AM -0500, Steven Pratt wrote:
>>>>>
>>>>>           
>>>>>> Upgraded the btrfs tree to 6-17 and all of the stability problems went
>>>>>>  away on the single disk system, so not sure if this was a code problem  or
>>>>>> hardware, but at least stable now.
>>>>>> Performance results updated at:
>>>>>> http://btrfs.boxacle.net/repository/single-disk/History/History.html
>>>>>>
>>>>>> The fixed to the cow path are obvious for random write, although even
>>>>>> on  single disk the CPU overhead is very noticeable as the efficiency graphs
>>>>>>  show.
>>>>>>
>>>>>> The good news is that now the only workload that Btrfs is not at or
>>>>>> near  the top in performance for single disk is MailServer.
>>>>>>
>>>>>>             
>>>>> Thanks Steve, glad to hear the stability problems are gone.
>>>>>
>>>>>
>>>>>           
>>>> Well, maybe I spoke too soon. :-(    Run with this patch died in similar
>>>>  way to before.  My remote service console is not responding, so will
>>>>  probably be Monday before I can get to the lab to restart manually.
>>>>
>>>>
>>>> I am getting messages like:
>>>>
>>>> Lots of these timeout messages, then eventually
>>>>
>>>> 18:40:32 btrfs2 kernel: [ 4459.870613] sd 0:0:1:0: [sdb] Unhandled error
>>>> code
>>>> Jun 26 18:40:32 btrfs2 kernel: [ 4459.870640] sd 0:0:1:0: [sdb] Result:
>>>>  hostbyte=DID_ABORT driverbyte=DRIVER_OK
>>>> Jun 26 18:40:32 btrfs2 kernel: [ 4459.870646] end_request: I/O error,
>>>>  dev sdb, sector 103359232
>>>>
>>>> So still not sure if this is HW, but no other FS has triggered it.
>>>>
>>>>
>>>>         
>>> I'm afraid Btrfs can't do this on its own.  It needs to HW, scsi
>>> drivers or HW or scsi drivdes ;)
>>>
>>> You could try dd if=/dev/sdb of=/dev/zero bs=512 count=1 skip=103359232
>>>
>>>       
>> Well, dd write of entire drive shows no errors.  Ran btrfs tests again and
>> go this, no disk or scsi errors reported this time.
>>
>>
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] kernel BUG at
>> fs/btrfs/extent-tree.c:3865!
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] invalid opcode: 0000 [#1] SMP
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] last sysfs file:
>> /sys/devices/system/cpu/cpu15/cache/index1/shared_cpu_map
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] CPU 8
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] Modules linked in: oprofile
>> btrfs zlib_deflate autofs4 nfs lockd nfs_acl auth_rpcgss sunrpc dm_multipath
>> sbs sbshc ba
>> ttery ac parport_pc lp parport sg joydev serio_raw acpi_memhotplug rtc_cmos
>> rtc_core rtc_lib button tg3 libphy i2c_piix4 i2c_core pcspkr dm_snapshot
>> dm_zero dm_mir
>> ror dm_region_hash dm_log dm_mod lpfc scsi_transport_fc aic94xx libsas
>> libata scsi_transport_sas sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd
>> ehci_hcd [last unloaded
>> : microcode]
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] Pid: 21731, comm:
>> btrfs-endio-wri Not tainted 2.6.30-rc7-autokern1 #1 IBM x3950-[88726RU]-
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] RIP: 0010:[<ffffffffa0346ce4>]
>>  [<ffffffffa0346ce4>] alloc_reserved_file_extent+0x8d/0x1c3 [btrfs]
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] RSP: 0018:ffff88013e10bb60
>>  EFLAGS: 00010282
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] RAX: 00000000ffffffef RBX:
>> ffff88006fbde000 RCX: 0000000000000002
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] RDX: 0000000000000001 RSI:
>> 0000000000000000 RDI: ffff8801020ac5b0
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] RBP: ffff88013e10bbd0 R08:
>> ffff88013e10b9d8 R09: ffff88013e10b9d0
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] R10: 0000000000000004 R11:
>> ffff8801020ac5b0 R12: 000000000000001d
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] R13: ffff88012e1e7910 R14:
>> 0000000000000000 R15: 0000000000000000
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] FS:  0000000000000000(0000)
>> GS:ffff88002bac0000(0000) knlGS:0000000000000000
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] CS:  0010 DS: 0018 ES: 0018
>> CR0: 000000008005003b
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] CR2: 00007fffdac2efb0 CR3:
>> 0000000138cc9000 CR4: 00000000000006e0
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] DR0: 0000000000000000 DR1:
>> 0000000000000000 DR2: 0000000000000000
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] DR3: 0000000000000000 DR6:
>> 00000000ffff0ff0 DR7: 0000000000000400
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] Process btrfs-endio-wri (pid:
>> 21731, threadinfo ffff88013e10a000, task ffff880138d117b0)
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] Stack:
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  0000000000000000
>> 00000000000011d5 0000000000000005 0000000000000000
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  ffff88005fcb0800
>> ffff88011a47f860 000000b2844a5030 000000000000008c
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  000000352e1e7910
>> ffff8800be095540 ffff8800be095740 0000000000000001
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011] Call Trace:
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  [<ffffffffa034b198>]
>> run_one_delayed_ref+0x382/0x42f [btrfs]
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  [<ffffffffa036abbd>] ?
>> map_extent_buffer+0xab/0xbe [btrfs]
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  [<ffffffffa034bf75>]
>> run_clustered_refs+0x237/0x2b4 [btrfs]
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  [<ffffffffa037ef71>] ?
>> btrfs_find_ref_cluster+0xdc/0x115 [btrfs]
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  [<ffffffffa034c09e>]
>> btrfs_run_delayed_refs+0xac/0x195 [btrfs]
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  [<ffffffffa035486e>]
>> __btrfs_end_transaction+0x59/0xfe [btrfs]
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  [<ffffffffa035492e>]
>> btrfs_end_transaction+0xb/0xd [btrfs]
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  [<ffffffffa035a18b>]
>> btrfs_finish_ordered_io+0x224/0x24d [btrfs]
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  [<ffffffffa035a1c4>]
>> btrfs_writepage_end_io_hook+0x10/0x12 [btrfs]
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  [<ffffffffa036d585>]
>> end_bio_extent_writepage+0xa3/0x18f [btrfs]
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  [<ffffffff8024276e>] ?
>> del_timer_sync+0x14/0x20
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  [<ffffffff802cbbee>]
>> bio_endio+0x26/0x28
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  [<ffffffffa03515d6>]
>> end_workqueue_fn+0x111/0x11e [btrfs]
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  [<ffffffffa0374fe1>]
>> worker_loop+0x67/0x1ee [btrfs]
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  [<ffffffffa0374f7a>] ?
>> worker_loop+0x0/0x1ee [btrfs]
>> Jun 29 15:55:34 btrfs2 kernel: [ 8214.725011]  [<ffffffff8024c324>]
>> kthread+0x56/0x86
>> Jun 29 15:55:35 btrfs2 kernel: [ 8214.725011]  [<ffffffff8020c9fa>]
>> child_rip+0xa/0x20
>> Jun 29 15:55:35 btrfs2 kernel: [ 8214.725011]  [<ffffffff8024c2ce>] ?
>> kthread+0x0/0x86
>> Jun 29 15:55:35 btrfs2 kernel: [ 8214.725011]  [<ffffffff8020c9f0>] ?
>> child_rip+0x0/0x20
>> Jun 29 15:55:35 btrfs2 kernel: [ 8214.725011] Code: 08 4c 8d 45 d4 41 8d 44
>> 24 18 48 8b 73 20 48 8b 4d 18 41 b9 01 00 00 00 48 8b 7d b8 4c 89 ea 89 45
>> d4 e8 df e3
>> ff ff 85 c0 74 04 <0f> 0b eb fe 49 63 75 40 4d 8b 65 00 49 83 cf 01 4c 89 e7
>> 48 6b
>> Jun 29 15:55:35 btrfs2 kernel: [ 8214.725011] RIP  [<ffffffffa0346ce4>]
>> alloc_reserved_file_extent+0x8d/0x1c3 [btrfs]
>> Jun 29 15:55:35 btrfs2 kernel: [ 8214.725011]  RSP <ffff88013e10bb60>
>> Jun 29 15:55:35 btrfs2 kernel: [ 8215.101864] ---[ end trace
>> 2a2583ccd67ef43b ]---
>>
>>     
>
> Is there any "parent transid verify failed on xxx wanted xxx found" like message
> in the log ?
>   

No, nothing like that.

Steve
> Thank you,
> Yan Zheng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

