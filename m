Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:36371 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750775AbdAXS5L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 13:57:11 -0500
Received: by mail-pf0-f170.google.com with SMTP id 189so52019208pfu.3
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 10:57:11 -0800 (PST)
Date: Tue, 24 Jan 2017 10:56:44 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170
 __btrfs_run_delayed_items,
Message-ID: <20170124185644.GA2853@vader>
References: <CAJCQCtQz5fhYymEgFuxuiactZpWeUSEeCCXFCAEmLTTA6AOZLQ@mail.gmail.com>
 <20170123213109.GA11778@vader.DHCP.thefacebook.com>
 <CAJCQCtSVXRXvGmnmfFt5yn_L33a8eCCuuFANxTOyWLrJeqrK9g@mail.gmail.com>
 <CAJCQCtRip_D7BPhCJDVP53LRoQoEcVrvCf7eyGK9sa8qv23BNQ@mail.gmail.com>
 <20170123220448.GB11778@vader.DHCP.thefacebook.com>
 <CAJCQCtQNgvu72GUBpvJtnAH-Sj-fd566HwDpeuGjaPmdtrUO3g@mail.gmail.com>
 <20170124000524.GC11778@vader.DHCP.thefacebook.com>
 <CAJCQCtSHx8cEanC7e71akLiRKzi+Rt96CSAoK11Ngud9=n1U-Q@mail.gmail.com>
 <20170124174907.GA27340@vader>
 <CAJCQCtQVYdc9JK_B=XCrTBE6YYjqz23D3rEmRLoJUbM7gQVQSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtQVYdc9JK_B=XCrTBE6YYjqz23D3rEmRLoJUbM7gQVQSQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2017 at 11:37:43AM -0700, Chris Murphy wrote:
