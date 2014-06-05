Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:55802 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFEKPd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 06:15:33 -0400
Received: by mail-lb0-f178.google.com with SMTP id w7so424076lbi.37
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 03:15:31 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 5 Jun 2014 10:15:31 +0000
Message-ID: <CAMNwjE+6vfbtTFSr_sfYzQxaj4q3QFRDN5jUkFGuzN7XwtH9SA@mail.gmail.com>
Subject: Means for userspace to know the used space (not allocated space) in a
 device of a multi-device filesystem
From: pkoroau pkoroau <pkoroau@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs filesystem show displays allocated space, but how can userspace
know how much space is used on each device?

In #btrfs channel on freenode.net, it was answered that the
TREE_SEARCH ioctl can be used to inspect the data structures, and that
btrfs-gui does this (thanks @darkling): http://carfax.org.uk/btrfs-gui

However, it would be good if third-party applications had means to get
this information from btrfs, without reimplementing what btrfs-gui
does.

For example, partitioning tools would be able to show an accurate
number, rather than 0 or an estimate.

Please, implement something in btrfs that returns this information.

Thanks
