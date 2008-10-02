From: Zheng Yan <zheng.yan@oracle.com>
Subject: Re: Kernel crashes when mounting btrfs filesystem when using latest
 git btrfs trunk.
Date: Fri, 03 Oct 2008 03:31:34 +0800
Message-ID: <48E52196.9010209@oracle.com>
References: <20081002141204.1516d767@parity.biterror.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Harley Peters <harley@thepetersclan.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081002141204.1516d767@parity.biterror.net>
List-ID: <linux-btrfs.vger.kernel.org>

Harley Peters wrote:
> When using the latest git trunk if I try and mount a brfs filesystem
> the kernel crashes with the following error.
> Is this a known problem are just me ?
> 
> 
> Oct  2 12:43:07 parity ------------[ cut here ]------------
> Oct  2 12:43:07 parity kernel BUG at fs/btrfs/disk-io.c:837!
> Oct  2 12:43:07 parity invalid opcode: 0000 [1] SMP
> Oct  2 12:43:07 parity CPU 1
> Oct  2 12:43:07 parity Modules linked in: btrfs compcache tlsf
> lzo1x_decompress lzo1x_compress w83627ehf hwmon_vid snd_seq_midi
> snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul
> snd_pcm_oss snd_mixer_oss snd_seq_oss snd_seq_midi_event snd_seq
> nvidia(P) snd_emu10k1 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm
> snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep k8temp
> Oct  2 12:43:07 parity Pid: 3523, comm: mount Tainted: P
> 2.6.27-rc7 #1 Oct  2 12:43:07 parity RIP: 0010:[<ffffffffa0850f88>]
> [<ffffffffa0850f88>] find_and_setup_root+0x98/0xb0 [btrfs] Oct  2
> 12:43:07 parity RSP: 0018:ffff88007b2c9b78  EFLAGS: 00010202 Oct  2
> 12:43:07 parity RAX: 0000000000000001 RBX: ffff88007e9ef000 RCX:
> ffffffffa084c105 Oct  2 12:43:07 parity RDX: 0000000000000000 RSI:
> ffffe20001b68760 RDI: ffff880001020800 Oct  2 12:43:07 parity RBP:
> ffff88007caa8c00 R08: ffff88007b2c99a8 R09: 0000000000000000 Oct  2
> 12:43:07 parity R10: 0000000000000007 R11: 0000000000000001 R12:
> fffffffffffffff7 Oct  2 12:43:07 parity R13: ffff88007d02a000 R14:
> ffff88007b2c9c28 R15: ffff88007d02b590 Oct  2 12:43:07 parity FS:
> 00007f52aedcf740(0000) GS:ffff88007f809580(0000) knlGS:0000000000000000
> Oct  2 12:43:07 parity CS:  0010 DS: 0000 ES: 0000 CR0:
> 000000008005003b Oct  2 12:43:07 parity CR2: 00007f52ae744520 CR3:
> 000000007d0b9000 CR4: 00000000000006e0 Oct  2 12:43:07 parity DR0:
> 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 Oct  2
> 12:43:07 parity DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400 Oct  2 12:43:07 parity Process mount (pid: 3523,
> threadinfo ffff88007b2c8000, task ffff88007eeed700) Oct  2 12:43:07
> parity Stack:  fffffffffffffff7 fffffffffffffff4 fffffffffffffff4
> ffff88007e9ef000 Oct  2 12:43:07 parity ffff88007caa8c00
> ffffffffa08515c1 000000007b2c9be8 ffffffff8022ee5c Oct  2 12:43:07
> parity 0000000000000082 ffff88007cbaf7a0 0000000000000000
> ffff88007d02a000 Oct  2 12:43:07 parity Call Trace: Oct  2 12:43:07
> parity [<ffffffffa08515c1>] ? btrfs_read_fs_root_no_radix+0xf1/0x220
> [btrfs] Oct  2 12:43:07 parity [<ffffffff8022ee5c>] ?
> hrtick_start_fair+0xec/0x1c0 Oct  2 12:43:07 parity
> [<ffffffffa085179c>] ? btrfs_read_fs_root_no_name+0xac/0x110 [btrfs]
> Oct  2 12:43:07 parity [<ffffffffa08426d3>] ?
> btrfs_cleanup_reloc_trees+0xa3/0xe0 [btrfs] Oct  2 12:43:07 parity
> [<ffffffffa0852754>] ? open_ctree+0xc14/0xd40 [btrfs] Oct  2 12:43:07
> parity [<ffffffffa0837441>] ? btrfs_get_sb+0x3b1/0x4e0 [btrfs] Oct  2
> 12:43:07 parity [<ffffffff802706e4>] ? kstrdup+0x54/0x70 Oct  2
> 12:43:07 parity [<ffffffff8028fb96>] ? vfs_kern_mount+0x56/0xd0 Oct  2
> 12:43:07 parity [<ffffffff8028fc73>] ? do_kern_mount+0x53/0x120 Oct  2
> 12:43:07 parity [<ffffffff802a9b80>] ? do_new_mount+0xa0/0xe0 Oct  2
> 12:43:07 parity [<ffffffff802aa1ee>] ? do_mount+0x1ee/0x220 Oct  2
> 12:43:07 parity [<ffffffff802695ee>] ? __get_free_pages+0x1e/0x60 Oct
> 2 12:43:07 parity [<ffffffff802aa2ed>] ? sys_mount+0xcd/0x100 Oct  2
> 12:43:07 parity [<ffffffff8020bafb>] ? system_call_fastpath+0x16/0x1b
> Oct  2 12:43:07 parity Oct  2 12:43:07 parity Oct  2 12:43:07 parity
> Code: 48 89 ef e8 fb fe ff ff 48 85 c0 48 89 45 00 74 22 48 83 c4 10 31
> c0 5b 5d 41 5c c3 0f 1f 80 00 00 00 00 8b 95 fc 01 00 00 eb cc <0f> 0b
> eb fe 0f 1f 40 00 0f 0b eb fe 66 66 66 2e 0f 1f 84 00 00 Oct  2
> 12:43:07 parity RIP  [<ffffffffa0850f88>] find_and_setup_root+0x98/0xb0
> [btrfs] Oct  2 12:43:07 parity RSP <ffff88007b2c9b78> Oct  2 12:43:07
> parity ---[ end trace 22a2031b2085e8be ]---
> --

Please pull btrfs-progs from the latest git.

Thanks
Yan Zheng
