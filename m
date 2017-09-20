Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49028 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751663AbdITOFA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 10:05:00 -0400
Date: Wed, 20 Sep 2017 16:03:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs: suggestion of removing --commit-after option of
 subvol delete
Message-ID: <20170920140328.GJ29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <3fab29e2-179e-2109-6217-1cb079f97f9e@jp.fujitsu.com>
 <20170919144836.GE29043@twin.jikos.cz>
 <18fc2d5c-de1a-7e0e-dd8f-bcae3fd24fef@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <18fc2d5c-de1a-7e0e-dd8f-bcae3fd24fef@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 20, 2017 at 08:22:54AM +0800, Qu Wenruo wrote:
> The costly part will be tracking the filesystems of subvolumes.
> We must do it for each subvolume and batch them to address the final 
> transaction commit for each fs.
> 
> I didn't see any easy ioctl to get the UUID from fd, meaning (if didn't 
> miss anything) we need to iterate the path until reaching the mount 
> boundary and then refer to mountinfo to find the fs.

The FS_INFO ioctl will tell you the fsid from a fd.  Iterating the paths
will not work reliably, due to some potentially very creative use of
mounts that could build up the path components.

> Not to mention that the possible softlink in the path may make things 
> more complex.
> 
> Yes, this may be fixed with tons of code, but I don't think the 
> complexity worthy for a minor feature.

So what if we fix it like that:

- iterate over subvolumes
- check if the fsid is same as for the previous subvolume
  - if it is, continue
  - if not, do the sync

IOW, sync when we leave subvolumes of one filesystem. In the degenerate
case, we can have subvolumes interleaved that we'd sync after each,
effectively --commit-each.

The simple tracking should avoid keeping all the filedescriptors open
and I think this won't need tons of code to implement.

The typical could be 'btrfs subvol delete -c path/*', ie. deleting from
just one filesystem. If we happen to cross more filesystems, each of
them will get the sync, but possibly more than one. I don't think this
is too serious.
