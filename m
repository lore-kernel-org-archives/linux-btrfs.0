From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V2 0/6] random bugfixes of the space management
Date: Wed, 05 Jan 2011 18:13:44 +0800
Message-ID: <4D244458.10608@cn.fujitsu.com>
References: <4D1B0AF7.1000907@cn.fujitsu.com> <AANLkTimmFadec41FOY0PZA2L0gkS44LdNwgY5N1TCs1i@mail.gmail.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimmFadec41FOY0PZA2L0gkS44LdNwgY5N1TCs1i@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Mitch

Could you test the third version of this patchset for me?

Thanks
Miao

On mon, 3 Jan 2011 23:46:00 -0600, Mitch Harder wrote:
> 2010/12/29 Miao Xie<miaox@cn.fujitsu.com>:
>> Hello, Chris
>>
>> I have a bunch of random fixes of the space management in
>>
>> git://repo.or.cz/linux-btrfs-devel.git space-manage
>>
>> They are the ENOSPC fixes, as well as fixes for df command.
>> The first one and the last one fixed the wrong free space information reported
>> by df command. The second one fixed ENOSPC when there is tiny space in the
>> filesystem. And The third fixed wrong calculation of stripe size. And the 4th
>> and 5th patches fixed the chunk allocation problem when the block devices have
>> no enough space to allocate a default-size chunk.
>>
>> Changelog V1 ->  V2:
>> - fix compiler errors on x86_32 machines.
>> - fix some bugs when allocating dup chunks.
>> - break the chunk allocation when errors happen.
>> - just allocate min_stripes stripes when the free space is not enough.
>> - cleanup redundant code
>>
>> You can merge this patchset to your "next" branch directly after dropping
>> the top four patches of the "next" branch.
>>
>> Thanks
>> Miao
>> ---
>>   fs/btrfs/ctree.h       |    2 +
>>   fs/btrfs/extent-tree.c |   71 +++++-
>>   fs/btrfs/super.c       |  147 +++++++++++-
>>   fs/btrfs/volumes.c     |  615 +++++++++++++++++++++++++++++++++++-------------
>>   fs/btrfs/volumes.h     |   27 ++
>>   5 files changed, 686 insertions(+), 176 deletions(-)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> I've applied these patches to a 2.6.36 kernel that I've merged with
> the patches on Chris' 'next' branch, and I'm getting a kernel error.
>
> As per the instructions, I dropped the previous top four patches, and
> applied patches 1-6 from this set of posts.
>
> I am receiving this error while compiling boost on a 3.5 GB partition
> formated with zlib compression.
>
> I've replicated the error several times, so it's reproducible.  Let me
> know if you want to try something different to test.
>
> I'm not seeing any corruption on this partition after rebooting, but
> the partition locks up until a reboot.
>
> This kernel was built for a single CPU.
>
> [  395.318007] device fsid 574581b1d0733ddc-9b56ea1839549fa0 devid 1
> transid 16783 /dev/sdc2
> [  395.319788] btrfs: force zlib compression
> [ 1602.944528] ------------[ cut here ]------------
> [ 1602.944533] kernel BUG at mm/slub.c:2833!
> [ 1602.944536] invalid opcode: 0000 [#1]
> [ 1602.944540] last sysfs file: /sys/devices/virtual/dmi/id/bios_vendor
> [ 1602.944543] Modules linked in: snd_pcm_oss snd_mixer_oss
> snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device ipv6
> nls_iso8859_1 nls_cp437 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm
> ppdev nvidia(P) tpm_tis snd_timer tpm parport_pc tpm_bios snd sr_mod
> i2c_nforce2 pcspkr parport forcedeth nvidia_agp i2c_core snd_page_alloc
> sl811_hcd ohci_hcd uhci_hcd hid ehci_hcd
> [ 1602.944570]
> [ 1602.944576] Pid: 14363, comm: cp Tainted: P
> 2.6.36.2-sabayon #1 MS-6570/
> [ 1602.944580] EIP: 0060:[<c1079724>] EFLAGS: 00210246 CPU: 0
> [ 1602.944588] EIP is at kfree+0x4b/0x8f
> [ 1602.944591] EAX: 00000000 EBX: 10000000 ECX: 00000000 EDX: c1f38fe0
> [ 1602.944595] ESI: 00000000 EDI: ffffffe4 EBP: f3709ac0 ESP: f3709ab4
> [ 1602.944598]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [ 1602.944603] Process cp (pid: 14363, ti=f3708000 task=d9bc83b0
> task.ti=f3708000)
> [ 1602.944605] Stack:
> [ 1602.944607]  10000000 00000000 ffffffe4 f3709b50 c126a7a8 f67bd130
> f67bd234 00000098
> [ 1602.944613]<0>  ffffffe4 00000000 f3709b88 10000000 00000000 f01b4060
> 00000001 f3cbb110
> [ 1602.944619]<0>  c974c2a0 f36410c0 f33da000 f3cbb110 20000000 00000000
> 00000000 00000020
> [ 1602.944625] Call Trace:
> [ 1602.944633]  [<c126a7a8>] ? __btrfs_alloc_chunk+0x6a5/0x6e4
> [ 1602.944638]  [<c1268289>] ? find_next_chunk+0xfd/0x107
> [ 1602.944642]  [<c126a831>] ? btrfs_alloc_chunk+0x4a/0x81
> [ 1602.944648]  [<c1239c19>] ? do_chunk_alloc+0x26f/0x2b0
> [ 1602.944654]  [<c123c6ab>] ? btrfs_reserve_extent+0x71/0x189
> [ 1602.944658]  [<c123c891>] ? btrfs_alloc_free_block+0xce/0x21d
> [ 1602.944667]  [<c10172ba>] ? kmap_atomic_prot+0xa8/0xaa
> [ 1602.944671]  [<c1234a45>] ? split_leaf+0x278/0x568
> [ 1602.944679]  [<c125882f>] ? btrfs_item_offset+0x93/0x9d
> [ 1602.944683]  [<c1235f41>] ? btrfs_search_slot+0x4af/0x579
> [ 1602.944688]  [<c12364d5>] ? btrfs_insert_empty_items+0x3d/0x7c
> [ 1602.944693]  [<c124ef70>] ? btrfs_new_inode+0x147/0x2a8
> [ 1602.944697]  [<c1250905>] ? btrfs_create+0xc0/0x1ec
> [ 1602.944705]  [<c108674c>] ? generic_permission+0xf/0x85
> [ 1602.944709]  [<c1087387>] ? vfs_create+0x85/0xce
> [ 1602.944713]  [<c1087d9a>] ? do_last+0x259/0x4e0
> [ 1602.944717]  [<c10895fe>] ? do_filp_open+0x196/0x446
> [ 1602.944722]  [<c1087aa4>] ? getname+0x1b/0xb8
> [ 1602.944726]  [<c1079645>] ? kmem_cache_alloc+0x3e/0x6c
> [ 1602.944733]  [<c107edcf>] ? do_sys_open+0x48/0xf6
> [ 1602.944737]  [<c107eebf>] ? sys_open+0x1e/0x26
> [ 1602.944742]  [<c100258c>] ? sysenter_do_call+0x12/0x22
> [ 1602.944745] Code: ea 0c c1 e2 05 83 e1 fc 8d 14 11 8b 0a 81 e1 00 40
> 02 00 81 f9 00 40 02 00 75 03 8b 52 0c 8b 0a 84 c9 78 14 8b 02 f6 c4 40
> 75 04<0f>  0b eb fe 89 d0 e8 8a 3f fe ff eb 2f 8b 7d 04 8b 72 0c 9c 5b
> [ 1602.944774] EIP: [<c1079724>] kfree+0x4b/0x8f SS:ESP 0068:f3709ab4
> [ 1602.944781] ---[ end trace e5193c705338f5d6 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

