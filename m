Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.srv.cs.cmu.edu ([128.2.217.200]:49478 "EHLO
	smtp01.srv.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab3LQTln (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 14:41:43 -0500
Message-ID: <1387305748.25257.34.camel@destiny.pc.cs.cmu.edu>
Subject: Re: [OpenAFS-devel] Re: What is needed to build an AFS fileserver
 on top of BTRFS?
From: Jeffrey Hutzelman <jhutz@cmu.edu>
To: David Howells <dhowells@redhat.com>
Cc: jhutz@cmu.edu, Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "simonxwilkinson@gmail.com" <simonxwilkinson@gmail.com>,
        "jaltman@your-file-system.com" <jaltman@your-file-system.com>,
        "openafs-devel@openafs.org" <openafs-devel@openafs.org>
Date: Tue, 17 Dec 2013 13:42:28 -0500
In-Reply-To: <17653.1387302045@warthog.procyon.org.uk>
References: <1387300065.15080.6.camel@ret.masoncoding.com>
	 <14884.1387299196@warthog.procyon.org.uk>
	 <17653.1387302045@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2013-12-17 at 17:40 +0000, David Howells wrote:
> Chris Mason <clm@fb.com> wrote:
> 
> > Hmmm, what exactly are vnodes?  Could we put them in xattrs?
> 
> vnode numbers are AFS's equivalent of inode numbers.  Since they're one per
> file, they could be the object filename.

Yes, in fact, the volume, vnode number, uniqifier, and DV are
effectively the "name" the fileserver uses for the underlying inode.
Note that if the fileserver is maintaining the vnode indices, then you
don't actually _need_ to store a uniqifier for normal operation, because
at any given time, a volume can contain at most one vnode with a
particular vnode number, and that vnode's uniqifier is stored in the
index.  The uniqifier is used on-the-wire to distinguish different files
that existed at different points in time with the same vnode number.

> Probably there would have to be a table of {vnode,latest_uniquifier} as the
> uniquifier must still go up even if the vnode is unused for a while, so there
> could also be a table of {vnode,btrfs_file}.

No, you don't actually  have to do this.  The OpenAFS fileserver
maintains a single uniqifier for an entire volume, and simply increments
it every time a vnode is created.

-- Jeff


