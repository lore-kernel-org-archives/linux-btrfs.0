Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32902 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751659AbeEVME5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 08:04:57 -0400
Date: Tue, 22 May 2018 14:02:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2 0/6] btrfs_search_slot cleanups
Message-ID: <20180522120214.GG6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <9b80bec0-b7cf-10da-f379-373fe6ec776a@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9b80bec0-b7cf-10da-f379-373fe6ec776a@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 07:05:14PM +0800, Su Yue wrote:
> Hi Liu and David,
> 	During my local xfstests on kdave/for-next, btrfs/139 failed and
> btrfs BUG_ON due to qgroup rescan.
> 	The bisect result is commit 560215eb3f32("Merge branch
> 'ext/liubo/search-cleanups-wip' into for-next-next-v4.18-20180521")
> which seems merged this patchset.
> 	The dmesg file is attached.
>
> On 05/18/2018 11:00 AM, Liu Bo wrote:
> > Here are a collection of patches I did for btrfs_search_slot().
> > 
> > v2: more explicit commit log for each patch.
> > 
> > Liu Bo (6):
> >   Btrfs: remove superfluous free_extent_buffer
> >   Btrfs: use more straightforward extent_buffer_uptodate
> >   Btrfs: move get root of btrfs_search_slot to a helper
> >   Btrfs: remove unused check of skip_locking
> >   Btrfs: grab write lock directly if write_lock_level is the max level
> >   Btrfs: remove always true check in unlock_up
> > 
> >  fs/btrfs/ctree.c | 121 +++++++++++++++++++++++++++++++++----------------------
> >  1 file changed, 73 insertions(+), 48 deletions(-)
> > 
> 
> 

> [   46.129166] BTRFS info (device vdb): disk space caching is enabled
> [   46.130545] BTRFS info (device vdb): has skinny extents
> [   46.171386] mount (2798) used greatest stack depth: 12920 bytes left
> [   46.508170] BTRFS: device fsid 83a117c7-a9ea-4bf5-b42f-7092078610d5 devid 1 transid 5 /dev/vdc
> [   46.562428] BTRFS info (device vdc): disk space caching is enabled
> [   46.563690] BTRFS info (device vdc): has skinny extents
> [   46.564563] BTRFS info (device vdc): flagging fs with big metadata feature
> [   46.587441] BTRFS info (device vdc): checking UUID tree
> [   46.766765] BTRFS info (device vdb): disk space caching is enabled
> [   46.768197] BTRFS info (device vdb): has skinny extents
> [   46.875534] run fstests btrfs/139 at 2018-05-22 18:40:36
> [   47.559411] BTRFS: device fsid 065f3825-057e-451f-8722-0d94d4a3f36f devid 1 transid 5 /dev/vdc
> [   47.612001] BTRFS info (device vdc): disk space caching is enabled
> [   47.613254] BTRFS info (device vdc): has skinny extents
> [   47.614147] BTRFS info (device vdc): flagging fs with big metadata feature
> [   47.632377] BTRFS info (device vdc): checking UUID tree
> [   47.681656] btrfs (3176) used greatest stack depth: 12632 bytes left
> [   47.691156] ------------[ cut here ]------------
> [   47.692084] kernel BUG at fs/btrfs/locking.c:286!

I saw the crash too but did not investigate the root cause. So I'll
remove the branch from for-next until it's fixed. Thanks for the report.
