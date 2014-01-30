Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaA3SaJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 13:30:09 -0500
Date: Thu, 30 Jan 2014 19:30:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Matthew Lai <m@matthewlai.ca>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send requires root
Message-ID: <20140130183007.GD1364@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52E955F2.60608@matthewlai.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52E955F2.60608@matthewlai.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 29, 2014 at 11:26:42AM -0800, Matthew Lai wrote:
> I have just started playing with btrfs, and noticed that "btrfs send" only
> works for root (ERROR: failed to initialize subvol search. Operation not
> permitted), even on subvolumes created by the user.
> 
> Am I doing something wrong? Or is this the intended behaviour?

Intended but can be revisited to allow non-root owner's to send their
snapshots.

> Returns:
> ERROR: can't perform the search- Operation not permitted
> ERROR: failed to initialize subvol search. Operation not permitted

The SEARCH_TREE ioctl is also root-only and a unconstrained interface to
the filesystem internals, so a new ioctl would have to be introduced to
do what send needs.
