From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: Dirtiable inode bdi default != sb bdi btrfs
Date: Wed, 22 Sep 2010 21:54:30 -0300
Message-ID: <4C9AA546.6050201@cesarb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <jaxboe@fusionio.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This started appearing for me on v2.6.36-rc5-49-gc79bd89; it did not 
happen on v2.6.36-rc5-33-g1ce1e41, probably because it does not have 
commit 692ebd17c2905313fff3c504c249c6a0faad16ec which introduces the 
warning.

[...]
device fsid 44d595920ddedfa-3ece6b56e80f689e devid 1 transid 22342 
/dev/mapper/vg_cesarbinspiro-lv_home
SELinux: initialized (dev dm-3, type btrfs), uses xattr
------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x62/0x6d()
Hardware name: Inspiron N4010
Dirtiable inode bdi default != sb bdi btrfs
Modules linked in: ipv6 kvm_intel kvm uinput arc4 ecb 
snd_hda_codec_intelhdmi snd_hda_codec_realtek iwlagn snd_hda_intel 
iwlcore snd_hda_codec uvcvideo snd_hwdep mac80211 videodev snd_seq 
snd_seq_device v4l1_compat snd_pcm atl1c v4l2_compat_ioctl32 btusb 
cfg80211 snd_timer i2c_i801 bluetooth iTCO_wdt dell_wmi dell_laptop snd 
pcspkr wmi dcdbas shpchp iTCO_vendor_support soundcore snd_page_alloc 
rfkill joydev microcode btrfs zlib_deflate libcrc32c cryptd aes_x86_64 
aes_generic xts gf128mul dm_crypt usb_storage i915 drm_kms_helper drm 
i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
Pid: 1073, comm: find Not tainted 2.6.36-rc5+ #8
Call Trace:
  [<ffffffff8104d0e4>] warn_slowpath_common+0x85/0x9d
  [<ffffffff8104d19f>] warn_slowpath_fmt+0x46/0x48
  [<ffffffff811308b7>] inode_to_bdi+0x62/0x6d
  [<ffffffff81131b48>] __mark_inode_dirty+0xd0/0x177
  [<ffffffff81127168>] touch_atime+0x107/0x12a
  [<ffffffff81122384>] ? filldir+0x0/0xd0
  [<ffffffff8112259b>] vfs_readdir+0x8d/0xb4
  [<ffffffff8112270b>] sys_getdents+0x81/0xd1
  [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
---[ end trace 8907b335812c497b ]---
------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x62/0x6d()
Hardware name: Inspiron N4010
Dirtiable inode bdi default != sb bdi btrfs
Modules linked in: ipv6 kvm_intel kvm uinput arc4 ecb 
snd_hda_codec_intelhdmi snd_hda_codec_realtek iwlagn snd_hda_intel 
iwlcore snd_hda_codec uvcvideo snd_hwdep mac80211 videodev snd_seq 
snd_seq_device v4l1_compat snd_pcm atl1c v4l2_compat_ioctl32 btusb 
cfg80211 snd_timer i2c_i801 bluetooth iTCO_wdt dell_wmi dell_laptop snd 
pcspkr wmi dcdbas shpchp iTCO_vendor_support soundcore snd_page_alloc 
rfkill joydev microcode btrfs zlib_deflate libcrc32c cryptd aes_x86_64 
aes_generic xts gf128mul dm_crypt usb_storage i915 drm_kms_helper drm 
i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
Pid: 1073, comm: find Tainted: G        W   2.6.36-rc5+ #8
Call Trace:
  [<ffffffff8104d0e4>] warn_slowpath_common+0x85/0x9d
  [<ffffffff8104d19f>] warn_slowpath_fmt+0x46/0x48
  [<ffffffff811308b7>] inode_to_bdi+0x62/0x6d
  [<ffffffff81131b48>] __mark_inode_dirty+0xd0/0x177
  [<ffffffff81127168>] touch_atime+0x107/0x12a
  [<ffffffff81122384>] ? filldir+0x0/0xd0
  [<ffffffff8112259b>] vfs_readdir+0x8d/0xb4
  [<ffffffff8112270b>] sys_getdents+0x81/0xd1
  [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
---[ end trace 8907b335812c497c ]---
[...]

These are only the first two; they keep happening, with several 
different processes (it is not only find), but always btrfs (I have / 
and /home on btrfs and /boot on ext4). In case it makes any difference, 
/dev seems to be on devtmpfs, and everything uses relatime.

There is also the following one which is not on vfs_readdir:

------------[ cut here ]------------
WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x62/0x6d()
Hardware name: Inspiron N4010
Dirtiable inode bdi default != sb bdi btrfs
Modules linked in: ipv6 kvm_intel kvm uinput arc4 ecb 
snd_hda_codec_intelhdmi snd_hda_codec_realtek iwlagn snd_hda_intel 
iwlcore snd_hda_codec uvcvideo snd_hwdep mac80211 videodev snd_seq 
snd_seq_device v4l1_compat snd_pcm atl1c v4l2_compat_ioctl32 btusb 
cfg80211 snd_timer i2c_i801 bluetooth iTCO_wdt dell_wmi dell_laptop snd 
pcspkr wmi dcdbas shpchp iTCO_vendor_support soundcore snd_page_alloc 
rfkill joydev microcode btrfs zlib_deflate libcrc32c cryptd aes_x86_64 
aes_generic xts gf128mul dm_crypt usb_storage i915 drm_kms_helper drm 
i2c_algo_bit i2c_core video output [last unloaded: scsi_wait_scan]
Pid: 1104, comm: mkdir Tainted: G        W   2.6.36-rc5+ #8
Call Trace:
  [<ffffffff8104d0e4>] warn_slowpath_common+0x85/0x9d
  [<ffffffff8104d19f>] warn_slowpath_fmt+0x46/0x48
  [<ffffffff811308b7>] inode_to_bdi+0x62/0x6d
  [<ffffffff81131b48>] __mark_inode_dirty+0xd0/0x177
  [<ffffffffa01408c6>] btrfs_setattr+0x210/0x23a [btrfs]
  [<ffffffff8112865e>] notify_change+0x1a2/0x29d
  [<ffffffff81113794>] sys_fchmod+0xac/0xfd
  [<ffffffff811188e2>] ? sys_newfstat+0x2e/0x39
  [<ffffffff81009c72>] system_call_fastpath+0x16/0x1b
---[ end trace 8907b335812c498d ]---

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
