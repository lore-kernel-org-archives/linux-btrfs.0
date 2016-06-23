Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:23568 "EHLO
	esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbcFWTXx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 15:23:53 -0400
Date: Thu, 23 Jun 2016 15:13:47 -0400
From: Scott Talbert <scott.talbert@hgst.com>
To: Steven Haigh <netwiz@crc.id.au>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: system crash on replace
In-Reply-To: <a4132954-66e2-f218-f201-3d19b3c9ee72@crc.id.au>
Message-ID: <alpine.DEB.2.10.1606231510080.4618@dispatch>
References: <4805f6ef-a422-ab61-657b-8aafa9c47d1b@crc.id.au> <22c30021-3939-795d-fd96-b116cd739764@gmail.com> <a4132954-66e2-f218-f201-3d19b3c9ee72@crc.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Thu, 23 Jun 2016, Steven Haigh wrote:

> On 24/06/16 04:35, Austin S. Hemmelgarn wrote:
>> On 2016-06-23 13:44, Steven Haigh wrote:
>>> Hi all,
>>>
>>> Relative newbie to BTRFS, but long time linux user. I pass the full
>>> disks from a Xen Dom0 -> guest DomU and run BTRFS within the DomU.
>>>
>>> I've migrated my existing mdadm RAID6 to a BTRFS raid6 layout. I have a
>>> drive that threw a few UNC errors during a subsequent balance, so I've
>>> pulled that drive, dd /dev/zero to it, then trying to add it back in to
>>> the BTRFS system via:
>>>     btrfs replace start 4 /dev/xvdf /mnt/fileshare
>>>
>>> The command gets accepted and the replace starts - however apart from it
>>> being at a glacial pace, it seems to hang the system hard with the
>>> following output:
>>>
>>> zeus login: BTRFS info (device xvdc): not using ssd allocation scheme
>>> BTRFS info (device xvdc): disk space caching is enabled
>>> BUG: unable to handle kernel paging request at ffffc90040eed000
>>> IP: [<ffffffff81332292>] __memcpy+0x12/0x20
>>> PGD 7fbc6067 PUD 7ce9e067 PMD 7b6d6067 PTE 0
>>> Oops: 0002 [#1] SMP
>>> Modules linked in: x86_pkg_temp_thermal coretemp crct10dif_pclmul btrfs
>>> aesni_intel aes_x86_64 lrw gf128mul xor glue_helper ablk_helper cryptd
>>> pcspkr raid6_pq nfsd auth
>>> _rpcgss nfs_acl lockd grace sunrpc ip_tables xen_netfront crc32c_intel
>>> xen_gntalloc xen_evtchn ipv6 autofs4
>>> CPU: 1 PID: 2271 Comm: kworker/u4:4 Not tainted 4.4.13-1.el7xen.x86_64 #1
>>> Workqueue: btrfs-endio btrfs_endio_helper [btrfs]
>>> task: ffff88007c5c83c0 ti: ffff88005b978000 task.ti: ffff88005b978000
>>> RIP: e030:[<ffffffff81332292>]  [<ffffffff81332292>] __memcpy+0x12/0x20
>>> RSP: e02b:ffff88005b97bc60  EFLAGS: 00010246
>>> RAX: ffffc90040eecff8 RBX: 0000000000001000 RCX: 00000000000001ff
>>> RDX: 0000000000000000 RSI: ffff88004e4ec008 RDI: ffffc90040eed000
>>> RBP: ffff88005b97bd28 R08: ffffc90040eeb000 R09: 00000000607a06e1
>>> R10: 0000000000007ff0 R11: 0000000000000000 R12: 0000000000000000
>>> R13: 00000000607a26d9 R14: 00000000607a26e1 R15: ffff880062c613d8
>>> FS:  00007fd08feb88c0(0000) GS:ffff88007f500000(0000)
>>> knlGS:0000000000000000
>>> CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: ffffc90040eed000 CR3: 0000000056004000 CR4: 0000000000042660
>>> Stack:
>>>  ffffffffa05afc77 ffff88005b97bc90 ffffffff81190a14 0000160000000000
>>>  ffff88005ba01900 0000000000000000 00000000607a06e1 ffffc90040eeb000
>>>  0000000000000002 000000000000001b 0000000000000000 0000002000000001
>>> Call Trace:
>>>  [<ffffffffa05afc77>] ? lzo_decompress_biovec+0x237/0x2b0 [btrfs]
>>>  [<ffffffff81190a14>] ? vmalloc+0x54/0x60
>>>  [<ffffffffa05b0b24>] end_compressed_bio_read+0x1d4/0x2a0 [btrfs]
>>>  [<ffffffff811a877c>] ? kmem_cache_free+0xcc/0x2c0
>>>  [<ffffffff812f40c0>] bio_endio+0x40/0x60
>>>  [<ffffffffa055fa6c>] end_workqueue_fn+0x3c/0x40 [btrfs]
>>>  [<ffffffffa05993f1>] normal_work_helper+0xc1/0x300 [btrfs]
>>>  [<ffffffff810a1352>] ? finish_task_switch+0x82/0x280
>>>  [<ffffffffa0599702>] btrfs_endio_helper+0x12/0x20 [btrfs]
>>>  [<ffffffff81093844>] process_one_work+0x154/0x400
>>>  [<ffffffff8109438a>] worker_thread+0x11a/0x460
>>>  [<ffffffff81094270>] ? rescuer_thread+0x2f0/0x2f0
>>>  [<ffffffff810993f9>] kthread+0xc9/0xe0
>>>  [<ffffffff81099330>] ? kthread_park+0x60/0x60
>>>  [<ffffffff8165e14f>] ret_from_fork+0x3f/0x70
>>>  [<ffffffff81099330>] ? kthread_park+0x60/0x60
>>> Code: 74 0e 48 8b 43 60 48 2b 43 50 88 43 4e 5b 5d c3 e8 b4 fc ff ff eb
>>> eb 90 90 66 66 90 66 90 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 <f3> 48
>>> a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 f3
>>> RIP  [<ffffffff81332292>] __memcpy+0x12/0x20
>>>  RSP <ffff88005b97bc60>
>>> CR2: ffffc90040eed000
>>> ---[ end trace 001cc830ec804da7 ]---
>>> BUG: unable to handle kernel paging request at ffffffffffffffd8
>>> IP: [<ffffffff81099b60>] kthread_data+0x10/0x20
>>> PGD 188d067 PUD 188f067 PMD 0
>>> Oops: 0000 [#2] SMP
>>> Modules linked in: x86_pkg_temp_thermal coretemp crct10dif_pclmul btrfs
>>> aesni_intel aes_x86_64 lrw gf128mul xor glue_helper ablk_helper cryptd
>>> pcspkr raid6_pq nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables
>>> xen_netfront crc32c_intel xen_gntalloc xen_evtchn ipv6 autofs4
>>> CPU: 1 PID: 2271 Comm: kworker/u4:4 Tainted: G      D
>>> 4.4.13-1.el7xen.x86_64 #1
>>> task: ffff88007c5c83c0 ti: ffff88005b978000 task.ti: ffff88005b978000
>>> RIP: e030:[<ffffffff81099b60>]  [<ffffffff81099b60>]
>>> kthread_data+0x10/0x20
>>> RSP: e02b:ffff88005b97b980  EFLAGS: 00010002
>>> RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000001
>>> RDX: ffffffff81bd5080 RSI: 0000000000000001 RDI: ffff88007c5c83c0
>>> RBP: ffff88005b97b980 R08: 0000000000000001 R09: 000013f6a632677e
>>> R10: 000000000000001f R11: 0000000000000000 R12: ffff88007c5c83c0
>>> R13: 0000000000000000 R14: 00000000000163c0 R15: 0000000000000001
>>> FS:  00007fd08feb88c0(0000) GS:ffff88007f500000(0000)
>>> knlGS:0000000000000000
>>> CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 0000000000000028 CR3: 0000000056004000 CR4: 0000000000042660
>>> Stack:
>>>  ffff88005b97b998 ffffffff81094751 ffff88007f5163c0 ffff88005b97b9e0
>>>  ffffffff8165a34f ffff88007b678448 ffff88007c5c83c0 ffff88005b97c000
>>>  ffff88007c5c8710 0000000000000000 ffff88007c5c83c0 ffff88007cffacc0
>>> Call Trace:
>>>  [<ffffffff81094751>] wq_worker_sleeping+0x11/0x90
>>>  [<ffffffff8165a34f>] __schedule+0x3bf/0x880
>>>  [<ffffffff8165a845>] schedule+0x35/0x80
>>>  [<ffffffff8107fc3f>] do_exit+0x65f/0xad0
>>>  [<ffffffff8101a5ea>] oops_end+0x9a/0xd0
>>>  [<ffffffff8105f7ad>] no_context+0x10d/0x360
>>>  [<ffffffff8105fb09>] __bad_area_nosemaphore+0x109/0x210
>>>  [<ffffffff8105fc23>] bad_area_nosemaphore+0x13/0x20
>>>  [<ffffffff81060200>] __do_page_fault+0x80/0x3f0
>>>  [<ffffffff8118e3a4>] ? vmap_page_range_noflush+0x284/0x390
>>>  [<ffffffff81060592>] do_page_fault+0x22/0x30
>>>  [<ffffffff8165fea8>] page_fault+0x28/0x30
>>>  [<ffffffff81332292>] ? __memcpy+0x12/0x20
>>>  [<ffffffffa05afc77>] ? lzo_decompress_biovec+0x237/0x2b0 [btrfs]
>>>  [<ffffffff81190a14>] ? vmalloc+0x54/0x60
>>>  [<ffffffffa05b0b24>] end_compressed_bio_read+0x1d4/0x2a0 [btrfs]
>>>  [<ffffffff811a877c>] ? kmem_cache_free+0xcc/0x2c0
>>>  [<ffffffff812f40c0>] bio_endio+0x40/0x60
>>>  [<ffffffffa055fa6c>] end_workqueue_fn+0x3c/0x40 [btrfs]
>>>  [<ffffffffa05993f1>] normal_work_helper+0xc1/0x300 [btrfs]
>>>  [<ffffffff810a1352>] ? finish_task_switch+0x82/0x280
>>>  [<ffffffffa0599702>] btrfs_endio_helper+0x12/0x20 [btrfs]
>>>  [<ffffffff81093844>] process_one_work+0x154/0x400
>>>  [<ffffffff8109438a>] worker_thread+0x11a/0x460
>>>  [<ffffffff81094270>] ? rescuer_thread+0x2f0/0x2f0
>>>  [<ffffffff810993f9>] kthread+0xc9/0xe0
>>>  [<ffffffff81099330>] ? kthread_park+0x60/0x60
>>>  [<ffffffff8165e14f>] ret_from_fork+0x3f/0x70
>>>  [<ffffffff81099330>] ? kthread_park+0x60/0x60
>>> Code: ff ff eb 92 be 3a 02 00 00 48 c7 c7 de 81 7a 81 e8 d6 34 fe ff e9
>>> d5 fe ff ff 90 66 66 66 66 90 55 48 8b 87 00 04 00 00 48 89 e5 <48> 8b
>>> 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
>>> RIP  [<ffffffff81099b60>] kthread_data+0x10/0x20
>>>  RSP <ffff88005b97b980>
>>> CR2: ffffffffffffffd8
>>> ---[ end trace 001cc830ec804da8 ]---
>>> Fixing recursive fault but reboot is needed!
>>>
>>> Current details:
>>> $ btrfs fi show
>>> Label: 'BTRFS'  uuid: 41cda023-1c96-4174-98ba-f29a3d38cd85
>>>         Total devices 5 FS bytes used 4.81TiB
>>>         devid    1 size 2.73TiB used 1.66TiB path /dev/xvdc
>>>         devid    2 size 2.73TiB used 1.67TiB path /dev/xvdd
>>>         devid    3 size 1.82TiB used 1.82TiB path /dev/xvde
>>>         devid    5 size 1.82TiB used 1.82TiB path /dev/xvdg
>>>         *** Some devices missing
>>>
>>> $ btrfs fi df /mnt/fileshare
>>> Data, RAID6: total=5.14TiB, used=4.81TiB
>>> System, RAID6: total=160.00MiB, used=608.00KiB
>>> Metadata, RAID6: total=6.19GiB, used=5.19GiB
>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>
>>> [   12.833431] Btrfs loaded
>>> [   12.834339] BTRFS: device label BTRFS devid 1 transid 46614 /dev/xvdc
>>> [   12.861109] BTRFS: device label BTRFS devid 0 transid 46614 /dev/xvdf
>>> [   12.861357] BTRFS: device label BTRFS devid 3 transid 46614 /dev/xvde
>>> [   12.862859] BTRFS: device label BTRFS devid 2 transid 46614 /dev/xvdd
>>> [   12.863372] BTRFS: device label BTRFS devid 5 transid 46614 /dev/xvdg
>>> [  379.629911] BTRFS info (device xvdg): allowing degraded mounts
>>> [  379.630028] BTRFS info (device xvdg): not using ssd allocation scheme
>>> [  379.630120] BTRFS info (device xvdg): disk space caching is enabled
>>> [  379.630207] BTRFS: has skinny extents
>>> [  379.631024] BTRFS warning (device xvdg): devid 4 uuid
>>> 61ccce61-9787-453e-b793-1b86f8015ee1 is missing
>>> [  383.675967] BTRFS info (device xvdg): continuing dev_replace from
>>> <missing disk> (devid 4) to /dev/xvdf @0%
>>>
>>> I've currently cancelled the replace with a btrfs replace cancel
>>> /mnt/fileshare - so at least the system doesn't crash completely in the
>>> meantime - and mounted it with -o degraded until I can see what the deal
>>> is here.
>>>
>>> Any suggestions?
>>>
>> The first thing I would suggest is to follow the suggestion at the
>> bottom of the back-trace you got, and reboot your system.  If you've hit
>> a recursive page fault, then something is going seriously wrong, and you
>> really can't trust the state of the system afterwards.
>
> It doesn't give me a choice here - the entire VM becomes unresponsive :)
>
>> Now, with that out of the way, I think you've actually hit two bugs. The
>> first is a known issue with a currently unknown cause in the BTRFS raid6
>> code which causes rebuilds to take extremely long amounts of time (the
>> only time I've seen this happen myself it took 8 hours to rebuild a FS
>> with only a few hundred GB of data on it, when the same operation with a
>> raid1 profile took only about 20 minutes).  The second appears to be a
>> previously unreported (at least, I've never seen anything like this
>> reported) issue in the in-line compression code.  You may be able to
>> work around the second bug short term by turning off compression in the
>> mount options, but I'm not 100% certain if this will help.
>>
>> Expanding further on this all though, after rebooting, see if you get
>> the same BUG output after rebooting the system (before turning off
>> compression in the mount options).  If it doesn't happen again, then I'd
>> seriously suggest checking your hardware, as certain types of RAM and/or
>> CPU issues can trigger things like this, and while this particular
>> symptom only shows up intermittently, the primary symptom is data
>> corruption in RAM.
>
> What seems to happen is that the system will boot again, I mount the
> filesystem, it says "Cool! I was doing a replace. I should resume it"
> and then promptly die with a similar crash again.
>
>> As far as the raid6 rebuild issue, there's currently not any known
>> method to fix it, let alone any known way to reliably reproduce it
>> (multiple people have reported it, but I don't know of anyone who has
>> been able to reliably reproduce it starting with a new filesystem).
>> Given this and the couple of other known issues in the raid5/6 code (one
>> being a slightly different form of the traditional 'write hole', and the
>> other being an issue with scrub parsing device stats), general advice
>> here is to avoid using raid5/6 for production systems for the time being.
>
> Right now, I've cancelled the replace via 'btrfs replace cancel', which
> freed up the device. I this did:
> 	$ btrfs device add /dev/xvdf /mnt/fileshare
> 	$ btrfs device delete missing /mnt/fileshare
>
> This seems to be rebalancing the data from all drives (and I assume
> recalculating anything that is missing) onto the 'new' target.

Indeed, device replace seems to be broken with raid5/6, but device add / 
device delete missing seems to work (and is much faster, as you've noted).

Scott
