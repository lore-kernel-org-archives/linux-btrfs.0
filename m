Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49074 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaKYEpN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 23:45:13 -0500
Date: Mon, 24 Nov 2014 23:45:08 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] vfs: don't let the dirty time inodes get more than a
 day stale
Message-ID: <20141125044508.GG31339@thunk.org>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
 <1416599964-21892-4-git-send-email-tytso@mit.edu>
 <20141125015332.GE27262@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141125015332.GE27262@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 25, 2014 at 12:53:32PM +1100, Dave Chinner wrote:
> On Fri, Nov 21, 2014 at 02:59:23PM -0500, Theodore Ts'o wrote:
> > Guarantee that the on-disk timestamps will be no more than 24 hours
> > stale.
> > 
> > Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> 
> If we put these inodes on the dirty inode list with at writeback
> time of 24 hours, this is completely unnecessary.

What do you mean by "a writeback time of 24 hours"?  Do you mean
creating a new field in the inode which specifies when the writeback
should happen?  I still worry about the dirty inode list getting
somewhat long large in the strictatime && lazytime case, and the inode
bloat nazi's coming after us for adding a new field to struct inode
structure.

Or do you mean trying to abuse the dirtied_when field in some way?

      	       	      	       	   - Ted
