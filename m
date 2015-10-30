Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:34455 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275AbbJ3Bn3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 21:43:29 -0400
MIME-Version: 1.0
Date: Fri, 30 Oct 2015 09:43:28 +0800
Message-ID: <CAGnHSEm4UND4aUuFMDesXQYiTGWFzv+tk1OEvMOj+6KRHC-MPw@mail.gmail.com>
Subject: bad handling of unpartitioned device in sysfs_devno_to_wholedisk()
 (which breaks mkfs.btrfs)
From: Tom Yan <tom.ty89@gmail.com>
To: util-linux@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, elliott@hpe.com, ahferroin7@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I noticed that SSD detection does work on unpartitioned devices in
mkfs.btrfs somehow:
https://bugzilla.kernel.org/show_bug.cgi?id=102921

Later I found out that it breaks at blkid_devno_to_wholedisk() in is_ssd():
http://git.kernel.org/cgit/linux/kernel/git/kdave/btrfs-progs.git/tree/mkfs.c?h=v4.2.3#n1103

which Elliot had shown an example with strace:
https://lists.01.org/pipermail/linux-nvdimm/2015-September/002109.html

And I think the problem occurs in the sysfs_get_devname() here:
https://git.kernel.org/cgit/utils/util-linux/util-linux.git/tree/lib/sysfs.c?h=v2.27#n785

Since sysfs_get_devname() has to call sysfs_readlink() later, which
output a long full device path in /sys, I don't think we should call
it directly with the buffer "diskname", which people won't expect that
it has to be large enough to carry the path in the middle of the
process. For example in is_sdd(), a char array of size 32 is used
("wholedisk").
