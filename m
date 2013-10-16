Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934104Ab3JPNJ3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 09:09:29 -0400
Date: Wed, 16 Oct 2013 15:09:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3 v4] btrfs-progs: use kernel for mounted disk for show
Message-ID: <20131016130927.GT5787@suse.cz>
Reply-To: dsterba@suse.cz
References: <1381203700-17558-1-git-send-email-anand.jain@oracle.com>
 <20131015171333.GM5787@twin.jikos.cz>
 <525E5B91.4050808@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <525E5B91.4050808@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 16, 2013 at 05:25:37PM +0800, Anand Jain wrote:
>  Ah. good catch. but what do you suggest. ?
>  as of now user on disk-group is able to do things like,
>  check --repair. but won't  be able to list the subvol /
>  manage the snapshots, and is able to run btrfs fi show -d
>  but won't be able to run btrfs fi show / -m. what do we
>  do in this case ?

We can drop the CAP_SYS_ADMIN check from btrfs_ioctl_fs_info, it does
not do or revealy sensitive information.

>  OR when /sys interface is ready that should help to manage
>  based on the user-groups.?

This could be decided case by case if a sysfs file should not be
publicly readable, otherwise let them be readable to everyone.

david
