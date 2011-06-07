From: Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: btrfs hang on brd
Date: Tue, 07 Jun 2011 08:35:45 +0300
Message-ID: <4DEDB8B1.1040901@intel.com>
References: <4DE492B0.9020302@linux.intel.com> <20110601085439.GD12709@twin.jikos.cz> <4DE60F44.6090400@linux.intel.com> <4DE8AC3E.8020908@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DE8AC3E.8020908@intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/06/11 12:41, Adrian Hunter wrote:
> No improvement on 3.0-rc1+ (commit
> 5c6cce92bc8aee751aafe82c5d9caf7553226a3d).

And on 59c5f46fbe01a00eedf54a23789634438bb80603 Linux 3.0-rc2
btrfs quickly fails to mount due to no space e.g.


Script
------

#!/bin/sh

sudo modprobe brd rd_size=262144

sudo umount /mnt/test/ 2> /dev/null

echo 'mkfs.btrfs /dev/ram0'

sudo mkfs.btrfs /dev/ram0

sudo mkdir -p /mnt/test

echo 'mount -t btrfs /dev/ram0 /mnt/test'

sudo mount -t btrfs /dev/ram0 /mnt/test

sudo mkdir -p /mnt/test/test

sudo chown $USER /mnt/test/test
sudo chgrp $USER /mnt/test/test

sudo umount /mnt/test

full=0
i=0
while true; do
	sudo mount -t btrfs /dev/ram0 /mnt/test

	if df | grep ram0 | grep 100% > /dev/null; then
		full=`expr $full \+ 1`
		if test $full -gt 6;then
			rm -rf /mnt/test/test/*
			full=0
		fi
	else
		full=0
	fi

	fsstress -c -r -d /mnt/test/test -p 3 -n 1000 -l 10

	sudo umount /mnt/test

	i=`expr $i \+ 1`
	echo $i
done



Script Output
-------------

mkfs.btrfs /dev/ram0

WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/ram0
	nodesize 4096 leafsize 4096 sectorsize 4096 size 256.00MB
Btrfs Btrfs v0.19
mount -t btrfs /dev/ram0 /mnt/test
1
2
3
4
mount: No space left on device
^C



Kernel messages
---------------

[   95.084429] brd: module loaded
[   95.368708] Btrfs loaded
[   95.369455] device fsid 9644bae59f78285c-8db3a698a8a82293 devid 1 
transid 7 /dev/ram0
[   95.370582] SELinux: initialized (dev ram0, type btrfs), uses xattr
[   95.487905] device fsid 9644bae59f78285c-8db3a698a8a82293 devid 1 
transid 10 /dev/ram0
[   95.488889] SELinux: initialized (dev ram0, type btrfs), uses xattr
[  107.336869] device fsid 9644bae59f78285c-8db3a698a8a82293 devid 1 
transid 2664 /dev/ram0
[  107.338873] SELinux: initialized (dev ram0, type btrfs), uses xattr
[  115.861909] device fsid 9644bae59f78285c-8db3a698a8a82293 devid 1 
transid 6816 /dev/ram0
[  115.864089] SELinux: initialized (dev ram0, type btrfs), uses xattr
[  122.586606] device fsid 9644bae59f78285c-8db3a698a8a82293 devid 1 
transid 10872 /dev/ram0
[  122.587779] SELinux: initialized (dev ram0, type btrfs), uses xattr
[  128.824401] BTRFS: inode 19622 still on the orphan list
[  128.844945] ------------[ cut here ]------------
[  128.844969] WARNING: at fs/btrfs/extent-tree.c:6878 
btrfs_free_block_groups+0x1e6/0x228 [btrfs]()
[  128.844973] Hardware name: XPS 8300
[  128.844974] Modules linked in: btrfs zlib_deflate libcrc32c brd tun 
fuse cpufreq_ondemand acpi_cpufreq freq_table mperf ip6t_REJECT 
nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipv6 uinput 
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec 
snd_hwdep snd_seq snd_seq_device snd_pcm broadcom snd_timer snd tg3 
pcspkr joydev iTCO_wdt iTCO_vendor_support soundcore snd_page_alloc 
i2c_i801 serio_raw dcdbas microcode usb_storage i915 drm_kms_helper drm 
i2c_algo_bit i2c_core video [last unloaded: scsi_wait_scan]
[  128.845024] Pid: 2503, comm: umount Not tainted 
3.0.0-rc2-2011-06-06-02+ #13
[  128.845026] Call Trace:
[  128.845035]  [<ffffffff8104db2e>] warn_slowpath_common+0x85/0x9d
[  128.845050]  [<ffffffffa02a6b70>] ? 
btrfs_free_block_groups+0x204/0x228 [btrfs]
[  128.845056]  [<ffffffff8104db60>] warn_slowpath_null+0x1a/0x1c
[  128.845069]  [<ffffffffa02a6b52>] btrfs_free_block_groups+0x1e6/0x228 
[btrfs]
[  128.845087]  [<ffffffffa02afa0b>] close_ctree+0x22c/0x346 [btrfs]
[  128.845092]  [<ffffffff8103d068>] ? should_resched+0xe/0x2e
[  128.845097]  [<ffffffff8147abfe>] ? _cond_resched+0xe/0x22
[  128.845100]  [<ffffffff8147b7d5>] ? down_write+0x29/0x49
[  128.845110]  [<ffffffffa0295a1e>] btrfs_put_super+0x1d/0x2c [btrfs]
[  128.845116]  [<ffffffff8111ecb4>] generic_shutdown_super+0x74/0xe9
[  128.845120]  [<ffffffff8111eda9>] kill_anon_super+0x16/0x50
[  128.845125]  [<ffffffff8111efd6>] deactivate_locked_super+0x26/0x4b
[  128.845129]  [<ffffffff8111f7c5>] deactivate_super+0x3a/0x3f
[  128.845133]  [<ffffffff81134a09>] mntput_no_expire+0xd0/0xd5
[  128.845136]  [<ffffffff81135688>] sys_umount+0x2dc/0x30a
[  128.845141]  [<ffffffff81125c64>] ? path_put+0x22/0x27
[  128.845145]  [<ffffffff814828c2>] system_call_fastpath+0x16/0x1b
[  128.845149] ---[ end trace e535ebf83dd43354 ]---
[  128.845152] space_info has 8814592 free, is full
[  128.845156] space_info total=41943040, used=24576000, pinned=0, 
reserved=98304, may_use=0, readonly=8454144
[  128.897312] device fsid 9644bae59f78285c-8db3a698a8a82293 devid 1 
transid 14722 /dev/ram0
[  128.910740] BTRFS: inode 19622 still on the orphan list
[  128.910747] btrfs: could not do orphan cleanup -28
[  128.948912] btrfs: open_ctree failed
