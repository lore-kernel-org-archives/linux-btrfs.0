Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34509 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265AbbKDOj4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Nov 2015 09:39:56 -0500
Received: by iody8 with SMTP id y8so55265589iod.1
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2015 06:39:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJtFHUQ9jwX1i2JuYvcXhmb3GEibgGhRe_SOoxOhWeM4GwV9Fw@mail.gmail.com>
References: <CAJtFHUQ9jwX1i2JuYvcXhmb3GEibgGhRe_SOoxOhWeM4GwV9Fw@mail.gmail.com>
Date: Wed, 4 Nov 2015 09:39:55 -0500
Message-ID: <CAJtFHUQnVYHfvUYTD5wTS7MOxOFB=pL7dVtbTSQLWC7-xA0DNg@mail.gmail.com>
Subject: Re: 4.2.5 forced read-only -ENOSPC w/ free space
From: E V <eliventer@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FYI, 4.1.12 completed the big rsync without issues. Guess I'm using
longterm for now.

On Mon, Nov 2, 2015 at 9:53 AM, E V <eliventer@gmail.com> wrote:
> During an rsync, 20TB unallocated space. Currently, no snapshots.
> Should I try 4.1.12, or 4.3?
> dmesg:
> [122014.436612] BTRFS: error (device sde) in
> btrfs_run_delayed_refs:2781: errno=-28 No space left
> [122014.436615] BTRFS info (device sde): forced readonly
> [122014.436624] BTRFS: error (device sde) in
> btrfs_run_delayed_refs:2781: errno=-28 No space left
> [122014.436725] WARNING: CPU: 13 PID: 8025 at
> fs/btrfs/extent-tree.c:2781 btrfs_run_delayed_refs+0x97/0x195
> [btrfs]()
> [122014.436741] BTRFS: error (device sde) in
> __btrfs_prealloc_file_range:9636: errno=-28 No space left
> [122014.436772] BTRFS: error (device sde) in
> btrfs_start_dirty_block_groups:3461: errno=-28 No space left
> [122014.436777] BTRFS warning (device sde): Skipping commit of aborted
> transaction.
> [122014.436780] BTRFS: error (device sde) in cleanup_transaction:1710:
> errno=-5 IO failure
> [122014.436959] BTRFS: Transaction aborted (error -28)
> [122014.436961] Modules linked in: ipmi_si mpt2sas raid_class
> scsi_transport_sas dell_rbu nfsv3 nfsv4 nfsd auth_rpcgss oid_registry
> nfs_acl nfs lockd grace fscache sunrpc ext4 crc16 jbd2 ext2 coretemp
> joydev crct10dif_pclmul sha256_generic psmouse serio_raw hmac drbg
> aesni_intel iTCO_wdt ipmi_devintf iTCO_vendor_support dcdbas evdev
> aes_x86_64 glue_helper lrw gf128mul ablk_helper pcspkr cryptd lpc_ich
> mfd_core i7core_edac edac_core ipmi_msghandler acpi_power_meter button
> processor thermal_sys loop ext3 mbcache jbd btrfs xor raid6_pq
> hid_generic usbhid hid sg sd_mod crc32c_intel uhci_hcd ehci_pci
> ehci_hcd megaraid_sas ixgbe mdio ptp usbcore pps_core usb_common
> scsi_mod bnx2 [last unloaded: ipmi_si]
> [122014.437405] CPU: 13 PID: 8025 Comm: kworker/u66:13 Tainted: G
>     I     4.2.5 #1
> [122014.437519] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
> [122014.437552]  0000000000000000 0000000000000009 ffffffff813af77a
> ffff880006ab7d08
> [122014.437606]  ffffffff810421bb 0000000000003dac ffffffffa01ee526
> ffff880342782f30
> [122014.437660]  00000000ffffffe4 ffff880100ea33b0 ffff8803218ae800
> ffff880342782e08
> [122014.437714] Call Trace:
> [122014.437743]  [<ffffffff813af77a>] ? dump_stack+0x40/0x50
> [122014.437773]  [<ffffffff810421bb>] ? warn_slowpath_common+0x98/0xb0
> [122014.437817]  [<ffffffffa01ee526>] ?
> btrfs_run_delayed_refs+0x97/0x195 [btrfs]
> [122014.437863]  [<ffffffff81042218>] ? warn_slowpath_fmt+0x45/0x4a
> [122014.437906]  [<ffffffffa01ee526>] ?
> btrfs_run_delayed_refs+0x97/0x195 [btrfs]
> [122014.437965]  [<ffffffffa01ee657>] ?
> delayed_ref_async_start+0x33/0x71 [btrfs]
> [122014.438029]  [<ffffffffa0224f0d>] ? normal_work_helper+0xc3/0x1fa [btrfs]
> [122014.438063]  [<ffffffff810539ee>] ? process_one_work+0x159/0x286
> [122014.438093]  [<ffffffff81054283>] ? worker_thread+0x1d9/0x280
> [122014.438123]  [<ffffffff810540aa>] ? rescuer_thread+0x27a/0x27a
> [122014.438152]  [<ffffffff81057fb6>] ? kthread+0xab/0xb3
> [122014.438180]  [<ffffffff81057f0b>] ? kthread_parkme+0x16/0x16
> [122014.438211]  [<ffffffff813b375f>] ? ret_from_fork+0x3f/0x70
> [122014.438240]  [<ffffffff81057f0b>] ? kthread_parkme+0x16/0x16
> [122014.438268] ---[ end trace 1c8deab18b734f90 ]---
> [122014.438296] BTRFS: error (device sde) in
> btrfs_run_delayed_refs:2781: errno=-28 No space left
>
> btrfs file usage /mirror
> Overall:
>     Device size:                 140.07TiB
>     Device allocated:            119.96TiB
>     Device unallocated:           20.11TiB
>     Device missing:                  0.00B
>     Used:                        117.54TiB
>     Free (estimated):             22.53TiB      (min: 12.47TiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
>
> Data,single: Size:119.66TiB, Used:117.24TiB
>    /dev/sdb       24.91TiB
>    /dev/sdc       24.91TiB
>    /dev/sdd       34.92TiB
>    /dev/sde       34.92TiB
>
> Metadata,RAID10: Size:151.00GiB, Used:149.88GiB
>    /dev/sdb       37.75GiB
>    /dev/sdc       37.75GiB
>    /dev/sdd       37.75GiB
>    /dev/sde       37.75GiB
>
> System,RAID10: Size:64.00MiB, Used:15.75MiB
>    /dev/sdb       16.00MiB
>    /dev/sdc       16.00MiB
>    /dev/sdd       16.00MiB
>    /dev/sde       16.00MiB
>
> Unallocated:
>    /dev/sdb        5.06TiB
>    /dev/sdc        5.06TiB
>    /dev/sdd        5.06TiB
>    /dev/sde        5.06TiB
