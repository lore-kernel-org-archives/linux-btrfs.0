Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:35167 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaENOhB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 10:37:01 -0400
Message-ID: <5373803E.9000406@libero.it>
Date: Wed, 14 May 2014 16:39:58 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
CC: jshubin@redhat.com
Subject: Re: [PATCH] mkfs.btrfs: allow UUID specification at mkfs time
References: <5372C457.3000706@redhat.com>
In-Reply-To: <5372C457.3000706@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Eric,

On 05/14/2014 03:18 AM, Eric Sandeen wrote:
> Allow the specification of the filesystem UUID at mkfs time.

I suggest to add some warning when this options is used, because the behavior could be very different than the one expected.

I suspect that BTRFS tracks the filesystem by UUID and not by devices. When two filesystems have the same UUID at the same time, it may mount the wrong one.

$ #
$ # Make two *different* filesystems with the *same* UUID
$ #
$ UUID=e285c9bd-ea97-40b3-ad7d-8713dcfd5eea
$ sudo ./mkfs.btrfs -f -U $UUID /dev/vdg
$ sudo ./mkfs.btrfs -f -U $UUID /dev/vdh

$ #
$ # from the beginning "btrfs fi show" reports wrong information
$ #
$ sudo btrfs fi show
Label: none  uuid: e285c9bd-ea97-40b3-ad7d-8713dcfd5eea
	Total devices 1 FS bytes used 96.00KB
	devid    1 size 50.00GB used 4.00MB path /dev/vdh
	devid    1 size 50.00GB used 2.04GB path /dev/vdg

$ #
$ # mount the first one, create a new file then un-mount it
$ #
$ sudo mount /dev/vdg /mnt/btrfs1
$ sudo touch /mnt/btrfs1/dev-vdg
$ sudo umount /dev/vdg

$ #
$ # mount the second one, it should be empty
$ # instead btrfs mount the first one
$ #
$ sudo mount /dev/vdh /mnt/btrfs2
$ ls -l /mnt/btrfs2
total 0
-rw-r--r-- 1 root root 0 May 14 16:12 dev-vdg


I am not against this option; I am suggesting to add a explicit warning to the user about the risk of doing that, both on the man pages and into the program. 
The warning should say that this option is only for testing. Better ask for a confirmation (even with an undocumented switch like '--I-know-that-I-am-doing-something-really-dangerous').

For the record, BTRFS seems unable to mount at the same time two different filesystems with the same UUID:

$ #
$ # try to mount two fs with the same UUID, but BTRFS doesn't allow it
$ #
$ sudo mount /dev/vdh /mnt/btrfs2
$ sudo mount /dev/vdg /mnt/btrfs1
ERROR: mount failed : 16 - Device or resource busy


BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
