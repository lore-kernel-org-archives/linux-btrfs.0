Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:41708 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751499AbcJZBDu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 21:03:50 -0400
Received: from [192.168.0.32] (adsl.bouton.name [82.234.193.23])
        by mail.bouton.name (Postfix) with ESMTP id DF252B893
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Oct 2016 02:57:05 +0200 (CEST)
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Lionel Bouton <lionel-subscription@bouton.name>
Subject: Compression and device replace on raid10 kernel panic on 4.4.6 and
 4.6.x
Message-ID: <b1fd641c-7047-e83c-83ff-582c6abfb815@bouton.name>
Date: Wed, 26 Oct 2016 02:57:05 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm currently trying to recover from a disk failure on a 6-drive Btrfs
RAID10 filesystem. A "mount -o degraded" auto-resumes a current
btrfs-replace from a missing dev to a new disk. This eventually triggers
a kernel panic (and the panic  seemed faster on each new boot). I
managed to cancel the replace, hoping to get a usable (although in
degraded state) system this way.

This is a hosted system and I just managed to have a basic KVM connected
to the rescue system where I could capture the console output after the
system stopped working.
This is on a 4.6.x kernel (I didn't have the opportunity to note down
the exact version yet) and I got this :

http://imgur.com/a/D10z6

The following elements in the stack trace caught my attention because I
remembered seeing some problems with compression and recovery reported
here :
clean_io_failure, btrfs_submit_compressed_read, btrfs_map_bio

I found discussions on similar cases (involving clean_io_failure,
btrfs_submit_compressed_read, btrfs_map_bio) but it isn't clear to me if :
- the filesystem is damaged to the point where my best choice is
restoring backups and generating data again (a several days process but
I can manage to bring back the most important data in less than a day),
- a simple kernel upgrade can work around this (I currently run 4.4.6
with the default Gentoo patchset which probably trigger the same kind of
problem although I don't have a kernel panic screenshot yet to prove it).

Other miscellanous informations :

Another problem is that corruption happened at least 2 times on the
single subvolume hosting only nodatacow files (a PostgreSQL server). I'm
currently restoring backups for this data on mdadm raid10 + ext4 as it
is the most used service of this system...

The filesystem is quite old (it probably began its life with 3.19 kernels).

It passed a full scrub with flying colors a few hours ago.

A btrfs check in the rescue environment found this :
checking extents
checking free space cache
checking fs roots
root 4485 inode 608 errors 400, nbytes wrong
found 3136342732761 bytes used err is 1
total csum bytes: 6403620384
total tree bytes: 12181405696
total fs tree bytes: 2774007808
total extent tree bytes: 1459339264
btree space waste bytes: 2186016312
file data blocks allocated: 7061947838464
 referenced 6796179566592
Btrfs v3.17

The subvolume 4485 inode 608 was a simple text file. I saved a copy,
truncated/deleted it and restored it. btrfs check didn't complain at all
after this.

Currently compiling a 4.8.4 kernel with Gentoo patches. I can easily try
4.9-rc2 mainline or even a git tree if needed.
I can use this system without trying to replace the drive for a few days
if it can work reliably in this state. If I'm stuck with replace not
working another solution I can try is adding one drive and deleting the
missing one if this works and is the only known way to work around this.

I have the opportunity to do some (non destructive) tests between 00:00
and 03:00 (GMT+2) or more if I don't fall asleep at the keyboard. This
has 6+TB of data and a total of 41 subvolumes (most of them snapshots).

Best regards,

Lionel
