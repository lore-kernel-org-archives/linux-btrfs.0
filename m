Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:33075 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbbIKJts convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 05:49:48 -0400
Received: by igbkq10 with SMTP id kq10so40814513igb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2015 02:49:47 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <trinity-b317212e-1398-43c1-812b-f080647cfc40-1441964392845@3capp-gmx-bs05>
References: <trinity-b317212e-1398-43c1-812b-f080647cfc40-1441964392845@3capp-gmx-bs05>
Date: Fri, 11 Sep 2015 10:49:47 +0100
Message-ID: <CAL3q7H5sssGb5XRm5UFnoNuRdNogEi92Bi6T3fVGZposUiAGLA@mail.gmail.com>
Subject: Re: btrfs corruption / bug after sending and receiving and repair
From: Filipe David Manana <fdmanana@gmail.com>
To: Jonas von Malottki <yoshtec@gmx.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 11, 2015 at 10:39 AM, Jonas von Malottki <yoshtec@gmx.net> wrote:
> Hi Btrfslers,
>
> I was playing around with send and receive facility to store backups at a remote machine. Unfortunately I send more data to a device that it could handle. So the receive operation was ended with "could not write file, no more space left on device". So far so good, no big deal. To my surprise the snapshot was transferred but was incomplete (you could actually cd into the snap and view files, but some were missing). Naturally I didn't trust the snapshot so I deleted it via btrfs sub del. As I needed more space I deleted also all other subvolumes. So the device was emtpy, a btrfs subvol list -a /mntpoint showed nothing, but there was still around 500gb on the btrfs volume (btrfs fil df), so I dismounted the dev and started a btrfs check --repair /dev/sdb2 (output below) followed by mounting it via subvolid  "mount -t btrfs -o subvolid=0 /dev/sdb2 /mnt/btrfs2". But it showed that there were still 27% of the device in use (2TB device) with supposedly nothing on it. So I tried to dismount it to reformat the device, but the umount just hang and a quick look into dmesg (below) showed that something was freaked up.
>
> No real damage done, just wanted you to know maybe you can fix a bug. I can leave the device for a few days if you would like to have special information. But i'll have to reboot at least.
>
> Thanks for all cool btrfs features though :).
>
> Best regards
> Jonas
>
>
>
> Output requested (but defunct after the whole stuff happened):
>
> vid@tauon:~$   uname -a
> Linux tauon 3.19.0-28-generic #30-Ubuntu SMP Mon Aug 31 15:52:51 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> vid@tauon:~$ btrfs --version
> Btrfs v3.17
> vid@tauon:~$  btrfs fi show
> ERROR: unable to access '/mnt/btrfs1'
> ERROR: could not open /dev/sdb2
> ERROR: could not open /dev/sdc1
> Btrfs v3.17
>
>
> Output from Repair:
>
> vid@tauon:/mnt$ sudo btrfs check --repair  /dev/sdb2
> enabling repair mode
> Fixed 0 roots.
> Checking filesystem on /dev/sdb2
> UUID: 1af082d6-10f5-45b6-8373-c67b5c595ed6
> checking extents
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> checking csums
> checking root refs
> found 256752151257 bytes used err is 0
> total csum bytes: 512030428
> total tree bytes: 557645824
> total fs tree bytes: 5079040
> total extent tree bytes: 4685824
> btree space waste bytes: 31440848
> file data blocks allocated: 524450885632
>  referenced 524450885632
> Btrfs v3.17
>
>
>
>
> Output from Dmesg
>
>
> [84963.514765] btrfs[6456]: segfault at 0 ip 00007fcba71e36b4 sp 00007ffe01ba8c40 error 4 in libc-2.21.so[7fcba71a8000+1c0000]
> [86002.789758] BTRFS info (device sdb2): disk space caching is enabled
> [86003.549464] BTRFS: checking UUID tree
> [86077.520375] ------------[ cut here ]------------
> [86077.520381] kernel BUG at /build/linux-5xFjum/linux-3.19.0/fs/btrfs/inode.c:3142!
> [86077.520383] invalid opcode: 0000 [#1] SMP
> [86077.520386] Modules linked in: cfg80211 snd_hda_codec_hdmi gpio_ich kvm_intel kvm snd_emu10k1_synth snd_emux_synth snd_seq_midi_emul snd_seq_virmidi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_emu10k1 snd_hda_controller snd_hda_codec snd_util_mem serio_raw snd_hwdep snd_ac97_codec ac97_bus snd_seq_midi snd_seq_midi_event joydev snd_rawmidi nvidia(POE) lpc_ich snd_pcm snd_seq emu10k1_gp snd_seq_device gameport snd_timer snd drm soundcore x38_edac 8250_fintek edac_core shpchp mac_hid it87 hwmon_vid coretemp parport_pc ppdev lp parport autofs4 pata_acpi btrfs xor raid6_pq hid_generic usbhid hid firewire_ohci firewire_core crc_itu_t r8169 mii ahci pata_jmicron libahci
> [86077.520421] CPU: 1 PID: 6519 Comm: btrfs-cleaner Tainted: P           OE  3.19.0-28-generic #30-Ubuntu
> [86077.520422] Hardware name: Gigabyte Technology Co., Ltd. X38-DQ6/X38-DQ6, BIOS F9F 07/30/2008
> [86077.520425] task: ffff88020ed68000 ti: ffff88020ee90000 task.ti: ffff88020ee90000
> [86077.520426] RIP: 0010:[<ffffffffc03caa00>]  [<ffffffffc03caa00>] btrfs_orphan_add+0x1c0/0x1e0 [btrfs]
> [86077.520447] RSP: 0018:ffff88020ee93c38  EFLAGS: 00010286
> [86077.520449] RAX: 00000000ffffffe4 RBX: ffff880002004800 RCX: ffff880104cfa000
> [86077.520450] RDX: 000000000000510e RSI: 0000000000040000 RDI: ffff880104cfa138
> [86077.520452] RBP: ffff88020ee93c78 R08: 000000000001db10 R09: ffff880210fcf090
> [86077.520453] R10: ffff88022fc9db50 R11: ffffea0008744840 R12: ffff880105660578
> [86077.520455] R13: ffff8802226ef630 R14: ffff880002004c58 R15: 0000000000000001
> [86077.520456] FS:  0000000000000000(0000) GS:ffff88022fc80000(0000) knlGS:0000000000000000
> [86077.520458] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [86077.520460] CR2: 00007f8167699148 CR3: 0000000001c13000 CR4: 00000000000007e0
> [86077.520461] Stack:
> [86077.520462]  ffff88020ee93c78 ffffffffc0408ca5 ffff880104cfa000 ffff880002001800
> [86077.520465]  ffff880210fcf090 ffff880105660578 ffff880223b7ec00 ffff8801b8337d80
> [86077.520468]  ffff88020ee93d08 ffffffffc03b42da ffff880210fcf098 ffff880210fcf110
> [86077.520470] Call Trace:
> [86077.520487]  [<ffffffffc0408ca5>] ? lookup_free_space_inode+0x45/0xf0 [btrfs]
> [86077.520498]  [<ffffffffc03b42da>] btrfs_remove_block_group+0x13a/0x760 [btrfs]
> [86077.520513]  [<ffffffffc03edeea>] btrfs_remove_chunk+0x63a/0x760 [btrfs]
> [86077.520524]  [<ffffffffc03b4b49>] btrfs_delete_unused_bgs+0x249/0x270 [btrfs]
> [86077.520536]  [<ffffffffc03bd144>] cleaner_kthread+0x144/0x1a0 [btrfs]
> [86077.520547]  [<ffffffffc03bd000>] ? check_leaf+0x360/0x360 [btrfs]
> [86077.520552]  [<ffffffff81095939>] kthread+0xc9/0xe0
> [86077.520555]  [<ffffffff81095870>] ? kthread_create_on_node+0x1c0/0x1c0
> [86077.520558]  [<ffffffff817cb618>] ret_from_fork+0x58/0x90
> [86077.520560]  [<ffffffff81095870>] ? kthread_create_on_node+0x1c0/0x1c0
> [86077.520562] Code: 60 04 00 00 e9 b0 fe ff ff 66 90 89 45 c8 f0 41 80 64 24 80 fd 4c 89 e7 e8 1e 21 fe ff 8b 45 c8 e9 1b ff ff ff 66 0f 1f 44 00 00 <0f> 0b b8 f4 ff ff ff e9 10 ff ff ff 4c 89 f7 45 31 f6 e8 69 07
> [86077.520587] RIP  [<ffffffffc03caa00>] btrfs_orphan_add+0x1c0/0x1e0 [btrfs]
> [86077.520600]  RSP <ffff88020ee93c38>
> [86077.520602] ---[ end trace 24353018afe32b08 ]---

It isn't a corruption, just a failure to reserve space necessary for
block group deletion (triggering a BUG_ON / hang). This got fixed in
kernel 4.0:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=3d84be799194147e04c0e3129ed44a948773b80a

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
