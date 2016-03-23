Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35549 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505AbcCWRls (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Mar 2016 13:41:48 -0400
Received: by mail-io0-f180.google.com with SMTP id v187so24274667ioe.2
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Mar 2016 10:41:48 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 23 Mar 2016 17:41:40 +0000
Message-ID: <CAO5K3OeqQUx18gjHNVcOK8=Zo=JLOJhHBJz4jdti73DGakeAfQ@mail.gmail.com>
Subject: btrfs ways to travel back in time
From: Vytautas D <vytdau@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I can think of few ways to revert changes with btrfs, but I wonder
what are the trade-offs between each method and perhaps there is
already research done on this?

ways to restore a snapshot ( post kernel 3.* ):
a) via set-default
 1. btrfs subvolume set-default / $id
 2. reboot
b) always mount into snapshot
 1. mount -o suvol=/.current $disk # at initrd
 2. btrfs subvol del /.current
 3. btrfs subvol snapshot /.snapshotA /.current
 4. reboot
c) rsync
 1. rsync $options /.snapshotA /.current
 2. reboot

- Vytas Dauksa