> On Tue, Jan 24, 2017 at 10:49 AM, Omar Sandoval <osandov@osandov.com> wrote:
> > On Mon, Jan 23, 2017 at 08:51:24PM -0700, Chris Murphy wrote:
> >> On Mon, Jan 23, 2017 at 5:05 PM, Omar Sandoval <osandov@osandov.com> wrote:
> >> > Thanks! Hmm, okay, so it's coming from btrfs_update_delayed_inode()...
> >> > That's probably us failing btrfs_lookup_inode(), but just to make sure,
> >> > could you apply the updated diff at the same link as before
> >> > (https://gist.github.com/osandov/9f223bda27f3e1cd1ab9c1bd634c51a4)? If
> >> > that's the case, I'm even more confused about what xattrs have to do
> >> > with it.
> >>
> >> [   35.015363] __btrfs_update_delayed_inode(): inode is missing
> >
> > Okay, like I expected...
> >
> >> [   35.015372] btrfs_update_delayed_inode(ino=2) -> -2
> >
> > Wtf? Inode numbers should be >=256. I updated the diff a third time to
> > catch where that came from. If we're lucky, the backtrace should have
> > the exact culprit. If we're unlucky, there might be memory corruption
> > involved.
> 
> Now two traces. This one is new, and follows a bunch of xattr related stuff...
> 
> [    6.861504] WARNING: CPU: 3 PID: 690 at fs/btrfs/delayed-inode.c:55
> btrfs_get_or_create_delayed_node+0x16a/0x1e0 [btrfs]
> [    6.862833] ino 2 is out of range
> 
> Then this:
> [    7.016061] __btrfs_update_delayed_inode(): inode is missing
> [    7.017149] btrfs_update_delayed_inode() failed
> [    7.018233] __btrfs_commit_inode_delayed_items(ino=2, flags=3) -> -2
> 
> And finally what we've already seen:
> [   34.930890] WARNING: CPU: 0 PID: 396 at
> fs/btrfs/delayed-inode.c:1194 __btrfs_run_delayed_items+0x1d0/0x670
> [btrfs]
> 
> Complete dmesg osandov-9f223b-3_dmesg.log
> https://drive.google.com/open?id=0B_2Asp8DGjJ9bnpNamIydklraTQ
> 

Aha, so it is xattrs! Here's the full warning trace:

[    6.860185] ------------[ cut here ]------------
[    6.861504] WARNING: CPU: 3 PID: 690 at fs/btrfs/delayed-inode.c:55 btrfs_get_or_create_delayed_node+0x16a/0x1e0 [btrfs]
[    6.862833] ino 2 is out of range
[    6.862842] Modules linked in:
[    6.864213]  xfs libcrc32c arc4 iwlmvm intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp mac80211 snd_soc_skl kvm_intel snd_soc_skl_ipc kvm snd_hda_codec_hdmi snd_soc_sst_ipc irqbypass snd_soc_sst_dsp crct10dif_pclmul iTCO_wdt crc32_pclmul snd_hda_codec_conexant snd_hda_ext_core snd_hda_codec_generic ghash_clmulni_intel iTCO_vendor_support snd_soc_sst_match intel_cstate snd_soc_core iwlwifi i2c_designware_platform i2c_designware_core hp_wmi sparse_keymap snd_hda_intel intel_uncore snd_hda_codec cfg80211 snd_hwdep snd_hda_core snd_seq snd_seq_device uvcvideo intel_rapl_perf snd_pcm videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core joydev videodev idma64 snd_timer btusb hci_uart i2c_i801 snd i2c_smbus media btrtl btbcm soundcore btqca btintel mei_me mei bluetooth shpchp processor_thermal_device
[    6.869661]  intel_pch_thermal intel_lpss_pci intel_soc_dts_iosf ucsi wmi hp_accel pinctrl_sunrisepoint lis3lv02d pinctrl_intel int3403_thermal rfkill input_polldev hp_wireless intel_lpss_acpi int340x_thermal_zone nfsd int3400_thermal intel_lpss tpm_crb acpi_thermal_rel acpi_pad tpm_tis tpm_tis_core tpm auth_rpcgss nfs_acl lockd grace sunrpc btrfs i915 xor raid6_pq i2c_algo_bit drm_kms_helper drm crc32c_intel nvme serio_raw nvme_core i2c_hid video fjes
[    6.874780] CPU: 3 PID: 690 Comm: systemd-tmpfile Not tainted 4.9.0+ #2
[    6.876294] Hardware name: HP HP Spectre Notebook/81A0, BIOS F.30 12/15/2016
[    6.877820]  ffff9bc341187a78 ffffffff923ed9ed ffff9bc341187ac8 0000000000000000
[    6.879316]  ffff9bc341187ab8 ffffffff920a1d9b 00000037921cafcb 0000000000000002
[    6.880836]  ffff8c4126d62000 ffff8c413170b0b0 ffffffffffffff02 ffff8c4129a8f300
[    6.882364] Call Trace:
[    6.883861]  [<ffffffff923ed9ed>] dump_stack+0x63/0x86
[    6.885355]  [<ffffffff920a1d9b>] __warn+0xcb/0xf0
[    6.886888]  [<ffffffff920a1e1f>] warn_slowpath_fmt+0x5f/0x80
[    6.888415]  [<ffffffffc04a9426>] ? btrfs_get_or_create_delayed_node+0x126/0x1e0 [btrfs]
[    6.889979]  [<ffffffffc04a946a>] btrfs_get_or_create_delayed_node+0x16a/0x1e0 [btrfs]
[    6.891498]  [<ffffffffc04ac3c7>] btrfs_delayed_update_inode+0x27/0x420 [btrfs]
[    6.893023]  [<ffffffff9210de03>] ? current_fs_time+0x23/0x30
[    6.894602]  [<ffffffffc0453bbd>] btrfs_update_inode+0x8d/0x100 [btrfs]
[    6.896122]  [<ffffffff92270626>] ? current_time+0x36/0x70
[    6.897681]  [<ffffffffc0469503>] __btrfs_setxattr+0xe3/0x120 [btrfs]
[    6.899212]  [<ffffffffc0469576>] btrfs_xattr_handler_set+0x36/0x40 [btrfs]
[    6.900690]  [<ffffffff9227ac6b>] __vfs_setxattr+0x6b/0x90
[    6.902182]  [<ffffffff9227b912>] __vfs_setxattr_noperm+0x72/0x1b0
[    6.903622]  [<ffffffff9227baf7>] vfs_setxattr+0xa7/0xb0
[    6.905078]  [<ffffffff9227bc60>] setxattr+0x160/0x180
[    6.906515]  [<ffffffff9224fa3f>] ? __check_object_size+0xff/0x1d6
[    6.907894]  [<ffffffff9241ecad>] ? strncpy_from_user+0x4d/0x170
[    6.909231]  [<ffffffff9226456f>] ? getname_flags+0x6f/0x1f0
[    6.910590]  [<ffffffff9227bd33>] path_setxattr+0xb3/0xe0
[    6.911913]  [<ffffffff9227bea1>] SyS_lsetxattr+0x11/0x20
[    6.913211]  [<ffffffff92003c17>] do_syscall_64+0x67/0x180
[    6.914557]  [<ffffffff9280a3ab>] entry_SYSCALL64_slow_path+0x25/0x25
[    6.915862] ---[ end trace 16f2b6ce06b1433e ]---

> Also, to do these tests, I'm making a new rw snapshot each time so
> that the new kernel modules are in the snapshot. e.g.
> 
> 1. subvolumes 'home' and 'root' are originally created with 'btrfs sub
> create' and then filled, and these work OK with all kernels.
> 2. build kernel with patch
> 3. 'btrfs sub snap root root.test8'  and also 'btrfs sub snap home home.test8'
> 4. sudo vi root.test8/etc/fstab to update the entry for / so that
> subvol=root is now subvol=root.test8, and also update for /home
> 5. sudo vi /boot/efi/EFI/fedora/grub.cfg to update the command line,
> rootflags=subvol=root becomes rootflags=subvol=root.test8
> 
> So the fact the kernel works on subvolume root, but consistently does
> not work on each brand new snapshot, is suspiciously unlike what I'd
> expect for memory corruption; unless the memory corruption has already
> "tainted" the file system in a way that neither btrfs check or scrub
> can find; and this "taintedness" of the file system doesn't manifest
> until there's a snapshot being used and with a particular kernel with
> the xattr patch?
> 
> Pretty weird.

Yup, definitely doesn't look like memory corruption. I set up a Fedora
VM yesterday to try to repro with basically those same steps but it
didn't happen. I'll try again, but is there anything special about your
Fedora installation? I installed Fedora Server with however the
installer set up Btrfs.
