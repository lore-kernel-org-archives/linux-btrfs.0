Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:55656 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965297Ab3CZPe6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 11:34:58 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 6C6A57C0680
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 09:34:58 -0600 (MDT)
Date: Tue, 26 Mar 2013 11:34:52 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: anand jain <anand.jain@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] mount and /proc/mounts disagrees
Message-ID: <20130326153452.GO1955@localhost.localdomain>
References: <5151BD92.2010802@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5151BD92.2010802@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 26, 2013 at 09:24:02AM -0600, anand jain wrote:
> 
> 3.8.0+ #3
> 
> This happened after 'umount /btrfs' was interrupted by ctl-C
> 
> # mount | egrep btrfs
> /dev/mapper/mpathe on /btrfs type btrfs (rw,degraded)
> 
> # cat /etc/mtab | egrep btrfs
> /dev/mapper/mpathe /btrfs btrfs rw,degraded 0 0
> 
> # cat /proc/mounts | egrep btrfs
> # umount /btrfs
> umount: /btrfs: not mounted
> #
>

That's because your mount still uses /etc/mtab for some reason, I thought it had
stopped doing that and was using /proc/mounts?  Anyway it's just because the
entry made it into mtab, if umount and /proc/mounts says its not there then its
not there.  Thanks,

Josef 
