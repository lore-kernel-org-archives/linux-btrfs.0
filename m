Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38918 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbbKIH7c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Nov 2015 02:59:32 -0500
Date: Sun, 8 Nov 2015 23:59:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [RFCv3 00/12] xfstests: test the btrfs/xfs reflink/dedupe ioctls
Message-ID: <20151109075926.GB17974@infradead.org>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151007051257.3260.73072.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 06, 2015 at 10:12:57PM -0700, Darrick J. Wong wrote:
>  * I don't have any interesting NFS/CIFS setups for test. :(

I have a banrch with client and server support for NFSv4.2 CLONE
support:

http://git.infradead.org/users/hch/pnfs.git/shortlog/refs/heads/reflink+clone

For now you want to use btrfs on the server, as using reflinks on XFS
seems to be a little unstable over NFS.

> If you're going to start using this mess, you probably ought to just
> pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
> They should just work with the btrfs that's in 4.3.
> 
> Comments and questions are, as always, welcome.

Any reason the groups are called clone?  I don't really have an opinion
on clone vs reflink but given that the xfs_io command is reflink I'd
rather be consistent.

Otherwise I'd say get it merged ASAP, we can still fix up various
details later.
