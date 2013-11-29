Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53174 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959Ab3K2Pp1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Nov 2013 10:45:27 -0500
Date: Fri, 29 Nov 2013 16:45:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe David Borba Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com
Subject: Re: [PATCH] Btrfs: optimize btrfs_lookup_extent_info() - extent
 refcount mismatches?
Message-ID: <20131129154525.GN25312@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Fri, Jul 05, 2013 at 09:32:05PM +0100, Filipe David Borba Manana wrote:
> If we're looking for a metadata item in the tree and the
> search fails with return value of 1, and the slot doesn't
> point to the first item in the leaf, check if the previous
> item in the leaf corresponds to an extent item for the same
> object id - if it does, then don't do another tree search
> to get it.

I'm suspecting this patch to cause some trouble, see
https://bugzilla.kernel.org/show_bug.cgi?id=64961

but there were more reports similar to this one:
http://www.spinics.net/lists/linux-btrfs/msg29243.html
http://www.spinics.net/lists/linux-btrfs/msg29478.html

I did a quick analysis in comment 3, the warning pops when there are 0
references, there's no other evidence that the extent should have none.
This happens during balance, so far the working hypothesis is that the
refcount changes during relocation (eg. subvolume deletion) but is not
fixed up in the late reloc phase.

fsck finds lots of wrong refcounts, off by one. The kernel warning fires
only if the refcount is 0 though there are > 0 expected. So this could
mean that the refcount is silently wrong all the time.


david
