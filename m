Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36197 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753250AbeBLSWV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 13:22:21 -0500
Date: Mon, 12 Feb 2018 19:20:05 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        wqu@suse.com
Subject: Re: [PATCH] btrfs: Move qgroup rescan on quota enable to
 btrfs_quota_enable
Message-ID: <20180212182005.GO3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1517388724-1483-1-git-send-email-nborisov@suse.com>
 <fd3a625b-cc65-b032-911a-e9154ddd99d5@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <fd3a625b-cc65-b032-911a-e9154ddd99d5@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 03, 2018 at 11:30:42AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年01月31日 16:52, Nikolay Borisov wrote:
> > Currently btrfs_run_qgroups is doing a bit too much. Not only is it
> > responsible for synchronizing in-memory state of qgroups to disk but
> > it also contains code to trigger the initial qgroup rescan when
> > quota is enabled initially. This condition is detected by checking that
> > BTRFS_FS_QUOTA_ENABLED is not set and BTRFS_FS_QUOTA_ENABLING is set.
> > Nothing really requires fro the code to be structured (and scattered)
> > the way it is so let's streamline things. First move the quota rescan
> > code into btrfs_quota_enable, where its invocation is closer to the
> > user. This also makes the FS_QUOTA_ENABLING flag redundant so let's
> > remove it as well.i
> > 
> > This has been tested with a full xfstest run with qgroups enabled on
> > the scratch device of every xfstest and no regressions were observed.
> > 
> > Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Looks good.
> 
> Since rescan work is async, initializing it at enable looks pretty
> reasonable.
> 
> No delaying makes it easier to read.
> 
> > ---
> >  fs/btrfs/ctree.h  |  1 -
> >  fs/btrfs/qgroup.c | 35 ++++++++++-------------------------
> >  2 files changed, 10 insertions(+), 26 deletions(-)
> 
> And indeed reduces codes.
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>

Looks good to me to, added to next. The two bits tracking the state
seemed like an overkill to me. Thanks.
