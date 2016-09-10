Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:61890 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751722AbcIJLr5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Sep 2016 07:47:57 -0400
Subject: Re: segfault btrfs scrub
To: bo.li.liu@oracle.com
References: <trinity-2d94fea3-703e-4378-9700-43d6af78481f-1473424905009@3capp-gmx-bs47>
 <20160909202113.GA18046@localhost.localdomain>
Cc: linux-btrfs@vger.kernel.org
From: Jan Koester <jan.koester@gmx.net>
Message-ID: <dc4c4a73-a481-f89a-08c3-c8c75f657707@gmx.net>
Date: Sat, 10 Sep 2016 13:47:42 +0200
MIME-Version: 1.0
In-Reply-To: <20160909202113.GA18046@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

i have now installed kernel 4.8-rc5 now i got this output when i 
starting scrub. My problem is that i can see all files on my Filesystem 
but can't access them.

[43176.787859] ------------[ cut here ]------------
[43176.787926] WARNING: CPU: 1 PID: 19517 at 
/home/kernel/COD/linux/fs/btrfs/extent-tree.c:6947 
__btrfs_free_extent.isra.71+0x85a/0xd40 [btrfs]
[43176.787928] Modules linked in: fuse ufs qnx4 hfsplus hfs minix ntfs 
vfat msdos fat jfs xfs libcrc32c dm_mod binfmt_misc crc32c_generic btrfs 
xor raid6_pq kvm_amd kvm irqbypass serio_raw k10temp snd_hda_codec_hdmi 
joydev snd_hda_intel snd_hda_codec snd_hda_core snd_usb_audio snd_ctxfi 
snd_usbmidi_lib snd_hwdep snd_pcm snd_seq_midi snd_seq_midi_event 
snd_rawmidi snd_seq sg snd_seq_device i2c_piix4 snd_timer snd soundcore 
tpm_infineon evdev acpi_cpufreq shpchp tpm_tis tpm_tis_core tpm 
parport_pc ppdev sunrpc lp parport autofs4 ext4 crc16 jbd2 fscrypto 
mbcache sd_mod hid_generic usbhid hid ohci_pci amdkfd radeon 
i2c_algo_bit ttm drm_kms_helper syscopyarea sysfillrect sysimgblt 
fb_sys_fops drm xhci_pci xhci_hcd ahci libahci ohci_hcd ehci_pci 
ehci_hcd libata e1000e usbcore scsi_mod r8169 ptp usb_common
[43176.788305]  pps_core mii fjes wmi button
[43176.788317] CPU: 1 PID: 19517 Comm: kworker/u16:4 Tainted: G        W 
       4.8.0-040800rc5-generic #201609041832
