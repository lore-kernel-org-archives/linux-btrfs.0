From: Arne Jansen <sensille@gmx.net>
Subject: Re: [RFC] Subvolume Quota on-disk structures and configuration
Date: Thu, 01 Dec 2011 10:15:48 +0100
Message-ID: <4ED745C4.8000505@gmx.net>
References: <4E19611D.2090007@gmx.net> <4ED067A8.1010208@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED067A8.1010208@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 26.11.2011 05:14, Phillip Susi wrote:
> On 07/10/2011 04:21 AM, Arne Jansen wrote:
>> Now that I've got a working prototype of subvolume quota, I'd like
>> to get some feedback on the on-disk structure and the commands I
>> intend to use.
> 
> I think I've noticed a bug so far, and have one comment on the qgroup show command.  The command seems to show the current usage of the qgroup, but I can't see how to view the limits ( if any ).  It seems like the show command should show both.

It seems there's no command to show the limits, I'll add it to
qgroup show. Also it should be reflected in df.

> 
> The bug I seem to have noticed is that rm fails with EQUOTA.  I set a 1g limit on a new subvol, and ran dd if=/dev/zero of=/mnt/foo, which created a file approx 1g in size before erroring out with EQUOTA.  After that, I did an echo bar /mnt/bar, and to my surprise, this did not fail with EQUOTA.  Now when I try to rm /mnt/bar or /mnt/foo, THAT fails with EQUOTA.  I also got this in dmesg:

here we go :) Every quota implementation on a cow filesystem have
to have this problem in the beginning :) I thought I had taken
care of that, but maybe I'm missing a path there. I'll have a
look.

-Arne

> 
> [  992.078275] WARNING: at fs/btrfs/inode.c:6670 btrfs_destroy_inode+0x31d/0x360 [btrfs]()
> [  992.078276] Hardware name: System Product Name
> [  992.078277] Modules linked in: nls_utf8 isofs bnep rfcomm kvm_intel kvm parport_pc ppdev dm_crypt binfmt_misc nls_iso8859_1 nls_cp437 vfat fat snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event joydev snd_seq psmouse eeepc_wmi asus_wmi snd_timer snd_seq_device btusb bluetooth serio_raw snd sparse_keymap soundcore mei(C) snd_page_alloc w83627ehf hwmon_vid coretemp lp parport raid10 raid456 async_pq async_xor async_memcpy async_raid6_recov raid6_pq async_tx raid1 raid0 multipath linear dm_raid45 xor dm_mirror dm_region_hash dm_log btrfs zlib_deflate libcrc32c hid_microsoft usbhid hid mxm_wmi wmi radeon ahci libahci ttm drm_kms_helper e1000e xhci_hcd drm i2c_algo_bit zram(C)
> [  992.078305] Pid: 2342, comm: rm Tainted: G         C   3.2.0-rc2+ #7
> [  992.078306] Call Trace:
> [  992.078311]  [<ffffffff81062acf>] warn_slowpath_common+0x7f/0xc0
> [  992.078313]  [<ffffffff81062b2a>] warn_slowpath_null+0x1a/0x20
> [  992.078320]  [<ffffffffa020de9d>] btrfs_destroy_inode+0x31d/0x360 [btrfs]
> [  992.078324]  [<ffffffff811895cc>] destroy_inode+0x3c/0x70
> [  992.078326]  [<ffffffff8118972a>] evict+0x12a/0x1c0
> [  992.078328]  [<ffffffff811898c9>] iput+0x109/0x220
> [  992.078331]  [<ffffffff8117e7b3>] do_unlinkat+0x153/0x1d0
> [  992.078333]  [<ffffffff811740ea>] ? sys_newfstatat+0x2a/0x40
> [  992.078334]  [<ffffffff8117f352>] sys_unlinkat+0x22/0x40
> [  992.078337]  [<ffffffff8160d0c2>] system_call_fastpath+0x16/0x1b
> [  992.078338] ---[ end trace 770bc93001697fbc ]---
> 
