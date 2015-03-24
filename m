Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57729 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249AbbCXOqb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 10:46:31 -0400
Date: Tue, 24 Mar 2015 15:46:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: WARNING at fs/btrfs/super.c:260 __btrfs_abort_transaction
Message-ID: <20150324144629.GW20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150320045900.GA16812@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150320045900.GA16812@dhcp-13-216.nay.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 20, 2015 at 12:59:01PM +0800, Eryu Guan wrote:
> Filling a dm/lvm snapshot triggered this btrfs WARNING, kernel is 4.0-rc3+

It's an EIO because the underlying storage does not want to write the
data.

> The same script can trigger warning on ext4 too, I'll file another bug
> report to ext4 list.

So it's likely caused by dm/lvm.

> [150646.284481] device-mapper: snapshots: Invalidating snapshot: Unable to allocate exception.
...
> [150646.312739] BTRFS: bdev /dev/mapper/vg_081-snap_081 errs: wr 10, rd 0, flush 0, corrupt 0, gen 0
> [150646.331472] BTRFS: error (device dm-3) in btrfs_commit_transaction:2019: errno=-5 IO failure (Error while writing out transaction)
> [150646.334251] BTRFS info (device dm-3): forced readonly
> [150646.335365] BTRFS warning (device dm-3): Skipping commit of aborted transaction.

And this is the standard behaviour of the filesystem in such case.
