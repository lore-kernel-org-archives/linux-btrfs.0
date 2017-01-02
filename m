Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60414 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933821AbdABSVU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jan 2017 13:21:20 -0500
Date: Mon, 2 Jan 2017 19:21:04 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, jbacik@fb.com
Subject: Re: [PULL REQUEST FOR NEXT PATCH 00/26] Patches from Fujitsu for
 next version
Message-ID: <20170102182104.GM12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20161230010036.28099-1-quwenruo@cn.fujitsu.com>
 <20170102164738.GK12081@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170102164738.GK12081@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 02, 2017 at 05:47:38PM +0100, David Sterba wrote:
> On Fri, Dec 30, 2016 at 09:00:36AM +0800, Qu Wenruo wrote:
> > Hi, please fetch the following branch for next branch:
> > https://github.com/adam900710/linux.git fujitsu_for_next
> > 
> > This branch contains most of Fujitsu unmerged patches for for-next branch.
> > 
> > Latest David's for-next-20161219 branch can cause kernel panic so I don't
> > use it as base, but v4.10-rc1.
> 
> The for-next branch will be reassembled again as we're past rc1 now.
> 
> > I ran the full xfstests test cases, with both default mount options and
> > compress=lzo options.
> > Fixes are working and no new regression.
> > 
> > So I thing it should be good enough to act as a base for for-next branch.
> > 
> > This big patch set contains the following fixes:
> > 
> > 1) Wang's fixes for compression ENOSPC
> 
> AFAIK, the patches have been reviewed only partially and used to be part
> of for-next until the merge conflicts became unbearable. Patches
> touching space handling need review before merging and at least some
> sort of ack in case of for-next.

The 3 patches added to for-next.
