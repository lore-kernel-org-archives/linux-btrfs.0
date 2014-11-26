Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52527 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbaKZKUV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 05:20:21 -0500
Date: Wed, 26 Nov 2014 05:20:17 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] vfs: don't let the dirty time inodes get more than a
 day stale
Message-ID: <20141126102017.GJ28449@thunk.org>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
 <1416599964-21892-4-git-send-email-tytso@mit.edu>
 <20141125015332.GE27262@dastard>
 <20141125044508.GG31339@thunk.org>
 <20141125234851.GB9561@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141125234851.GB9561@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 26, 2014 at 10:48:51AM +1100, Dave Chinner wrote:
> No abuse necessary at all. Just a different inode_dirtied_after()
> check is requires if the inode is on the time dirty list in
> move_expired_inodes().

I'm still not sure what you have in mind here.  When would this be
checked?  It sounds like you want to set a timeout such that when an
inode which had its timestamps updated lazily 24 hours earlier, the
inode would get written out.  Yes?  But that implies something is
going to have to scan the list of inodes on the dirty time list
periodically.  When are you proposing that this take place?

The various approaches that come to mind all seem more complex than
what I have in this patch 3 of 4, and I'm not sure it's worth the
complexity.

						- Ted
