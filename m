Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097Ab3LQRsR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 12:48:17 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20131217172002.GE11281@carfax.org.uk>
References: <20131217172002.GE11281@carfax.org.uk> <14884.1387299196@warthog.procyon.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: dhowells@redhat.com, Simon Wilkinson <simonxwilkinson@gmail.com>,
        jaltman@your-file-system.com,
        "openafs-devel@openafs.org" <openafs-devel@openafs.org>,
        linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: What is needed to build an AFS fileserver on top of BTRFS?
Date: Tue, 17 Dec 2013 17:47:58 +0000
Message-ID: <17945.1387302478@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills <hugo@carfax.org.uk> wrote:

> >  (1) 64-bit data version numbers that increase monotonically with
> > each write. Yes, this is likely to cause some performance
> > degredation as it introduces an ordering over data writes and
> > metadata writes to a file. Maybe writes can be batched to improve
> > performance?
> 
>    Do these have to be per-file? If not, then you might be able to get
> away with using the transid, which is a filesystem-global
> monotonically-increasing number.

Yes.  If you send a write RPC op to the server, you get back the new version
number.  If the new version number is not the old version number + 1 you know
there was a collision with a write from another client and you have to flush
your cache for that file and request a new "callback" (ie. a promise to notify
you if someone else changes the file).

> >  (3) The ability to snapshot a filesystem to make backups and for
> >      pushing to read-only volume servers.
> 
>    We have snapshots of subvolumes, but not the filesystem as a whole.

By "filesystem" I meant the current state of an AFS volume.  Very likely this
would be represented by a BTRFS subvolume, if I understand it correctly.  You
might have several AFS volumes represented within a BTRFS filesystem.  They
would be manipulated independently.

> >  (5) The ability to set the vnode number, vnode uniquifier and data
> >      version number to specific values. Necessary to clone volumes
> >      and restore volume dumps.
> 
>    What's a vnode meant to represent? I'm not familiar with the
> terminology.

AFS's equivalent of an inode with a 32-bit number representing it.  See my
reply to Chris's question about the same thing.

David
