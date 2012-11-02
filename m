Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58195 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab2KBOQq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2012 10:16:46 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1401191bkc.19
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 07:16:46 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Goffredo Baroncelli <kreijack@inwind.it>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH][BTRFS-PROGS][V1] btrfs-show-super: a tool to dump superblock
Date: Fri,  2 Nov 2012 15:17:29 +0100
Message-Id: <1351865850-21688-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I updated the Stefan's program btrfs-show-super. Now it prints the results of
some sanity checks (about checksum and superblock magic string), allow
more than one dovice as argument and a '-a' switch which dumps all the
device superblocks.

# btrfs-show-super  /dev/sdh1 
superblock: bytenr=65536, device=../sysfs/disks/disk-02.img
---------------------------------------------------------
csum			0x64d9fdb9 [match]
bytenr			65536
flags			0x1
magic			_BHRfS_M [match]
fsid			6d6141a6-5440-4f75-9c85-6d0ec7450187
label			test2
generation		15
root			29396992
sys_array_size		355
chunk_root_generation	15
root_level		0
chunk_root		20975616
chunk_root_level	0
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		117041005568
bytes_used		290816
sectorsize		4096
nodesize		4096
leafsize		4096
stripesize		4096
root_dir		6
num_devices		4
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x1
csum_type		0
csum_size		4
cache_generation	15
dev_item.uuid		421d2bdb-c9d9-41f8-a966-57248605f18c
dev_item.fsid		6d6141a6-5440-4f75-9c85-6d0ec7450187 [match]
dev_item.type		0
dev_item.total_bytes	3222274048
dev_item.bytes_used	1900216320
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		1
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0


You can pull the source from:
	http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
branch
	super-block-dump

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

