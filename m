Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:40526 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751304AbbJFBdJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Oct 2015 21:33:09 -0400
Date: Tue, 6 Oct 2015 12:31:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v2] fstests: generic: Check if a bull fallocate will
 change extent number
Message-ID: <20151006013141.GA32150@dastard>
References: <1443519264-19184-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150929215135.GZ3902@dastard>
 <560E41E9.2020204@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <560E41E9.2020204@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 02, 2015 at 04:35:53PM +0800, Qu Wenruo wrote:
> Hi Dave, I updated the patch and moved it to btrfs.
> 
> But I still has some question about the fallocate behavior.
> 
> Just as the new btrfs test case, I changed the fallocate range, not
> to cover the last part, to make the problem more obvious:
> 
> Btrfs will truncate beyond EOF even that's *not covered* by the
> fallocate range.
> 
> It's OK for a fs to modify the extent layout during fallocate, but
> is it OK to modify extent layout completely *out* of the fallocate
> range?

It's beyond EOF, so the filesystem can make whatever changes to
allocated blocks in that space whenever it likes because userspace
cannot access it.

In XFS, we don't remove unwritten extents beyond EOF if they were
placed there by fallocate except via explicit truncate() or
fallocate() operations (e.g. hole punch) from userspace that
manipulate that extent range beyond EOF.

What other filesytems do with blocks beyond EOF in any given
operation is up to the filesystem, really. If btrfs wants to
truncate away all extents beyond EOF when punching a hole that spans
EOF, then you can do that. It might not be what the user expects,
but blocks beyond EOF don't fall under posix_fallocate() because
it explicitly states:

"If the size of the file is less than offset+len, then the file is
increased to this size; otherwise the file size is left unchanged."

which means it can't allocate blocks beyond EOF....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
