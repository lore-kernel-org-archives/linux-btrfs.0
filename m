Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbbEMRCf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 13:02:35 -0400
Date: Wed, 13 May 2015 19:02:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: make root id query unprivileged
Message-ID: <20150513170233.GU23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431450889-27968-1-git-send-email-dsterba@suse.cz>
 <55537ED2.2050801@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55537ED2.2050801@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 13, 2015 at 06:41:54PM +0200, Goffredo Baroncelli wrote:
> I think that make sense to add another ioctl instead of relaxing the privilege check
> on the basis of the parameters.

Yeah, that was another way how to do it. In general I'm more inclined to
use the existing ioctls and related structures and avoid single purpose
ioctl.

Furthermore, we can teach btrfs_ioctl_ino_lookup to verify access rights
to the file it finds. The root restriction is not unnecessary in all
cases.

We've relaxed the ioctl permissions in the past, see FS_INFO for
example. I hope we can afford that if that's for sake of better
usability and user convenience.

> If I read correctly the code, in this case the function 
> btrfs_search_path_in_tree() is not even called: it is requested to return only 
> 
> 	BTRFS_I(inode)->root->root_key.objectid;

Right.
