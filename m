Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:58226 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408AbbFVUmT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Jun 2015 16:42:19 -0400
Date: Tue, 23 Jun 2015 06:42:15 +1000
From: Dave Chinner <david@fromorbit.com>
To: dsterba@suse.cz, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org, fdmanana@suse.com, kzak@redhat.com,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: i_version vs iversion (Was: Re: [RFC PATCH v2 1/2] Btrfs: add
 noi_version option to disable MS_I_VERSION)
Message-ID: <20150622204215.GA1557@dastard>
References: <1434527672-5762-1-git-send-email-bo.li.liu@oracle.com>
 <20150617153306.GY6761@twin.jikos.cz>
 <20150617155234.GB7773@localhost.localdomain>
 <20150617170118.GA6761@twin.jikos.cz>
 <20150618024607.GA8530@localhost.localdomain>
 <20150618143856.GG6761@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150618143856.GG6761@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 18, 2015 at 04:38:56PM +0200, David Sterba wrote:
> Moving the discussion to fsdevel.
> 
> Summary: disabling MS_I_VERSION brings some speedups to btrfs, but the
> generic 'noiversion' option cannot be used to achieve that. It is
> processed before it reaches btrfs superblock callback, where
> MS_I_VERSION is forced.
> 
> The proposed fix is to add btrfs-specific i_version/noi_version to btrfs,
> to which I object.

The issue is that you can't overide IS_I_VERSION(inode) because it
looks at the superblock flag, yes?

So perhaps IS_I_VERSION should become an inode flag, set by the
filesystem at inode instantiation time, and hence filesystems can
choose on a per-inode basis if they want I_VERSION behaviour or not.
At that point, the behaviour of MS_I_VERSION becomes irrelevant to
the discussion, doesn't it?

> xfs also forces I_VERSION if it detects the superblock version 5, so it
> could use the same fix that would work for btrfs.

XFS is a special snowflake - it updates the I_VERSION only when an
inode is otherwise modified in a transaction, so turning it off
saves nothing. (And yes, timestamp updates are transactional in
XFS). Hence XFS behaviour is irrelevant to the discussion, because
we aren't ever going to turn it off....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