[43176.788319] Hardware name: Gigabyte Technology Co., Ltd. 
GA-970A-D3/GA-970A-D3, BIOS F12 09/03/2013
[43176.788377] Workqueue: btrfs-extent-refs btrfs_extent_refs_helper [btrfs]
[43176.788382]  0000000000000286 000000001d97bfa2 ffffffffa5141064 
0000000000000000
[43176.788389]  0000000000000000 ffffffffa4e7f6ee 000000ddc9d93000 
ffff976cd9b635b0
[43176.788395]  00000000fffffffe ffff976cf93d5be0 ffff976da1478000 
0000000000000000
[43176.788401] Call Trace:
[43176.788410]  [<ffffffffa5141064>] ? dump_stack+0x5c/0x78
[43176.788417]  [<ffffffffa4e7f6ee>] ? __warn+0xbe/0xe0
[43176.788461]  [<ffffffffc0b237aa>] ? 
__btrfs_free_extent.isra.71+0x85a/0xd40 [btrfs]
[43176.788513]  [<ffffffffc0b94609>] ? 
btrfs_merge_delayed_refs+0x69/0x570 [btrfs]
[43176.788557]  [<ffffffffc0b28133>] ? 
__btrfs_run_delayed_refs+0xb43/0x13d0 [btrfs]
[43176.788564]  [<ffffffffa4fefba7>] ? kmem_cache_alloc+0xb7/0x510
[43176.788609]  [<ffffffffc0b2b95a>] ? btrfs_run_delayed_refs+0x9a/0x2b0 
[btrfs]
[43176.788654]  [<ffffffffc0b2bbf9>] ? delayed_ref_async_start+0x89/0xa0 
[btrfs]
[43176.788706]  [<ffffffffc0b7685a>] ? 
btrfs_scrubparity_helper+0xca/0x380 [btrfs]
[43176.788712]  [<ffffffffa4e98f94>] ? process_one_work+0x184/0x4b0
[43176.788716]  [<ffffffffa4e9930d>] ? worker_thread+0x4d/0x480
[43176.788721]  [<ffffffffa541a241>] ? __schedule+0x261/0x720
[43176.788725]  [<ffffffffa4e992c0>] ? process_one_work+0x4b0/0x4b0
[43176.788730]  [<ffffffffa4e9f46d>] ? kthread+0xcd/0xf0
[43176.788735]  [<ffffffffa4e2c751>] ? __switch_to+0x2c1/0x7a0
[43176.788741]  [<ffffffffa541ed9f>] ? ret_from_fork+0x1f/0x40
[43176.788747]  [<ffffffffa4e9f3a0>] ? kthread_create_on_node+0x1a0/0x1a0
[43176.788750] ---[ end trace 18d7bec13eeb81e1 ]---
[43176.788757] BTRFS info (device sde): leaf 950359658496 total ptrs 56 
free space 711
[43176.788761]  item 0 key (503649468416 168 4096) itemoff 3944 itemsize 51
[43176.788764]          extent refs 1 gen 861173 flags 2
[43176.788767]          tree block key (0 0 0) level 0
[43176.788778]          tree block backref root 7
[43176.788789]  item 1 key (503649468416 192 1107296256) itemoff 3920 
itemsize 24
[43176.788799]          block group used 45056
[43176.788808]  item 2 key (503649484800 168 4096) itemoff 3869 itemsize 51
[43176.788818]          extent refs 1 gen 861172 flags 2
[43176.788832]          tree block key (0 0 0) level 0
[43176.788841]          tree block backref root 7
[43176.788855]  item 3 key (503649488896 168 4096) itemoff 3818 itemsize 51
[43176.788867]          extent refs 1 gen 861174 flags 2
[43176.788880]          tree block key (2 132 0) level 1
[43176.788889]          tree block backref root 1
[43176.788899]  item 4 key (503649501184 168 4096) itemoff 3767 itemsize 51
[43176.788907]          extent refs 1 gen 861174 flags 2
[43176.788919]          tree block key (2 132 0) level 0
[43176.788928]          tree block backref root 1
[43176.788939]  item 5 key (503649570816 168 4096) itemoff 3716 itemsize 51
[43176.788948]          extent refs 1 gen 861170 flags 2
[43176.788961]          tree block key (1065417768960 192 3221225472) 
level 0
[43176.788970]          tree block backref root 2
[43176.788981]  item 6 key (503649607680 168 4096) itemoff 3665 itemsize 51
[43176.788988]          extent refs 1 gen 861170 flags 2
[43176.788996]          tree block key (1316673355776 192 3221225472) 
level 0
[43176.789005]          tree block backref root 2
[43176.789015]  item 7 key (503649628160 168 4096) itemoff 3614 itemsize 51
[43176.789025]          extent refs 1 gen 861170 flags 2
[43176.789035]          tree block key (1446629670912 192 3221225472) 
level 0
[43176.789041]          tree block backref root 2
[43176.789050]  item 8 key (503649636352 168 4096) itemoff 3563 itemsize 51
[43176.789060]          extent refs 1 gen 861170 flags 2
[43176.789069]          tree block key (1707548934144 192 3221225472) 
level 0
[43176.789077]          tree block backref root 2
[43176.789088]  item 9 key (950359621632 168 4096) itemoff 3512 itemsize 51
[43176.789095]          extent refs 1 gen 861175 flags 2
[43176.789103]          tree block key (256 1 0) level 4
[43176.789110]          tree block backref root 5
[43176.789118]  item 10 key (950359621632 192 1107296256) itemoff 3488 
itemsize 24
[43176.789127]          block group used 0
[43176.789135]  item 11 key (950359625728 168 4096) itemoff 3437 itemsize 51
[43176.789152]          extent refs 1 gen 861175 flags 2
[43176.789154]          tree block key (9406070 108 0) level 3
[43176.789155]          tree block backref root 5
[43176.789159]  item 12 key (950359629824 168 4096) itemoff 3386 itemsize 51
[43176.789161]          extent refs 1 gen 861175 flags 2
[43176.789163]          tree block key (18405423 1 0) level 2
[43176.789165]          tree block backref root 5
[43176.789168]  item 13 key (950359633920 168 4096) itemoff 3335 itemsize 51
[43176.789170]          extent refs 1 gen 861175 flags 2
[43176.789173]          tree block key (18687456 1 0) level 1
[43176.789174]          tree block backref root 5
[43176.789177]  item 14 key (950359638016 168 4096) itemoff 3284 itemsize 51
[43176.789179]          extent refs 1 gen 861175 flags 2
[43176.789181]          tree block key (18689154 1 0) level 0
[43176.789183]          tree block backref root 5
[43176.789186]  item 15 key (950359642112 168 4096) itemoff 3233 itemsize 51
[43176.789188]          extent refs 1 gen 861175 flags 2
[43176.789190]          tree block key (18690745 108 0) level 1
[43176.789192]          tree block backref root 5
[43176.789195]  item 16 key (950359646208 168 4096) itemoff 3182 itemsize 51
[43176.789197]          extent refs 1 gen 861175 flags 2
[43176.789199]          tree block key (18691274 12 1366601) level 0
[43176.789201]          tree block backref root 5
[43176.789204]  item 17 key (950359650304 168 4096) itemoff 3131 itemsize 51
[43176.789206]          extent refs 1 gen 861175 flags 2
[43176.789208]          tree block key (503649468416 168 4096) level 1
[43176.789209]          tree block backref root 2
[43176.789213]  item 18 key (950359654400 168 4096) itemoff 3080 itemsize 51
[43176.789215]          extent refs 1 gen 861175 flags 2
[43176.789217]          tree block key (2095203287040 192 3221225472) 
level 0
[43176.789218]          tree block backref root 2
[43176.789222]  item 19 key (950359658496 168 4096) itemoff 3029 itemsize 51
[43176.789224]          extent refs 1 gen 861175 flags 2
[43176.789226]          tree block key (503649468416 168 4096) level 0
[43176.789227]          tree block backref root 2
[43176.789230]  item 20 key (950359662592 168 4096) itemoff 2978 itemsize 51
[43176.789232]          extent refs 1 gen 861175 flags 2
[43176.789234]          tree block key (0 249 1) level 1
[43176.789236]          tree block backref root 4
[43176.789239]  item 21 key (950359666688 168 4096) itemoff 2927 itemsize 51
[43176.789241]          extent refs 1 gen 861175 flags 2
[43176.789243]          tree block key (3 204 73421488128) level 0
[43176.789244]          tree block backref root 4
[43176.789248]  item 22 key (951466917888 192 1107296256) itemoff 2903 
itemsize 24
[43176.789249]          block group used 0
[43176.789252]  item 23 key (952574214144 192 100663296) itemoff 2879 
itemsize 24
[43176.789253]          block group used 0
[43176.789256]  item 24 key (952674877440 192 3221225472) itemoff 2855 
itemsize 24
[43176.789258]          block group used 0
[43176.789261]  item 25 key (955896102912 192 3221225472) itemoff 2831 
itemsize 24
[43176.789262]          block group used 0
[43176.789265]  item 26 key (959117328384 192 3221225472) itemoff 2807 
itemsize 24
[43176.789267]          block group used 0
[43176.789270]  item 27 key (962338553856 192 3221225472) itemoff 2783 
itemsize 24
[43176.789271]          block group used 0
[43176.789274]  item 28 key (965559779328 192 3221225472) itemoff 2759 
itemsize 24
[43176.789275]          block group used 0
[43176.789279]  item 29 key (968781004800 192 3221225472) itemoff 2735 
itemsize 24
[43176.789280]          block group used 0
[43176.789283]  item 30 key (972002230272 192 3221225472) itemoff 2711 
itemsize 24
[43176.789284]          block group used 0
[43176.789288]  item 31 key (975223455744 192 3221225472) itemoff 2687 
itemsize 24
[43176.789289]          block group used 0
[43176.789292]  item 32 key (978444681216 192 3221225472) itemoff 2663 
itemsize 24
[43176.789293]          block group used 0
[43176.789296]  item 33 key (981665906688 192 3221225472) itemoff 2639 
itemsize 24
[43176.789298]          block group used 0
[43176.789301]  item 34 key (984887132160 192 3221225472) itemoff 2615 
itemsize 24
[43176.789302]          block group used 0
[43176.789305]  item 35 key (988108357632 192 3221225472) itemoff 2591 
itemsize 24
[43176.789306]          block group used 0
[43176.789310]  item 36 key (991329583104 192 3221225472) itemoff 2567 
itemsize 24
[43176.789311]          block group used 0
[43176.789314]  item 37 key (994550808576 192 3221225472) itemoff 2543 
itemsize 24
[43176.789315]          block group used 0
[43176.789319]  item 38 key (997772034048 192 3221225472) itemoff 2519 
itemsize 24
[43176.789320]          block group used 0
[43176.789323]  item 39 key (1000993259520 192 3221225472) itemoff 2495 
itemsize 24
[43176.789324]          block group used 0
[43176.789327]  item 40 key (1004214484992 192 3221225472) itemoff 2471 
itemsize 24
[43176.789329]          block group used 0
[43176.789332]  item 41 key (1007435710464 192 3221225472) itemoff 2447 
itemsize 24
[43176.789333]          block group used 0
[43176.789336]  item 42 key (1010656935936 192 3221225472) itemoff 2423 
itemsize 24
[43176.789338]          block group used 0
[43176.789341]  item 43 key (1013878161408 192 3221225472) itemoff 2399 
itemsize 24
[43176.789342]          block group used 0
[43176.789345]  item 44 key (1017099386880 192 3221225472) itemoff 2375 
itemsize 24
[43176.789346]          block group used 0
[43176.789350]  item 45 key (1020320612352 192 3221225472) itemoff 2351 
itemsize 24
[43176.789351]          block group used 0
[43176.789354]  item 46 key (1023541837824 192 3221225472) itemoff 2327 
itemsize 24
[43176.789355]          block group used 0
[43176.789358]  item 47 key (1026763063296 192 3221225472) itemoff 2303 
itemsize 24
[43176.789360]          block group used 0
[43176.789363]  item 48 key (1029984288768 192 3221225472) itemoff 2279 
itemsize 24
[43176.789364]          block group used 0
[43176.789367]  item 49 key (1033205514240 192 3221225472) itemoff 2255 
itemsize 24
[43176.789368]          block group used 0
[43176.789371]  item 50 key (1036426739712 192 3221225472) itemoff 2231 
itemsize 24
[43176.789373]          block group used 0
[43176.789376]  item 51 key (1039647965184 192 3221225472) itemoff 2207 
itemsize 24
[43176.789377]          block group used 0
[43176.789380]  item 52 key (1042869190656 192 3221225472) itemoff 2183 
itemsize 24
[43176.789381]          block group used 0
[43176.789385]  item 53 key (1046090416128 192 3221225472) itemoff 2159 
itemsize 24
[43176.789386]          block group used 0
[43176.789389]  item 54 key (1049311641600 192 3221225472) itemoff 2135 
itemsize 24
[43176.789390]          block group used 0
[43176.789393]  item 55 key (1052532867072 192 3221225472) itemoff 2111 
itemsize 24
[43176.789395]          block group used 0
[43176.789399] BTRFS error (device sde): unable to find ref byte nr 
952574226432 parent 0 root 3  owner 0 offset 0
[43176.789409] BTRFS: error (device sde) in __btrfs_free_extent:6953: 
errno=-2 No such entry
[43176.789418] BTRFS: error (device sde) in btrfs_run_delayed_refs:2960: 
errno=-2 No such entry
[43176.823989] pending csums is 4096

