Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48123 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750815AbdABOaJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jan 2017 09:30:09 -0500
Date: Mon, 2 Jan 2017 15:29:53 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@suse.com, dsterba@suse.com
Subject: Re: [PATCH] Btrfs: Fix deadlock between direct IO and fast fsync
Message-ID: <20170102142953.GH12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1482485418-4190-1-git-send-email-chandan@linux.vnet.ibm.com>
 <25132456.GqS7QuRSzf@localhost.localdomain>
 <2606394.PBVynvYKAF@localhost.localdomain>
 <20161224001800.GA11160@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161224001800.GA11160@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 23, 2016 at 04:18:00PM -0800, Liu Bo wrote:
> > > Btw, I was able to reproduce the issue on kdave/for-next branch with "Merge
> > > branch 'for-next-next-4.9-20161125' into for-next-20161125" as the topmost
> > > commit. The issue cannot be reproduced yet on latest code available from
> > > kdave/for-next branch.
> > 
> > Maybe changes in upstream might have masked the issue in the recent
> > kdave/for-next branch. I say that because 'git bisect' resulted in the
> > following commit ...
> 
> I guess that the for-next branch didn't revert this patch[1] as upstream
> did, [...]

> [1]: Btrfs: adjust len of writes if following a preallocated extent
> https://patchwork.kernel.org/patch/9413129/

The revert was present in the for-next-20161219 branch, the for-next
branches sit on top of recent upstream rc tag and are merged from
various dev branches so the patch difference should be minimal in the
end.
