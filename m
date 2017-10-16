Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:51956 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752129AbdJPLaG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 07:30:06 -0400
Received: by mail-wm0-f41.google.com with SMTP id f4so2221467wme.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Oct 2017 04:30:06 -0700 (PDT)
Subject: Re: btrfs errors over NFS
To: Steve Leung <sjleung@shaw.ca>, linux-btrfs@vger.kernel.org
References: <87o9pcmfad.fsf@shaw.ca>
 <0f4c26ac-9c31-7312-096d-f4b69bfc8365@gmail.com>
 <e110503c-ae55-8f8c-1097-3ccbb7a4d35d@shaw.ca>
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <f00848b8-422f-db9f-12be-a56d7b16df3d@gmail.com>
Date: Mon, 16 Oct 2017 14:30:02 +0300
MIME-Version: 1.0
In-Reply-To: <e110503c-ae55-8f8c-1097-3ccbb7a4d35d@shaw.ca>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 16.10.2017 08:00, Steve Leung wrote:
> On 10/13/2017 03:14 AM, Nikolay Borisov wrote:
>>
>>
>> On 12.10.2017 20:44, Steve Leung wrote:
>>> I've run into a btrfs error trying to do a -j8 build of android on a
>>> btrfs
>>> filesystem exported over NFSv3.  That in itself might be unwise, but
>>> should be
>>> legal.  :)  This is on 64-bit Arch, kernel 4.13.3, and the filesystem
>>> is RAID1 on 4
>>> devices, with nearly 4TiB unallocated.
>>>
>>> The build itself failed when part of the build process noticed that a
>>> file got
>>> created with mode 000.  i.e. in "ls -l" the mode column looked like
>>> ?---------.
>>>
>>> That much happened without any errors in dmesg, though the NFS client
>>> complained
>>> about some inodes having a mode of 0.
>>>
>>> Then when I tried to delete those files, I got the error below:
>>>
>>> [21476.546060] BTRFS error (device sdc1): err add delayed dir index
>>> item(index: 17) into the deletion tree of the delayed node(root id:
>>> 21780, inode id: 15668343, errno: -17)
>>> [21476.546194] ------------[ cut here ]------------
>>> [21476.546196] kernel BUG at fs/btrfs/delayed-inode.c:1552!
>>> [21476.546231] invalid opcode: 0000 [#1] PREEMPT SMP
>>> [21476.546258] Modules linked in: ipt_MASQUERADE
>>> nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
>>> nf_nat_ipv4 nf_nat nf_conntrack libcrc32c iptable_filter tun coretemp
>>> kvm_intel kvm iTCO_wdt ppdev gpio_ich iTCO_vendor_support evdev i915
>>> input_leds psmouse pcspkr irqbypass i2c_i801 snd_hda_codec_idt
>>> snd_hda_codec_generic mac_hid lpc_ich tpm_tis tpm_tis_core parport_pc
>>> tpm parport video drm_kms_helper drm syscopyarea winbond_cir
>>> sysfillrect sysimgblt rc_core led_class snd_hda_intel snd_hda_codec
>>> snd_hda_core snd_hwdep snd_pcm snd_timer shpchp snd button e1000e
>>> soundcore intel_agp intel_gtt acpi_cpufreq mei_me mei fb_sys_fops
>>> i2c_algo_bit ptp pps_core sch_fq_codel nfsd auth_rpcgss oid_registry
>>> nfs_acl lockd grace sunrpc ip_tables x_tables crc32c_generic btrfs
>>> xor raid6_pq sr_mod cdrom
>>> [21476.546623]  sd_mod hid_generic usbhid hid serio_raw atkbd libps2
>>> uhci_hcd pata_it821x ahci libahci libata firewire_ohci scsi_mod
>>> firewire_core crc_itu_t i8042 serio ehci_pci ehci_hcd usbcore usb_common
>>> [21476.546725] CPU: 0 PID: 984 Comm: rm Not tainted 4.13.3-1-ARCH #1
>>> [21476.546756] Hardware name:                  /DG33TL, BIOS
>>> DPP3510J.86A.0572.2009.0715.2346 07/15/2009
>>> [21476.546801] task: ffff943668131b80 task.stack: ffffaa3840da4000
>>> [21476.546854] RIP: 0010:btrfs_delete_delayed_dir_index+0x24d/0x330
>>> [btrfs]
>>> [21476.546889] RSP: 0018:ffffaa3840da7d18 EFLAGS: 00010286
>>> [21476.546918] RAX: 0000000000000000 RBX: ffff94367c074b90 RCX:
>>> 0000000000000000
>>> [21476.546953] RDX: 0000000000000000 RSI: ffff9436abc0dc78 RDI:
>>> ffff9436abc0dc78
>>> [21476.546989] RBP: ffffaa3840da7d88 R08: 0000000000000323 R09:
>>> 0000000000000000
>>> [21476.547025] R10: ffffaa3840da7bd8 R11: 00000000ffffffff R12:
>>> ffff943583503100
>>> [21476.547060] R13: ffff94367c074bd8 R14: ffff94367c074bd0 R15:
>>> ffff943583503218
>>> [21476.547096] FS:  00007f57da0f6500(0000) GS:ffff9436abc00000(0000)
>>> knlGS:0000000000000000
>>> [21476.547138] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [21476.547167] CR2: 00007f57d9c809c0 CR3: 000000005e39b000 CR4:
>>> 00000000000006f0
>>> [21476.547203] Call Trace:
>>> [21476.547235]  __btrfs_unlink_inode+0x1bc/0x550 [btrfs]
>>> [21476.547278]  btrfs_unlink_inode+0x1c/0x50 [btrfs]
>>> [21476.547317]  btrfs_unlink+0x88/0xe0 [btrfs]
>>> [21476.547343]  vfs_unlink+0x111/0x1c0
>>> [21476.547365]  ? __lookup_hash+0x22/0xa0
>>> [21476.547389]  do_unlinkat+0x2b1/0x310
>>> [21476.547412]  SyS_unlinkat+0x1b/0x30
>>> [21476.547434]  entry_SYSCALL_64_fastpath+0x1a/0xa5
>>> [21476.547460] RIP: 0033:0x7f57d9c303d7
>>> [21476.547481] RSP: 002b:00007fff4bc1a6b8 EFLAGS: 00000246 ORIG_RAX:
>>> 0000000000000107
>>> [21476.547520] RAX: ffffffffffffffda RBX: 00005644fee69540 RCX:
>>> 00007f57d9c303d7
>>> [21476.547556] RDX: 0000000000000000 RSI: 00005644fee68310 RDI:
>>> 00000000ffffff9c
>>> [21476.547591] RBP: 00005644fee69648 R08: 0000000000000003 R09:
>>> 0000000000000000
>>> [21476.547627] R10: 0000000000000100 R11: 0000000000000246 R12:
>>> 00005644fee68280
>>> [21476.547662] R13: 00007fff4bc1a7f0 R14: 00005644fd37094f R15:
>>> 0000000000000000
>>> [21476.547700] Code: ff ff ff 48 8b 43 10 4c 8b 03 41 b9 ef ff ff ff
>>> 48 8b 55 b0 48 8b 7d a8 48 c7 c6 b0 99 3f c0 48 8b 88 38 03 00 00 e8
>>> f3 0d f7 ff <0f> 0b 48 8b 4d a8 49 8b 7e 38 8b 81 70 10 00 00 48 8d
>>> b1 c8 01
>>> [21476.547840] RIP: btrfs_delete_delayed_dir_index+0x24d/0x330
>>> [btrfs] RSP: ffffaa3840da7d18
>>> [21476.549333] ---[ end trace 41039f5467d88882 ]---
>>>
>>
>> Well, the main thing here is that you hit the BUG() in
>> btrfs_delete_delayed_dir_index.
>> So this happened because you tried to delete a file, which was already
>> staged for deletion.
>>
>> So which directory corresponds to inode 15668343, presumably the
>> android build dir?
> 
> Hi Nikolay, thanks for looking at this.
> 
> Yup, this is definitely an Android build dir full of png files.
> 
>> If you could print the output of the following commands that could
>> help in narrowing down the problem:
>>
>> btrfs inspect-internal dump-tree /dev/sdc1 | grep -A3 "(15668343
>> DIR_INDEX"
>>
>> That will print all the DIR_INDEX items of the directory, and I will
>> be particularly
>> interested in item with index 17. Which should print something like:
> 
> I've attached the output.  I'm a bit surprised to find that the
> directory seems to have every index number in it besides 17. :)

