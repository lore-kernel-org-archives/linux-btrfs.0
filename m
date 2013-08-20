Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33054 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab3HTTTo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 15:19:44 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id CA3EF9A06AD
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2013 13:19:43 -0600 (MDT)
Date: Tue, 20 Aug 2013 15:19:41 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Anand Jain <anand.jain@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: Re: [PATCH 3/3] btrfs-progs: avoid write to the disk before sure to
 create fs
Message-ID: <20130820191941.GJ3990@localhost.localdomain>
References: <1374773730-29957-1-git-send-email-anand.jain@oracle.com>
 <1375877485-12105-1-git-send-email-anand.jain@oracle.com>
 <1375877485-12105-4-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1375877485-12105-4-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 07, 2013 at 08:11:25PM +0800, Anand Jain wrote:
> This patch provides fix for the following bug,
> 
> When mkfs.btrfs fails the disks shouldn't be written.
> ------------
> btrfs fi show /dev/sdb
> Label: none  uuid: 60fb76f4-3b4d-4632-a7da-6a44dea5573d
>         Total devices 1 FS bytes used 24.00KiB
>         devid    1 size 2.00GiB used 20.00MiB path /dev/sdb
> 
> mkfs.btrfs -dsingle -mraid1 /dev/sdb -f
> ::
> unable to create FS with metadata profile 16 (have 1 devices)
> 
> btrfs fi show /dev/sdb
> Label: none  uuid: 2da2179d-ecb1-4a4e-a44d-e7613a08c18d
>         Total devices 1 FS bytes used 24.00KiB
>         devid    1 size 2.00GiB used 20.00MiB path /dev/sdb
> -------------
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

This regresses making a filesystem that is forced to be a mixed block group.
Dave this is in your integration branch, can you please kick it out?  Anand if
I have to waste 30 more minutes bisecting your latest regression I'm going to
just start ignoring all of your patches.

Josef
