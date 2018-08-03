Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53010 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726115AbeHCRDm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Aug 2018 13:03:42 -0400
Date: Fri, 3 Aug 2018 17:06:53 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: ins: logical-resolve: Print message
 when path cannot be resolved
Message-ID: <20180803150653.GA3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1532501096.git.misono.tomohiro@jp.fujitsu.com>
 <a5545edbef2d2b1800a5ea83d9c14773b5b1fbe7.1532501096.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a5545edbef2d2b1800a5ea83d9c14773b5b1fbe7.1532501096.git.misono.tomohiro@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 25, 2018 at 05:20:17PM +0900, Misono Tomohiro wrote:
> Since BTRFS_IOC_INO_PATHS requires fd of subvolume,

Does it? AFAICS btrfs_ioctl_ino_to_path gets root that's the containing
subvolume of the path given by the user.

> logical-resolve
> cannot find the path when mount point is not FS_TREE
> (because the subvolume path cannot be opened).

Sorry, I don't understand what's the problem here. What you write sounds
like there's a reproducer. If yes, please post it.
