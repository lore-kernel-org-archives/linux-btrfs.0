Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:36830 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbbE1M6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 May 2015 08:58:20 -0400
Received: by lbbqq2 with SMTP id qq2so27555412lbb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 28 May 2015 05:58:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55668222.8060707@cn.fujitsu.com>
References: <CAGwxe4h5ubG1SptGLH9STNvDaghQJwbUXEDTa_UHREXye9nPsA@mail.gmail.com>
 <55668222.8060707@cn.fujitsu.com>
From: Tobias Holst <tobby@tobby.eu>
Date: Thu, 28 May 2015 14:57:57 +0200
Message-ID: <CAGwxe4iTtf87K=WYMYWaUBQ7SEVSp3LEu4sT8eYzW2fiPn6ybw@mail.gmail.com>
Subject: Re: Uncorrectable errors on RAID6
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

no, I didn't run a replace. But I ran a defrag with "-clzo" on all
files while there has been slightly I/O on the devices. Don't know if
this could cause corruptions, too?

Later on I deleted a r/o-snapshot which should free a big amount of
storage space. It didn't free as much as it should so after a few days
I started a balance to free the space. During the balance the first
checksum errors happened and the whole balance process crashed:

[19174.342882] BTRFS: dm-5 checksum verify failed on 6318462353408
wanted 25D94CD6 found 8BA427D4 level 1
[19174.365473] BTRFS: dm-5 checksum verify failed on 6318462353408
wanted 25D94CD6 found 8BA427D4 level 1
[19174.365651] BTRFS: dm-5 checksum verify failed on 6318462353408
wanted 25D94CD6 found 8BA427D4 level 1
[19174.366168] BTRFS: dm-5 checksum verify failed on 6318462353408
wanted 25D94CD6 found 8BA427D4 level 1
[19174.366250] BTRFS: dm-5 checksum verify failed on 6318462353408
wanted 25D94CD6 found 8BA427D4 level 1
[19174.366392] BTRFS: dm-5 checksum verify failed on 6318462353408
wanted 25D94CD6 found 8BA427D4 level 1
[19174.367313] ------------[ cut here ]------------
[19174.367340] kernel BUG at /home/kernel/COD/linux/fs/btrfs/relocation.c:242!
[19174.367384] invalid opcode: 0000 [#1] SMP
[19174.367418] Modules linked in: iosf_mbi kvm_intel kvm
crct10dif_pclmul ppdev dm_crypt crc32_pclmul ghash_clmulni_intel
aesni_intel aes_x86_64 lrw gf128mul glue_helper parport_pc ablk_helper
cryptd mac_hid 8250_fintek virtio_rng serio_raw i2c_piix4 pvpanic lp
parport btrfs xor raid6_pq cirrus syscopyarea sysfillrect sysimgblt
ttm mpt2sas drm_kms_helper raid_class scsi_transport_sas drm floppy
psmouse pata_acpi
[19174.367656] CPU: 1 PID: 4960 Comm: btrfs Not tainted
4.0.4-040004-generic #201505171336
[19174.367703] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS Bochs 01/01/2011
[19174.367752] task: ffff8804274e8000 ti: ffff880367b50000 task.ti:
ffff880367b50000
[19174.367797] RIP: 0010:[<ffffffffc05ec4ba>]  [<ffffffffc05ec4ba>]
backref_cache_cleanup+0xea/0x100 [btrfs]
[19174.367867] RSP: 0018:ffff880367b53bd8  EFLAGS: 00010202
[19174.367905] RAX: ffff88008250d8f8 RBX: ffff88008250d820 RCX: 0000000180200001
[19174.367948] RDX: ffff88008250d8d8 RSI: ffff88008250d8e8 RDI: 0000000040000000
[19174.367992] RBP: ffff880367b53bf8 R08: ffff880418b77780 R09: 0000000180200001
[19174.368037] R10: ffffffffc05ec1d9 R11: 0000000000018bf8 R12: 0000000000000001
[19174.368081] R13: ffff88008250d8e8 R14: 00000000fffffffb R15: ffff880367b53c28
[19174.368125] FS:  00007f7fd6831c80(0000) GS:ffff88043fc40000(0000)
knlGS:0000000000000000
[19174.368172] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[19174.368210] CR2: 00007f65f7564770 CR3: 00000003ac92f000 CR4: 00000000001407e0
[19174.368257] Stack:
[19174.368279]  00000000fffffffb ffff88008250d800 ffff88042b3d46e0
ffff88006845f990
[19174.368327]  ffff880367b53c78 ffffffffc05f25eb ffff880367b53c78
0000000000000002
[19174.368376]  00ff880429e4c670 a9000010d8fb7e00 0000000000000000
0000000000000000
[19174.368424] Call Trace:
[19174.368459]  [<ffffffffc05f25eb>] relocate_block_group+0x2cb/0x510 [btrfs]
[19174.368509]  [<ffffffffc05f29e0>]
btrfs_relocate_block_group+0x1b0/0x2d0 [btrfs]
[19174.368562]  [<ffffffffc05c6eab>]
btrfs_relocate_chunk.isra.75+0x4b/0xd0 [btrfs]
[19174.368615]  [<ffffffffc05c82e8>] __btrfs_balance+0x348/0x460 [btrfs]
[19174.368663]  [<ffffffffc05c87b5>] btrfs_balance+0x3b5/0x5d0 [btrfs]
[19174.368710]  [<ffffffffc05d5cac>] btrfs_ioctl_balance+0x1cc/0x530 [btrfs]
[19174.368756]  [<ffffffff811b52e0>] ? handle_mm_fault+0xb0/0x160
[19174.368802]  [<ffffffffc05d7c7e>] btrfs_ioctl+0x69e/0xb20 [btrfs]
[19174.368845]  [<ffffffff8120f5b5>] do_vfs_ioctl+0x75/0x320
[19174.368882]  [<ffffffff8120f8f1>] SyS_ioctl+0x91/0xb0
[19174.368923]  [<ffffffff817f098d>] system_call_fastpath+0x16/0x1b
[19174.368962] Code: 3b 00 75 29 44 8b a3 00 01 00 00 45 85 e4 75 1b
44 8b 9b 04 01 00 00 45 85 db 75 0d 48 83 c4 08 5b 41 5c 41 5d 5d c3
0f 0b 0f 0b <0f> 0b 0f 0b 0f 0b 0f 0b 66 66 66 66 66 2e 0f 1f 84 00 00
00 00
[19174.369133] RIP  [<ffffffffc05ec4ba>]
backref_cache_cleanup+0xea/0x100 [btrfs]
[19174.369186]  RSP <ffff880367b53bd8>
[19174.369827] ------------[ cut here ]------------
[19174.369827] kernel BUG at /home/kernel/COD/linux/arch/x86/mm/pageattr.c:216!
[19174.369827] invalid opcode: 0000 [#2] SMP
[19174.369827] Modules linked in: iosf_mbi kvm_intel kvm
crct10dif_pclmul ppdev dm_crypt crc32_pclmul ghash_clmulni_intel
aesni_intel aes_x86_64 lrw gf128mul glue_helper parport_pc ablk_helper
cryptd mac_hid 8250_fintek virtio_rng serio_raw i2c_piix4 pvpanic lp
parport btrfs xor raid6_pq cirrus syscopyarea sysfillrect sysimgblt
ttm mpt2sas drm_kms_helper raid_class scsi_transport_sas drm floppy
psmouse pata_acpi
[19174.369827] CPU: 1 PID: 4960 Comm: btrfs Not tainted
4.0.4-040004-generic #201505171336
[19174.369827] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS Bochs 01/01/2011
[19174.369827] task: ffff8804274e8000 ti: ffff880367b50000 task.ti:
ffff880367b50000
[19174.369827] RIP: 0010:[<ffffffff8106875f>]  [<ffffffff8106875f>]
cpa_flush_array+0x10f/0x120
[19174.369827] RSP: 0018:ffff880367b52cf8  EFLAGS: 00010046
[19174.369827] RAX: 0000000000000092 RBX: 0000000000000000 RCX: 0000000000000005
[19174.369827] RDX: 0000000000000001 RSI: 0000000000000200 RDI: 0000000000000000
[19174.369827] RBP: ffff880367b52d48 R08: ffff880411ef2000 R09: 0000000000000001
[19174.369827] R10: 0000000000000004 R11: ffffffff81adb6be R12: 0000000000000200
[19174.369827] R13: 0000000000000001 R14: 0000000000000005 R15: 0000000000000000
[19174.369827] FS:  00007f7fd6831c80(0000) GS:ffff88043fc40000(0000)
knlGS:0000000000000000
[19174.369827] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[19174.369827] CR2: 00007f65f7564770 CR3: 00000003ac92f000 CR4: 00000000001407e0
[19174.369827] Stack:
[19174.369827]  0000000000000001 ffff880411ef2000 0000000000000001
0000000000000001
[19174.369827]  ffff880367b52d48 0000000000000000 0000000000000200
0000000000000000
[19174.369827]  0000000000000004 0000000000000000 ffff880367b52de8
ffffffff8106979c
[19174.369827] Call Trace:
[19174.369827]  [<ffffffff8106979c>] change_page_attr_set_clr+0x23c/0x2c0
[19174.369827]  [<ffffffff810699b0>] _set_pages_array+0xf0/0x140
[19174.369827]  [<ffffffff81069a13>] set_pages_array_wc+0x13/0x20
[19174.369827]  [<ffffffffc052d926>] ttm_set_pages_caching+0x46/0x80 [ttm]
[19174.369827]  [<ffffffffc052da24>] ttm_alloc_new_pages.isra.6+0xc4/0x1a0 [ttm]
[19174.369827]  [<ffffffffc052dc76>]
ttm_page_pool_fill_locked.isra.7.constprop.12+0x96/0x140 [ttm]
[19174.369827]  [<ffffffffc052dd5a>]
ttm_page_pool_get_pages.isra.8.constprop.10+0x3a/0xe0 [ttm]
[19174.369827]  [<ffffffffc052dea0>] ttm_get_pages.constprop.11+0xa0/0x1f0 [ttm]
[19174.369827]  [<ffffffffc052e07c>] ttm_pool_populate+0x8c/0xf0 [ttm]
[19174.369827]  [<ffffffffc052a0f3>] ? ttm_mem_reg_ioremap+0x63/0xf0 [ttm]
[19174.369827]  [<ffffffffc056146e>] cirrus_ttm_tt_populate+0xe/0x10 [cirrus]
[19174.369827]  [<ffffffffc052a7ea>] ttm_bo_move_memcpy+0x5ea/0x650 [ttm]
[19174.369827]  [<ffffffffc05266ac>] ? ttm_tt_init+0x8c/0xb0 [ttm]
[19174.369827]  [<ffffffff811c3aee>] ? __vmalloc_node+0x3e/0x40
[19174.369827]  [<ffffffffc0561418>] cirrus_bo_move+0x18/0x20 [cirrus]
[19174.369827]  [<ffffffffc0527f5f>] ttm_bo_handle_move_mem+0x27f/0x6f0 [ttm]
[19174.369827]  [<ffffffffc0528f7c>] ttm_bo_move_buffer+0xdc/0xf0 [ttm]
[19174.369827]  [<ffffffffc0529023>] ttm_bo_validate+0x93/0xb0 [ttm]
[19174.369827]  [<ffffffffc0561c3f>] cirrus_bo_push_sysram+0x8f/0xe0 [cirrus]
[19174.369827]  [<ffffffffc055feb3>]
cirrus_crtc_do_set_base.isra.9.constprop.10+0x83/0x2b0 [cirrus]
[19174.369827]  [<ffffffff811df534>] ? kmem_cache_alloc_trace+0x1c4/0x210
[19174.369827]  [<ffffffffc056056f>] cirrus_crtc_mode_set+0x48f/0x4f0 [cirrus]
[19174.369827]  [<ffffffffc04c29de>]
drm_crtc_helper_set_mode+0x35e/0x5c0 [drm_kms_helper]
[19174.369827]  [<ffffffffc04c35f2>]
drm_crtc_helper_set_config+0x6d2/0xad0 [drm_kms_helper]
[19174.369827]  [<ffffffffc0560f9a>] ? cirrus_dirty_update+0xca/0x320 [cirrus]
[19174.369827]  [<ffffffff811df534>] ? kmem_cache_alloc_trace+0x1c4/0x210
[19174.369827]  [<ffffffffc0406026>]
drm_mode_set_config_internal+0x66/0x110 [drm]
[19174.369827]  [<ffffffffc04ceee2>]
drm_fb_helper_pan_display+0xa2/0xf0 [drm_kms_helper]
[19174.369827]  [<ffffffff814382cd>] fb_pan_display+0xbd/0x170
[19174.369827]  [<ffffffff81432629>] bit_update_start+0x29/0x60
[19174.369827]  [<ffffffff81431ee2>] fbcon_switch+0x3b2/0x560
[19174.369827]  [<ffffffff814c22f9>] redraw_screen+0x179/0x220
[19174.369827]  [<ffffffff8143024a>] fbcon_blank+0x21a/0x2d0
[19174.369827]  [<ffffffff810d0aa2>] ? wake_up_klogd+0x32/0x40
[19174.369827]  [<ffffffff810d0cd8>] ? console_unlock.part.19+0x228/0x2a0
[19174.369827]  [<ffffffff810e343c>] ? internal_add_timer+0x6c/0x90
[19174.369827]  [<ffffffff810e58d9>] ? mod_timer+0xf9/0x200
[19174.369827]  [<ffffffff814c2de0>] do_unblank_screen.part.22+0xa0/0x180
[19174.369827]  [<ffffffff814c2f0c>] do_unblank_screen+0x4c/0x80
[19174.369827]  [<ffffffffc05ec4ba>] ? backref_cache_cleanup+0xea/0x100 [btrfs]
[19174.369827]  [<ffffffff814c2f50>] unblank_screen+0x10/0x20
[19174.369827]  [<ffffffff813c3ccd>] bust_spinlocks+0x1d/0x40
[19174.369827]  [<ffffffff81019bd3>] oops_end+0x43/0x120
[19174.369827]  [<ffffffff8101a2f8>] die+0x58/0x90
[19174.369827]  [<ffffffff8101642d>] do_trap+0xcd/0x160
[19174.369827]  [<ffffffff810167e6>] do_error_trap+0xe6/0x170
[19174.369827]  [<ffffffffc05ec4ba>] ? backref_cache_cleanup+0xea/0x100 [btrfs]
[19174.369827]  [<ffffffff817dce0f>] ? __slab_free+0xee/0x234
[19174.369827]  [<ffffffff817dce0f>] ? __slab_free+0xee/0x234
[19174.369827]  [<ffffffffc05baf0e>] ? clear_state_bit+0xae/0x170 [btrfs]
[19174.369827]  [<ffffffffc05ba67a>] ? free_extent_state+0x6a/0xd0 [btrfs]
[19174.369827]  [<ffffffff810172e0>] do_invalid_op+0x20/0x30
[19174.369827]  [<ffffffff817f24ee>] invalid_op+0x1e/0x30
[19174.369827]  [<ffffffffc05ec1d9>] ?
free_backref_node.isra.36+0x19/0x20 [btrfs]
[19174.369827]  [<ffffffffc05ec4ba>] ? backref_cache_cleanup+0xea/0x100 [btrfs]
[19174.369827]  [<ffffffffc05ec43c>] ? backref_cache_cleanup+0x6c/0x100 [btrfs]
[19174.369827]  [<ffffffffc05f25eb>] relocate_block_group+0x2cb/0x510 [btrfs]
[19174.369827]  [<ffffffffc05f29e0>]
btrfs_relocate_block_group+0x1b0/0x2d0 [btrfs]
[19174.369827]  [<ffffffffc05c6eab>]
btrfs_relocate_chunk.isra.75+0x4b/0xd0 [btrfs]
[19174.369827]  [<ffffffffc05c82e8>] __btrfs_balance+0x348/0x460 [btrfs]
[19174.369827]  [<ffffffffc05c87b5>] btrfs_balance+0x3b5/0x5d0 [btrfs]
[19174.369827]  [<ffffffffc05d5cac>] btrfs_ioctl_balance+0x1cc/0x530 [btrfs]
[19174.369827]  [<ffffffff811b52e0>] ? handle_mm_fault+0xb0/0x160
[19174.369827]  [<ffffffffc05d7c7e>] btrfs_ioctl+0x69e/0xb20 [btrfs]
[19174.369827]  [<ffffffff8120f5b5>] do_vfs_ioctl+0x75/0x320
[19174.369827]  [<ffffffff8120f8f1>] SyS_ioctl+0x91/0xb0
[19174.369827]  [<ffffffff817f098d>] system_call_fastpath+0x16/0x1b
[19174.369827] Code: 4e 8b 2c 23 eb cd 66 0f 1f 44 00 00 48 83 c4 28
5b 41 5c 41 5d 41 5e 41 5f 5d c3 90 be 00 10 00 00 4c 89 ef e8 a3 ee
ff ff eb c7 <0f> 0b 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f
44 00
[19174.369827] RIP  [<ffffffff8106875f>] cpa_flush_array+0x10f/0x120
[19174.369827]  RSP <ffff880367b52cf8>
[19174.369827] ---[ end trace 60adc437bd944044 ]---

After a reboot and a remount it always tried to resume the balance and
and then crashed again, so I had to be quick to do a "btrfs balance
cancel". Then I started the scrub and got these uncorrectable errors I
mentioned in the first mail.

I just unmounted it and started a btrfsck. Will post the output when it's done.
It's already showing me several of these:

checksum verify failed on 18523667709952 found C240FB11 wanted 1ED6A587
checksum verify failed on 18523667709952 found C240FB11 wanted 1ED6A587
checksum verify failed on 18523667709952 found 5EAB6BFE wanted BA48D648
checksum verify failed on 18523667709952 found 8E19F60E wanted E3A34D18
checksum verify failed on 18523667709952 found C240FB11 wanted 1ED6A587
bytenr mismatch, want=18523667709952, have=10838194617263884761


Thanks,
Tobias



2015-05-28 4:49 GMT+02:00 Qu Wenruo <quwenruo@cn.fujitsu.com>:
>
>
> -------- Original Message  --------
> Subject: Uncorrectable errors on RAID6
> From: Tobias Holst <tobby@tobby.eu>
> To: linux-btrfs@vger.kernel.org <linux-btrfs@vger.kernel.org>
> Date: 2015年05月28日 10:18
>
>> Hi
>>
>> I am doing a scrub on my 6-drive btrfs RAID6. Last time it found zero
>> errors, but now I am getting this in my log:
>>
>> [ 6610.888020] BTRFS: checksum error at logical 478232346624 on dev
>> /dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
>> [ 6610.888025] BTRFS: checksum error at logical 478232346624 on dev
>> /dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
>> [ 6610.888029] BTRFS: bdev /dev/dm-2 errs: wr 0, rd 0, flush 0, corrupt 1,
>> gen 0
>> [ 6611.271334] BTRFS: unable to fixup (regular) error at logical
>> 478232346624 on dev /dev/dm-2
>> [ 6611.831370] BTRFS: checksum error at logical 478232346624 on dev
>> /dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
>> [ 6611.831373] BTRFS: checksum error at logical 478232346624 on dev
>> /dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
>> [ 6611.831375] BTRFS: bdev /dev/dm-2 errs: wr 0, rd 0, flush 0, corrupt 2,
>> gen 0
>> [ 6612.396402] BTRFS: unable to fixup (regular) error at logical
>> 478232346624 on dev /dev/dm-2
>> [ 6904.027456] BTRFS: checksum error at logical 478232346624 on dev
>> /dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
>> [ 6904.027460] BTRFS: checksum error at logical 478232346624 on dev
>> /dev/dm-2, sector 231373760: metadata leaf (level 0) in tree 2
>> [ 6904.027463] BTRFS: bdev /dev/dm-2 errs: wr 0, rd 0, flush 0, corrupt 3,
>> gen 0
>>
>> Looks like it is always the same sector.
>>
>> "btrfs balance status" shows me:
>> scrub status for a34ce68b-bb9f-49f0-91fe-21a924ef11ae
>>          scrub started at Thu May 28 02:25:31 2015, running for 6759
>> seconds
>>          total bytes scrubbed: 448.87GiB with 14 errors
>>          error details: read=8 csum=6
>>          corrected errors: 3, uncorrectable errors: 11, unverified errors:
>> 0
>>
>> What does it mean and why are these erros uncorrectable even on a RAID6?
>> Can I find out, which files are affected?
>
> If it's OK for you to put the fs offline,
> btrfsck is the best method to check what happens, although it may take a
> long time.
>
> There is a known bug that replace can cause checksum error, found by Zhao
> Lei.
> So did you run replace while there is still some other disk I/O happens?
>
> Thanks,
> Qu
>>
>>
>> system: Ubuntu 14.04.2
>> kernel version 4.0.4
>> btrfs-tools version: 4.0
>>
>> Regards
>> Tobias
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
