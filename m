Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.114.20]:38629 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaL1UAz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Dec 2014 15:00:55 -0500
Date: Mon, 29 Dec 2014 01:00:47 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Marc MERLIN <marc@merlins.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: 3.16.3: fs/btrfs/delayed-inode.c:1410
 btrfs_assert_delayed_root_empty
Message-ID: <20141229010047.7f9b6d43@natsu>
In-Reply-To: <20141228192614.GO17254@merlins.org>
References: <20141228192614.GO17254@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 28 Dec 2014 11:26:14 -0800
Marc MERLIN <marc@merlins.org> wrote:

> Not sure if it's useful to anyone, but there you go. This happened after a forced
> power cycle:
> 
> BTRFS info (device dm-1): disk space caching is enabled
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 778 at fs/btrfs/delayed-inode.c:1410 btrfs_assert_delayed_root_empty+0x32/0x34()
> Modules linked in: aes_x86_64 lm85 hwmon_vid dm_snapshot dm_bufio iptable_nat ip_tables nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_conntrack_ftp ipt_MASQUERADE nf_nat x_tables nf_conntrack sg st snd_pcm_oss snd_mixer_oss fuse snd_hda_codec_realtek snd_hda_codec_generic microcode snd_cmipci gameport snd_hda_intel kvm_intel snd_hda_controller kvm snd_hda_codec snd_opl3_lib eeepc_wmi snd_mpu401_uart snd_seq_midi snd_seq_midi_event snd_seq asus_wmi battery snd_rawmidi snd_hwdep sparse_keymap rfkill snd_pcm snd_seq_device tpm_infineon snd_timer tpm_tis rc_ati_x10 asix coretemp tpm i2c_i801 snd processor wmi pl2303 kl5kusb105 libphy ati_remote parport_pc rc_core xhci_hcd intel_rapl keyspan ftdi_sio evdev usbnet soundcore pcspkr parport lpc_ich intel_powerclamp ezusb usbserial x86_pkg_temp_thermal xts gf128mul dm_crypt dm_mod raid456 async_raid6_recov async_pq async_xor async_memcpy async_tx e1000e ptp pps_core crc32c_intel crc32_pclmul sata_sil24 thermal crct10dif_pclmul ehci_pci eh
 ci
>  _hcd ghash_clmulni_intel r8169 cryptd fan mii usbcore usb_common sata_mv
> CPU: 2 PID: 778 Comm: btrfs-transacti Tainted: G        W     3.16.7-amd64-i915-volpreempt-20141114 #1
> Hardware name: System manufacturer System Product Name/P8H67-M PRO, BIOS 3806 08/20/2012
>  0000000000000000 ffff8802117abdc8 ffffffff816295db 0000000000000000
>  ffff8802117abe00 ffffffff81051e2d ffffffff8127038d ffff880211534000
>  ffff880212639980 0000000000000000 ffff8802137eaf00 ffff8802117abe10
> Call Trace:
>  [<ffffffff816295db>] dump_stack+0x45/0x56
>  [<ffffffff81051e2d>] warn_slowpath_common+0x7f/0x98
>  [<ffffffff8127038d>] ? btrfs_assert_delayed_root_empty+0x32/0x34
>  [<ffffffff81051ef4>] warn_slowpath_null+0x1a/0x1c
>  [<ffffffff8127038d>] btrfs_assert_delayed_root_empty+0x32/0x34
>  [<ffffffff8122db95>] btrfs_commit_transaction+0x37f/0x867
>  [<ffffffff8122a2f1>] transaction_kthread+0xec/0x19f
>  [<ffffffff8122a205>] ? btrfs_cleanup_transaction+0x3f3/0x3f3
>  [<ffffffff8106cd8f>] kthread+0xae/0xb6
>  [<ffffffff8106cce1>] ? __kthread_parkme+0x61/0x61
>  [<ffffffff8163007c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff8106cce1>] ? __kthread_parkme+0x61/0x61
> ---[ end trace 32de13ca415f14fa ]---
> 
> I'm now getting this on interval as kernel spam.
> 
> It doesn't say which of my 4 btrfs volumes this is linked to, which
> doesn't make life easier.
> 
> Any idea what I should do from here?
> 
> Will btrfs scrub, even if it takes about 24H to run for me, tell me
> which FS is affected and if so do I run btrfs repair?

I had this: http://www.spinics.net/lists/linux-btrfs/msg40586.html

1) I determined which btrfs of the multiple ones that I have is the culprit, by
unmounting them one by one and seeing if the dmesg spam disappears;

2) Surprisingly(#1), it was not the one that was heavily operated on in the fashion
described in that message;

3) After that, I ran btrfsck (it did found some errors that looked like this,
repeated dozens of times, with different "root nnnnn" numbers):

root 22730 inode 97339 errors 200, dir isize wrong
root 22730 inode 4044171 errors 200, dir isize wrong
root 22730 inode 4478553 errors 200, dir isize wrong
root 22730 inode 6236418 errors 2000, link count wrong
        unresolved ref dir 105512 index 586340 namelen 48 name [redacted].dat.bak filetype 0 errors 3, no dir item, no dir index
root 22730 inode 6325949 errors 2000, link count wrong
        unresolved ref dir 105512 index 586348 namelen 48 name [redacted].dat.bak filetype 0 errors 3, no dir item, no dir index
root 22730 inode 6326136 errors 2000, link count wrong
        unresolved ref dir 105512 index 586344 namelen 48 name [redacted].dat.bak filetype 0 errors 3, no dir item, no dir index
root 22730 inode 6326291 errors 2000, link count wrong
        unresolved ref dir 104979 index 192292 namelen 16 name downloads.config filetype 0 errors 3, no dir item, no dir index
root 22730 inode 6326292 errors 2000, link count wrong
        unresolved ref dir 4376855 index 19522 namelen 15 name xfce4-panel.xml filetype 0 errors 3, no dir item, no dir index
root 22730 inode 6326296 errors 2000, link count wrong
        unresolved ref dir 104979 index 192295 namelen 18 name azureus.statistics filetype 0 errors 3, no dir item, no dir index
root 22730 inode 6326380 errors 2000, link count wrong
        unresolved ref dir 4478552 index 45107 namelen 11 name Local State filetype 0 errors 3, no dir item, no dir index
root 22730 inode 6326402 errors 2000, link count wrong
        unresolved ref dir 105469 index 233238 namelen 11 name diverse.dat filetype 0 errors 3, no dir item, no dir index
root 22730 inode 6326405 errors 2000, link count wrong
        unresolved ref dir 4478553 index 914792 namelen 17 name TransportSecurity filetype 0 errors 3, no dir item, no dir index

4) then btrfsck --repair;

5) The latter, after three hours flat of 100% CPU usage on a 4 GHz AMD FX, proceeding
very slowly with increasing the "root nnnnn" number and the same error descriptions,
still didn't manage to fix of them; so I terminated it as I had other work to do on
the machine, rather than sitting around with its key FSes unmounted;

6) Surprisingly(#2), despite apparently not all of the errors having been
fixed, the btrfs_assert_delayed_root_empty messages no longer appear in dmesg.

The current versions of files mentioned (xfce4-panel.xml and parts of the Chromium profile)
were of course corrupted, but I already noticed that and restored them from an earlier snapshot
even before starting the fsck (yes I also had backups, but didn't need them as snapshotted versions
were fine).

-- 
With respect,
Roman
