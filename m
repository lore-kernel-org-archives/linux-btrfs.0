From: Nicholas Tung <gatoatigrado@gmail.com>
Subject: segmentation fault while running btrfsck
Date: Wed, 18 Apr 2012 01:34:48 -0700
Message-ID: <CAH55dvMzcduXnvrGP03cG=mJP7CwJm6mMCv2A3FVR8Rb_GaSNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

    One of my btrfs volumes got corrupted, and seems to be
unrecoverable. When I tried to run a recent version of btrfsck (built
from git), it crashed with a segmentation fault. I have a file
containing the first 8 GB (copied with "dd if=3D/dev/sda5 ..."), which
seems to reproduce the segmentation fault when using the btrfsck tool.
The volume shouldn't have any too-personal files (a different
partition handles "/home"), so I'm comfortable sharing it with any
longstanding btrfs developers (yeah, "/etc/passwd", but ... whatever).
I have access to a machine on UC Berkeley's network (w/ fast internet
access), so the 8GB shouldn't be a problem. Also, here is the output
from btrfsck (the "** Segmentation Fault **" is my annotation -- I
think it's printed by the shell according btrfsck's error code),
http://pastebin.com/3txgBn71 .

    I do need to use my computer, so I reformatted the partition with
ext4 after I couldn't get my data back. I hope this error can help
development of BTRFS though; it seems like a very promising
filesystem. A final note: the corruption of my partition was likely
due to some hardware instability problems -- it could either be
related to the SATA controller (some of the earlier Intel H67 Sandy
Bridge motherboards like mine had issues), bad SATA cables, or new SSD
(though, I ran badblocks, and it seemed okay ... and very fast, yay!).
The disk would unmount, and wouldn't be recognized by the motherboard
until I left the system off for a while.

Thanks,
Nicholas =E2=80=94=C2=A0https://ntung.com=C2=A0=E2=80=94=C2=A04432-nstu=
ng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
