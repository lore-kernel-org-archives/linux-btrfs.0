Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932342AbbAFS0x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Jan 2015 13:26:53 -0500
Date: Tue, 6 Jan 2015 19:26:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Lennart Poettering <lennart@poettering.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs_inode_item's otime?
Message-ID: <20150106182652.GE24104@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150105172152.GB19126@gardel-login>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150105172152.GB19126@gardel-login>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 05, 2015 at 06:21:52PM +0100, Lennart Poettering wrote:
> btrfs' btrfs_inode_item structure contains a field for the birth time
> of a file, .otime. This field could be quite useful, and I'd like to
> make use of it. I can query it with the BTRFS_IOC_TREE_SEARCH ioctl
> from userspace, alas it appears that the entry is never actually
> initialized to anything other than 0?
> 
> Is this on purpose, or simply an oversight? It should be easy to
> initialize it to the mtime when the inode is first created...

I'ts probably just lack of implementation due to lack of interface to
userspace, but we should set it.

> I am aware of the discussions about introducing the birth time as
> something queriable with a future xstat() call. Even if that
> high-level API doesn't exist yet, and even if it might be messy to use
> BTRFS_IOC_TREE_SEARCH to query the otime currently, I think it would
> be good to properly initialize the field, so that pre-existing file
> systems would report useful data when xstat() is added one day...

Agreed.

> (Of course, even without xstat(), I think it would be good to have an
> unprivileged ioctl to query the otime in btrfs... the TREE_SEARCH
> ioctl after all requires privileges...)

Adding this interface is a different question. I do not like to add
ioctls that do too specialized things that normally fit into a generic
interface like the xstat example. We could use the object properties
instead (ie. export the otime as an extended attribute), but the work on
that has stalled and it's not ready to just simply add the otime in
advance.
