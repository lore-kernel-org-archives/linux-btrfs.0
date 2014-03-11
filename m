Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:51729 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbaCKDQV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 23:16:21 -0400
Message-ID: <531E8004.2030704@linux.intel.com>
Date: Mon, 10 Mar 2014 20:16:20 -0700
From: Saul Wold <sgw@linux.intel.com>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Building a brtfs filesystem < 70M?
References: <531E4A02.5010404@linux.intel.com> <1394505491.6207.4.camel@localhost.localdomain>
In-Reply-To: <1394505491.6207.4.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/10/2014 07:38 PM, Gui Hecheng wrote:
> On Mon, 2014-03-10 at 16:25 -0700, Saul Wold wrote:
>> Hi There
>>
>> There seems to be an issue if we try to build a btrfs based FS that is
>> less than 70M, we get the following assertion failure:
>>
>> mkfs.btrfs: extent-tree.c:2682: btrfs_reserve_extent: Assertion `!(ret)'
>> failed.
>>
>> I tried to do a search on this and did not find anything obvious.
>>
>> Further, if I do build a 70M image, it will not mount until I get to I
>> increase  the about 100M!
>>
>> # mount -o loop -v rootfs.btrfs mnt
>> mount: wrong fs type, bad option, bad superblock on /dev/loop0,
>>          missing codepage or helper program, or other error
>>
>>          In some cases useful info is found in syslog - try
>>          dmesg | tail or so.
>>
>> I can provide a small rootfs (~4M) example if needed
>>
>> Builds and mounts correct:
>> mkfs.btrfs -b 104857600 -r rootfs rootfs.btrfs
>>
>> Builds, but does not mount:
>> mkfs.btrfs -b 73400320 -r rootfs rootfs.btrfs
>>
>> Does not build, gives the above assertion error:
>> mkfs.btrfs -b 10889216 -r rootfs rootfs.btrfs
>>
>>
>> Thanks
>>
> Hi Saul,
> Sorry, I'm not able to reproduce your problem...
> Are you running the latest btrfs-progs from david's branch?
>
Yes, I am building it from git using master I think, git hash: 
8cae1840afb3ea44dcc298f32983e577480dfee4

I tried both with and without the -M as cwillu suggested, still no joy, 
I can send some the rootfs I am using to see if is's something specific.

Here's the full failure:

$ tmp/sysroots/x86_64-linux/usr/bin/mkfs.btrfs -M -b 10889216 -r 
tmp/work/qemux86_64-poky-linux/core-image-minimal/1.0-r0/rootfs rootfs.btrfs
SMALL VOLUME: forcing mixed metadata/data groups
SMALL VOLUME: forcing mixed metadata/data groups

WARNING! - Btrfs v3.12-dirty IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

Turning ON incompat feature 'mixed-bg': mixed data and metadata block groups
Turning ON incompat feature 'extref': increased hardlink limit per file 
to 65536
Created a data/metadata chunk of size 8388608
fs created label (null) on rootfs.btrfs
	nodesize 4096 leafsize 4096 sectorsize 4096 size 180.00MiB
Btrfs v3.12-dirty
scandir for 
tmp/work/qemux86_64-poky-linux/core-image-minimal/1.0-r0/rootfs failed: 
No such file or directory
unable to traverse_directory
Making image is aborted.
mkfs.btrfs: mkfs.c:1592: main: Assertion `!(ret)' failed.
Aborted (core dumped)


Thanks for the help!

Sau!



> Thanks,
> Gui
>
>
