From: Erik Jensen <eriksjunk@rkjnsn.net>
Subject: Recovering data from old corrupted file system
Date: Mon, 21 Nov 2011 19:19:44 -0800
Message-ID: <CAGh96GFUS-1X-o8n+N_fCRc=6nViru+tM9obJMgSYuLf7D-MpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have a corrupted multi-device file system that got corrupted ages
ago (as I recall, one of the drives stopped responding, causing btrfs
to panic). I am hoping to recover some of the data. For what it's
worth, here is the dmesg output from trying to mount the file system
on a 3.0 kernel:

device label Media devid 6 transid 816153 /dev/sdq
device label Media devid 7 transid 816153 /dev/sdl
device label Media devid 11 transid 816153 /dev/sdj
device label Media devid 9 transid 816153 /dev/sdk
device label Media devid 10 transid 816153 /dev/sdi
device label Media devid 3 transid 816152 /dev/sdh
device label Media devid 4 transid 816152 /dev/sdf
device label Media devid 1 transid 816152 /dev/sdg
device label Media devid 2 transid 816152 /dev/sde
device label Media devid 8 transid 816153 /dev/sdb
parent transid verify failed on 47051597279232 wanted 816153 found 816151
parent transid verify failed on 47051597279232 wanted 816153 found 816151
parent transid verify failed on 47051597279232 wanted 816153 found 816151

Most of the data is unimportant at this point, and I don't have enough
extra space elsewhere to store it all anyway. Is there any way I could
get a read-only view of the file system to pull off the bits I need?

Any help would be greatly appreciated.

Thanks.

-- Erik Jensen
