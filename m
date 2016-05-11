Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbcEKQji (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 12:39:38 -0400
Date: Wed, 11 May 2016 18:39:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About in-band dedupe for v4.7
Message-ID: <20160511163915.GG29353@suse.cz>
Reply-To: dsterba@suse.cz
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 10, 2016 at 03:19:52PM +0800, Qu Wenruo wrote:
> As merge window for v4.7 is coming, it would be good to hear your ideas 
> about the inband dedupe.

For me it's still in the process of review.

> We are addressing the ENOSPC problem which Josef pointed out, and we 
> believe the final fix patch would come out at the beginning of the merge 
> window.(Next week)
> 
> If it's fine, would you please consider to merge the in-memory backend 
> patchset for v4.7 as an experimental feature?
>
> Most of the patch won't be changed from v10 patchset, only ENOSPC fix 
> will be updated, and ioctl patchset will introduce a new Kconfig option 
> of "btrfs experimental features" for inband dedupe.
> (With explain about unstable ioctl/on-disk format for experimental features)
>
> If you are all OK to merge inband dedupe in-memory backend, I'll prepare 
> the new v11 patchset for this merge.

Given the unfixed bug(s) and lack of review/ack from others, 4.7 cannot
be considered as merging target.  I had promised to put the patchset
branch to my for-next (regarding v10) but forgot to do it, too many
patches to juggle sorry.  Ideally, a feature like this should spend a
full development cycle in next so it gets enough exposure and testing.
