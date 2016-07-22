Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:36350 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbcGVVQD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Jul 2016 17:16:03 -0400
Received: by mail-oi0-f43.google.com with SMTP id w18so180036008oiw.3
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jul 2016 14:16:02 -0700 (PDT)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 22 Jul 2016 15:16:01 -0600
Message-ID: <CAJCQCtQOV4gsh-Kaz6n=d9KBYCyOh9eb65-G8KBd8B_HJ_tNBg@mail.gmail.com>
Subject: qcow2 becomes 37P in size while qemu crashes
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is the bug write up so far, which contains most of the relevant details.
https://bugzilla.redhat.com/show_bug.cgi?id=1359325

Here are three teasers to get you to look at the bug:

1.
[root@f24m ~]# ls -lsh /var/lib/libvirt/images
total 57G
1.5G -rw-r-----. 1 qemu qemu 1.5G Jul 21 10:54
Fedora-Workstation-Live-x86_64-24-1.2.iso
1.4G -rw-r--r--. 1 qemu qemu 1.4G Jul 20 13:28
Fedora-Workstation-Live-x86_64-Rawhide-20160718.n.0.iso
4.4G -rw-r-----. 1 qemu qemu 4.4G Jul 22 10:43
openSUSE-Leap-42.2-DVD-x86_64-Build0109-Media.iso
 50G -rw-r--r--. 1 root root  37P Jul 22 13:23 uefi_opensuseleap42.2a3-1.qcow2
196K -rw-r--r--. 1 root root 193K Jul 22 08:46 uefi_opensuseleap42.2a3-2.qcow2
[root@f24m ~]#

Yes, it's using 50G worth of sectors on the drive. But then it's 37
Petabytes?! That's really weird.

[root@f24m ~]# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda5       104G   67G   36G  65% /

2.
Btrfs mounts, reads, writes, just fine, no messages in dmesg other
than the usual mount messages; all before, during, and after the qemu
crash, and rebooting. I rebooted to do an offline btrfs check, which
has no complaints. Scrub has no complaints. Yes the qcow2 has +C xattr
set so there's no independent way to determine if/hoe it's corrupt.
But qemu-img does say it's corrupt and libvirt will not start the VM
anymore with this qcow2 attached.

3.
I've attached to the bug a filefrag -v output from the 37 P file,
which has ~900 extents. There's only one thing that's a bit out of the
ordinary, which is mentioned in the bug.

Pretty weird. To try to reproduce this I kinda need to delete that
qcow2 file. So if anyone has suggestions on what other information to
put in that bug report before I change the state of the system, lemme
know.

-- 
Chris Murphy
