Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:37761 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbbDNMcn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Apr 2015 08:32:43 -0400
Received: by igblo3 with SMTP id lo3so12922334igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2015 05:32:43 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAJiZgcqkfr-_Fp6fK1MG3PwCLNAqyx28W9Sxa86+++902rNsfA@mail.gmail.com>
References: <CAJiZgcoDyD6eT8giU48xUSSYZvAerwTCjnG7LpyVNFuRQcR=ZQ@mail.gmail.com>
	<CAL3q7H4CucRKtwXiVdmfDAq0NRxGEv8VKHzfMG59Er3VU1ivcw@mail.gmail.com>
	<CAJiZgcqkfr-_Fp6fK1MG3PwCLNAqyx28W9Sxa86+++902rNsfA@mail.gmail.com>
Date: Tue, 14 Apr 2015 13:32:42 +0100
Message-ID: <CAL3q7H62R6trDPajY9njYp3H-dhgbTwPyChiouQDvgPtudhXmA@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: incremental send, don't rename a directory too soon
From: Filipe David Manana <fdmanana@gmail.com>
To: Robbie Ko <robbieko@synology.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 14, 2015 at 12:09 PM, Robbie Ko <robbieko@synology.com> wrote:
> Hi,
>
> Sorry for not making it clear.
>
> 2015-04-14 16:16 GMT+08:00 Filipe David Manana <fdmanana@gmail.com>:
>> On Tue, Apr 14, 2015 at 8:33 AM, Robbie Ko <robbieko@synology.com> wrote:
>>> Hi,
>>>
>>> After applying the patch, I got WARN_ON.
>>> btrfs progs finished without any error message,
>>> but received subvolume is not the same as send subvolume.
>>>
>>> Here's the related information.
>>> thanks,
>>> robbieko
>>>
>>> uanme -a
>>> Linux ubuntu 4.0.0-rc4-custom #2 SMP Tue Apr 14 11:43:00 CST 2015
>>> x86_64 x86_64 x86_64 GNU/Linux
>>> btrfs --version
>>> Btrfs v3.14.1
>>>
>>> Steps to reproduce:
>>>
>>>  $ mkfs.btrfs -f /dev/sdb
>>>  $ mount /dev/sdb /mnt
>>>  $ mkfs.btrfs -f /dev/sdc
>>>  $ mount /dev/sdc /mnt2
>>>
>>> $ mkdir -p /mnt/data
>>> $ mkdir -p /mnt/data/n1/n2
>>> $ mkdir -p /mnt/data/n4
>>> $ mkdir -p /mnt/data/n1/n2/p1
>>> $ mkdir -p /mnt/data/t4
>>> $ mkdir -p /mnt/data/p1
>>> $ mkdir -p /mnt/data/p1/2
>>>
>>>   $ btrfs subvolume snapshot -r /mnt /mnt/snap1
>>>
>>> $ mv /mnt/data/n1/n2 /mnt/data/t4
>>> $ mv /mnt/data/n4 /mnt/data/t4/n2
>>> $ mv /mnt/data/t4/n2/p1 /mnt/data/t4/p1
>>> $ mv /mnt/data/p1 /mnt/data/t4/n2
>>>
>>>   $ btrfs subvolume snapshot -r /mnt /mnt/snap2
>>>
>>>   $ btrfs send /mnt/snap1 | btrfs receive /mnt2
>>>   $ btrfs send -p /mnt/snap1 /mnt/snap2 | btrfs receive /mnt2
>>
>> So this is a new case, different from the ones you've sent before, isn't it?
>>
>> You should have all previous patches applied too, not just this one
>> you're replying to.
>
> Hi,
>
> I have applied all the patches fixed recently.
> Then WARN_ON happened with steps mentioned above.
> I tested it without these patches, no WARN_ON but the following error
> appeared instead.
> ERROR: rename data/t4/n2/p1 -> data/t4/n2/p1/p1 failed. Invalid argument
>
> I started to revert these patches and found that this patch causes the
> WARN_ON problem.
>
> I'm not sure whether it's a new case.

So it's a case that didn't work neither before nor after all the
recent fixes, but for different reasons.
I have 2 cases here, one triggered by your fuzz tester script and
another one I know of for quite some time (involving creation of new
directories and removing old ones in the second snapshot) but haven't
had the time to find a solution without breaking other cases that are
currently working (and have xfstests). Haven't checked however if your
reproducer fails for the same reasons as those 2 cases I know of.

thanks

