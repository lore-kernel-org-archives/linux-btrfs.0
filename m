Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287AbaGVRmo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jul 2014 13:42:44 -0400
Date: Tue, 22 Jul 2014 19:42:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: code optimize use btrfs_get_bdev_and_sb() at
 btrfs_scan_one_device
Message-ID: <20140722174241.GC1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404758317-7000-1-git-send-email-Anand.Jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404758317-7000-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 08, 2014 at 02:38:37AM +0800, Anand Jain wrote:
> (for review comments pls).
> 
> btrfs_scan_one_device() needs SB, instead of doing it from scratch could
> use btrfs_get_bdev_and_sb()

Please see
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=6f60cbd3ae442cb35861bb522f388db123d42ec1

your patch actually reverts the changes. btrfs_get_bdev_and_sb does not
work and it was a pretty nasty bug, we've spent a long afternoon
catching it.

Some of the check may seem unnecessary, but they 'make sure' that
something unexpected will not happen.
