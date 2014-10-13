Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:34579 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbaJMPPl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 11:15:41 -0400
Received: by mail-vc0-f177.google.com with SMTP id hq11so5883651vcb.22
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 08:15:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e4a8d9ba015981b895919256a2223950@admin.virtall.com>
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com>
Date: Mon, 13 Oct 2014 11:15:40 -0400
Message-ID: <CAGfcS_m+kZXFr=_vHVdzamptjWZQoOr0Bp9vikqt9fEdpG3yXg@mail.gmail.com>
Subject: Re: 3.17.0-rc7: kernel BUG at fs/btrfs/relocation.c:931!
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 2, 2014 at 3:27 AM, Tomasz Chmielewski <tch@virtall.com> wrote:
> Got this when running balance with 3.17.0-rc7:
>
> [173475.410717] kernel BUG at fs/btrfs/relocation.c:931!

I just started a post on another thread with this exact same issue on
3.17.0. I started a balance after adding a new drive.

[453046.291762] BTRFS info (device sde2): relocating block group
10367073779712 flags 17
[453062.494151] BTRFS info (device sde2): found 13 extents
[453069.283368] ------------[ cut here ]------------
[453069.283468] kernel BUG at
/data/src/linux-3.17.0-gentoo/fs/btrfs/relocation.c:931!
[453069.283590] invalid opcode: 0000 [#1] SMP
[453069.283666] Modules linked in: vhost_net vhost macvtap macvlan tun
ipt_MASQUERADE xt_conntrack veth nfsd auth_rpcgss oid_registry lockd
iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables it87
hwmon_vid hid_logitech_dj nxt200x cx88_dvb videobuf_dvb dvb_core
cx88_vp3054_i2c tuner_simple tuner_types tuner mousedev hid_generic
usbhid cx88_alsa radeon cx8800 cx8802 cx88xx snd_hda_codec_realtek
btcx_risc snd_hda_codec_generic videobuf_dma_sg videobuf_core kvm_amd
tveeprom kvm rc_core v4l2_common cfbfillrect fbcon videodev cfbimgblt
snd_hda_intel bitblit snd_hda_controller cfbcopyarea softcursor font
tileblit i2c_algo_bit k10temp snd_hda_codec backlight drm_kms_helper
snd_hwdep i2c_piix4 ttm snd_pcm snd_timer drm snd soundcore 8250 evdev
[453069.285043]  serial_core ext4 crc16 jbd2 mbcache zram lz4_compress
zsmalloc ata_generic pata_acpi btrfs xor zlib_deflate atkbd raid6_pq
ohci_pci firewire_ohci firewire_core crc_itu_t pata_atiixp ehci_pci
ohci_hcd ehci_hcd usbcore usb_common r8169 mii sunrpc dm_mirror
dm_region_hash dm_log dm_mod
[453069.285552] CPU: 1 PID: 17270 Comm: btrfs Not tainted 3.17.0-gentoo #1
[453069.285657] Hardware name: Gigabyte Technology Co., Ltd.
GA-880GM-UD2H/GA-880GM-UD2H, BIOS F8 10/11/2010
[453069.285806] task: ffff88040ec556e0 ti: ffff88010cf94000 task.ti:
ffff88010cf94000
[453069.285925] RIP: 0010:[<ffffffffa02ddd62>]  [<ffffffffa02ddd62>]
build_backref_tree+0x1152/0x11b0 [btrfs]
[453069.286137] RSP: 0018:ffff88010cf97848  EFLAGS: 00010206
[453069.286223] RAX: ffff8800ae67c800 RBX: ffff880122e94000 RCX:
ffff880122e949c0
[453069.286336] RDX: 000009270788d000 RSI: ffff880054c3fbc0 RDI:
ffff8800ae67c800
[453069.286449] RBP: ffff88010cf97958 R08: 00000000000159a0 R09:
ffff880122e94000
[453069.286561] R10: 0000000000000003 R11: 0000000000000000 R12:
ffff8802da313000
[453069.286674] R13: ffff8802da313c60 R14: ffff880122e94780 R15:
ffff88040c277000
[453069.286787] FS:  00007f175ac51880(0000) GS:ffff880427c40000(0000)
knlGS:00000000f7333b40
[453069.286913] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[453069.287005] CR2: 00007f208de58000 CR3: 00000003b0a9c000 CR4:
00000000000007e0
[453069.287116] Stack:
[453069.287151]  ffff88010cf97868 ffff880122e94000 01ff880122e94300
ffff880342156060
[453069.287282]  ffff880122e94780 ffff8802da313c60 ffff880122e94600
ffff8800ae67c800
[453069.287412]  ffff880122e947c0 ffff8802da313000 ffff88040c277120
ffff880100000005
[453069.287542] Call Trace:
[453069.287640]  [<ffffffffa02ddfa3>] relocate_tree_blocks+0x1e3/0x630 [btrfs]
[453069.287796]  [<ffffffffa02e0550>] relocate_block_group+0x3d0/0x650 [btrfs]
[453069.287951]  [<ffffffffa02e0958>]
btrfs_relocate_block_group+0x188/0x2a0 [btrfs]
[453069.288113]  [<ffffffffa02b48f0>]
btrfs_relocate_chunk.isra.61+0x70/0x780 [btrfs]
[453069.288276]  [<ffffffffa02c7fd0>] ?
btrfs_set_lock_blocking_rw+0x70/0xc0 [btrfs]
[453069.288438]  [<ffffffffa02b0e79>] ? free_extent_buffer+0x59/0xb0 [btrfs]
[453069.288590]  [<ffffffffa02b8e99>] btrfs_balance+0x829/0xf40 [btrfs]
[453069.288738]  [<ffffffffa02bf80f>] btrfs_ioctl_balance+0x1af/0x510 [btrfs]
[453069.288890]  [<ffffffffa02c59e4>] btrfs_ioctl+0xa54/0x2950 [btrfs]
[453069.288995]  [<ffffffff8111d016>] ?
lru_cache_add_active_or_unevictable+0x26/0x90
[453069.289119]  [<ffffffff8113a061>] ? handle_mm_fault+0xbe1/0xdb0
[453069.289219]  [<ffffffff811ffdce>] ? cred_has_capability+0x5e/0x100
[453069.289323]  [<ffffffff8104065c>] ? __do_page_fault+0x1fc/0x4f0
[453069.289422]  [<ffffffff8117d80e>] do_vfs_ioctl+0x7e/0x4f0
[453069.289513]  [<ffffffff811ff64f>] ? file_has_perm+0x8f/0xa0
[453069.289606]  [<ffffffff8117dd09>] SyS_ioctl+0x89/0xa0
[453069.289692]  [<ffffffff81040a1c>] ? do_page_fault+0xc/0x10
[453069.289785]  [<ffffffff814f5752>] system_call_fastpath+0x16/0x1b
[453069.289881] Code: ff ff 48 8b 9d 20 ff ff ff e9 11 ff ff ff 0f 0b
be ec 03 00 00 48 c7 c7 d0 f0 30 a0 e8 28 00 d7 e0 e9 06 f3 ff ff e8
c4 42 02 00 <0f> 0b 3c b0 0f 84 72 f1 ff ff be 22 03 00 00 48 c7 c7 d0
f0 30
[453069.290429] RIP  [<ffffffffa02ddd62>]
build_backref_tree+0x1152/0x11b0 [btrfs]
[453069.290591]  RSP <ffff88010cf97848>
[453069.316194] ---[ end trace 5fdc0af4cc62bf41 ]---
