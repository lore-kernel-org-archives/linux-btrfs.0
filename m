Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:41080 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752326AbeDSAw5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 20:52:57 -0400
Date: Wed, 18 Apr 2018 17:54:03 -0700
From: Eric Biggers <ebiggers3@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: d_instantiate() and unlock_new_inode() order in btrfs_mkdir()
Message-ID: <20180419005403.GA946@sol.localdomain>
References: <20180419000029.GA133757@gmail.com>
 <20180419000612.GF30522@ZenIV.linux.org.uk>
 <20180419001559.GG30522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180419001559.GG30522@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 19, 2018 at 01:15:59AM +0100, Al Viro wrote:
> On Thu, Apr 19, 2018 at 01:06:13AM +0100, Al Viro wrote:
> > On Wed, Apr 18, 2018 at 05:00:29PM -0700, Eric Biggers wrote:
> > > Hi Chris and other btrfs folks,
> > > 
> > > btrfs_mkdir() calls d_instantiate() before unlock_new_inode(), which is wrong
> > > because it exposes the inode to lookups before it's been fully initialized.
> > 
> > Huh?  It *is* fully initialized by that point; what else is left to do?
> 
> 	ISTR something about false positives from lockdep (with
> lockdep_annotate_inode_mutex_key() called too late, perhaps?); said that, it
> was a long time ago and I don't remember details at the moment...  Are you
> actually seeing a deadlock there or is that just lockdep complaining?

It's an actual deadlock.  unlock_new_inode() calls
lockdep_annotate_inode_mutex_key() which calls init_rwsem(), which resets
i_rwsem->count while it's read-locked by lookup_slow().  Then the unlock in
lookup_slow() makes i_rwsem->count negative, which makes it appear to be
write-locked.

So no, the inode isn't fully initialized until unlock_new_inode() ran.

Eric
