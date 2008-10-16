From: rektide <rektide@gmail.com>
Subject: raid 1 / raid 10
Date: Thu, 16 Oct 2008 04:12:48 -0400
Message-ID: <1df9a2bf0810160112wff9e874x1f949dd704fa1480@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

I recently checked out btrfs and have started putting it through its
paces.  I tried a raid10 and then a raid1, as so:

mkfs.btrfs -m raid10 -d raid10 /dev/sda5 /dev/sdb5 /dev/sdc5 /dev/sdd5

and

mkfs.btrfs -m raid1 -d raid1 /dev/sda5 /dev/sdb5 /dev/sdc5 /dev/sdd5


In both cases after mounting /dev/sda5 /mnt, df -h reported 4 *
partition size.  Is df lying, or is replication not happening right
now?  I also noticed that when I copied a file on to /mnt, I had to
sync before the available file size was affected.  Also, I did not
read or write much, but only the first two disks /dev/sda5 and
/dev/sdb5 had their access lights going while I was using -m raid1 and
-d raid1.  Is there any case where the third and fourth disks would be
used with -m raid1 -d raid1?


I've been writing Copy-On-Write software for a while now and believe
strongly that it is "the right way" to do almost all data operations.
There are manifest benefits in the filesystem domain for users, and am
glad to see such an amazingly slick & easy to use competitor appear on
the scene.  I look forward to btrfs becoming disk format stable so I
can more wholeheartedly embrace it.


I spent quite a few hours late last night playing with Linux raid10
and ext4; setting stride and stripe sizes.  Tonight I briefly toyed
with btrfs and found it to be a far more pleasurable experience, and I
got considerably higher performance metrics (using simple bonnie++
pleasurements).  My CPU usage is considerably higher, but I find that
I dont mind that knowing there is real consistency checking ongoing.


Thank you all for this great effort.

rektide
