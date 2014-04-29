Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f198.google.com ([209.85.216.198]:62609 "EHLO
	mail-qc0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbaD2VuV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 17:50:21 -0400
Received: by mail-qc0-f198.google.com with SMTP id r5so2687956qcx.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 14:50:20 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 29 Apr 2014 14:44:08 -0700
Message-ID: <CAEm7Kty8sgL850nOPUG3DGmAjJmJZuAPL-EAseRWVD=-i3_RYw@mail.gmail.com>
Subject: EBS volumes with identical UUIDs + btrfs
From: Brandon Philips <brandon@ifup.co>
To: linux-btrfs@vger.kernel.org
Cc: Michael Marineau <mike@marineau.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello All-

I attached an AWS EBS volume to `xvdh` that was from a terminated EC2
machine to another machine. The filesystem shared a btrfs UUID since
they came from an identical install. When I mounted the new EBS volume
to /mnt something very odd happened:

Before:

$ mount
/dev/xvda9 on / type btrfs (rw,relatime,ssd,space_cache)
/dev/xvda3 on /usr type ext4 (ro,relatime)

After:

# mount /dev/xvdh9 /mnt

# mount
/dev/xvdh9 on / type btrfs (rw,relatime,ssd,space_cache)
/dev/xvdh9 on /mnt type btrfs (rw,relatime,ssd,space_cache)

It seems that btrfs gets very confused when there are matching UUIDs
and /mnt didn't contain the contents that I expected. To work around
the issue I booted a non-identical machine image that had a different
btrfs UUID and attached the backup EBS volume again and everything
worked as expected.

What is the right way of handling this? Attaching EBS volumes from
snapshots or old identical machines is a common use case.

Thanks!

Brandon
