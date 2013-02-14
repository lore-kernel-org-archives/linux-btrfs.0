Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:56449 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab3BNUX2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 15:23:28 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 686747C0416
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2013 13:23:28 -0700 (MST)
Date: Thu, 14 Feb 2013 15:23:24 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH, RFC] btrfs-progs: require mkfs -f force option to
 overwrite filesystem or partition table
Message-ID: <20130214202324.GD3919@shiny.masoncoding.com>
References: <511D2D2B.8040804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <511D2D2B.8040804@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 14, 2013 at 11:30:03AM -0700, Eric Sandeen wrote:
> The core of this is shamelessly stolen from xfsprogs.
> 
> Use blkid to detect an existing filesystem or partition
> table on any of the target devices.  If something is found,
> require the '-f' option to overwrite it, hopefully avoiding
> disaster due to mistyped devicenames, etc.

So, this has always been the one thing I didn't want to steal from XFS.
I don't have a good reason though, and it seems like it is time to bring
this in.

Just to get back at you though, I'll turn on an incandescent light bulb
every time I have to use -f.

-chris
