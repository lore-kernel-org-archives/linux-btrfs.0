Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:35120 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbcC1TcQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 15:32:16 -0400
Received: by mail-vk0-f42.google.com with SMTP id e6so168718446vkh.2
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Mar 2016 12:32:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJtFHUR7Jppv_znVBPLEZy3RU9n3jaA7dNUPOjrmMOCS4-_z_w@mail.gmail.com>
References: <CAJtFHUR7Jppv_znVBPLEZy3RU9n3jaA7dNUPOjrmMOCS4-_z_w@mail.gmail.com>
Date: Mon, 28 Mar 2016 15:32:15 -0400
Message-ID: <CAJtFHUReh3KmfcGVGMUHp_DBZucvoXe19m3r=_SuuYiVcpVjEg@mail.gmail.com>
Subject: Re: linux 4.4.3 oops on aborted transaction, forces FS read-only
From: E V <eliventer@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It appears this issue has been caused by space cache corruption
preventing allocation of new meta data on the filesystem(8 device
RAID-10 for meta data.) I've now been running nospace_cache for the
past couple of weeks of my heavy rsync traffic without any failures.
It's certainly slower, but the rsync now completes every time without
the fs once being forced read-only.

On Fri, Mar 4, 2016 at 9:14 AM, E V <eliventer@gmail.com> wrote:
> Looks like the transaction abort ends up causing the no space, if
> that's at all helpful. Lot's of free space seems to be irrelevant.
> Any chance this will be getting better soon? Seems to happen to me a
> lot these days, and adding space doesn't change anything.
> [282713.823416] WARNING: CPU: 4 PID: 3978 at
> fs/btrfs/extent-tree.c:6549 __btrfs_free_extent+0x98c/0x9a8 [btrfs]()
> [282713.823466] BTRFS: Transaction aborted (error -28)
> [282713.823467] Modules linked in: ipmi_si mpt3sas raid_class
> scsi_transport_sas dell_rbu nfsv3 nfsv4 nfsd auth_rpcgss oid_registry
> nfs_acl nfs lockd grace fscache sunrpc ext2 intel_powerclamp coretemp
> crct10dif_pclmul crc32_pclmul sha256_generic hmac drbg aesni_intel
> joydev aes_x86_64 glue_helper lrw gf128mul evdev ipmi_devintf iTCO_wdt
> ablk_helper cryptd iTCO_vendor_support dcdbas psmouse serio_raw pcspkr
> i7core_edac edac_core lpc_ich mfd_core ipmi_msghandler
> acpi_power_meter button processor loop autofs4 ext4 crc16 mbcache jbd2
> btrfs xor raid6_pq hid_generic usbhid hid sg sd_mod crc32c_intel
> uhci_hcd ehci_pci ehci_hcd megaraid_sas ixgbe mdio usbcore ptp
> usb_common pps_core scsi_mod bnx2 [last unloaded: ipmi_si]
> [282713.823891] CPU: 4 PID: 3978 Comm: btrfs-transacti Tainted: G
>     I     4.4.3 #1
> [282713.823979]  0000000000000006 ffffffff811eba76 ffff8807c4fbbb50
> 0000000000000009
> [282713.824029]  ffffffff810442ee ffffffffa0160c9e 00000000ffffffe4
> ffff8807c4fbbba8
> [282713.824080]  ffff88041e0e8000 0000000000000000 ffffffff81044346
> ffffffffa01db5aa
> [282713.824130] Call Trace:
> [282713.824155]  [<ffffffff811eba76>] ? dump_stack+0x46/0x59
> [282713.824185]  [<ffffffff810442ee>] ? warn_slowpath_common+0x94/0xa9
> [282713.824222]  [<ffffffffa0160c9e>] ? __btrfs_free_extent+0x98c/0x9a8 [btrfs]
> [282713.824252]  [<ffffffff81044346>] ? warn_slowpath_fmt+0x43/0x4b
> [282713.824288]  [<ffffffffa0160c9e>] ? __btrfs_free_extent+0x98c/0x9a8 [btrfs]
> [282713.824319]  [<ffffffff811182d7>] ? __cache_free.isra.49+0x1df/0x1ee
> [282713.824358]  [<ffffffffa01b124e>] ?
> btrfs_merge_delayed_refs+0x59/0x23d [btrfs]
> [282713.824412]  [<ffffffffa016438b>] ?
> __btrfs_run_delayed_refs+0xad5/0xc83 [btrfs]
> [282713.824466]  [<ffffffffa0165c63>] ?
> btrfs_run_delayed_refs+0x6a/0x1a7 [btrfs]
> [282713.824519]  [<ffffffffa01666ec>] ?
> btrfs_write_dirty_block_groups+0xd0/0x219 [btrfs]
> [282713.824573]  [<ffffffffa01d2e7a>] ? commit_cowonly_roots+0x1dd/0x275 [btrfs]
> [282713.824613]  [<ffffffffa0176ccd>] ?
> btrfs_commit_transaction+0x476/0x924 [btrfs]
> [282713.824668]  [<ffffffffa017745c>] ? start_transaction+0x2e1/0x46f [btrfs]
> [282713.824708]  [<ffffffffa0172b53>] ? transaction_kthread+0xde/0x18e [btrfs]
> [282713.824749]  [<ffffffffa0172a75>] ?
> btrfs_cleanup_transaction+0x3ee/0x3ee [btrfs]
> [282713.824794]  [<ffffffff81059f1a>] ? kthread+0xa7/0xaf
> [282713.824820]  [<ffffffff81059e73>] ? kthread_parkme+0x16/0x16
> [282713.824849]  [<ffffffff813c6d5f>] ? ret_from_fork+0x3f/0x70
> [282713.824876]  [<ffffffff81059e73>] ? kthread_parkme+0x16/0x16
> [282713.824902] ---[ end trace 2857e44546172518 ]---
> [282713.824946] BTRFS: error (device sdh) in __btrfs_free_extent:6549:
> errno=-28 No space left
> [282713.824995] BTRFS info (device sdh): forced readonly
> [282713.825021] BTRFS: error (device sdh) in
> btrfs_run_delayed_refs:2927: errno=-28 No space left
> [282713.856362] BTRFS warning (device sdh): Skipping commit of aborted
> transaction.
> [282713.856413] BTRFS: error (device sdh) in cleanup_transaction:1746:
> errno=-28 No space left