Not having item with index 17 and the BUG_ON failure before. Means that the file was
scheduled for deletion. Was apparently deleted (since it's not on the disk), yet it 
somehow got queued up again for deletion, which caused the BUG_ON to be hit. That's a 
really odd failure scenario I have to admit. 

> 
> Possibly related due to unclean shutdowns - btrfs inspect internal also
> spits this out:
> 
>   parent transid verify failed on 4969828220928 wanted 3176121 found
> 3176123
>   parent transid verify failed on 4969828220928 wanted 3176121 found
> 3176123
>   parent transid verify failed on 4969828220928 wanted 3176121 found
> 3176123
>   parent transid verify failed on 4969828220928 wanted 3176121 found
> 3176123
>   Ignoring transid failure
>   WARNING: eb corrupted: item 4 eb level 0 next level 2, skipping the rest
>   parent transid verify failed on 4969825992704 wanted 3176121 found
> 3176123
>   parent transid verify failed on 4969825992704 wanted 3176121 found
> 3176123
>   parent transid verify failed on 4969825992704 wanted 3176121 found
> 3176123
>   parent transid verify failed on 4969825992704 wanted 3176121 found
> 3176123
>   Ignoring transid failure
>   WARNING: eb corrupted: item 1 eb level 0 next level 2, skipping the rest


Those error messages mean there is a discrepancy between the transactions which 
modified blocks 4969825992704 and 4969828220928 and their parent blocks. This 
is evidence there is internal filesystem inconsistency which might have been caused
by either a bug in the code or hardware failure. 

> 
>> btrfs inspect-internal dump-tree /dev/sdc1 | grep -A4 "(259 INODE_ITEM
>> 0) itemoff"
>> where the stuff in the brackets should be the same as the contents of
>> () following
>> "location key" string.
> 
> The problematic file (tab_unselected_pressed_holo.9.png) has inode
> number 15669905, but I'm unable to locate its details using btrfs
> inspect-internal.  I'm guessing that explains the weird behaviour with
> the directory thinking the file is there, but then nothing can find it.

So if there is no inode item which corresponds to this inode by e.g. 

btrfs inspect-internal dump-tree /dev/sdc1 | grep -A4 "(15669905 INODE_ITEM 0) itemoff"

But you are able to find dir index items by : 

btrfs inspect-internal dump-tree /dev/sdc1 | grep -B2 "name: tab_unselected_pressed_holo.9.png"

Then you are fs is indeed corrupted and you might want to run  btrfs check to see 
what else it finds. 


> 
> I've also started seeing some other weird behaviour from this machine -
> unexpected hangs and reboots.  It might be flaky hardware now, so I
> might need to look at replacing it.  In which case it might mean that
> whatever's gone wrong on the filesystem isn't btrfs's fault.

I'd advise to first rule out hw failure and then report back if you observe 
similar issues. 


> 
> Steve
