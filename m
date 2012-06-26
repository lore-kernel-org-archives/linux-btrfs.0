Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailpro.odiso.net ([89.248.209.98]:54800 "EHLO
	mailpro.odiso.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2FZETJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 00:19:09 -0400
Date: Tue, 26 Jun 2012 06:09:18 +0200 (CEST)
From: Alexandre DERUMIER <aderumier@odiso.com>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Sage Weil <sage@inktank.com>
Subject: Re: btrfs call trace
Message-ID: <07a2e84b-067e-4963-a59d-eada2f934be9@mailpro>
In-Reply-To: <7DF1A6C5-0EC7-4B4F-8450-F8BBF1A06301@profihost.ag>
Content-Type: text/plain; charset=utf-8
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Stephan,
Maybe it can help:

If I remember discard from a kvm guest works only with ide and scsi device, but not virtio device.

----- Mail original ----- 

De: "Stefan Priebe" <s.priebe@profihost.ag> 
À: "Sage Weil" <sage@inktank.com> 
Cc: ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org 
Envoyé: Mardi 26 Juin 2012 00:12:10 
Objet: Re: btrfs call trace 

Thanks it seems to be a problem with the discard option. I'm already talking to JBacik at linux-btrfs. 

You can find more info in this thread. 

http://www.spinics.net/lists/linux-btrfs/msg17439.html 

Hopefully we can solve it as discard gives me a huge improvement in ceph. 

Stefan 

Am 26.06.2012 um 00:04 schrieb Sage Weil <sage@inktank.com>: 

> Hi Stefan, 
> 
> I haven't seen this one. The async commit stuff is mine, but there 
> haven't been problems with it for a year or more. This is a recent 
> kernel, I assume? 
> 
> Can you dump the other tasks? Something is preventing the commit from 
> completing. 
> 
> [adding linux-btrfs to cc] 
> 
> sage 
> 
> 
> On Fri, 22 Jun 2012, Stefan Priebe wrote: 
> 
>> Hi, 
>> 
>> are these bugs known? 
>> 
>> [ 2157.104532] INFO: task kworker/2:2:6278 blocked for more than 120 seconds. 
>> [ 2157.130649] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
>> this message. 
>> [ 2157.156750] kworker/2:2 D ffffffff8180eba0 0 6278 2 
>> 0x00000000 
>> [ 2157.182763] ffff880c3c0d7c90 0000000000000046 ffff880c3e2aa1c0 
>> 0000000000012280 
>> [ 2157.208662] ffff880c3c0d7fd8 ffff880c3c0d6010 0000000000012280 
>> 0000000000012280 
>> [ 2157.234591] ffff880c3c0d7fd8 0000000000012280 ffff880e78e5a240 
>> ffff880c3e2aa1c0 
>> [ 2157.260573] Call Trace: 
>> [ 2157.285872] [<ffffffff81620334>] schedule+0x24/0x70 
>> [ 2157.311097] [<ffffffffa007f4e5>] wait_for_commit+0x55/0x90 [btrfs] 
>> [ 2157.311106] [<ffffffff81060140>] ? wake_up_bit+0x40/0x40 
>> [ 2157.311129] [<ffffffffa00810b5>] btrfs_commit_transaction+0x655/0xab0 
>> [btrfs] 
>> [ 2157.311134] [<ffffffff810736f0>] ? set_next_entity+0x90/0xa0 
>> [ 2157.311138] [<ffffffff81060140>] ? wake_up_bit+0x40/0x40 
>> [ 2157.311156] [<ffffffffa0081810>] ? btrfs_end_transaction+0x20/0x20 [btrfs] 
>> [ 2157.311171] [<ffffffffa008182a>] do_async_commit+0x1a/0x30 [btrfs] 
>> [ 2157.311175] [<ffffffff81058eff>] process_one_work+0x11f/0x470 
>> [ 2157.311179] [<ffffffff8105b128>] worker_thread+0x178/0x400 
>> [ 2157.311182] [<ffffffff8105afb0>] ? manage_workers+0x210/0x210 
>> [ 2157.311185] [<ffffffff8105fc46>] kthread+0x96/0xa0 
>> [ 2157.311190] [<ffffffff81622dd4>] kernel_thread_helper+0x4/0x10 
>> [ 2157.311195] [<ffffffff8105fbb0>] ? kthread_worker_fn+0x130/0x130 
>> [ 2157.311198] [<ffffffff81622dd0>] ? gs_change+0xb/0xb 
>> [ 2157.311220] INFO: task ceph-osd:14426 blocked for more than 120 seconds. 
>> [ 2157.311220] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
>> this message. 
>> [ 2157.311224] ceph-osd D 0000000000000002 0 14426 1 
>> 0x00000000 
>> [ 2157.311228] ffff880ae8c33c38 0000000000000082 ffff880a39142180 
>> 0000000000012280 
>> [ 2157.311231] ffff880ae8c33fd8 ffff880ae8c32010 0000000000012280 
>> 0000000000012280 
>> [ 2157.311234] ffff880ae8c33fd8 0000000000012280 ffff880983efa1c0 
>> ffff880a39142180 
>> [ 2157.311235] Call Trace: 
>> [ 2157.311240] [<ffffffff81620334>] schedule+0x24/0x70 
>> [ 2157.311256] [<ffffffffa0081d85>] 
>> btrfs_commit_transaction_async+0x1d5/0x240 [btrfs] 
>> [ 2157.311271] [<ffffffffa0065eb6>] ? block_rsv_add_bytes+0x26/0x60 [btrfs] 
>> [ 2157.311275] [<ffffffff81060140>] ? wake_up_bit+0x40/0x40 
>> [ 2157.311289] [<ffffffffa0065f25>] ? block_rsv_migrate_bytes+0x35/0x50 
>> [btrfs] 
>> [ 2157.311311] [<ffffffffa00b2d5e>] btrfs_mksubvol+0x2be/0x350 [btrfs] 
>> [ 2157.311329] [<ffffffffa00b2ef9>] 
>> btrfs_ioctl_snap_create_transid+0x109/0x1a0 [btrfs] 
>> [ 2157.311346] [<ffffffffa00b4bf4>] btrfs_ioctl_snap_create_v2+0x84/0xf0 
>> [btrfs] 
>> [ 2157.311363] [<ffffffffa00b756f>] btrfs_ioctl+0x76f/0x12d0 [btrfs] 
>> [ 2157.311368] [<ffffffff8114459a>] ? fsnotify+0x1ba/0x2e0 
>> [ 2157.311372] [<ffffffff8111ade3>] do_vfs_ioctl+0x93/0x4f0 
>> [ 2157.311375] [<ffffffff8111b28a>] sys_ioctl+0x4a/0x80 
>> [ 2157.311379] [<ffffffff81621ba2>] system_call_fastpath+0x16/0x1b 
>> 
>> Stefan 
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in 
>> the body of a message to majordomo@vger.kernel.org 
>> More majordomo info at http://vger.kernel.org/majordomo-info.html 
>> 
>> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in 
> the body of a message to majordomo@vger.kernel.org 
> More majordomo info at http://vger.kernel.org/majordomo-info.html 
-- 
To unsubscribe from this list: send the line "unsubscribe ceph-devel" in 
the body of a message to majordomo@vger.kernel.org 
More majordomo info at http://vger.kernel.org/majordomo-info.html 



-- 

-- 



	

Alexandre D e rumier 

Ingénieur Systèmes et Réseaux 


Fixe : 03 20 68 88 85 

Fax : 03 20 68 90 88 


45 Bvd du Général Leclerc 59100 Roubaix 
12 rue Marivaux 75002 Paris 

