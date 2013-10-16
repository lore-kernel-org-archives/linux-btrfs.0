Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25992 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760482Ab3JPJ1y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 05:27:54 -0400
Message-ID: <525E5B91.4050808@oracle.com>
Date: Wed, 16 Oct 2013 17:25:37 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3 v4] btrfs-progs: use kernel for mounted disk for show
References: <1381203700-17558-1-git-send-email-anand.jain@oracle.com> <20131015171333.GM5787@twin.jikos.cz>
In-Reply-To: <20131015171333.GM5787@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> The reason is simple, for my
> convenience I've added the user to the 'disk' group so I can access the
> block devices without root. This patch stops to read the block devs
> directly and uses the ioctl BTRFS_IOC_FS_INFO which gives me a silent
> EPERM.
 > If I run show with sudo, then all filesystems show up as
 > expected.

  Ah. good catch. but what do you suggest. ?
  as of now user on disk-group is able to do things like,
  check --repair. but won't  be able to list the subvol /
  manage the snapshots, and is able to run btrfs fi show -d
  but won't be able to run btrfs fi show / -m. what do we
  do in this case ?
  OR when /sys interface is ready that should help to manage
  based on the user-groups.?

Thanks Anand
