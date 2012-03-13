From: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: kernel BUG at fs/btrfs/transaction.c:1337!
Date: Tue, 13 Mar 2012 22:45:06 +0800
Message-ID: <4F5F5D72.80706@oracle.com>
References: <CAMtaSwQUG2ovM8Yv_2+kLNMQbtMzwDq1pgd9PsMC3xYn2b6xmw@mail.gmail.com> <4F5DA13A.7010506@oracle.com> <CAMtaSwThPed_GjJOGFVYhHjBiCCVNc-KAe6XsvOLpZ0dRwpYfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: btrfs <linux-btrfs@vger.kernel.org>
To: qasdfgtyuiop <qasdfgtyuiop@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMtaSwThPed_GjJOGFVYhHjBiCCVNc-KAe6XsvOLpZ0dRwpYfw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>



  These logs doesn't have the traces of the below BUG_ON().
  stack as in the dmesg below has 'btrfs_congested_fn'
  which generally notifies block-device near Q full condition.
  we would need logs to confirm anything further. was there
  a kernel dump generated when BUG_ON was called? that should
  help.

Thanks, Anand


On 03/13/12 13:42, qasdfgtyuiop wrote:
> All my logs are attached
> I have reinstalled my system the old filesystem has been backuped as a
> img file using dd if=/dev/sdb1 of=broken-btrfs.img bs=1G.  I mounted
> the broken filesystem and copied the log files out.  While copying I
> got the error message:
> cp: reading `log/messages.log': Input/output error
> cp: failed to extend `/home/gaoxiang/tests/log/messages.log': Input/output error
> cp: reading `log/kernel.log': Input/output error
> cp: failed to extend `/home/gaoxiang/tests/log/kernel.log': Input/output error
> cp: reading `log/errors.log': Input/output error
> cp: failed to extend `/home/gaoxiang/tests/log/errors.log': Input/output error
> cp: reading `log/everything.log': Input/output error
> cp: failed to extend `/home/gaoxiang/tests/log/everything.log':
> Input/output error
>
>
> On Mon, Mar 12, 2012 at 3:09 PM, Anand Jain<Anand.Jain@oracle.com>  wrote:
>>
>>   could you also post few lines of dmesg logged _before_ the below logs.
>>
>> Thanks,  -Anand
>>
>>
>>
>> On Saturday 10,March,2012 06:26 PM, qasdfgtyuiop wrote:
>>>
>>> [11558.527680] ------------[ cut here ]------------
>>> [11558.527708] kernel BUG at fs/btrfs/transaction.c:1337!
>>> [11558.527730] invalid opcode: 0000 [#1] PREEMPT SMP
>> [11558.527764] CPU 1
>>> [11558.527776] Modules linked in: loop nls_cp437 vfat fat dm_mod xfs
>>> exportfs jfs usb_storage uas fuse ext4 jbd2 mbcache snd_hda_codec_hdmi
>>> snd_hda_codec_realtek arc4 iwlwifi snd_hda_intel snd_hda_codec
>>> uvcvideo snd_hwdep nouveau iTCO_wdt i2c_i801 jmb38x_ms broadcom
>>> snd_pcm i915 videodev tg3 sdhci_pci v4l2_compat_ioctl32 mac80211 sdhci
>>> ttm i2c_algo_bit snd_page_alloc intel_agp snd_timer mxm_wmi serio_raw
>>> drm_kms_helper btusb media bluetooth drm psmouse evdev joydev pcspkr
>>> crc16 mei(C) iTCO_vendor_support snd libphy intel_ips memstick
>>> mmc_core cfg80211 soundcore intel_gtt i2c_core thermal battery
>>> ideapad_laptop sparse_keymap rfkill wmi ac video processor button
>>> btrfs crc32c libcrc32c zlib_deflate sd_mod sr_mod cdrom usbhid hid
>>> ahci libahci libata scsi_mod ehci_hcd usbcore usb_common
>>> [11558.528323]
>>> [11558.528333] Pid: 125, comm: btrfs-transacti Tainted: G         C
>>> 3.2.9-1-ARCH #1 LENOVO                           IdeaPad Y460    /KL2
>>> [11558.528389] RIP: 0010:[<ffffffffa014c879>]  [<ffffffffa014c879>]
>>> btrfs_commit_transaction+0x879/0x880 [btrfs]
>>> [11558.528439] RSP: 0018:ffff8801af1dfde0  EFLAGS: 00010282
>>> [11558.528460] RAX: 00000000fffffffb RBX: ffff8801afa91690 RCX:
>>> 0000000000000000
>>> [11558.528484] RDX: ffff8801af1dfce8 RSI: 0000000003c10000 RDI:
>>> ffff8801afa916f0
>>> [11558.528510] RBP: ffff8801af1dfe70 R08: 0000000000002000 R09:
>>> 0000000000000000
>>> [11558.528536] R10: 0000000000000000 R11: 0000000000000001 R12:
>>> ffff8801b13ab000
>>> [11558.528561] R13: ffff8801afa90c18 R14: ffff8801afa91708 R15:
>>> 0000000000000218
>>> [11558.528586] FS:  0000000000000000(0000) GS:ffff8801bbc80000(0000)
>>> knlGS:0000000000000000
>>> [11558.528616] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>> [11558.528637] CR2: 00007fb7899244e8 CR3: 0000000001805000 CR4:
>>> 00000000000006e0
>>> [11558.528663] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>>> 0000000000000000
>>> [11558.528688] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>>> 0000000000000400
>>> [11558.528714] Process btrfs-transacti (pid: 125, threadinfo
>>> ffff8801af1de000, task ffff8801aff2ce60)
>>> [11558.528744] Stack:
>>> [11558.528755]  ffff8801af1dfe10 0000000000000000 0000000000000000
>>> ffff8801aff2ce60
>>> [11558.528791]  ffffffff81088d80 ffff8801af1dfe08 ffff8801af1dfe08
>>> ffffffffa014ccd4
>>> [11558.528827]  0000000000000000 00000000af2b0560 ffff8801aff2ce60
>>> ffff8801b13ab000
>>> [11558.528863] Call Trace:
>>> [11558.528879]  [<ffffffff81088d80>] ? abort_exclusive_wait+0xb0/0xb0
>>> [11558.528910]  [<ffffffffa014ccd4>] ? start_transaction+0x94/0x2b0
>>> [btrfs]
>>> [11558.528940]  [<ffffffffa0144e6d>] transaction_kthread+0x26d/0x290
>>> [btrfs]
>>> [11558.528971]  [<ffffffffa0144c00>] ? btrfs_congested_fn+0xd0/0xd0
>>> [btrfs]
>>> [11558.528996]  [<ffffffff8108843c>] kthread+0x8c/0xa0
>>> [11558.529018]  [<ffffffff8145feb4>] kernel_thread_helper+0x4/0x10
>>> [11558.529040]  [<ffffffff810883b0>] ? kthread_worker_fn+0x190/0x190
>>> [11558.529064]  [<ffffffff8145feb0>] ? gs_change+0x13/0x13
>>> [11558.529083] Code: ff ff e9 44 f9 ff ff 0f 0b 0f 0b 0f 0b be fc 04
>>> 00 00 48 c7 c7 fa 00 1a a0 e8 84 98 f1 e0 e9 3c fb ff ff 0f 0b 0f 0b
>>> 0f 0b 0f 0b<0f>    0b 0f 0b 0f 1f 00 55 48 89 e5 53 48 83 ec 08 66 66 66
>>> 66 90
>>> [11558.529389] RIP  [<ffffffffa014c879>]
>>> btrfs_commit_transaction+0x879/0x880 [btrfs]
>>> [11558.529425]  RSP<ffff8801af1dfde0>
>>> [11558.592012] ---[ end trace e0456c287e012690 ]---
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
