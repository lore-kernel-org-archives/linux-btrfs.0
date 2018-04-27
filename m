Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49858 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757569AbeD0QnG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 12:43:06 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6C558ABD0
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 16:43:05 +0000 (UTC)
Date: Fri, 27 Apr 2018 18:40:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: qgroups, fix rescan worker running races
Message-ID: <20180427164031.GH21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180426192351.473-1-jeffm@suse.com>
 <20180427155608.GC21272@twin.jikos.cz>
 <fbfbd98c-a7ee-4309-22ab-1e3a8416d27a@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fbfbd98c-a7ee-4309-22ab-1e3a8416d27a@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 27, 2018 at 12:02:13PM -0400, Jeff Mahoney wrote:
> >> +static void queue_rescan_worker(struct btrfs_fs_info *fs_info)
> >> +{
> > 
> > And this had to be moved upwards as there was earlier use of
> > btrfs_queue_work that matched following the hunk.
> 
> Weird.  That must be exactly the kind of mismerge artifact that we were
> talking about the other day.  In my tree it's in the right spot.

I've tried current master, upcoming pull request queue (misc-4.17, one
nonc-onflicting patch) and current misc-next. None of them applies the
patch cleanly and the function is still added after the first use, so
this would not compile.

The result can be found in
https://github.com/kdave/btrfs-devel/commits/ext/jeffm/qgroup-fixes
