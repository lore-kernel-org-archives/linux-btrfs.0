Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56595 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab3LPNqg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 08:46:36 -0500
Date: Mon, 16 Dec 2013 14:46:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Shilong Wang <wangshilong1991@gmail.com>
Cc: Philipp Matthias Hahn <pmhahn@pmhahn.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG] open_ctree() failes after mounting BTRFS with 3.2 after
 3.12
Message-ID: <20131216134635.GC6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20131214095845.GA21618@pmhahn.de>
 <CAP9B-Q=0wWxXH5usnOq6MGN-LQZfw5y8dxgLZYidu_oPsOxrjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAP9B-Q=0wWxXH5usnOq6MGN-LQZfw5y8dxgLZYidu_oPsOxrjQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 15, 2013 at 10:03:35PM +0800, Shilong Wang wrote:
> I compile btrfs in kernel 3.2 and 3.12.
> 
> # mkfs.btrfs  -f /dev/sda2
> # mount /dev/sda2  /mnt
> # dd if=/dev/zero of=/mnt/data bs=1M count=1024
> # umount /mnt
> 
> The above operations is in 3.2
> 
> and then i switch my system into 3.12, and try to mount /dev/sda2
> it will output something like the following:
> 
> btrfs: mismatching generation and generation_v2 found in root item.
> This root was probably mounted with an older kernel. Resetting all new
> fields.
> 
> But it mounted successfully, then i do some similar operations in
> 3.12...and umount it.
> and switch into kernel version 3.2...
> 
> but i failt to mount it in 3.2 and it output the following message.
> 
> BTRFS: couldn't mount because of unsupported optional features (20)

BTRFS_FEATURE_INCOMPAT_BIG_METADATA     (1ULL << 5)
== 0x20

so you've made the filesystem with new progs that turn on bigblocks by
default.

> It seems that here the problem is because incompat features in newer
> kernel and make older kernel
> unmountable any more..

This is not the case for any incompat feature introduced after 3.2.
Default subolume, lzo compression are automatically set when the feature
is used, but nothing from the rest like bigblocks, extrefs, skinny
metadata etc.
