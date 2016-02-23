Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46405 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbcBWLeR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 06:34:17 -0500
Date: Tue, 23 Feb 2016 12:34:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use proper type for failrec in extent_state
Message-ID: <20160223113407.GJ4374@suse.cz>
Reply-To: dsterba@suse.cz
References: <1455193453-14837-1-git-send-email-dsterba@suse.com>
 <20160222175837.GH4374@twin.jikos.cz>
 <56CBBEC3.8040106@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <56CBBEC3.8040106@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 23, 2016 at 10:06:59AM +0800, Qu Wenruo wrote:
> > I'm not sure why, but my gcc 5.3.1 think's that a member of failrec can
> > be used uninitialized:
> >
> >    CC [M]  fs/btrfs/extent_io.o
> > fs/btrfs/extent_io.c: In function ‘clean_io_failure’:
> > fs/btrfs/extent_io.c:2133:4: warning: ‘failrec’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> >      repair_io_failure(inode, start, failrec->len,
> >      ^
> >
> After applying your patch on integration-4.6, and compiling, my gcc 
> 5.3.0 didn't give such warning though.
> 
> And I didn't see an official 5.3.1, but only 5.3 so I assume maybe it's 
> related to the .1 from your distribution?

Yes it's distro gcc 5.3 + patches. Arnd sent a patch to fix the warning.
