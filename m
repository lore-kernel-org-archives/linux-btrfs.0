Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51007 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbbKXHmA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 02:42:00 -0500
Date: Mon, 23 Nov 2015 23:41:59 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, david@fromorbit.com,
        fstests@vger.kernel.org, xfs@oss.sgi.com, tao.peng@primarydata.com,
        linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] generic/15[78]: fix error messages in the golden
 output
Message-ID: <20151124074159.GA32289@infradead.org>
References: <20151121005001.20398.92856.stgit@birch.djwong.org>
 <20151121005014.20398.22316.stgit@birch.djwong.org>
 <20151121180644.GA23916@infradead.org>
 <20151123212533.GC10589@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151123212533.GC10589@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 23, 2015 at 01:25:33PM -0800, Darrick J. Wong wrote:
> > Shouldn't these be Invalid argument just like the
> > to a device case above or the clone case?
> 
> I was trying to mirror the behavior of reflink, which spits out
> EOPNOTSUPP when the destination isn't a regular file and EINVAL
> when the source isn't a regular file.

clone is called on the destination and takes the source from the
ioctl argument.  dedupe is called on the source and then opens the
destinations, so they're not really comparable.  Btrfs currently
returns EACCES for non-dir, non-regular destinations which look
wrong and I think EINVAL for a mismatch between source and destination
types would make most sense.  I've also prepared a btrfs patch for
this and clone, but I'd like to have consensus on the exact error
first.
