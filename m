Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:44824 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbcB1FR4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 00:17:56 -0500
Date: Sat, 27 Feb 2016 21:17:54 -0800
From: Marc MERLIN <marc@merlins.org>
To: Anand Jain <anand.jain@oracle.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs check --repair is clean, but mount fails
Message-ID: <20160228051754.GU19699@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56D25104.9020107@oracle.com>
 <56D25104.9020107@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 28, 2016 at 09:44:36AM +0800, Anand Jain wrote:
> If you have a choice pls add, 'btrfs fi show -d' as well for the outputs
> to be taken at the time of boot just before system's 'btrfs dev scan',
 
Ok, I had to reboot anyway, so here's the state when it's bad:

gargamel:~# btrfs fi show -d
Label: 'btrfs_boot'  uuid: e4c1daa8-9c39-4a59-b0a9-86297d397f3b
        Total devices 1 FS bytes used 43.52GiB
        devid    1 size 79.93GiB used 62.13GiB path /dev/mapper/cryptroot
 
Label: 'dshelf2'  uuid: d4a51178-c1e6-4219-95ab-5c5864695bfd
        Total devices 1 FS bytes used 4.27TiB
        devid    1 size 7.28TiB used 4.44TiB path /dev/mapper/dshelf2
 
Label: 'btrfs_space'  uuid: 01334b81-c0db-4e80-92e4-cac4da867651
        Total devices 2 FS bytes used 1.09TiB
        devid    1 size 836.13GiB used 641.03GiB path /dev/mapper/raid0d1
        devid    2 size 836.13GiB used 641.03GiB path /dev/mapper/raid0d2
 
Label: 'dshelf1'  uuid: 5d0847f8-b243-494a-9e31-0a7c9adbd764
        Total devices 1 FS bytes used 8.88TiB
        devid    1 size 21.83TiB used 8.92TiB path /dev/bcache1

gargamel:~# mount /var/local/space
mount: wrong fs type, bad option, bad superblock on /dev/mapper/raid0d1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so
[ 3209.752862] BTRFS info (device dm-6): disk space caching is enabled
[ 3209.775418] BTRFS: failed to read the system array on dm-6
[ 3209.807673] BTRFS: open_ctree failed

blkid shows:
/dev/mapper/raid0d1: LABEL="btrfs_space" UUID="01334b81-c0db-4e80-92e4-cac4da867651" UUID_SUB="a87c0954-e0d5-4cdb-acb9-05ed290c16df" TYPE="btrfs" 
/dev/mapper/raid0d2: LABEL="btrfs_space" UUID="01334b81-c0db-4e80-92e4-cac4da867651" UUID_SUB="b4ea90fa-4262-489a-830d-3bd4e7518ff2" TYPE="btrfs" 

but mount fails.

And then:
gargamel:~# btrfs dev scan
Scanning for Btrfs filesystems
gargamel:~# mount /var/local/space
gargamel:~# 

Does this make any sense to you?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
