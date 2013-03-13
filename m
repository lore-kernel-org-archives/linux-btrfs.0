Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285Ab3CMCDc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 22:03:32 -0400
Message-ID: <513FDE67.1050907@redhat.com>
Date: Tue, 12 Mar 2013 21:03:19 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: russell@coker.com.au
CC: linux-btrfs@vger.kernel.org
Subject: Re: Debian 3.7.1 BTRFS crash
References: <201303131238.33692.russell@coker.com.au>
In-Reply-To: <201303131238.33692.russell@coker.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 3/12/13 8:38 PM, Russell Coker wrote:
> I have a workstation running the Debian packaged 3.7.1 kernel from 24th 
> December last year.  After some period of uptime (maybe months) it crashed and 
> mounted the root filesystem read-only.  Now when I boot it the root filesystem 
> gets mounted read-only.
> 
> I have attached the dmesg output from the last boot.
> 
> The system has an Intel 120G SSD and apart from 4G of swap and 400M of /boot 
> it's all a single encrypted BTRFS filesystem.
> 
> Any suggestions on what I should do next?

Not offhand, but I took a look at the logs, and maybe this will help the
people who are more guru-like than I am.

First you hit:

[   37.175750] btrfs: corrupt leaf, bad key order: block=70852288512,root=1, slot=8
[   37.176435] btrfs: corrupt leaf, bad key order: block=70852288512,root=1, slot=8

which led to an aborted transaction and an attempt at graceful shutdown:

[   37.176478] WARNING: at /build/buildd-linux_3.7.1-1~experimental.1-amd64-lU7Aeh/linux-3.7.1/fs/btrfs/super.c:246 __btrfs_abort_transaction+0x4c/0xcf [btrfs]()
[   37.176481] btrfs: Transaction aborted
...
[   37.176790] BTRFS error (device dm-0) in __btrfs_free_extent:5143: IO failure
[   37.176791] btrfs is forced readonly
[   37.176793] btrfs: run_one_delayed_ref returned -5


in the end, despite that attempt at graceful exit, you hit:

[   37.937174] kernel BUG at /build/buildd-linux_3.7.1-1~experimental.1-amd64-lU7Aeh/linux-3.7.1/fs/btrfs/transaction.c:1753!

because in btrfs_clean_old_snapshots(), btrfs_drop_snapshot() failed, and

		BUG_ON(ret < 0);

it doesn't handle that well.

I have no idea what btrfsck might do, but it seems like if there is a corrupt
leaf, that might be in order.  I might make a device image first, as well.

-Eric

