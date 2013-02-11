Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:54806 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab3BKNJ5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 08:09:57 -0500
Received: by mail-vc0-f169.google.com with SMTP id n10so3863037vcn.28
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2013 05:09:56 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 11 Feb 2013 14:09:56 +0100
Message-ID: <CAMqPLXVezXkqMPn3R56HTVkgPTN859fjukyr06dgtCFPme0Lug@mail.gmail.com>
Subject: btrfs-progs 0.20rc1.1, linux 3.7.6 - new filesystem: failed to
 recover relocation
From: Sjon Hortensius <Sjon@hortensius.net>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have just completed installing an archlinux machine with 2 btrfs
partitions, one works fine (the rootfs), the other one I cannot mount.
Even after recreating the filesystem I still cannot mount it. I
receive te following output in my dmesg:

[ 6526.037089] device fsid 74cc8eb8-f60a-4797-9ab3-0c8ac4fe847f devid
1 transid 3 /dev/vdb1
[ 6526.037763] btrfs: disk space caching is enabled
[ 6526.038415] btrfs: failed to recover relocation
[ 6526.039716] btrfs: open_ctree failed

this is on a virtual machine using libvirt, a virtio hdd and kvm;
btrfsck reports no errors. An image of this filesystem can be found
here: http://home.react.nl/~sjon/bug-reports/btrfs/btrfs-failed-to-recover-relocation
(29 KiB)

After recreating the same filesystem again on a smaller (100Mb)
filesystem btrfsck reports:

Check tree block failed, want=139264, have=0
Check tree block failed, want=139264, have=0
Check tree block failed, want=139264, have=0
read block failed check_tree_block
Couldn't read chunk root

and btrfs-image segfaults on this. I have dumped the partition with
dd, it can be found here:
http://home.react.nl/~sjon/bug-reports/btrfs/vdb1.raw.gz (98 KiB).

I couldn't find any recent reports mentioning these sort of problems.

Thanks,
Sjon Hortensius
