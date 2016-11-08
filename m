Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41642 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751670AbcKHXPf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 8 Nov 2016 18:15:35 -0500
Message-Id: <1478646934.2753701.781728689.373545C7@webmail.messagingengine.com>
From: Ian Kelling <ian@iankelling.org>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
In-Reply-To: <20161108230057.GQ16645@carfax.org.uk>
Date: Tue, 08 Nov 2016 15:15:34 -0800
References: <1478645336.2739242.781712345.6ADE1927@webmail.messagingengine.com>
 <20161108230057.GQ16645@carfax.org.uk>
Subject: Re: Could receive allow updating an existing subvolume?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 8, 2016, at 03:00 PM, Hugo Mills wrote:
> On Tue, Nov 08, 2016 at 02:48:56PM -0800, Ian Kelling wrote:
> > It seems to be an artificially imposed limitation which hurts which
> > hurts its usefulness. Let me know if this makes sense. If so, perhaps it
> > can be implemented eventually. It seems a bit obvious but I couldn't
> > find any existing discussion of it.
> 
>    It's not artificial -- it's ensuring safety of operation.

No, it doesn't ensure the subvolume is not modified, so it IS
artificial. I can still set the subvolume to rw before or probably
during the send and modify a file and mess things up.

> 
>    If the sender sends an incremental stream, that assumes an *exact*
> subvol state on the receiving side. If the subvol on the receiving
> side is modified, then the receive can fail.

No. The reading program never needs to have access to rw files if it's
reading from a read-only mountpoint while the subvolume is rw and
mounted as such elsewhere. And a reading program does not magically risk
writes.

> 
>    So, the assumption is that the reference subvol on the receiving
> side (equivalent to the -p subvol on the sending side) hasn't been
> changed since it was received. The same assumption applies to the -p
> subvol on the sending side.
> 
>    Now, receive is a fully userspace tool, so it would have to set the
> subvol to RW, then update it, then set it to RO. The subvol risks
> being modified by other processes during that window -- *particularly*
> if it's actively being read by those other processes.

No. The reading program never needs to have access to rw files if it's
reading from a read-only mountpoint while the subvolume is rw and
mounted as such elsewhere. And a reading program does not magically risk
writes.

> 
>    Note that this is still an issue with the current situation, but
> the expectation is that nothing's going to be actively reading that
> location at the time the receive is running. But, if something does go
> wrong with the receive, it's possible to abort and restart the
> process. If you're modifying an existing subvol, there's no
> recoverability if something goes wrong halfway through.

No. You could recover using the snapshot that I mentioned.

>    Hugo.

So my question still stands.
