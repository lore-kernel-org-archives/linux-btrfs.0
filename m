Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f49.google.com ([209.85.210.49]:46168 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933357Ab3BTSmo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 13:42:44 -0500
Received: by mail-da0-f49.google.com with SMTP id t11so3679240daj.36
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 10:42:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130220131123.GD9521@twin.jikos.cz>
References: <CALJXSJrNNkEmSeGkez+A5-SWT9k8CUA7fUW5MRviXBWTLB1nqQ@mail.gmail.com>
	<512266F5.7000109@die-jansens.de>
	<CALJXSJpEVB6vESOQmpLfBkHYSqxU0quhByYGSJqgUR5SVY6Shw@mail.gmail.com>
	<20130220131123.GD9521@twin.jikos.cz>
Date: Wed, 20 Feb 2013 13:42:42 -0500
Message-ID: <CALJXSJq7Y4QyDpDY6g1A1o1=OoMRk+4p2L2vtAeU+-ATtbit-Q@mail.gmail.com>
Subject: Re: Kernel panic when scrub is used
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: dsterba@suse.cz, =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>,
        Arne Jansen <lists@die-jansens.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 20, 2013 at 8:11 AM, David Sterba <dsterba@suse.cz> wrote:
> Was the filesystem created with nodesize > 4k ?

Yes; 64KB.

root@p4:~ btrfs-show-super /dev/sda4
superblock: bytenr=65536, device=/dev/sda4
---------------------------------------------------------
csum 0x799cb7d1 [match]
bytenr 65536
flags 0x1
magic _BHRfS_M [match]
fsid 73f86413-2368-4cf8-8371-71a44d6d8bb3
label p4-btrfsRoot
generation 172418
root 27028815872
sys_array_size 226
chunk_root_generation 171189
root_level 0
chunk_root 27538685952
chunk_root_level 0
log_root 27049787392
log_root_transid 0
log_root_level 0
total_bytes 15415397888
bytes_used 9044217856
sectorsize 4096
nodesize 65536
leafsize 65536
stripesize 4096
root_dir 6
num_devices 4
compat_flags 0x0
compat_ro_flags 0x0
incompat_flags 0xab
csum_type 0
csum_size 4
cache_generation 172418
dev_item.uuid c0494d4e-82ad-4241-9a05-c3f2a1d31bd7
dev_item.fsid 73f86413-2368-4cf8-8371-71a44d6d8bb3 [match]
dev_item.type 0
dev_item.total_bytes 3853848576
dev_item.bytes_used 2973761536
dev_item.io_align 4096
dev_item.io_width 4096
dev_item.sector_size 4096
dev_item.devid 1
dev_item.dev_group 0
dev_item.seek_speed 0
dev_item.bandwidth 0
dev_item.generation 0
