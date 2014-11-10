Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:64783 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533AbaKJBbU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Nov 2014 20:31:20 -0500
Date: Mon, 10 Nov 2014 12:31:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Filipe Manana <fdmanana@suse.com>, fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] fstests: add generic test to verify xattr replace
 operations are atomic
Message-ID: <20141110013115.GL28565@dastard>
References: <1415392826-11606-1-git-send-email-fdmanana@suse.com>
 <20141109234522.GK28565@dastard>
 <CAL3q7H5JqquwHeWSTMCnTiTGBTuh77w9HS2V2LW06TpON_saUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5JqquwHeWSTMCnTiTGBTuh77w9HS2V2LW06TpON_saUg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 10, 2014 at 12:49:12AM +0000, Filipe David Manana wrote:
> On Sun, Nov 9, 2014 at 11:45 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Nov 07, 2014 at 08:40:26PM +0000, Filipe Manana wrote:
> >> This test verifies that replacing a xattr's value is an atomic
> >> operation. This is motivated by an issue in btrfs where replacing
> >> a xattr's value wasn't an atomic operation, it consisted of
> >> removing the old value and then inserting the new value in a
> >> btree. This made readers (getxattr and listxattrs) not getting
> >> neither the old nor the new value during a short time window.
> >
> > OK, seems like a good thing to test that the application can only
> > see the old or the new value.
> >
> > However, I can't help but wonder about whether the btrfs behaviour
> > is crash safe as it wasn't designed to be atomic from the ground up.
> > i.e. if the system crashes half way through a attribute overwrite,
> > what does btrfs end up with as a result? XFS is guaranteed at a
> > transactional level to return either the old or the new value,
> > depending on where in the operaiton the crash occurred, but I'd just
> > assumed that everyone did attribute replace atomically so it never
> > occurred to me that it might be an issue...
> 
> It's crash safe. Both the delete and insert were done in the same
> transaction, so a crash in between both operations (or after both and
> before the transaction commit) would result in always seeing the old
> value (or better saying, the last persisted value by a transaction
> commit or fsync).

Alright, so no crash issues because all the modifications are in a
single transaction. However, if both modifications are made in the
same transaction, then this bug implies that a user can read a
metadata object in the btree whilst somethign else is concurrently
modifying it, right? i.e. that there is no serialisation between
inode metadata reads and transactional modification operations?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
