Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:32870 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966184AbcA0VJW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jan 2016 16:09:22 -0500
Received: by mail-oi0-f52.google.com with SMTP id r14so14058751oie.0
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Jan 2016 13:09:22 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 27 Jan 2016 16:09:21 -0500
Message-ID: <CA+-0u-YhEBy7jDoJZeZG4hbkj+oxmTJOcxmnMCueEb6+XTZ2Sg@mail.gmail.com>
Subject: btrfs subvolume list -o does not behave as expected
From: "Daniel E. Shub" <daniel.e.shub@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am experiencing what I think might be a bug with: btrfs subvolume list -o

I reported it at https://bugzilla.kernel.org/show_bug.cgi?id=109861,
but have read that bugs should be sent to the mailing list also.

My root file system is on a btrfs partition and I have created btrfs
subvolumes in /chroot and /var/lib. The following behavior seems
incorrect

# btrfs subvolume list -o /chroot
ID 593 gen 6616 top level 5 path chroot/base-devel/root
ID 594 gen 6618 top level 5 path chroot/multilib-devel/root
ID 595 gen 6620 top level 5 path chroot/base/root
ID 597 gen 6624 top level 5 path chroot/twm/root
ID 599 gen 6628 top level 5 path chroot/lxde/root
ID 601 gen 6655 top level 5 path chroot/wheezy/root
ID 602 gen 6684 top level 5 path chroot/sid/root
ID 603 gen 6862 top level 5 path var/lib/machines

The man page for btrfs subvolume says
  -o print only subvolumes below specified <path>.

so I expected to only see the subvolumes below /chroot and to not see
/var/lib/machines/.

I am running Arch Linux with the 4.2.5 kernel and btrfs-progs v4.3.1.
