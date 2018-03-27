Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42097 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751890AbeC0MQZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 08:16:25 -0400
Date: Tue, 27 Mar 2018 14:13:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Ashu Tiwary <ashuatibm@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Corruption on Big Endian System
Message-ID: <20180327121358.GP6955@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CACJ+inTx=1tfrx0V-2gwq08xxMxvzCq7oBPGcPnH8xUhtX4uBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACJ+inTx=1tfrx0V-2gwq08xxMxvzCq7oBPGcPnH8xUhtX4uBQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 26, 2018 at 10:00:04AM -0500, Ashu Tiwary wrote:
> It appears my system may have hit the issue reverted here (
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg74621.html
> ) ( [PATCH] Revert "btrfs: use proper endianness accessors for
> super_copy" ); system is an IBM OpenPower 720 (Big Endian) running
> Fedora 27; kernel was at 4.15.9; attempting to reboot after updating
> system (including kernel to 4.15.10) caused system to not be able to
> boot:
> 
> =====
>          Mounting /sysroot...
> [   34.644721] BTRFS warning (device dm-3): suspicious: generation <
> chunk_root_generation: 15959351903540740096 < 17261735521269317632
> [   34.644761] BTRFS info (device dm-3): disk space caching is enabled
> [   34.644771] BTRFS info (device dm-3): has skinny extents
> [   34.645925] BTRFS critical (device dm-3): unable to find logical
> 71472550772736 length 65536
> [   34.645941] BTRFS critical (device dm-3): unable to find logical
> 71472550772736 length 65536
> [   34.645952] BTRFS error (device dm-3): failed to read chunk root
> [   34.807156] BTRFS error (device dm-3): open_ctree failed
> [FAILED] Failed to mount /sysroot.
> =====
> 
> It appears there is a manual method available to repair the corrupted
> superblock: can that be made available?

Yes, details below.

Quick check from your logs:

chunk_root_generation: 15959351903540740096 = 0xdd7b020000000000
should be: 162781 = 0x0x27bdd

tree root block pointer: 71472550772736 = 0x410100000000
should be: 21037056 = 0x1410000

The tool is available in the branch devel in my repos.  Setup repository
unless you already have one:

$ git clone git://github.com/kdave/btrfs-progs
$ cd btrfs-progs
$ git checkout devel
$ ./autogen.sh
$ ./configure

Build the tool:

$ make btrfs-sb-mod

Use it (replace the path with the real one) and save the output in case
something goes unexpectedly wrong:

device=/path/to/the/device
./btrfs-sb-mod $device root @0
./btrfs-sb-mod $device generation @0
./btrfs-sb-mod $device chunk_root @0
./btrfs-sb-mod $device chunk_root_generation @0
./btrfs-sb-mod $device cache_generation @0
./btrfs-sb-mod $device uuid_tree_generation @0

It prints the current and new values so it's reversible, besides that
the byteswap can be run twice to get back to the starting point.

Then the filesystem should be mountable again.
