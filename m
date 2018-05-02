Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751137AbeEBNSU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 May 2018 09:18:20 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A5CCFAC5E
        for <linux-btrfs@vger.kernel.org>; Wed,  2 May 2018 13:18:18 +0000 (UTC)
Date: Wed, 2 May 2018 15:15:43 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, jeffm@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: qgroups, fix rescan worker running races
Message-ID: <20180502131543.GY21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180426192351.473-1-jeffm@suse.com>
 <20180502102928.GX21272@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180502102928.GX21272@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 02, 2018 at 12:29:28PM +0200, David Sterba wrote:
> On Thu, Apr 26, 2018 at 03:23:49PM -0400, jeffm@suse.com wrote:
> > From: Jeff Mahoney <jeffm@suse.com>
> > +static void queue_rescan_worker(struct btrfs_fs_info *fs_info)
> > +{
> > +	mutex_lock(&fs_info->qgroup_rescan_lock);
> > +	if (btrfs_fs_closing(fs_info)) {
> > +		mutex_unlock(&fs_info->qgroup_rescan_lock);
> > +		return;
> > +	}
> > +	if (WARN_ON(fs_info->qgroup_rescan_running)) {
> 
> The warning is quite noisy, I see it after tests btrfs/ 017, 022, 124,
> 139, 153. Is it necessary for non-debugging builds?
> 
> The tested branch was full for-next so it could be your patchset
> interacting with other fixes, but the warning noise level question still
> stands.

So it must be something with the rest of misc-next or for-next patches,
current for 4.17 queue does show the warning at all, and the patch is ok
for merge.
