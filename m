Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36306 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbcB1GL1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 01:11:27 -0500
Subject: Re: btrfs check --repair is clean, but mount fails
To: Marc MERLIN <marc@merlins.org>
References: <20160228051754.GU19699@merlins.org>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56D28F84.5010006@oracle.com>
Date: Sun, 28 Feb 2016 14:11:16 +0800
MIME-Version: 1.0
In-Reply-To: <20160228051754.GU19699@merlins.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/28/2016 01:17 PM, Marc MERLIN wrote:
> On Sun, Feb 28, 2016 at 09:44:36AM +0800, Anand Jain wrote:
>> If you have a choice pls add, 'btrfs fi show -d' as well for the outputs
>> to be taken at the time of boot just before system's 'btrfs dev scan',
>
> Ok, I had to reboot anyway, so here's the state when it's bad:
>
> gargamel:~# btrfs fi show -d
> Label: 'btrfs_boot'  uuid: e4c1daa8-9c39-4a59-b0a9-86297d397f3b
>          Total devices 1 FS bytes used 43.52GiB
>          devid    1 size 79.93GiB used 62.13GiB path /dev/mapper/cryptroot
>
> Label: 'dshelf2'  uuid: d4a51178-c1e6-4219-95ab-5c5864695bfd
>          Total devices 1 FS bytes used 4.27TiB
>          devid    1 size 7.28TiB used 4.44TiB path /dev/mapper/dshelf2
>
> Label: 'btrfs_space'  uuid: 01334b81-c0db-4e80-92e4-cac4da867651
>          Total devices 2 FS bytes used 1.09TiB
>          devid    1 size 836.13GiB used 641.03GiB path /dev/mapper/raid0d1
>          devid    2 size 836.13GiB used 641.03GiB path /dev/mapper/raid0d2
>
> Label: 'dshelf1'  uuid: 5d0847f8-b243-494a-9e31-0a7c9adbd764
>          Total devices 1 FS bytes used 8.88TiB
>          devid    1 size 21.83TiB used 8.92TiB path /dev/bcache1
>
> gargamel:~# mount /var/local/space
> mount: wrong fs type, bad option, bad superblock on /dev/mapper/raid0d1,
>         missing codepage or helper program, or other error
>         In some cases useful info is found in syslog - try
>         dmesg | tail  or so
> [ 3209.752862] BTRFS info (device dm-6): disk space caching is enabled
> [ 3209.775418] BTRFS: failed to read the system array on dm-6
> [ 3209.807673] BTRFS: open_ctree failed
>
> blkid shows:
> /dev/mapper/raid0d1: LABEL="btrfs_space" UUID="01334b81-c0db-4e80-92e4-cac4da867651" UUID_SUB="a87c0954-e0d5-4cdb-acb9-05ed290c16df" TYPE="btrfs"
> /dev/mapper/raid0d2: LABEL="btrfs_space" UUID="01334b81-c0db-4e80-92e4-cac4da867651" UUID_SUB="b4ea90fa-4262-489a-830d-3bd4e7518ff2" TYPE="btrfs"
>
> but mount fails.
>
> And then:
> gargamel:~# btrfs dev scan
> Scanning for Btrfs filesystems
> gargamel:~# mount /var/local/space
> gargamel:~#
>
> Does this make any sense to you?

  Not really. Here we are trying to understand why the first 'btrfs dev
  scan' doesn't help. And, as I understand the first 'btrfs dev scan' is
  during boot up by some system'd script. But the above output seems to
  be taken from the terminal which is after the system has booted up.
  That does not help. We need those commands output during the bootup
  at the time and just before when systemd issues 'btrfs dev scan'.
  Hope I sound clearer now, sorry if it wasn't before.

Thanks, Anand


> Thanks,
> Marc
>
