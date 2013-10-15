Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758902Ab3JORNf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 13:13:35 -0400
Date: Tue, 15 Oct 2013 19:13:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/3 v4] btrfs-progs: use kernel for mounted disk for show
Message-ID: <20131015171333.GM5787@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1381203700-17558-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381203700-17558-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 08, 2013 at 11:41:38AM +0800, Anand Jain wrote:
> As of now btrfs filesystem show reads directly from
> disks. So sometimes output can be stale, mainly when
> user wants to cross verify their operation like,
> label or device delete or add... etc. so this
> patch will read from the kernel ioctl if it finds
> that disk is mounted.

Sorry for holding this patch back for so long, I wanted to find out why
the output is different before and after. The reason is simple, for my
convenience I've added the user to the 'disk' group so I can access the
block devices without root. This patch stops to read the block devs
directly and uses the ioctl BTRFS_IOC_FS_INFO which gives me a silent
EPERM. If I run show with sudo, then all filesystems show up as
expected.

david
