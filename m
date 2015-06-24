Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51820 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbbFXR2H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 13:28:07 -0400
Date: Wed, 24 Jun 2015 19:28:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        fdmanana@suse.com, kzak@redhat.com, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: i_version vs iversion (Was: Re: [RFC PATCH v2 1/2] Btrfs: add
 noi_version option to disable MS_I_VERSION)
Message-ID: <20150624172804.GB726@suse.cz>
Reply-To: dsterba@suse.cz
References: <1434527672-5762-1-git-send-email-bo.li.liu@oracle.com>
 <20150617153306.GY6761@twin.jikos.cz>
 <20150617155234.GB7773@localhost.localdomain>
 <20150617170118.GA6761@twin.jikos.cz>
 <20150618024607.GA8530@localhost.localdomain>
 <20150618143856.GG6761@suse.cz>
 <20150622204215.GA1557@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150622204215.GA1557@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2015 at 06:42:15AM +1000, Dave Chinner wrote:
> On Thu, Jun 18, 2015 at 04:38:56PM +0200, David Sterba wrote:
> > Moving the discussion to fsdevel.
> > 
> > Summary: disabling MS_I_VERSION brings some speedups to btrfs, but the
> > generic 'noiversion' option cannot be used to achieve that. It is
> > processed before it reaches btrfs superblock callback, where
> > MS_I_VERSION is forced.
> > 
> > The proposed fix is to add btrfs-specific i_version/noi_version to btrfs,
> > to which I object.
> 
> The issue is that you can't overide IS_I_VERSION(inode) because it
> looks at the superblock flag, yes?

Effectively, yes.

> So perhaps IS_I_VERSION should become an inode flag, set by the
> filesystem at inode instantiation time, and hence filesystems can
> choose on a per-inode basis if they want I_VERSION behaviour or not.

Sounds good, I like that. Looking at the proposed usecase again, the
performance speedup needs the NODATACOW bit set as well, so setting
one more bit is not a big deal.

Besides, the global 'noi_version' does not have the expected effect
because inode::i_version is incremented unconditionally everywhere
(except 1 call site).  From that perspective I think that the
inode-specific bit is the right approach.

> At that point, the behaviour of MS_I_VERSION becomes irrelevant to
> the discussion, doesn't it?

Agreed.

> > xfs also forces I_VERSION if it detects the superblock version 5, so it
> > could use the same fix that would work for btrfs.
> 
> XFS is a special snowflake - it updates the I_VERSION only when an
> inode is otherwise modified in a transaction, so turning it off
> saves nothing. (And yes, timestamp updates are transactional in
> XFS). Hence XFS behaviour is irrelevant to the discussion, because
> we aren't ever going to turn it off....

Understood.

Thanks for the feedback.
