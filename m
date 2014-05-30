Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45886 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239AbaE3RYs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 13:24:48 -0400
Received: by mail-wg0-f44.google.com with SMTP id a1so2327772wgh.27
        for <linux-btrfs@vger.kernel.org>; Fri, 30 May 2014 10:24:46 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 30 May 2014 19:24:45 +0200
Message-ID: <CAPTapspXunvk531ONGAfPJmbGZ9M3bqY5qXtMLfMfYKZu41fKQ@mail.gmail.com>
Subject: Dead btrfs partition after hibernate
From: Thomas Loo <tloo@saltstorm.net>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Ok, I am turning to you guys as a last straw for help. Have been
running btrfs ontop of a LUKS encrypted device for some three months.
It's been working great up until last week, when I suddenly ended up
with an unmountable filesystem. This happened right after I woke up
the system from a hibernation cycle - noticed after login that the
filesystem was mounted readonly, so I did a reboot, without thinking
further about it. After that I am not able to mount the partition
period.

This is an Arch based setup with the latest everything and a
3.14-kernel. I have tried everything I can think of: rescue, restore
etc. in order to get it up again, or atleast get some of the data
back.

As far I can tell there seems to be some sort of corruption of the
csum and extent trees, but I am not familiar with the internals, so I
am basically stuck at that. Pasted below are a few command outputs
that might give you a better picture.


Thanks,
Thomas

# btrfs fi show

Label: 'home'  uuid: 911ddc1a-fa8e-445e-960d-2159b2765536
        Total devices 1 FS bytes used 72.24GiB
        devid    1 size 89.02GiB used 89.02GiB path /dev/mapper/home

Btrfs v3.14.2-dirty


# mount -o recovery /dev/mapper/home /mnt
# dmesg

[10141.943603] BTRFS: device label home devid 1 transid 160513 /dev/mapper/home
[10141.946969] BTRFS info (device dm-0): enabling auto recovery
[10141.946991] BTRFS info (device dm-0): disk space caching is enabled
[10141.949743] BTRFS: bad tree block start 15628847726759533615 360235008
[10141.949921] BTRFS: bad tree block start 15628847726759533615 360235008
[10141.950145] BTRFS: bad tree block start 15628847726759533615 360235008
[10141.950324] BTRFS: bad tree block start 15628847726759533615 360235008
[10141.950508] BTRFS: bad tree block start 15628847726759533615 359628800
[10141.950718] BTRFS: bad tree block start 15628847726759533615 359628800
[10141.950725] BTRFS: failed to read tree root on dm-0
[10141.950931] BTRFS: bad tree block start 15628847726759533615 356335616
[10141.951125] BTRFS: bad tree block start 15628847726759533615 356335616
[10141.951130] BTRFS: failed to read tree root on dm-0
[10141.951322] BTRFS: bad tree block start 15628847726759533615 354893824
[10141.951545] BTRFS: bad tree block start 15628847726759533615 354893824
[10141.951551] BTRFS: failed to read tree root on dm-0
[10142.005922] BTRFS: open_ctree failed



# btrfs restore /dev/mapper/home /mnt

Check tree block failed, want=360235008, have=15628847726759533615
Check tree block failed, want=360235008, have=15628847726759533615
Check tree block failed, want=360235008, have=15628847726759533615
Check tree block failed, want=360235008, have=15628847726759533615
Check tree block failed, want=360235008, have=15628847726759533615
read block failed check_tree_block
Couldn't setup extent tree
Check tree block failed, want=359825408, have=15628847726759533615
Check tree block failed, want=359825408, have=15628847726759533615
Check tree block failed, want=359825408, have=15628847726759533615
Check tree block failed, want=359825408, have=15628847726759533615
Check tree block failed, want=359825408, have=15628847726759533615
read block failed check_tree_block
Couldn't setup csum tree
Check tree block failed, want=359776256, have=15628847726759533615
Check tree block failed, want=359776256, have=15628847726759533615
Check tree block failed, want=359776256, have=15628847726759533615
Check tree block failed, want=359776256, have=15628847726759533615
Check tree block failed, want=359776256, have=15628847726759533615
read block failed check_tree_block



$ btrfs-find-root /dev/mapper/home

Super think's the tree root is at 360824832, chunk root 20987904
Well block 4194304 seems great, but generation doesn't match, have=2,
want=160513 level 0
Well block 4243456 seems great, but generation doesn't match, have=3,
want=160513 level 0
Well block 218316800 seems great, but generation doesn't match,
have=160432, want=160513 level 0
Found tree root at 360824832 gen 160513 level 1


# btrfs rescue super-recover -v /dev/mapper/home

All Devices:
        Device: id = 1, name = /dev/mapper/home

Before Recovering:
        [All good supers]:
                device name = /dev/mapper/home
                superblock bytenr = 65536

                device name = /dev/mapper/home
                superblock bytenr = 67108864

        [All bad supers]:

All supers are valid, no need to recover



# btrfs rescue chunk-recover -v /dev/mapper/home

All Devices:
        Device: id = 1, name = /dev/mapper/home

DEVICE SCAN RESULT:
Filesystem Information:
        sectorsize: 4096
        leafsize: 16384
        tree root generation: 160513
        chunk root generation: 115793

All Devices:
        Device: id = 1, name = /dev/mapper/home

... long chunk + block list truncated out...
full dump here: <http://pastebin.com/s9pyp7e6>


Total Chunks:   92
  Heathy:       92
  Bad:  0

Orphan Block Groups:

Orphan Device Extents:
Check chunks successfully with no orphans
Recover the chunk tree successfully.
