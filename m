From: Erik Logtenberg <erik@logtenberg.eu>
Subject: Re: Kernel error during btrfs balance
Date: Fri, 21 Jan 2011 09:50:19 +0100
Message-ID: <4D3948CB.8090801@logtenberg.eu>
References: <4D344EBB.6030903@logtenberg.eu> <4D3452C9.901@logtenberg.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D3452C9.901@logtenberg.eu>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I hit the same bug again I think:

[291835.724344] ------------[ cut here ]------------
[291835.724376] kernel BUG at fs/btrfs/relocation.c:836!
[291835.724401] invalid opcode: 0000 [#1] SMP
[291835.724424] last sysfs file:
/sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map
[291835.724461] CPU 0
[291835.724472] Modules linked in: uvcvideo snd_usb_audio
snd_usbmidi_lib videodev v4l1_compat snd_rawmidi v4l2_compat_ioctl32
btrfs zlib_deflate libcrc32c sha256_generic cryptd aes_x86_64
aes_generic cbc dm_crypt tun ebtable_nat ebtables ipt_MASQUERADE
iptable_nat nf_nat bridge stp llc nfsd lockd nfs_acl auth_rpcgss
exportfs nls_utf8 cifs fscache sunrpc cpufreq_ondemand acpi_cpufreq
freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
ip6table_filter ip6_tables ipv6 kvm_intel kvm dummy uinput
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device e1000e snd_pcm snd_timer i2c_i801 snd shpchp iTCO_wdt
iTCO_vendor_support soundcore dell_wmi sparse_keymap snd_page_alloc
serio_raw joydev wmi dcdbas microcode usb_storage uas raid1 pata_acpi
ata_generic radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core [last
unloaded: scsi_wait_scan]
[291835.725002]
[291835.725013] Pid: 27386, comm: btrfs Tainted: G          I
2.6.37-2.fc15.x86_64 #1
[291835.725062] RIP: 0010:[<ffffffffa0565237>]  [<ffffffffa0565237>]
build_backref_tree+0x473/0xd6d [btrfs]
[291835.725126] RSP: 0018:ffff8800373bf9c8  EFLAGS: 00010246
[291835.725152] RAX: ffff8801367d5100 RBX: ffff88020b110880 RCX:
0000000000000040
[291835.725186] RDX: 0000000000000030 RSI: 0000006dd08d3000 RDI:
ffff880100069820
[291835.725219] RBP: ffff8800373bfaf8 R08: 0000000000008050 R09:
ffff8800373bf980
[291835.725253] R10: ffff8800373bf918 R11: ffff88020b110880 R12:
ffff8801367d5100
[291835.725254] R13: ffff88012c0a24c0 R14: ffff88021e2013f0 R15:
ffff88021e201cf0
[291835.725254] FS:  00007fcb1a6cc760(0000) GS:ffff8800bfa00000(0000)
knlGS:0000000000000000
[291835.725254] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[291835.725254] CR2: 0000000002feeeb8 CR3: 00000001c2943000 CR4:
00000000000426e0
[291835.725254] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[291835.725254] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[291835.725254] Process btrfs (pid: 27386, threadinfo ffff8800373be000,
task ffff88022452ae40)
[291835.725254] Stack:
[291835.725254]  ffffea0004b5a470 ffffea0000000000 ffff8800373bf9f8
ffff8800373bfaa8
[291835.725254]  0000000000000000 ffff88005faafbb0 ffff880100069808
ffff880100069d78
[291835.725254]  ffff88012c0a2aa0 ffff880100069820 ffff88020b1108c0
ffff880100069d80
[291835.725254] Call Trace:
[291835.725254]  [<ffffffffa0565c91>] relocate_tree_blocks+0x160/0x478
[btrfs]
[291835.725254]  [<ffffffffa056463d>] ? add_tree_block+0x11e/0x13e [btrfs]
[291835.725254]  [<ffffffffa0566b45>] relocate_block_group+0x1e3/0x490
[btrfs]
[291835.725254]  [<ffffffff8103edb9>] ? should_resched+0xe/0x2e
[291835.725254]  [<ffffffffa0566f39>]
btrfs_relocate_block_group+0x147/0x28a [btrfs]
[291835.725254]  [<ffffffffa054e52a>]
btrfs_relocate_chunk.clone.40+0x61/0x4ab [btrfs]
[291835.725254]  [<ffffffffa05152d4>] ? btrfs_item_key+0x1e/0x20 [btrfs]
[291835.725254]  [<ffffffffa05152f0>] ? btrfs_item_key_to_cpu+0x1a/0x36
[btrfs]
[291835.725254]  [<ffffffffa054c2a8>] ? read_extent_buffer+0xc3/0xe3 [btrfs]
[291835.725254]  [<ffffffffa05154e6>] ?
btrfs_header_nritems.clone.12+0x17/0x1c [btrfs]
[291835.725254]  [<ffffffffa054cff6>] ? btrfs_item_key_to_cpu+0x2a/0x46
[btrfs]
[291835.725254]  [<ffffffffa055045e>] btrfs_balance+0x1a3/0x1f0 [btrfs]
[291835.725254]  [<ffffffff8112bce5>] ? do_filp_open+0x226/0x5c8
[291835.725254]  [<ffffffffa0556773>] btrfs_ioctl+0x641/0x846 [btrfs]
[291835.725254]  [<ffffffff811f3ed1>] ? file_has_perm+0xa5/0xc7
[291835.725254]  [<ffffffff8112e091>] do_vfs_ioctl+0x4b1/0x4f2
[291835.725254]  [<ffffffff8112e128>] sys_ioctl+0x56/0x7a
[291835.725254]  [<ffffffff8100acc2>] system_call_fastpath+0x16/0x1b
[291835.725254] Code: 48 8b 45 89 49 8d 7d 10 48 8d 75 b0 49 89 44 24 18
8a 43 70 ff c0 41 88 44 24 70 e8 f7 c3 ff ff eb 17 f6 40 71 10 49 89 c4
75 02 <0f> 0b 49 8d 45 10 49 89 45 10 49 89 45 18 48 8b b5 20 ff ff ff
[291835.725254] RIP  [<ffffffffa0565237>] build_backref_tree+0x473/0xd6d
[btrfs]
[291835.725254]  RSP <ffff8800373bf9c8>
[291835.738971] ---[ end trace a7919e7f17c0a727 ]---


It is really difficult to reproduce this bug. This time, I was balancing
a 300GB volume, which was almost finished by the time it crashed. It had
been running for 2 days straight, and survived a complete backup run,
with 5 simultaneous rsyncs running on it. Last night when the rsyncs
kicked in, it crashed within half an hour though.

I will now try downgrading to 2.6.36 as per Zheng Yan's suggestion.

Thanks,

Erik.


Op 17-1-2011 15:31, Erik Logtenberg schreef:
> Hi,
> 
> Please find attached the error log, for future reference.
> 
> Forgot to mention:
> I could still use the system after this error, so it was not a complete
> fatal error in that regard. All active processes (mostly rsync) were
> hanging in state D though, so I couldn't kill them anymore. Also the FS
> was not umountable. So I still had to reboot.
> 
> Thanks,
> 
> Erik.
> 
> 
> On 01/17/2011 03:14 PM, Erik Logtenberg wrote:
>> Hi,
>>
>> btrfs balance results in:
>>
>> http://pastebin.com/v5j0809M
>>
>> My system: fully up-to-date Fedora 14 with rawhide kernel to make btrfs
>> balance do useful stuff to my free space:
>>
>> kernel-2.6.37-2.fc15.x86_64
>> btrfs-progs-0.19-12.fc14.x86_64
>>
>> Filesystem had 0 bytes free, should be 45G, so on darklings advice I ran
>> btrfs balance on the fs, while doing heavy I/O (re-running 5 backup jobs
>> that had failed due to ENOSP).
>> Up until the crash, btrfs balance did retrieve a couple of Gigs free
>> space though, so that part of the plan worked just fine.
>>
>> Thanks,
>>
>> Erik.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

