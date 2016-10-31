Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21808 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753056AbcJaBC7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Oct 2016 21:02:59 -0400
Subject: Re: btrfs check --repair: ERROR: cannot read chunk root
To: Marc MERLIN <marc@merlins.org>, <linux-btrfs@vger.kernel.org>
References: <20161030183437.GA3287@merlins.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <062d36da-197f-6a58-0b6e-208a5ca9fef3@cn.fujitsu.com>
Date: Mon, 31 Oct 2016 09:02:50 +0800
MIME-Version: 1.0
In-Reply-To: <20161030183437.GA3287@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 10/31/2016 02:34 AM, Marc MERLIN wrote:
> I have a filesystem on top of md raid5 that got a few problems due to the
> underlying block layer (bad data cable).
> The filesystem mounts fine, but had a few issues
> Scrub runs (I didn't let it finish, it takes a _long_ time)
> But check --repair won't even run at all:
>
> myth:~# btrfs --version
> btrfs-progs v4.7.3
> myth:~# uname -r
> 4.8.5-ia32-20161028
>
> myth:~# btrfs check -p --repair  /dev/mapper/crypt_bcache0  2>&1 | tee
> /var/spool/repair
> bytenr mismatch, want=13835462344704, have=0
> ERROR: cannot read chunk root

Your chunk root is corrupted, and since chunk tree provides the 
underlying disk layout, even for single device, so if we failed to read 
it, then it will never be able to be mounted.

You could try to use backup chunk root.

"btrfs inspect-internal dump-super -f" to find the backup chunk root, 
and use "btrfs check --chunk-root <backup chunk root bytenr>" to have 
another try.

Thanks,
Qu
> Couldn't open file system
> enabling repair mode
> myth:~#
>
> myth:~# btrfs rescue super-recover -v /dev//mapper/crypt_bcache0
> All Devices:
>         Device: id = 1, name = /dev//mapper/crypt_bcache0
>
> Before Recovering:
>         [All good supers]:
>                 device name = /dev//mapper/crypt_bcache0
>                 superblock bytenr = 65536
>
>                 device name = /dev//mapper/crypt_bcache0
>                 superblock bytenr = 67108864
>
>                 device name = /dev//mapper/crypt_bcache0
>                 superblock bytenr = 274877906944
>
>         [All bad supers]:
>
> All supers are valid, no need to recover
>
>
> I don't care about the data, it's a backup array, but I'd still like to know
> if I can recover from this state and do a repair to see how much data got
> damaged
>
> Thanks,
> Marc
>


