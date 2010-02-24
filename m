From: Boyd Waters <waters.boyd@gmail.com>
Subject: Re: No space left on device, btrfsctl segmentation fault
Date: Tue, 23 Feb 2010 23:27:49 -0500
Message-ID: <2b0225fb1002232027p65709d99nbd0d8d6bab45ae98@mail.gmail.com>
References: <2b0225fb1002231939q2020bf05g145f852e5b4c560@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2b0225fb1002231939q2020bf05g145f852e5b4c560@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I believe there is a kerneloops associated with this problem:

ProblemType: KernelOops
Annotation: Your system might become unstable now and might need to be
restarted.
Date: Tue Feb 23 22:40:53 2010
Failure: oops
OopsText:
 ------------[ cut here ]------------
 WARNING: at /build/buildd/linux-2.6.32/fs/btrfs/extent_io.c:3210
free_extent_buffer+0x31/0x40 [btrfs]()
 Hardware name: To Be Filled By O.E.M.
 Modules linked in: nfs btrfs zlib_deflate crc32c libcrc32c
binfmt_misc ppdev vboxnetflt vboxnetadp vboxdrv nfsd lockd nfs_acl
auth_rpcgss sunrpc exportfs snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm fbcon
tileblit font bitblit snd_seq_dummy softcursor lp nvidia(P) vga16fb
vgastate snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
parport snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc
psmouse serio_raw ohci1394 ieee1394 usbhid r8169 mii
 Pid: 4317, comm: ls Tainted: P      D W  2.6.32-14-generic #20-Ubuntu
 Call Trace:
  [<ffffffff81064f7b>] warn_slowpath_common+0x7b/0xc0
  [<ffffffff81064fd4>] warn_slowpath_null+0x14/0x20
  [<ffffffffa0eae441>] free_extent_buffer+0x31/0x40 [btrfs]
  [<ffffffffa0e741bd>] btrfs_release_path+0x1d/0x70 [btrfs]
  [<ffffffffa0e7459b>] btrfs_free_path+0x1b/0x40 [btrfs]
  [<ffffffffa0e9ac94>] btrfs_real_readdir+0x234/0x4f0 [btrfs]
  [<ffffffff81150c10>] ? filldir+0x0/0xe0
  [<ffffffffa0e992e4>] ? btrfs_dirty_inode+0x54/0x70 [btrfs]
  [<ffffffff8155ea1e>] ? _spin_lock+0xe/0x20
  [<ffffffff81156ead>] ? touch_atime+0x13d/0x180
  [<ffffffff81150c10>] ? filldir+0x0/0xe0
  [<ffffffff81150e90>] vfs_readdir+0xc0/0xe0
  [<ffffffff81151019>] sys_getdents+0x89/0xf0
  [<ffffffff8155eee5>] ? page_fault+0x25/0x30
  [<ffffffff810131f2>] system_call_fastpath+0x16/0x1b
 ---[ end trace 0fdd336562453361 ]---

Package: linux-image-2.6.32-14-generic
SourcePackage: linux
Tags: kernel-oops
