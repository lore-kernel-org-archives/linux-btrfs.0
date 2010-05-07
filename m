From: jason chan <jascan88@gmail.com>
Subject: Snapshots and VM resrouce
Date: Fri, 7 May 2010 00:48:54 -0700
Message-ID: <k2h1495a7251005070048gf0172e50i523970b62f0a24ac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Try this:

create a 2GB file A in a subvolume vol_0
take a snapshot snap_1 of  vol_0

Now see if their shared disk blocks give rise to shared VM resource:

dd if=vol_0/A  of=/dev/null
dd if=snap_1/A  of=/dev/null

And you will discover that the 2 dd sessions take same amount of time
to complete, vmstat will show that they incurred same amount of disk
IO. Now shouldn't vfs/vm be smart enough to know that they are
identical disk blocks and save the disk IOs?
