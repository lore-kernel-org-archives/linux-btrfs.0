Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53843 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751907AbdI0PK1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Sep 2017 11:10:27 -0400
Date: Wed, 27 Sep 2017 17:08:53 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] btrfs-progs: subvol: fix del --commit-after
Message-ID: <20170927150853.GL31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <7610069d-bd81-2239-0be8-6635478c2dda@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7610069d-bd81-2239-0be8-6635478c2dda@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 27, 2017 at 11:00:35AM +0900, Misono, Tomohiro wrote:
> Fix subvol del --commit-after to work properly:
>  - SYNC ioctl will be issued even when last delete is failed
>  - SYNC ioctl will be issued on each file system only once in the end
> 
> To achieve this, each deleted subvol's (parent's) fsid is checked each
> time. If the fsid is seen for the first time, its fd will be kept in order
> to issue SYNC ioctl in the end.
> 
> There already exists get_fsid() in cmds-property.c and seen_fsid which
> keeps fsid in hush function in cmds-filesystem.c. This patch utilizes
> them.
> 
> First patch is the independent but critical. Current code is reversed in
> --commit-after and --commit-each operation. i.e. --commit-after means
> --commit-each actually. The patch fix this.
> 
> 2rd to 4th patches make functions stated above to common and last one is
> the main part.

Thanks for the fix, I'm glad we did not have to remove the option.
Patches applied with some adjustments. Please became more familiar with
the coding style. I'm usually fixing all patches here and there, but
once the amount grows I'd rather spend time on more useful things.

Bothering with coding style is annoying but the point is that the
committed code looks exactly the same no matter when or who authored it.

> Thanks Qu for reviewing whole patches.

Appreciated.
