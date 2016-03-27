Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35772 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbcC0EnI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Mar 2016 00:43:08 -0400
Received: by mail-ig0-f182.google.com with SMTP id cl4so34015056igb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Mar 2016 21:43:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160327035038.5ab6e64b@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
	<56F1068E.6050806@cn.fujitsu.com>
	<20160322194854.161e9c4c@jupiter.sol.kaishome.de>
	<56F21898.3020101@cn.fujitsu.com>
	<20160326203035.4b876a04@jupiter.sol.kaishome.de>
	<20160327035038.5ab6e64b@jupiter.sol.kaishome.de>
Date: Sat, 26 Mar 2016 22:43:06 -0600
Message-ID: <CAJCQCtR0uMeZ4cKsKsLYn8Wn9rTihwnLTq-FETazdheewTq6kA@mail.gmail.com>
Subject: Re: csum errors in VirtualBox VDI files
From: Chris Murphy <lists@colorremedies.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 26, 2016 at 7:50 PM, Kai Krakow <hurikhan77@gmail.com> wrote:

>
> # now let's wait for the backup to mount the FS and look at dmesg:
>
> [21375.606479] BTRFS info (device sde1): force zlib compression
> [21375.606483] BTRFS info (device sde1): using free space tree

You're using space_cache=v2. You're aware new free space tree option
sets a read only incompat feature flag on the file system? You've got
quite a few non-default mount options on this backup volume. Hopefully
Qu has some idea what to try next or if you're better off just
starting over with a new file system.



> I only saw unreliable behavior with 4.4.5, 4.4.6, and 4.5.0 tho the
> problem may exist longer in my FS.
>
> $ sudo btrfs-show-super /dev/sde1
> superblock: bytenr=65536, device=/dev/sde1
> ---------------------------------------------------------
> csum                    0xcc976d97 [match]
> bytenr                  65536
> flags                   0x1
>                         ( WRITTEN )
> magic                   _BHRfS_M [match]
> fsid                    1318ec21-c421-4e36-a44a-7be3d41f9c3f
> label                   usb-backup
> generation              50814
> root                    1251250159616
> sys_array_size          129
> chunk_root_generation   50784
> root_level              1
> chunk_root              2516518567936
> chunk_root_level        1
> log_root                0
> log_root_transid        0
> log_root_level          0
> total_bytes             2000397864960
> bytes_used              1860398493696
> sectorsize              4096
> nodesize                16384
> leafsize                16384
> stripesize              4096
> root_dir                6
> num_devices             1
> compat_flags            0x0
> compat_ro_flags         0x1
> incompat_flags          0x169
>                         ( MIXED_BACKREF |
>                           COMPRESS_LZO |
>                           BIG_METADATA |
>                           EXTENDED_IREF |
>                           SKINNY_METADATA )
> csum_type               0
> csum_size               4
> cache_generation        50208
> uuid_tree_generation    50742
> dev_item.uuid           9008d5a0-ac7b-4505-8193-27428429f953
> dev_item.fsid           1318ec21-c421-4e36-a44a-7be3d41f9c3f [match]
> dev_item.type           0
> dev_item.total_bytes    2000397864960
> dev_item.bytes_used     1912308039680
> dev_item.io_align       4096
> dev_item.io_width       4096
> dev_item.sector_size    4096
> dev_item.devid          1
> dev_item.dev_group      0
> dev_item.seek_speed     0
> dev_item.bandwidth      0
> dev_item.generation     0
>
>
>
> BTW: btrfsck thinks that the space tree is invalid every time it is
> run, no matter if cleanly unmounted, uncleanly unmounted, or "btrfsck
> --repair" and then ran a second time.


-- 
Chris Murphy
