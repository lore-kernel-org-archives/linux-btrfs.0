Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:45834 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934143Ab3GQXEE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jul 2013 19:04:04 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E321D9A0372
	for <linux-btrfs@vger.kernel.org>; Wed, 17 Jul 2013 17:04:03 -0600 (MDT)
Date: Wed, 17 Jul 2013 19:04:01 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Jon Nelson <jnelson@jamponi.net>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: report: my btrfs filesystem failed hard today
Message-ID: <20130717230401.GA2581@localhost.localdomain>
References: <CAKuK5J0ZiMnAHWAEvNBESX99cawYJQ4_sFQ=5_Ka8gwJqLT2cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAKuK5J0ZiMnAHWAEvNBESX99cawYJQ4_sFQ=5_Ka8gwJqLT2cA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 17, 2013 at 05:44:23PM -0500, Jon Nelson wrote:
> I had a btrfs filesystem under 3.9.8 that failed /hard/ today. So hard
> that the filesystem could not be mounted because there wasn't enough
> free space, unless it was mounted read only.
> 
> This happened after I ran out of metadata space (is there a way to
> increase the amount of metadata storage) while still having many gigs
> free of data space, as reported by btrfs fi df. I tried balancing the
> metadata, defrag'ing files (with -czlib) and even tried mounting with
> -o remount,metadata_ratio={several values}, none of which worked, and
> then it crashed hard.
> 
> First, it killed systemd's logger (journald), which refused to
> start.Following the crash, I was not able to mount the filesystem
> without -o ro.  -o recovery did not work.
>

Can you try btrfs-next, I did some work in this area in the last few months.
Thanks,

Josef 
