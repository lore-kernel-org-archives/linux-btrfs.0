Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:51501 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3FJM0b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 08:26:31 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 0BF337C065C
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 06:26:31 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Mitch Harder <mitch.harder@sabayonlinux.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAKcLGm-+19LiOaMzQ5b6dCboB_wGJNM_R=TP1ORVcJOgmj8s8A@mail.gmail.com>
In-Reply-To: <CAKcLGm-+19LiOaMzQ5b6dCboB_wGJNM_R=TP1ORVcJOgmj8s8A@mail.gmail.com>
Message-ID: <20130610122628.4088.57887@localhost.localdomain>
Subject: Re: btrfs-cleaner Blocked on xfstests 068
Date: Mon, 10 Jun 2013 08:26:28 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Mitch Harder (2013-06-10 00:03:31)
> I'm running into a problem with the btrfs-cleaner thread becoming
> blocked on xfstests 068.
> 
> The test locks up indefinitely without completing (normally it
> finished in about 45 seconds on my test box).
> 
> I've replicated the issue on 3.10.0_rc5 and the for-linus branch of 3.9.0.
> 
> I ran a git bisect on the 3.9.0 for-linus branch, and tracked my issue
> to the following commit:
> 
> commit 9d1a2a3ad59f7ae810bf04a5a05995bf2d79300c
> btrfs: clean snapshots one by one
> 
> The 068 test uses the scratch drive, so I believe xfs-test is using
> the defaults for formatting the device, which is a physical partition
> on my SATA drive.
> 
> My mount settings for xfstests is:
> export MOUNT_OPTIONS="-o compress-force=lzo,autodefrag"
> 
> There are no errors shown in dmesg.  Here is the result of Alt-SysRq-W
> to show the blocked states:

This is a known problem between freeze and mount -o compress.
btrfs-next has a fix from Miao, but I wanted to be very cautious with
moving around unmount related mutexes.

-chris
