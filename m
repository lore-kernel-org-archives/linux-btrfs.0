Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33867 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192AbbEEBmV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 May 2015 21:42:21 -0400
Received: by oiko83 with SMTP id o83so126458918oik.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2015 18:42:20 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 4 May 2015 18:42:20 -0700
Message-ID: <CAA=o1pmDtxRCgWZjUwazq8G+ch__oMAdXLUhnu3-N7ieASZO_Q@mail.gmail.com>
Subject: fstab: use UUID or labe?
From: Rory Jaffe <rsjaffe@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Question about fault tolerance and choice of ID. I'm running btrfs
with subvolumes for / and /home. /boot and grub are on a thumb drive.
I have six drives in the system, running raid1 for both data and
metadata.

When I run "sudo btrfs fi show" it provides both the label and the
uuid. The UUID shown is the same as that for the first partition that
btrfs was installed on.

In fstab, the mount points currently use that UUID to identify the file system.

If the original drive fails, will that UUID still point to the
filesystem, or is it better to use the label for the filesystem? Will
the filesystem mount in either case with the failure of the original
drive?

Thanks

Rory
