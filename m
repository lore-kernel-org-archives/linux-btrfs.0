From: Christoph Groth <cwg@falma.de>
Subject: btrfs csum failed, scrub ok
Date: Tue, 27 Mar 2012 12:57:31 +0200
Message-ID: <87haxawbtw.fsf@falma.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have a freshly installed system with btrfs as the root file system.
The machine is running linux 3.2.  The raid1 btrfs file system lives on
two new hard drives.

About one day after installation the following message appeared in
kern.log.  There were no other errors.

root@mim:/var/log# grep 'btrfs.*fail' kern.log
Mar 27 01:07:46 mim kernel: [ 6480.233861] btrfs csum failed ino 453509 off 1495040 csum 3301532933 private 4156998194
Mar 27 01:07:46 mim kernel: [ 6480.234470] btrfs csum failed ino 453509 off 1499136 csum 1873118812 private 3512102188
Mar 27 01:07:46 mim kernel: [ 6480.234572] btrfs csum failed ino 453509 off 1503232 csum 1034640717 private 2041007647
Mar 27 01:07:46 mim kernel: [ 6480.234670] btrfs csum failed ino 453509 off 1507328 csum 889729013 private 2342095239
Mar 27 01:07:46 mim kernel: [ 6480.237977] btrfs csum failed ino 453509 off 1503232 csum 1518679450 private 2041007647
Mar 27 01:07:46 mim kernel: [ 6480.238149] btrfs csum failed ino 453509 off 1507328 csum 889729013 private 2342095239
Mar 27 01:07:46 mim kernel: [ 6480.238330] btrfs csum failed ino 453509 off 1495040 csum 3234580989 private 4156998194
Mar 27 01:07:46 mim kernel: [ 6480.238447] btrfs csum failed ino 453509 off 1499136 csum 1873118812 private 3512102188
Mar 27 01:07:46 mim kernel: [ 6480.243873] btrfs csum failed ino 453509 off 1503232 csum 2184012753 private 2041007647
Mar 27 01:07:46 mim kernel: [ 6480.243962] btrfs csum failed ino 453509 off 1507328 csum 240604621 private 2342095239

inode 453509 belongs to a file installed by dpkg

root@mim:/# find / -inum 453509 -ls
453509 1976 -rw-r--r--   1 root     root      2020832 Mar  7 21:11 /usr/lib/libreoffice/basis3.4/program/libsblx.so

That file seems to be ok, there are no errors when re-reading it.

A scrub done the morning after the incident also didn't find any
problems:

root@mim:/home/cwg# btrfs scrub status /
scrub status for 2da00153-f9ea-4d6c-a6cc-10c913d22686
	scrub started at Tue Mar 27 10:37:49 2012 and finished after 3921 seconds
	total bytes scrubbed: 550.20GB with 0 errors

Also inspecting the SMART status of the hard drives does not reveal any
problems.

Is this a bug in btrfs, or am I supposed to be afraid that the new hard
drives are not working reliably?  Or could this be the effect of some
cosmic ray hitting my machine?  (It doesn't have ECC.)  Or is it normal
that hard drives sometimes make errors?  (In that case the additional
layer of btrfs checksumming seems to be a very good thing.)

Christoph

