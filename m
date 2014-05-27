Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbaE0PXv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 May 2014 11:23:51 -0400
Date: Tue, 27 May 2014 17:23:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Jeff Mahoney <jeffm@suse.com>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH v3] btrfs: allocate raid type kobjects dynamically
Message-ID: <20140527152349.GK5346@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5383EBE0.2000906@suse.com>
 <20140527112604.GJ5346@suse.cz>
 <53848193.9090709@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53848193.9090709@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 27, 2014 at 08:14:11AM -0400, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 5/27/14, 7:26 AM, David Sterba wrote:
> > A different lockdep chain, from test btrfs/014:
> 
> Are you sure this one was with the new patch? We shouldn't be holding
> groups_sem anymore in btrfs_remove_block_group while performing the
> kobject ops.

Right, the lockdep call chain does not match the sources. I've rebuilt &
rebooted with v3 and am not seeing any of the sysfs related messages.

Tested-by: David Sterba <dsterba@suse.cz>

The fix is for stable 3.13+ and even better if it lands in 3.15, as it
fixes a double-free that can randomly hit other subsystems due to
frequent kmalloc-32 slab reuse,
(eg. https://bugzilla.kernel.org/show_bug.cgi?id=72461).
