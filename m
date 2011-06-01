From: Jacques <jacques.louw.za@gmail.com>
Subject: btrfs kernel module crash
Date: Wed, 01 Jun 2011 19:21:02 +0200
Message-ID: <4DE674FE.7040809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I have been using btrfs as my / partition on my fedora 14 box for a
while now and until yesterday it was working a treat.

Had an unexpected power fail during the night and now my os crashes when
mounting /

Most of my data is backed up, but there is some data which I don't want
to lose on the partition...

I put the drive in a SATA - USB cradle and hooked it to my fedora 13
laptop which promptly became unresponsive.

So I upgraded the laptop to fc15 and installed the latest 2.6.39.1
kernel from rawhide. When I try to mount the first time I get the
following crash: http://pastebin.com/qA3kztzh but at least the system
stays alive. When I manually try to 'mount /dev/sdb5 /mnt' the process
just stalls, can't even crtl+c to quit.

On recommendations from the IRC folks I compiled the git
btrfs-progs-unstable including the 'btrfs-zero-logs' tool. I have tried
running the tool against the affected partition to no avail, no error
messages either.

btrfsck reports no errors either: http://pastebin.com/P4uXteLC

I have no idea where to go from here, if anyone can help it would be
much appreciated!
