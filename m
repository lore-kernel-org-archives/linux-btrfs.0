Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:40536 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880Ab3DXU7W (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 16:59:22 -0400
Received: by mail-pd0-f177.google.com with SMTP id p11so1381611pdj.36
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2013 13:59:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <517839C2.7060905@storix.com>
References: <517839C2.7060905@storix.com>
Date: Wed, 24 Apr 2013 16:59:21 -0400
Message-ID: <CALJXSJoJ1iQ9qGA1QAEgE=tPa3UPY3t9Dmckd4oSM5Pd4e8K4Q@mail.gmail.com>
Subject: Re: query btrfs creation options
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Rich Turner <rturner@storix.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think actual userland tools should be able to do what you want;
leafsize, nodesize, sectorsize: btrfs-show-super /dev/dm-6
label: blkid /dev/dm-6
data, metadata: btrfs filesystem df /

# btrfs-show-super /dev/dm-6
superblock: bytenr=65536, device=/dev/dm-6
---------------------------------------------------------
csum 0xba41e65b [match]
bytenr 65536
flags 0x1
magic _BHRfS_M [match]
fsid 456e363c-650e-4c29-898c-b2b65bf9c3b3
label p4-btrfs2
generation 253003
root 664749473792
sys_array_size 97
chunk_root_generation 218142
root_level 1
chunk_root 131072
chunk_root_level 0
log_root 0
log_root_transid 0
log_root_level 0
total_bytes 536869732352
bytes_used 441861300224
sectorsize 4096
nodesize 65536
leafsize 65536
stripesize 4096
root_dir 6
num_devices 1
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0x29
csum_type 0
csum_size 4
cache_generation 253003
dev_item.uuid 5a5802fb-5012-4bae-897e-388754b5ed08
dev_item.fsid 456e363c-650e-4c29-898c-b2b65bf9c3b3 [match]
dev_item.type 0
dev_item.total_bytes 536869732352
dev_item.bytes_used 446689181696
dev_item.io_align 4096
dev_item.io_width 4096
dev_item.sector_size 4096
dev_item.devid 1
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0


On Wed, Apr 24, 2013 at 4:00 PM, Rich Turner <rturner@storix.com> wrote:
> i am looking for a way to query btrfs filesystems for all options used to
> create the filesystem (i.e. data, leafsize, label, metadata, nodesize,
> sectorsize) in an effort to be able to record this information and be able
> to recreate the filesystem with the same attributes if necessary.
>
> i see there is a feature request for creating an api/library that may
> provide this functionality, but i am unable to find any suitable userspace
> command that provides the information.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
