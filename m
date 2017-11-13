Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54978 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752719AbdKMWwk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Nov 2017 17:52:40 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 926DEACCF
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Nov 2017 22:52:39 +0000 (UTC)
Date: Mon, 13 Nov 2017 23:50:46 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: Read before you deploy btrfs + zstd
Message-ID: <20171113225046.GD28899@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

while 4.14 is still fresh, let me address some concerns I've seen on linux
forums already.

The newly added ZSTD support is a feature that has broader impact than
just the runtime compression. The btrfs-progs understand filesystem with
ZSTD since 4.13. The remaining key part is the bootloader.

Up to now, there are no bootloaders supporting ZSTD. This could lead to an
unmountable filesystem if the critical files under /boot get accidentally
or intentionally compressed by ZSTD.

There are several ways how to get around that:

- separate boot partition, no zstd there

- reset potential compression of /boot/* files to something supported, eg.
  $ btrfs filesystem defrag -r -czlib /boot/*
  or
  $ btrfs filesystem defrag -r -clzo /boot/*

To see if there are zstd files:

$ find /boot -print -exec sudo btrfs prop get '{}' compression \; | grep -B1 zstd

There might be other workarounds but I want to keep the advice simple.

d.
