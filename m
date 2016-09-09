Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47289 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752462AbcIIIcj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Sep 2016 04:32:39 -0400
To: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: bug report about patch "Btrfs: kill the btree_inode"
Message-ID: <57D272A5.5050201@cn.fujitsu.com>
Date: Fri, 9 Sep 2016 16:28:21 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

When we rebase dedupe patches to David's for-next-20160906 branch,
we found below panic. By bisect, it seems that "Btrfs: kill the btree_inode"
causing this bug, please check.
Fstests case btrfs/060 can easily reproduce this bug.

localhost login: [   43.694734] BUG: unable to handle kernel NULL 
pointer dereference at 0000000000000070
[   43.695812] IP: [<ffffffff811c2911>] list_lru_destroy+0x11/0xe0
[   43.696526] PGD 0
[   43.696765] Oops: 0000 [#1] SMP
[   43.697105] Modules linked in: uinput fuse ip6t_rpfilter ip6t_REJECT 
nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_nat 
ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat 
nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle 
ip6table_security ip6table_raw ip6table_filter ip6_tables iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
iptable_mangle iptable_security iptable_raw iptable_filter dm_mirror 
dm_region_hash dm_log dm_mod snd_hda_codec_generic crct10dif_pclmul 
crc32_pclmul ext4 snd_hda_intel ppdev snd_hda_codec jbd2 btrfs 
ghash_clmulni_intel mbcache snd_hwdep snd_hda_core snd_seq xor 
snd_seq_device aesni_intel glue_helper lrw raid6_pq snd_pcm gf128mul 
ablk_helper cryptd parport_pc snd_timer pcspkr virtio_balloon snd 
parport soundcore sg i2c_piix4 nfsd auth_rpcgss nfs_acl lockd grace 
sunrpc ip_tables xfs libcrc32c sr_mod cdrom sd_mod ata_generic pata_acpi 
qxl virtio_console drm_kms_helper 8139too syscopyarea sysfillrect ahci 
sysimgblt fb_sys_fops ttm libahci ata_piix drm libata crc32c_intel 
serio_raw virtio_pci i2c_core virtio_ring virtio 8139cp mii floppy
[   43.709009] CPU: 0 PID: 8267 Comm: mount Not tainted 4.8.0-rc5+ #50
[   43.709680] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 1.8.2-20150714_191134- 04/01/2014
[   43.710691] task: ffff880074e3ab80 task.stack: ffff88006c1e8000
[   43.711322] RIP: 0010:[<ffffffff811c2911>] [<ffffffff811c2911>] 
list_lru_destroy+0x11/0xe0
[   43.712227] RSP: 0018:ffff88006c1ebb88  EFLAGS: 00010246
[   43.712796] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
dead000000000200
[   43.713552] RDX: ffffffff81c78d78 RSI: ffff880074e3ab80 RDI: 
0000000000000070
[   43.714314] RBP: ffff88006c1ebba0 R08: ffff88006c1ebb00 R09: 
ffff88003337e000
[   43.715074] R10: 0000000000000000 R11: 0000000a282f3176 R12: 
0000000000000070
[   43.715948] R13: ffff8800738b6000 R14: ffff88007b028680 R15: 
ffff8800769b0a80
[   43.716709] FS:  00007fd734456880(0000) GS:ffff88007de00000(0000) 
knlGS:0000000000000000
[   43.717570] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   43.718187] CR2: 0000000000000070 CR3: 0000000077b8d000 CR4: 
00000000000406f0
[   43.718954] Stack:
[   43.719177]  0000000000000000 ffffffffa05f31a0 ffff8800738b6000 
ffff88006c1ebc80
[   43.720018]  ffffffffa052a1fe ffffc90000abea50 0000000800000294 
000000017b403b01
[   43.720862]  ffff88006c1ebbd8 ffffffff813640ae ffff88006c1ebc08 
ffffffff811b8b4e
[   43.721675] Call Trace:
[   43.721968]  [<ffffffffa052a1fe>] btrfs_mount+0xb6e/0xfc0 [btrfs]
[   43.722676]  [<ffffffff813640ae>] ? find_next_zero_bit+0x1e/0x20
[   43.723321]  [<ffffffff811b8b4e>] ? pcpu_next_unpop+0x3e/0x50
[   43.723938]  [<ffffffff81364089>] ? find_next_bit+0x19/0x20
[   43.724537]  [<ffffffff81223e09>] mount_fs+0x39/0x160
[   43.725085]  [<ffffffff811ba005>] ? __alloc_percpu+0x15/0x20
[   43.725696]  [<ffffffff81240a57>] vfs_kern_mount+0x67/0x100
[   43.726332]  [<ffffffffa052982d>] btrfs_mount+0x19d/0xfc0 [btrfs]
[   43.726992]  [<ffffffff813640ae>] ? find_next_zero_bit+0x1e/0x20
[   43.727646]  [<ffffffff81223e09>] mount_fs+0x39/0x160
[   43.728192]  [<ffffffff811ba005>] ? __alloc_percpu+0x15/0x20
[   43.728881]  [<ffffffff81240a57>] vfs_kern_mount+0x67/0x100
[   43.729480]  [<ffffffff81242f62>] do_mount+0x1e2/0xca0
[   43.730036]  [<ffffffff811f7aab>] ? kmem_cache_alloc_trace+0x14b/0x1b0
[   43.730742]  [<ffffffff81243d33>] SyS_mount+0x83/0xd0
[   43.731290]  [<ffffffff81003a47>] do_syscall_64+0x67/0x160
[   43.731888]  [<ffffffff816cbe61>] entry_SYSCALL64_slow_path+0x25/0x25
[   43.732575] Code: 4d 8b 26 4c 89 e7 e8 9f 64 03 00 5b 41 5c 41 5d 41 
5e 5d c3 66 0f 1f 44 00 00 66 66 66 66 90 55 48 89 e5 41 55 41 54 49 89 
fc 53 <48> 83 3f 00 0f 84 b2 00 00 00 e8 50 9a 04 00 48 c7 c7 20 34 c9
[   43.735379] RIP  [<ffffffff811c2911>] list_lru_destroy+0x11/0xe0
[   43.736043]  RSP <ffff88006c1ebb88>
[   43.736421] CR2: 0000000000000070
[   43.737102] ---[ end trace 7f226c7f270332f0 ]---
[   43.737837] Kernel panic - not syncing: Fatal exception
[   43.738430] Kernel Offset: disabled
[   43.738735] ---[ end Kernel panic - not syncing: Fatal exception

Regards,
Xiaoguang Wang


