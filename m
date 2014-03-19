Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbaCSSrS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 14:47:18 -0400
Date: Wed, 19 Mar 2014 19:47:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Disseldorp <ddiss@suse.de>
Subject: Re: [PATCH] Btrfs: fix a crash of clone with inline extents's split
Message-ID: <20140319184716.GK29256@suse.cz>
Reply-To: dsterba@suse.cz
References: <1394448967-14128-1-git-send-email-bo.li.liu@oracle.com>
 <20140317144131.GF29256@twin.jikos.cz>
 <20140318105511.GA6163@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140318105511.GA6163@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 18, 2014 at 06:55:13PM +0800, Liu Bo wrote:
> On Mon, Mar 17, 2014 at 03:41:31PM +0100, David Sterba wrote:
> > There are enough EINVAL's that verify correcntess of the input
> > parameters and it's not always clear which one fails. The EOPNOTSUPP
> > errocode is close to the true reason of the failure, but it could be
> > misinterpreted as if the whole clone operation is not supported, so it's
> > not all correct but IMO better than EINVAL.
> 
> Yep, I was hesitating on these two errors while making the patch, but I
> prefer EINVAL rather than EOPNOTSUPP because of the reason you've stated.
> 
> I think it'd be good to add one more btrfs_printk message to clarify what's
> happening here, agree?

I don't think a printk is the right thing here, this means that if an
error happens somebody has to look into the log what happened and act
accordingly.

The EOPNOTSUPP errorcode would allow an application to do a fallback
action, ie. copy the data instead of cloning. The same as if the clone
ioctl would not exist at all.

EINVAL says "you didn't give me valid arguments to work with".