Am 09.09.2016 um 22:21 schrieb Liu Bo:
> On Fri, Sep 09, 2016 at 02:41:45PM +0200, Jan Koester wrote:
>>
>>
>>
>> Hi,
>>
>> i got from btrfs scrub command segfault. I use btrfs tools 4.7.2.
>>
>> root@dibsi:/home/jan# btrfs scrub status /local
>> Speicherzugriffsfehler
>> root@dibsi:/home/jan# dmesg
>> [78294.556713] BTRFS error (device sda): bad tree block start 18427384836265136347 2304683610112
>> [78294.556956] BTRFS error (device sda): bad tree block start 17385487456874290426 2304683610112
>> [78294.558323] BTRFS error (device sda): bad tree block start 17385487456874290426 2304683610112
>> [78294.558397] ------------[ cut here ]------------
>> [78294.569900] kernel BUG at fs/btrfs/ctree.c:5202!
>> [78294.581634] invalid opcode: 0000 [#15] SMP
>> [78294.593089] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs libcrc32c binfmt_misc btrfs xor raid6_pq kvm_amd kvm irqbypass serio_raw snd_usb_audio input_leds joydev snd_usbmidi_lib snd_hda_codec_hdmi edac_mce_amd snd_hda_intel edac_core snd_hda_codec k10temp snd_ctxfi snd_hda_core snd_hwdep snd_pcm i2c_piix4 snd_seq_midi snd_seq_midi_event snd_rawmidi snd_seq snd_seq_device snd_timer snd soundcore tpm_infineon mac_hid 8250_fintek shpchp sunrpc parport_pc ppdev lp parport autofs4 hid_generic usbhid hid amdkfd amd_iommu_v2 radeon i2c_algo_bit ttm drm_kms_helper e1000e syscopyarea sysfillrect sysimgblt ptp fb_sys_fops r8169 drm mii ahci pps_core libahci wmi fjes
>> [78294.629504] CPU: 3 PID: 16486 Comm: btrfs Tainted: G      D W       4.6.0-rc4 #1
>> [78294.629506] Hardware name: Gigabyte Technology Co., Ltd. GA-970A-D3/GA-970A-D3, BIOS F12 09/03/2013
>> [78294.629510] task: ffff880070766800 ti: ffff8801c2d30000 task.ti: ffff8801c2d30000
>> [78294.629568] RIP: 0010:[<ffffffffc088f54d>]  [<ffffffffc088f54d>] btrfs_search_forward+0x24d/0x330 [btrfs]
>> [78294.629572] RSP: 0018:ffff8801c2d33c10  EFLAGS: 00010246
>> [78294.629581] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
>> [78294.629583] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff880080638d40
>> [78294.629585] RBP: ffff8801c2d33c70 R08: 0000021899d90000 R09: 000002189fd90000
>> [78294.629587] R10: 0000000000000000 R11: 0000000000000003 R12: ffff88008826e8c0
>> [78294.629589] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000000
>> [78294.629593] FS:  00007ff69486f8c0(0000) GS:ffff88022fcc0000(0000) knlGS:00000000e71e3b40
>> [78294.629595] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [78294.629598] CR2: 0000000001a94088 CR3: 0000000221fe6000 CR4: 00000000000006e0
>> [78294.629599] Stack:
>> [78294.629605]  00000000024280ca ffff8801c2d33cbf ffff880223bfa800 01ffffff00000000
>> [78294.629609]  d800000000000000 0000000000000001 00000000db9fb905 ffff88008826e8c0
>> [78294.629613]  ffff8801c2d33d18 ffff8802008ee000 ffff8801c2d33cbf ffff8801f91e6800
>> [78294.629614] Call Trace:
>> [78294.629669]  [<ffffffffc08e9ed2>] search_ioctl+0xf2/0x1a0 [btrfs]
>> [78294.629720]  [<ffffffffc08e9ff2>] btrfs_ioctl_tree_search+0x72/0xc0 [btrfs]
>> [78294.629769]  [<ffffffffc08ee6e4>] btrfs_ioctl+0x3e4/0x21a0 [btrfs]
>> [78294.629777]  [<ffffffff811c9cbf>] ? handle_mm_fault+0x14cf/0x1e60
>> [78294.629782]  [<ffffffff81223213>] ? cp_new_stat+0x153/0x180
>> [78294.629789]  [<ffffffff81231cc1>] do_vfs_ioctl+0xa1/0x5b0
>> [78294.629794]  [<ffffffff8106b5c5>] ? __do_page_fault+0x205/0x4d0
>> [78294.629800]  [<ffffffff81232249>] SyS_ioctl+0x79/0x90
>> [78294.629806]  [<ffffffff818360f6>] entry_SYSCALL_64_fastpath+0x1e/0xa8
>> [78294.629847] Code: 8b 4d a0 48 8b 55 a8 4d 89 f8 48 8b 7d b0 4c 89 e6 e8 68 fb ff ff 85 c0 0f 85 bf 00 00 00 4c 89 e7 e8 88 7f ff ff e9 fa fd ff ff <0f> 0b 48 8d 04 92 43 89 54 ac 40 48 8d 75 bf b9 11 00 00 00 48
>> [78294.629885] RIP  [<ffffffffc088f54d>] btrfs_search_forward+0x24d/0x330 [btrfs]
>> [78294.629887]  RSP <ffff8801c2d33c10>
>> [78294.629969] ---[ end trace fa1ffcf4f496deaf ]---
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> We have a commit[1] in 4.8 which has cleaned up this BUG_ON().
>
> But it'll only help us to return gracefully, for the invalid metadata,
> try btrfsck instead.
>
> [1]:
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=fb770ae414d018255afa7a70b14ba1f8620762dd
>
>
> Thanks,
>
> -liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
