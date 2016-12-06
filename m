Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752765AbcLFO4J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Dec 2016 09:56:09 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0F6CAAC0D
        for <linux-btrfs@vger.kernel.org>; Tue,  6 Dec 2016 14:54:51 +0000 (UTC)
Date: Tue, 6 Dec 2016 15:54:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 10/18] btrfs: root->fs_info cleanup,
 btrfs_calc_{trans,trunc}_metadata_size
Message-ID: <20161206145446.GY12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
 <1480655258-15400-11-git-send-email-jeffm@suse.com>
 <20161205152904.GW12522@twin.jikos.cz>
 <b4fd0266-e743-a90a-ac9a-d816a2ef2c61@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b4fd0266-e743-a90a-ac9a-d816a2ef2c61@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 05, 2016 at 10:50:34AM -0500, Jeff Mahoney wrote:
> On 12/5/16 10:29 AM, David Sterba wrote:
> > On Fri, Dec 02, 2016 at 12:07:30AM -0500, jeffm@suse.com wrote:
> >> -static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
> >> +static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_fs_info *fs_info,
> >>  						 unsigned num_items)
> >>  {
> >> -	return root->fs_info->nodesize * BTRFS_MAX_LEVEL * 2 * num_items;
> >> +	return fs_info->nodesize * BTRFS_MAX_LEVEL * 2 * num_items;
> > 
> > Is there a missing patch that moves 'nodesize' to fs_info? The patch has
> > a minor conflict in the original line where it's just 'root->nodesize',
> > but thre are many compilation faiures due to lack of fs_info::nodesize.
> 
> Yeah, it looks like the list dropped it.  It shows up in the thread
> posted to me.
> 
> I've pushed the series as the for-4.10/misc-4.10 branch in
> my repo at git://git.kernel.org/pub/scm/linux/kernel/git/jeffm/linux-btrfs.git
> 
> It also contains the fix Omar suggested in his review.

Thanks, added to 4.10 queue.
