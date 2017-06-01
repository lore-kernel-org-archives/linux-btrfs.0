Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751435AbdFAKw3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Jun 2017 06:52:29 -0400
Received: from mail-it0-f53.google.com (mail-it0-f53.google.com [209.85.214.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11A15239E9
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Jun 2017 10:52:28 +0000 (UTC)
Received: by mail-it0-f53.google.com with SMTP id a10so1918333itg.1
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Jun 2017 03:52:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170531203240.GA4024@lim.localdomain>
References: <20170528163153.31962-1-fdmanana@kernel.org> <20170528213105.19249-1-fdmanana@kernel.org>
 <20170531203240.GA4024@lim.localdomain>
From: Filipe Manana <fdmanana@kernel.org>
Date: Thu, 1 Jun 2017 11:52:26 +0100
Message-ID: <CAL3q7H4YMyptgGE2+fsNTFUPR3G0hRNDS-zKJ94tdCJ_7mSBZg@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix invalid extent maps due to hole punching
To: Liu Bo <bo.li.liu@oracle.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 31, 2017 at 9:32 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Sun, May 28, 2017 at 10:31:05PM +0100, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> While punching a hole in a range that is not aligned with the sector size
>> (currently the same as the page size) we can end up leaving an extent map
>> in memory with a length that is smaller then the sector size, which is
>> not expected and can lead to problems. This issue is easily detected
>> after the patch from commit a7e3b975a0f9 ("Btrfs: fix reported number of
>> inode blocks"), introduced in kernel 4.12-rc1, in a scenario like the
>> following for example:
>>
>>   $ mkfs.btrfs -f /dev/sdb
>>   $ mount /dev/sdb /mnt
>>   $ xfs_io -c "pwrite -S 0xaa -b 100K 0 100K" /mnt/foo
>>   $ xfs_io -c "fpunch 60K 90K" /mnt/foo
>>   $ xfs_io -c "pwrite -S 0xbb -b 100K 50K 100K" /mnt/foo
>>   $ xfs_io -c "pwrite -S 0xcc -b 50K 100K 50K" /mnt/foo
>>   $ umount /mnt
>>
>> After the unmount operation we can see several warnings emmitted due to
>> underflows related to space reservation counters:
>>
>> [ 2837.443299] ------------[ cut here ]------------
>> [ 2837.447395] WARNING: CPU: 8 PID: 2474 at fs/btrfs/inode.c:9444 btrfs_destroy_inode+0xe8/0x27e [btrfs]
>> [ 2837.452108] Modules linked in: dm_flakey dm_mod ppdev parport_pc psmouse parport sg pcspkr acpi_cpufreq tpm_tis tpm_tis_core i2c_piix4 i2c_core evdev tpm button se
>> rio_raw sunrpc loop autofs4 ext4 crc16 jbd2 mbcache btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_gene
>> ric raid1 raid0 multipath linear md_mod sr_mod cdrom sd_mod ata_generic virtio_scsi ata_piix libata virtio_pci virtio_ring virtio e1000 scsi_mod floppy
>> [ 2837.458389] CPU: 8 PID: 2474 Comm: umount Tainted: G        W       4.10.0-rc8-btrfs-next-43+ #1
>> [ 2837.459754] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
>> [ 2837.462379] Call Trace:
>> [ 2837.462379]  dump_stack+0x68/0x92
>> [ 2837.462379]  __warn+0xc2/0xdd
>> [ 2837.462379]  warn_slowpath_null+0x1d/0x1f
>> [ 2837.462379]  btrfs_destroy_inode+0xe8/0x27e [btrfs]
>> [ 2837.462379]  destroy_inode+0x3d/0x55
>> [ 2837.462379]  evict+0x177/0x17e
>> [ 2837.462379]  dispose_list+0x50/0x71
>> [ 2837.462379]  evict_inodes+0x132/0x141
>> [ 2837.462379]  generic_shutdown_super+0x3f/0xeb
>> [ 2837.462379]  kill_anon_super+0x12/0x1c
>> [ 2837.462379]  btrfs_kill_super+0x16/0x21 [btrfs]
>> [ 2837.462379]  deactivate_locked_super+0x30/0x68
>> [ 2837.462379]  deactivate_super+0x36/0x39
>> [ 2837.462379]  cleanup_mnt+0x58/0x76
>> [ 2837.462379]  __cleanup_mnt+0x12/0x14
>> [ 2837.462379]  task_work_run+0x77/0x9b
>> [ 2837.462379]  prepare_exit_to_usermode+0x9d/0xc5
>> [ 2837.462379]  syscall_return_slowpath+0x196/0x1b9
>> [ 2837.462379]  entry_SYSCALL_64_fastpath+0xab/0xad
>> [ 2837.462379] RIP: 0033:0x7f3ef3e6b9a7
>> [ 2837.462379] RSP: 002b:00007ffdd0d8de58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
>> [ 2837.462379] RAX: 0000000000000000 RBX: 0000556f76a39060 RCX: 00007f3ef3e6b9a7
>> [ 2837.462379] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000556f76a3f910
>> [ 2837.462379] RBP: 0000556f76a3f910 R08: 0000556f76a3e670 R09: 0000000000000015
>> [ 2837.462379] R10: 00000000000006b4 R11: 0000000000000246 R12: 00007f3ef436ce64
>> [ 2837.462379] R13: 0000000000000000 R14: 0000556f76a39240 R15: 00007ffdd0d8e0e0
>> [ 2837.519355] ---[ end trace e79345fe24b30b8d ]---
>> [ 2837.596256] ------------[ cut here ]------------
>> [ 2837.597625] WARNING: CPU: 8 PID: 2474 at fs/btrfs/extent-tree.c:5699 btrfs_free_block_groups+0x246/0x3eb [btrfs]
>> [ 2837.603547] Modules linked in: dm_flakey dm_mod ppdev parport_pc psmouse parport sg pcspkr acpi_cpufreq tpm_tis tpm_tis_core i2c_piix4 i2c_core evdev tpm button serio_raw sunrpc loop autofs4 ext4 crc16 jbd2 mbcache btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 multipath linear md_mod sr_mod cdrom sd_mod ata_generic virtio_scsi ata_piix libata virtio_pci virtio_ring virtio e1000 scsi_mod floppy
>> [ 2837.659372] CPU: 8 PID: 2474 Comm: umount Tainted: G        W       4.10.0-rc8-btrfs-next-43+ #1
>> [ 2837.663359] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
>> [ 2837.663359] Call Trace:
>> [ 2837.663359]  dump_stack+0x68/0x92
>> [ 2837.663359]  __warn+0xc2/0xdd
>> [ 2837.663359]  warn_slowpath_null+0x1d/0x1f
>> [ 2837.663359]  btrfs_free_block_groups+0x246/0x3eb [btrfs]
>> [ 2837.663359]  close_ctree+0x1dd/0x2e1 [btrfs]
>> [ 2837.663359]  ? evict_inodes+0x132/0x141
>> [ 2837.663359]  btrfs_put_super+0x15/0x17 [btrfs]
>> [ 2837.663359]  generic_shutdown_super+0x6a/0xeb
>> [ 2837.663359]  kill_anon_super+0x12/0x1c
>> [ 2837.663359]  btrfs_kill_super+0x16/0x21 [btrfs]
>> [ 2837.663359]  deactivate_locked_super+0x30/0x68
>> [ 2837.663359]  deactivate_super+0x36/0x39
>> [ 2837.663359]  cleanup_mnt+0x58/0x76
>> [ 2837.663359]  __cleanup_mnt+0x12/0x14
>> [ 2837.663359]  task_work_run+0x77/0x9b
>> [ 2837.663359]  prepare_exit_to_usermode+0x9d/0xc5
>> [ 2837.663359]  syscall_return_slowpath+0x196/0x1b9
>> [ 2837.663359]  entry_SYSCALL_64_fastpath+0xab/0xad
>> [ 2837.663359] RIP: 0033:0x7f3ef3e6b9a7
>> [ 2837.663359] RSP: 002b:00007ffdd0d8de58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
>> [ 2837.663359] RAX: 0000000000000000 RBX: 0000556f76a39060 RCX: 00007f3ef3e6b9a7
>> [ 2837.663359] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000556f76a3f910
>> [ 2837.663359] RBP: 0000556f76a3f910 R08: 0000556f76a3e670 R09: 0000000000000015
>> [ 2837.663359] R10: 00000000000006b4 R11: 0000000000000246 R12: 00007f3ef436ce64
>> [ 2837.663359] R13: 0000000000000000 R14: 0000556f76a39240 R15: 00007ffdd0d8e0e0
>> [ 2837.739445] ---[ end trace e79345fe24b30b8e ]---
>> [ 2837.745595] ------------[ cut here ]------------
>> [ 2837.746412] WARNING: CPU: 8 PID: 2474 at fs/btrfs/extent-tree.c:5700 btrfs_free_block_groups+0x261/0x3eb [btrfs]
>> [ 2837.747955] Modules linked in: dm_flakey dm_mod ppdev parport_pc psmouse parport sg pcspkr acpi_cpufreq tpm_tis tpm_tis_core i2c_piix4 i2c_core evdev tpm button serio_raw sunrpc loop autofs4 ext4 crc16 jbd2 mbcache btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 multipath linear md_mod sr_mod cdrom sd_mod ata_generic virtio_scsi ata_piix libata virtio_pci virtio_ring virtio e1000 scsi_mod floppy
>> [ 2837.755395] CPU: 8 PID: 2474 Comm: umount Tainted: G        W       4.10.0-rc8-btrfs-next-43+ #1
>> [ 2837.756769] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
>> [ 2837.758526] Call Trace:
>> [ 2837.758925]  dump_stack+0x68/0x92
>> [ 2837.759383]  __warn+0xc2/0xdd
>> [ 2837.759383]  warn_slowpath_null+0x1d/0x1f
>> [ 2837.759383]  btrfs_free_block_groups+0x261/0x3eb [btrfs]
>> [ 2837.759383]  close_ctree+0x1dd/0x2e1 [btrfs]
>> [ 2837.759383]  ? evict_inodes+0x132/0x141
>> [ 2837.759383]  btrfs_put_super+0x15/0x17 [btrfs]
>> [ 2837.759383]  generic_shutdown_super+0x6a/0xeb
>> [ 2837.759383]  kill_anon_super+0x12/0x1c
>> [ 2837.759383]  btrfs_kill_super+0x16/0x21 [btrfs]
>> [ 2837.759383]  deactivate_locked_super+0x30/0x68
>> [ 2837.759383]  deactivate_super+0x36/0x39
>> [ 2837.759383]  cleanup_mnt+0x58/0x76
>> [ 2837.759383]  __cleanup_mnt+0x12/0x14
>> [ 2837.759383]  task_work_run+0x77/0x9b
>> [ 2837.759383]  prepare_exit_to_usermode+0x9d/0xc5
>> [ 2837.759383]  syscall_return_slowpath+0x196/0x1b9
>> [ 2837.759383]  entry_SYSCALL_64_fastpath+0xab/0xad
>> [ 2837.759383] RIP: 0033:0x7f3ef3e6b9a7
>> [ 2837.759383] RSP: 002b:00007ffdd0d8de58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
>> [ 2837.759383] RAX: 0000000000000000 RBX: 0000556f76a39060 RCX: 00007f3ef3e6b9a7
>> [ 2837.759383] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000556f76a3f910
>> [ 2837.759383] RBP: 0000556f76a3f910 R08: 0000556f76a3e670 R09: 0000000000000015
>> [ 2837.759383] R10: 00000000000006b4 R11: 0000000000000246 R12: 00007f3ef436ce64
>> [ 2837.759383] R13: 0000000000000000 R14: 0000556f76a39240 R15: 00007ffdd0d8e0e0
>> [ 2837.777063] ---[ end trace e79345fe24b30b8f ]---
>> [ 2837.778235] ------------[ cut here ]------------
>> [ 2837.778856] WARNING: CPU: 8 PID: 2474 at fs/btrfs/extent-tree.c:9825 btrfs_free_block_groups+0x348/0x3eb [btrfs]
>> [ 2837.791385] Modules linked in: dm_flakey dm_mod ppdev parport_pc psmouse parport sg pcspkr acpi_cpufreq tpm_tis tpm_tis_core i2c_piix4 i2c_core evdev tpm button serio_raw sunrpc loop autofs4 ext4 crc16 jbd2 mbcache btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 multipath linear md_mod sr_mod cdrom sd_mod ata_generic virtio_scsi ata_piix libata virtio_pci virtio_ring virtio e1000 scsi_mod floppy
>> [ 2837.797711] CPU: 8 PID: 2474 Comm: umount Tainted: G        W       4.10.0-rc8-btrfs-next-43+ #1
>> [ 2837.798594] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
>> [ 2837.800118] Call Trace:
>> [ 2837.800515]  dump_stack+0x68/0x92
>> [ 2837.801015]  __warn+0xc2/0xdd
>> [ 2837.801471]  warn_slowpath_null+0x1d/0x1f
>> [ 2837.801698]  btrfs_free_block_groups+0x348/0x3eb [btrfs]
>> [ 2837.801698]  close_ctree+0x1dd/0x2e1 [btrfs]
>> [ 2837.801698]  ? evict_inodes+0x132/0x141
>> [ 2837.801698]  btrfs_put_super+0x15/0x17 [btrfs]
>> [ 2837.801698]  generic_shutdown_super+0x6a/0xeb
>> [ 2837.801698]  kill_anon_super+0x12/0x1c
>> [ 2837.801698]  btrfs_kill_super+0x16/0x21 [btrfs]
>> [ 2837.801698]  deactivate_locked_super+0x30/0x68
>> [ 2837.801698]  deactivate_super+0x36/0x39
>> [ 2837.801698]  cleanup_mnt+0x58/0x76
>> [ 2837.801698]  __cleanup_mnt+0x12/0x14
>> [ 2837.801698]  task_work_run+0x77/0x9b
>> [ 2837.801698]  prepare_exit_to_usermode+0x9d/0xc5
>> [ 2837.801698]  syscall_return_slowpath+0x196/0x1b9
>> [ 2837.801698]  entry_SYSCALL_64_fastpath+0xab/0xad
>> [ 2837.801698] RIP: 0033:0x7f3ef3e6b9a7
>> [ 2837.801698] RSP: 002b:00007ffdd0d8de58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
>> [ 2837.801698] RAX: 0000000000000000 RBX: 0000556f76a39060 RCX: 00007f3ef3e6b9a7
>> [ 2837.801698] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000556f76a3f910
>> [ 2837.801698] RBP: 0000556f76a3f910 R08: 0000556f76a3e670 R09: 0000000000000015
>> [ 2837.801698] R10: 00000000000006b4 R11: 0000000000000246 R12: 00007f3ef436ce64
>> [ 2837.801698] R13: 0000000000000000 R14: 0000556f76a39240 R15: 00007ffdd0d8e0e0
>> [ 2837.818441] ---[ end trace e79345fe24b30b90 ]---
>> [ 2837.818991] BTRFS info (device sdc): space_info 1 has 7974912 free, is not full
>> [ 2837.819830] BTRFS info (device sdc): space_info total=8388608, used=417792, pinned=0, reserved=0, may_use=18446744073709547520, readonly=0
>> [ 2837.821227] ------------[ cut here ]------------
>> [ 2837.821897] WARNING: CPU: 8 PID: 2474 at fs/btrfs/extent-tree.c:9825 btrfs_free_block_groups+0x348/0x3eb [btrfs]
>> [ 2837.823331] Modules linked in: dm_flakey dm_mod ppdev parport_pc psmouse parport sg pcspkr acpi_cpufreq tpm_tis tpm_tis_core i2c_piix4 i2c_core evdev tpm button serio_raw sunrpc loop autofs4 ext4 crc16 jbd2 mbcache btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid1 raid0 multipath linear md_mod sr_mod cdrom sd_mod ata_generic virtio_scsi ata_piix libata virtio_pci virtio_ring virtio e1000 scsi_mod floppy
>> [ 2837.829575] CPU: 8 PID: 2474 Comm: umount Tainted: G        W       4.10.0-rc8-btrfs-next-43+ #1
>> [ 2837.830767] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.9.1-0-gb3ef39f-prebuilt.qemu-project.org 04/01/2014
>> [ 2837.832407] Call Trace:
>> [ 2837.832820]  dump_stack+0x68/0x92
>> [ 2837.833336]  __warn+0xc2/0xdd
>> [ 2837.833561]  warn_slowpath_null+0x1d/0x1f
>> [ 2837.833561]  btrfs_free_block_groups+0x348/0x3eb [btrfs]
>> [ 2837.833561]  close_ctree+0x1dd/0x2e1 [btrfs]
>> [ 2837.833561]  ? evict_inodes+0x132/0x141
>> [ 2837.833561]  btrfs_put_super+0x15/0x17 [btrfs]
>> [ 2837.833561]  generic_shutdown_super+0x6a/0xeb
>> [ 2837.833561]  kill_anon_super+0x12/0x1c
>> [ 2837.833561]  btrfs_kill_super+0x16/0x21 [btrfs]
>> [ 2837.833561]  deactivate_locked_super+0x30/0x68
>> [ 2837.833561]  deactivate_super+0x36/0x39
>> [ 2837.833561]  cleanup_mnt+0x58/0x76
>> [ 2837.833561]  __cleanup_mnt+0x12/0x14
>> [ 2837.833561]  task_work_run+0x77/0x9b
>> [ 2837.833561]  prepare_exit_to_usermode+0x9d/0xc5
>> [ 2837.833561]  syscall_return_slowpath+0x196/0x1b9
>> [ 2837.833561]  entry_SYSCALL_64_fastpath+0xab/0xad
>> [ 2837.833561] RIP: 0033:0x7f3ef3e6b9a7
>> [ 2837.833561] RSP: 002b:00007ffdd0d8de58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
>> [ 2837.833561] RAX: 0000000000000000 RBX: 0000556f76a39060 RCX: 00007f3ef3e6b9a7
>> [ 2837.833561] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000556f76a3f910
>> [ 2837.833561] RBP: 0000556f76a3f910 R08: 0000556f76a3e670 R09: 0000000000000015
>> [ 2837.833561] R10: 00000000000006b4 R11: 0000000000000246 R12: 00007f3ef436ce64
>> [ 2837.833561] R13: 0000000000000000 R14: 0000556f76a39240 R15: 00007ffdd0d8e0e0
>> [ 2837.858288] ---[ end trace e79345fe24b30b91 ]---
>> [ 2837.858829] BTRFS info (device sdc): space_info 4 has 1073328128 free, is not full
>> [ 2837.859721] BTRFS info (device sdc): space_info total=1073741824, used=28672, pinned=0, reserved=0, may_use=319488, readonly=65536
>>
>> What happens in the above example is the following:
>>
>> 1) When punching the hole, at btrfs_punch_hole(), the variable tail_len
>>    is set to 2048 (as tail_start is 148Kb + 1 and offset + len is 150Kb).
>>    This results in the creation of an extent map with a length of 2Kb
>>    starting at file offset 148Kb, through find_first_non_hole() ->
>>    btrfs_get_extent().
>>
>> 2) The second write (first write after the hole punch operation), sets
>>    the range [50Kb, 152Kb[ to delalloc.
>>
>> 3) The third write, at btrfs_find_new_delalloc_bytes(), sees the extent
>>    map covering the range [148Kb, 150Kb[ and ends up calling
>>    set_extent_bit() for the same range, which results in splitting an
>>    existing extent state record, covering the range [148Kb, 152Kb[ into
>>    two 2Kb extent state records, covering the ranges [148Kb, 150Kb[ and
>>    [150Kb, 152Kb[.
>>
>> 4) Finally at lock_and_cleanup_extent_if_need(), immediately after calling
>>    btrfs_find_new_delalloc_bytes() we clear the delalloc bit from the
>>    range [100Kb, 152Kb[ which results in the btrfs_clear_bit_hook()
>>    callback being invoked against the two 2Kb extent state records that
>>    cover the ranges [148Kb, 150Kb[ and [150Kb, 152Kb[. When called against
>>    the first 2Kb extent state, it calls btrfs_delalloc_release_metadata()
>>    with a length argument of 2048 bytes. That function rounds up the length
>>    to a sector size aligned length, so it ends up considering a length of
>>    4096 bytes, and then calls calc_csum_metadata_size() which results in
>>    decrementing the inode's csum_bytes counter by 4096 bytes, so after
>>    it stays a value of 0 bytes. Then the same happens when
>>    btrfs_clear_bit_hook() is called against the second extent state that
>>    has a length of 2Kb, covering the range [150Kb, 152Kb[, the length is
>>    rounded up to 4096 and calc_csum_metadata_size() ends up being called
>>    to decrement 4096 bytes from the inode's csum_bytes counter, which
>>    at that time has a value of 0, leading to an underflow, which is
>>    exactly what triggers the first warning, at btrfs_destroy_inode().
>>    All the other warnings relate to several space accounting counters
>>    that underflow as well due to similar reasons.
>>
>> So fix the hole punching operation to make sure it never creates extent
>> maps with a length that is not aligned to the sector size, as this breaks
>> all assumptions and it's a land mine.
>>
>> Fixes: d77815461f04 ("btrfs: Avoid trucating page or punching hole in a already existed hole.")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> ---
>>
>> V2: Rebased on latest for-linus-4.12 branch from Chris, so that it
>>     applies cleanly.
>>
>>  fs/btrfs/file.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index da1096eb1a40..928fe290e834 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -2390,10 +2390,12 @@ static int fill_holes(struct btrfs_trans_handle *trans,
>>   */
>>  static int find_first_non_hole(struct inode *inode, u64 *start, u64 *len)
>>  {
>> +     struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>>       struct extent_map *em;
>>       int ret = 0;
>>
>> -     em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, *start, *len, 0);
>> +     em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, *start,
>> +                           round_up(*len, fs_info->sectorsize), 0);
>
> Sometime ago I found that punch hole can create unaligned extent map
> but I didn't have a case to prove it'd cause problem, thanks for
> catching it.
>
> Why not make btrfs_get_extent() to always return aligned extent map
> since every callers follow the rule except this punch hole?

That's precisely why it's done like this: because all callers
everywhere need to do it.
Plus you would have to go further than making such a change to
btrfs_get_extent(), as there are other ways of creating extent maps.

>
> Thanks,
> -liubo
>>       if (IS_ERR(em))
>>               return PTR_ERR(em);
>>
>> --
>> 2.11.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
