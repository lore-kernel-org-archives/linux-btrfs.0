Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:47692 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab3AHIbo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jan 2013 03:31:44 -0500
Date: Tue, 8 Jan 2013 09:30:54 +0100
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix off-by-one in lseek
Message-ID: <20130108083053.GD3763@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1357530788-5790-1-git-send-email-bo.li.liu@oracle.com>
 <20130107162050.GJ20089@twin.jikos.cz>
 <20130108024637.GA1916@liubo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130108024637.GA1916@liubo>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 08, 2013 at 10:46:38AM +0800, Liu Bo wrote:
> On Mon, Jan 07, 2013 at 05:20:50PM +0100, David Sterba wrote:
> > On Mon, Jan 07, 2013 at 11:53:08AM +0800, Liu Bo wrote:
> > Fix looks ok. I think this should be caught at runtime as well, the
> > number of ways how the lock start and end are passed is not small and it
> > need not be always possible to catch it from reading sources. The range
> > is inclusive, so it's 'lock end % 2 == 1' right? (in the bit
> > manipulating primitives).
> 
> Hmm, not always here, lockend = inode->i_size - 1, so lockend % 2 == 1 may not
> be true.

Yeah, that's the case that must be handled,

> But this check can worked in those places where we've rounded the range up to
> PAGE_SIZE :)

context:
2233         u64 lockend = i_size_read(inode);
...
2236         u64 len = i_size_read(inode);
...
2240         lockend = max_t(u64, root->sectorsize, lockend);
^^^^

lockend will be always at least root->sectorsize == PAGE_SIZE, so the simple
% 2 == 1 test should work generally. Am I missing something? Do we really lock
sub-PAGE_SIZE ranges?

2241         if (lockend <= lockstart)
2242                 lockend = lockstart + root->sectorsize;
2243
2244         len = lockend - lockstart + 1;
2245
2246         len = max_t(u64, len, root->sectorsize);
2247         if (inode->i_size == 0)
2248                 return -ENXIO;

