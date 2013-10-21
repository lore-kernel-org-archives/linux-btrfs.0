Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:57391 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab3JUOob (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 10:44:31 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id B4E9E7C0681
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 08:44:30 -0600 (MDT)
Date: Mon, 21 Oct 2013 10:44:28 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: <dsterba@suse.cz>, Anand Jain <anand.jain@oracle.com>,
        <linux-btrfs@vger.kernel.org>, <chris.mason@fusionio.com>
Subject: Re: [PATCH 1/3 v4] btrfs-progs: use kernel for mounted disk for show
Message-ID: <20131021144428.GG6924@localhost.localdomain>
References: <1381203700-17558-1-git-send-email-anand.jain@oracle.com>
 <20131015171333.GM5787@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20131015171333.GM5787@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 15, 2013 at 07:13:33PM +0200, David Sterba wrote:
> On Tue, Oct 08, 2013 at 11:41:38AM +0800, Anand Jain wrote:
> > As of now btrfs filesystem show reads directly from
> > disks. So sometimes output can be stale, mainly when
> > user wants to cross verify their operation like,
> > label or device delete or add... etc. so this
> > patch will read from the kernel ioctl if it finds
> > that disk is mounted.
> 
> Sorry for holding this patch back for so long, I wanted to find out why
> the output is different before and after. The reason is simple, for my
> convenience I've added the user to the 'disk' group so I can access the
> block devices without root. This patch stops to read the block devs
> directly and uses the ioctl BTRFS_IOC_FS_INFO which gives me a silent
> EPERM. If I run show with sudo, then all filesystems show up as
> expected.
> 

This patch needs to be dropped (I imagine the whole series too) as it breaks
xfstests btrfs/003.  If I do btrfs fi show on a mounted fs I get this

[root@destiny btrfs-progs]# btrfs fi show /dev/sdc
Btrfs v0.20-rc1-483-ge0173f6
[root@destiny btrfs-progs]# 

Chris this is in integration, so maybe a revert?  Thanks,

Josef
