From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Oops on btrfs filesystem balance
Date: Fri, 26 Mar 2010 11:40:51 +0800
Message-ID: <3d0408631003252040r70c54b2fm24d64b819c59c9c@mail.gmail.com>
References: <cc557aab1003250606g6b4e3e7dgb1adfd46adc89124@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, kirill@shutemov.name
To: Wu Fengguang <fengguang.wu@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cc557aab1003250606g6b4e3e7dgb1adfd46adc89124@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 25, 2010 at 9:06 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> On lastest Linus' git.
>
> [ 4005.426805] BUG: unable to handle kernel NULL pointer dereference =
at 00000021
> [ 4005.426818] IP: [<c109a130>] page_cache_sync_readahead+0x18/0x3e
> [ 4005.426837] *pde =3D 00000000
> [ 4005.426844] Oops: 0000 [#1] PREEMPT SMP
> [ 4005.426854] last sysfs file:
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0C09:00/=
PNP0C0A:00/power_supply/BAT0/energy_full
> [ 4005.426864] Modules linked in: btrfs zlib_deflate crc32c libcrc32c
> loop coretemp ext2 arc4 ecb iwlagn iwlcore snd_hda_codec_conexant
> snd_hda_intel mac80211 snd_hda_codec snd_hwdep snd_pcm snd_timer snd
> uvcvideo e1000e rtc_cmos rtc_core cdc_ether videodev uhci_hcd usbnet
> sg snd_page_alloc video thinkpad_acpi cdc_acm rtc_lib v4l1_compat mii
> output ext3 jbd usbhid sd_mod sha256_generic cbc ata_piix ehci_hcd
> aes_i586 aes_generic libata dm_crypt usbcore scsi_mod nls_base dm_mod
> [ 4005.426971]
> [ 4005.426979] Pid: 25838, comm: btrfs Not tainted 2.6.34-rc2 #67
> 2767BC8/2767BC8
> [ 4005.426987] EIP: 0060:[<c109a130>] EFLAGS: 00010206 CPU: 0
> [ 4005.426996] EIP is at page_cache_sync_readahead+0x18/0x3e
> [ 4005.427002] EAX: f58dcb84 EBX: 00000000 ECX: 00000000 EDX: f45efe4=
0
> [ 4005.427009] ESI: 00033b43 EDI: f58dcad4 EBP: f4b61ce0 ESP: f4b61cd=
8
> [ 4005.427010] =A0DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [ 4005.427010] Process btrfs (pid: 25838, ti=3Df4b60000 task=3Df6680a=
60
> task.ti=3Df4b60000)
> [ 4005.427010] Stack:
> [ 4005.427010] =A041c00001 00000001 f4b61d50 f9443902 00000000 00033b=
43
> f93fc3dc f6bf4d80
> [ 4005.427010] <0> f4cc74d0 41c00001 00000001 f58dcb4c 00033b42
> f58dc9e0 f72e7600 f4b61d2c
> [ 4005.427010] <0> f45efe40 00000000 00000000 00033b43 41c00000
> 00000001 00000000 00000000
> [ 4005.427010] Call Trace:
> [ 4005.427010] =A0[<f9443902>] ? relocate_file_extent_cluster+0x195/0=
x3bd [btrfs]
> [ 4005.427010] =A0[<f93fc3dc>] ? btrfs_release_path+0x39/0x4a [btrfs]
> [ 4005.427010] =A0[<f9444bd2>] ? relocate_block_group+0x2be/0x32a [bt=
rfs]
> [ 4005.427010] =A0[<f9411dd3>] ? btrfs_clean_old_snapshots+0x66/0xd9 =
[btrfs]
> [ 4005.427010] =A0[<f9444d87>] ? btrfs_relocate_block_group+0x149/0x2=
e3 [btrfs]
> [ 4005.427010] =A0[<f942eecc>] ? btrfs_relocate_chunk+0x5c/0x423 [btr=
fs]
> [ 4005.427010] =A0[<c10217cc>] ? kmap_atomic+0x13/0x15
> [ 4005.427010] =A0[<f9428f32>] ? map_private_extent_buffer+0x94/0xb6 =
[btrfs]
> [ 4005.427010] =A0[<f9428fa3>] ? map_extent_buffer+0x4f/0x7f [btrfs]
> [ 4005.427010] =A0[<c10216d3>] ? kunmap_atomic+0x6c/0x83
> [ 4005.427010] =A0[<f9428aca>] ? unmap_extent_buffer+0x11/0x13 [btrfs=
]
> [ 4005.427010] =A0[<f94206dd>] ? btrfs_item_offset+0x98/0xa2 [btrfs]
> [ 4005.427010] =A0[<f942f856>] ? btrfs_balance+0x20f/0x265 [btrfs]
> [ 4005.427010] =A0[<f9436ab9>] ? btrfs_ioctl+0x6ad/0x824 [btrfs]
> [ 4005.427010] =A0[<c10bf8e1>] ? __memcg_event_check+0x50/0x72
> [ 4005.427010] =A0[<c11461e2>] ? file_has_perm+0x8c/0xa6
> [ 4005.427010] =A0[<c10cf310>] ? vfs_ioctl+0x2c/0x96
> [ 4005.427010] =A0[<f943640c>] ? btrfs_ioctl+0x0/0x824 [btrfs]
> [ 4005.427010] =A0[<c10cf8ac>] ? do_vfs_ioctl+0x48e/0x4cc
> [ 4005.427010] =A0[<c11463ca>] ? selinux_file_ioctl+0x43/0x46
> [ 4005.427010] =A0[<c10cf930>] ? sys_ioctl+0x46/0x66
> [ 4005.427010] =A0[<c132ae88>] ? syscall_call+0x7/0xb
> [ 4005.427010] Code: 8b 48 24 85 c9 74 04 31 d2 ff d1 8d 65 f4 5b 5e
> 5f c9 c3 55 89 e5 56 53 0f 1f 44 00 00 89 cb 8b 75 0c 8b 4d 08 83 7a
> 0c 00 74 1f <f6> 43 21 10 74 0b 89 da 56 e8 f5 fc ff ff 5b eb 0e 56 5=
1
> 89 d9
> [ 4005.427010] EIP: [<c109a130>] page_cache_sync_readahead+0x18/0x3e
> SS:ESP 0068:f4b61cd8
> [ 4005.427010] CR2: 0000000000000021
> [ 4005.427898] ---[ end trace 0e53ab674cd5bfb9 ]---
>

The 'filp' parameter for page_cache_sync_readahead is NULL in this case=
=2E
Commit 0141450f66c3c12a3aaa869748caa64241885cdf  added code that
dereference 'filp'.

=46engguang, would you please fix this.

Regards
Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
