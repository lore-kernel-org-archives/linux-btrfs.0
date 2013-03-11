Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:58421 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3CKWo7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 18:44:59 -0400
Received: by mail-ob0-f173.google.com with SMTP id dn14so3908539obc.18
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2013 15:44:59 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 22:44:58 +0000
Message-ID: <CAF8C-HiwkgnuMOgq_4AGYoK9pOKZoL-WGYVFc497BuU+_z2GbQ@mail.gmail.com>
Subject: Unable to boot btrfs filesystem, and btrfsck aborts
From: Matthew Booth <matthew@heisenbug.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My laptop crashed hard earlier today. It reset immediately to a black
screen followed by the BIOS. I have no idea why.

However, it now fails to boot. I took a picture of the kernel panic
that results from trying to mount the root filesystem:
https://plus.google.com/107763699965053810188/posts/QZZt7GYzBZi

To make things worse, btrfsck aborts with a double free, without
fixing it. I took a picture of that, too:
https://plus.google.com/107763699965053810188/posts/gKYqGgFhWyT

As the kernel panic mentions btrfs_remove_free_space, I also tried
mounting with clear_cache. Unfortunately it didn't dislodge anything.

This is on a fully updated Fedora 18 system. I would really like to
get this data back. If anybody could offer a suggestion I'd be very
grateful.

Thanks,

Matt
