Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:51491 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbbAGN5h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jan 2015 08:57:37 -0500
Date: Wed, 7 Jan 2015 14:57:35 +0100
From: Lennart Poettering <lennart@poettering.net>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: btrfs_inode_item's otime?
Message-ID: <20150107135734.GA21327@gardel-login>
References: <20150105172152.GB19126@gardel-login>
 <20150106182652.GE24104@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150106182652.GE24104@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 06.01.15 19:26, David Sterba (dsterba@suse.cz) wrote:

> > (Of course, even without xstat(), I think it would be good to have an
> > unprivileged ioctl to query the otime in btrfs... the TREE_SEARCH
> > ioctl after all requires privileges...)
> 
> Adding this interface is a different question. I do not like to add
> ioctls that do too specialized things that normally fit into a generic
> interface like the xstat example. We could use the object properties
> instead (ie. export the otime as an extended attribute), but the work on
> that has stalled and it's not ready to just simply add the otime in
> advance.

Exposig this as xattr sounds great to me too.

Lennart

-- 
Lennart Poettering, Red Hat
