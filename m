Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60830 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750990AbdISOuI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 10:50:08 -0400
Date: Tue, 19 Sep 2017 16:48:36 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs: suggestion of removing --commit-after option of
 subvol delete
Message-ID: <20170919144836.GE29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <3fab29e2-179e-2109-6217-1cb079f97f9e@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3fab29e2-179e-2109-6217-1cb079f97f9e@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 19, 2017 at 04:50:04PM +0900, Misono, Tomohiro wrote:
> I read the code of "subvolume delete" and found that --commit-after option is
> not working well.
> 
> Since it issues BTRFS_IOC_START/WAIT_SYNC to the last fd (of directory
> containing the last deleted subvolume),
> 1. sync operation affects only the last fd's filesystem.
>    ("subvolume delete" can take multiple subvolumes on different filesystems.)

You're right, though I don't think this is a common usecase.

> 2. if the last delete action fails to open the path (fd == -1),
>    SYNC is not issued at all.
> 
> One solution is to keep every fd for deleted subvolumes, but I think it takes
> too much cost.

How do you evaluate the cost? We'd have to keep track of all the
distinct filesystems of the subvolumes, so we issue sync on each of them
in the end.

> Since we can just use "btrfs filesystem sync" after delete if
> needed, I think it is ok to remove --comit-after option.

The point of the option is to allow the sync in the same command as the
subvolume deletion. Even with the sync, the user would still have to
know all the filesystems where the the subvolumes were, so some way of
tracking them would need to be done.

I don't want to remove the option unless it's really not working as
expected and could mislead the users. What you found are bugs that can
be fixed.
