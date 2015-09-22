Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33685 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506AbbIVLz0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 07:55:26 -0400
Received: by oixx17 with SMTP id x17so3610949oix.0
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 04:55:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFENT7KRPVkkezyddhRXcbNKVftu6VsbrioEY4JTy1FV9jOjXQ@mail.gmail.com>
References: <CAFENT7LzCRHX3p-zSrk1ECjo0JQ6=49W=Om9P-2g4x+dpAM2pw@mail.gmail.com>
 <CAFENT7KRPVkkezyddhRXcbNKVftu6VsbrioEY4JTy1FV9jOjXQ@mail.gmail.com>
From: Sylvain Joyeux <sylvain.joyeux@m4x.org>
Date: Tue, 22 Sep 2015 08:55:05 -0300
Message-ID: <CAFENT7L=hq8uRZ=YU2gRm9S3xfDBLx=BJuFuMuEex_PWDyWLkA@mail.gmail.com>
Subject: Re: BTRFS kernel error on mounted partition. Partition has errors
 detected but not repaired by btrfs-check.
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

Hopefully, third time's the charm ... this time I'm subscribed.

(NB: sorry if you got this twice, but it did not appear in the ML
archives so I'm assuming it never reached the ML ...)

I am in the situation where a partition has errors, detected by
btrfs-check but not repaired by it. Mounting the partition causes
always the same kernel errors to be reported on dmesg.

I get these errors with a 4.2 kernel and btrfs-progs 4.2. The
partition has been used on a mixture of 4.0.7 and 4.2 kernels (I have
to reboot on 4.0 when I need to use the NVidia card), and I really am
unable to pinpoint whether it happened first on 4.0 or 4.2...

I use this partition mostly as a target for btrfs send / btrfs receive
- type backups (synchronization of snapper-based snapshotting), and
really did nothing fancy beyond that (which, well, is in itself
fancy). So, no big deal for now for me, I just thought that a
non-repairable corrupted filesystems could be of interest.

Attached:
 - the output of btrfs check. btrfs check --repair does not fix them.
 - the dmesg output with the kernel errors

I can provide the partition image as created by btrfs-image, but it's
230MB in size, don't know where to put it

Note: since it was a week or so ago, I reinitialized the partition,
and just got the exact same problem today. The only thing a bit out of
the ordinary about this partition is that it is mounted in two
different places, and that I have some VMs on it, and am using the
nocow attribute on the VM files.

Regards,
Sylvain