>
> thanks,
> robbieko
>
>> Also, it isn't clear, are you saying this happens only with this
>> particular patch applied but doesn't happen without it (and all other
>> recent ones)?
>>
>> thanks
>>
>>
>>>
>>> Call trace message
>>>
>>> [  135.498533] ------------[ cut here ]------------
>>>
>>> [  135.498557] WARNING: CPU: 1 PID: 2346 at fs/btrfs/send.c:5934
>>> btrfs_ioctl_send+0xc4c/0x11e0 [btrfs]()
>>>
>>> [  135.498560] Modules linked in: nf_conntrack_ipv4(E)
>>> nf_defrag_ipv4(E) xt_conntrack(E) nf_conntrack(E) ipt_REJECT(E)
>>> nf_reject_ipv4(E) xt_tcpudp(E) iptable_filter(E) ip_tables(E)
>>> x_tables(E) bridge(E) stp(E) llc(E) snd_intel8x0(E) snd_ac97_codec(E)
>>> ac97_bus(E) snd_pcm(E) snd_timer(E) snd(E) iosf_mbi(E) soundcore(E)
>>> ppdev(E) joydev(E) lp(E) serio_raw(E) parport_pc(E) i2c_piix4(E)
>>> mac_hid(E) parport(E) btrfs(E) xor(E) raid6_pq(E) hid_generic(E)
>>> usbhid(E) hid(E) ahci(E) psmouse(E) libahci(E) e1000(E) pata_acpi(E)
>>>
>>> [  135.498578] CPU: 1 PID: 2346 Comm: btrfs Tainted: G         E
>>> 4.0.0-rc4-custom #3
>>>
>>> [  135.498580] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
>>> VirtualBox 12/01/2006
>>>
>>> [  135.498583]  ffffffffc0509016 ffff88007a233c08 ffffffff817b62f3
>>> 0000000000000007
>>>
>>> [  135.498586]  0000000000000000 ffff88007a233c48 ffffffff8107452a
>>> ffffc90000567000
>>>
>>> [  135.498590]  ffff8800799f1400 ffff8800799f1418 ffff88007b3f82d0
>>> ffff880079f60000
>>>
>>> [  135.498593] Call Trace:
>>>
>>> [  135.498602]  [<ffffffff817b62f3>] dump_stack+0x45/0x57
>>>
>>> [  135.498609]  [<ffffffff8107452a>] warn_slowpath_common+0x8a/0xc0
>>>
>>> [  135.498614]  [<ffffffff8107461a>] warn_slowpath_null+0x1a/0x20
>>>
>>> [  135.498626]  [<ffffffffc04f5c6c>] btrfs_ioctl_send+0xc4c/0x11e0 [btrfs]
>>>
>>> [  135.498632]  [<ffffffff8118020e>] ? __alloc_pages_nodemask+0x1ae/0xab0
>>>
>>> [  135.498638]  [<ffffffff810a4775>] ? sched_clock_local+0x25/0x90
>>>
>>> [  135.498643]  [<ffffffff8109182e>] ? alloc_pid+0x2e/0x530
>>>
>>> [  135.498655]  [<ffffffffc04bc4f6>] btrfs_ioctl+0x286/0x27e0 [btrfs]
>>>
>>> [  135.498660]  [<ffffffff810a6368>] ? __enqueue_entity+0x78/0x80
>>>
>>> [  135.498665]  [<ffffffff810add70>] ? enqueue_entity+0x400/0xc20
>>>
>>> [  135.498679]  [<ffffffff8101dc3a>] ? native_sched_clock+0x2a/0x90
>>>
>>> [  135.498686]  [<ffffffff810ae708>] ? enqueue_task_fair+0x178/0x730
>>>
>>> [  135.498698]  [<ffffffff81047c1d>] ? native_smp_send_reschedule+0x4d/0x70
>>>
>>> [  135.498703]  [<ffffffff8109d5f0>] ? resched_curr+0x70/0xc0
>>>
>>> [  135.498710]  [<ffffffff8109e12a>] ? check_preempt_curr+0x5a/0xa0
>>>
>>> [  135.498715]  [<ffffffff810a152f>] ? wake_up_new_task+0x12f/0x1b0
>>>
>>> [  135.498722]  [<ffffffff81204010>] do_vfs_ioctl+0x2e0/0x4e0
>>>
>>> [  135.498728]  [<ffffffff8107368c>] ? do_fork+0x13c/0x370
>>>
>>> [  135.498733]  [<ffffffff81204291>] SyS_ioctl+0x81/0xa0
>>>
>>> [  135.498738]  [<ffffffff81073946>] ? SyS_clone+0x16/0x20
>>>
>>> [  135.498839]  [<ffffffff817bd80d>] ? stub_clone+0x6d/0x90
>>>
>>> [  135.498845]  [<ffffffff817bd50d>] system_call_fastpath+0x16/0x1b
>>>
>>> [  135.498848] ---[ end trace e1dd916182de3a9d ]---
>>>
>>> [  135.498851] ------------[ cut here ]------------
>>>
>>> [  135.498871] WARNING: CPU: 1 PID: 2346 at fs/btrfs/send.c:5951
>>> btrfs_ioctl_send+0x28f/0x11e0 [btrfs]()
>>>
>>> [  135.498894] Modules linked in: nf_conntrack_ipv4(E)
>>> nf_defrag_ipv4(E) xt_conntrack(E) nf_conntrack(E) ipt_REJECT(E)
>>> nf_reject_ipv4(E) xt_tcpudp(E) iptable_filter(E) ip_tables(E)
>>> x_tables(E) bridge(E) stp(E) llc(E) snd_intel8x0(E) snd_ac97_codec(E)
>>> ac97_bus(E) snd_pcm(E) snd_timer(E) snd(E) iosf_mbi(E) soundcore(E)
>>> ppdev(E) joydev(E) lp(E) serio_raw(E) parport_pc(E) i2c_piix4(E)
>>> mac_hid(E) parport(E) btrfs(E) xor(E) raid6_pq(E) hid_generic(E)
>>> usbhid(E) hid(E) ahci(E) psmouse(E) libahci(E) e1000(E) pata_acpi(E)
>>>
>>> [  135.498900] CPU: 1 PID: 2346 Comm: btrfs Tainted: G     W   E
>>> 4.0.0-rc4-custom #3
>>>
>>> [  135.498903] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
>>> VirtualBox 12/01/2006
>>>
>>> [  135.498910]  ffffffffc0509016 ffff88007a233c08 ffffffff817b62f3
>>> 000000004c724c72
>>>
>>> [  135.498918]  0000000000000000 ffff88007a233c48 ffffffff8107452a
>>> ffff88007a233c38
>>>
>>> [  135.498923]  ffff8800799f1400 ffff880078d52cc0 ffff880078d52cd8
>>> ffff8800799f15d8
>>>
>>> [  135.498927] Call Trace:
>>>
>>> [  135.498937]  [<ffffffff817b62f3>] dump_stack+0x45/0x57
>>>
>>> [  135.498945]  [<ffffffff8107452a>] warn_slowpath_common+0x8a/0xc0
>>>
>>> [  135.498951]  [<ffffffff8107461a>] warn_slowpath_null+0x1a/0x20
>>>
>>> [  135.498975]  [<ffffffffc04f52af>] btrfs_ioctl_send+0x28f/0x11e0 [btrfs]
>>>
>>> [  135.498984]  [<ffffffff8118020e>] ? __alloc_pages_nodemask+0x1ae/0xab0
>>>
>>> [  135.498990]  [<ffffffff810a4775>] ? sched_clock_local+0x25/0x90
>>>
>>> [  135.498996]  [<ffffffff8109182e>] ? alloc_pid+0x2e/0x530
>>>
>>> [  135.499023]  [<ffffffffc04bc4f6>] btrfs_ioctl+0x286/0x27e0 [btrfs]
>>>
>>> [  135.499031]  [<ffffffff810a6368>] ? __enqueue_entity+0x78/0x80
>>>
>>> [  135.499037]  [<ffffffff810add70>] ? enqueue_entity+0x400/0xc20
>>>
>>> [  135.499046]  [<ffffffff8101dc3a>] ? native_sched_clock+0x2a/0x90
>>>
>>> [  135.499055]  [<ffffffff810ae708>] ? enqueue_task_fair+0x178/0x730
>>>
>>> [  135.499061]  [<ffffffff81047c1d>] ? native_smp_send_reschedule+0x4d/0x70
>>>
>>> [  135.499069]  [<ffffffff8109d5f0>] ? resched_curr+0x70/0xc0
>>>
>>> [  135.499078]  [<ffffffff8109e12a>] ? check_preempt_curr+0x5a/0xa0
>>>
>>> [  135.499087]  [<ffffffff810a152f>] ? wake_up_new_task+0x12f/0x1b0
>>>
>>> [  135.499096]  [<ffffffff81204010>] do_vfs_ioctl+0x2e0/0x4e0
>>>
>>> [  135.499106]  [<ffffffff8107368c>] ? do_fork+0x13c/0x370
>>>
>>> [  135.499115]  [<ffffffff81204291>] SyS_ioctl+0x81/0xa0
>>>
>>> [  135.499121]  [<ffffffff81073946>] ? SyS_clone+0x16/0x20
>>>
>>> [  135.499131]  [<ffffffff817bd80d>] ? stub_clone+0x6d/0x90
>>>
>>> [  135.499140]  [<ffffffff817bd50d>] system_call_fastpath+0x16/0x1b
>>>
>>> [  135.499144] ---[ end trace e1dd916182de3a9e ]---
>>
>>
>>
>> --
>> Filipe David Manana,
>>
>> "Reasonable men adapt themselves to the world.
>>  Unreasonable men adapt the world to themselves.
>>  That's why all progress depends on unreasonable men."



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
