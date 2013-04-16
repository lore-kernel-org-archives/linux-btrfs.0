Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080Ab3DPL56 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 07:57:58 -0400
Date: Tue, 16 Apr 2013 13:57:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: a copy of superblock is zero may not mean
 btrfs is not there
Message-ID: <20130416115756.GJ18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1365753306-19412-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1365753306-19412-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 12, 2013 at 03:55:06PM +0800, Anand Jain wrote:
> If one of the copy of the superblock is zero it does not
> confirm to us that btrfs isn't there on that disk. When
> we are having more than one copy of superblock we should
> rather let the for loop to continue to check other copies.
> 
> the following test case and results would justify the
> fix
> 
> mkfs.btrfs /dev/sdb /dev/sdc -f
> mount /dev/sdb /btrfs
> dd if=/dev/zero bs=1 count=8 of=/dev/sdc seek=$((64*1024+64))
> ~/before/btrfs-select-super -s 1 /dev/sdc
> using SB copy 1, bytenr 67108864
> 
> here btrfs-select-super just wrote superblock to a mounted btrfs

Why does not check_mounted() catch this in the first place? Ie. based on
the status in /proc/mounts not on random bytes in the superblock.

david
