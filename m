Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab3LQN4s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 08:56:48 -0500
Date: Tue, 17 Dec 2013 14:56:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: move the extent buffer radix tree into the fs_info
Message-ID: <20131217135647.GM6498@suse.cz>
Reply-To: dsterba@suse.cz
References: <1387218386-5339-1-git-send-email-jbacik@fb.com>
 <20131217010627.GK6498@twin.jikos.cz>
 <1387243189.15080.2.camel@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1387243189.15080.2.camel@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 17, 2013 at 01:19:39AM +0000, Chris Mason wrote:
> On Tue, 2013-12-17 at 02:06 +0100, David Sterba wrote:
> > On Mon, Dec 16, 2013 at 01:26:26PM -0500, Josef Bacik wrote:
> > > I need to create a fake tree to test qgroups and I don't want to have to setup a
> > > fake btree_inode.  The fact is we only use the radix tree for the fs_info, so
> > > everybody else who allocates an extent_io_tree is just wasting the space anyway.
> > > This patch moves the radix tree and its lock into btrfs_fs_info so there is less
> > > stuff I have to fake to do qgroup sanity tests.  Thanks,
> > 
> > This would make the fs_info::buffer_lock a global hotspot if
> > alloc_extent_buffer and release_extent_buffer are called frequently.
> > 
> 
> But since the only place that was really using it was the metadata
> btree, the lock shouldn't be hotter than before right?

Right. What confused me first is that the number of trees that are
initialized by extent_io_tree_init is higher, but the only user is
metadata btree.
