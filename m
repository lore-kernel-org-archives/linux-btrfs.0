Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:47758 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab3BDQ62 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2013 11:58:28 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id DA2117C038A
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Feb 2013 09:58:27 -0700 (MST)
Date: Mon, 4 Feb 2013 11:58:25 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: =?utf-8?B?IlBpb3RyIFBhd8WCb3ci?= <pp@siedziba.pl>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:1772
Message-ID: <20130204165825.GC2275@localhost.localdomain>
References: <55e4fbbdada4ee37bdccac2537683d83.squirrel@lampka.siedziba.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <55e4fbbdada4ee37bdccac2537683d83.squirrel@lampka.siedziba.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 03, 2013 at 04:37:58PM -0700, "Piotr Pawłow" wrote:
> Hello,
> 
> 1 week ago I bought a new 2TB hard drive, created 1 partition on the whole
> disk, and created root and swap LVM volumes on it. I formatted root to
> btrfs with default options, except meta-data profile which I set to
> "single". I copied all my data to it and unplugged my old hard drives. It
> worked for a week.
> 
> Today I installed another 2TB hard drive, created LVM volumes as before,
> and added to my root filesystem. I started balance with data and metadata
> conversion to raid1. I left it doing its job, and returned few hours
> later. When I returned hard disks were idle, screen would not unlock, and
> I could not log in. I had to reset it.
> 
> After reset it won't mount. I booted the computer from a live-cd. It has
> an ancient kernel, so I installed qemu and captured the oops on the
> current version compiled from
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git:
> 

Ok good you have a git tree.  Can you run these commands

git remote-add josef \
	git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
git fetch josef
git co josef/piotr

and then build that and run that.  It will spit out some debug stuff when it
mounts before it panics, can you capture all the output and reply to this email
with it?  Thanks,

Josef
