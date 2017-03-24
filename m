Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53773 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935113AbdCXMNu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Mar 2017 08:13:50 -0400
Date: Fri, 24 Mar 2017 12:58:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Mark Fasheh <mfasheh@suse.de>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] fix inconsistent device between /proc/pid/maps and stat
Message-ID: <20170324115859.GN14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <871strcs56.wl-satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <871strcs56.wl-satoru.takeuchi@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 21, 2017 at 10:53:09AM +0900, Satoru Takeuchi wrote:
> There have been some discussions about inconsistent device between /proc/pid/maps and stat(2).
> 
> http://thr3ads.net/btrfs-devel/2011/05/2346176-RFC-PATCH-0-2-btrfs-vfs-Return-same-device-in-stat-2-and-proc-pid-maps
> https://www.spinics.net/lists/linux-btrfs/msg09044.html
> https://patchwork.kernel.org/patch/2825842/
> https://patchwork.kernel.org/patch/2831525/
> 
> It's important since it breaks user programs like lsof(8). There was a patche by Mark to fix this problem.
> However, unfortunately, that patch is not merged so far.

And no variant of the get_map_dev will ever be merged. Reworking this
requires extensions to the superblock and subvolume structures, making
it more generic and suitable for VFS.
