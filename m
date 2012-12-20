Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:44954 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab2LTPA7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Dec 2012 10:00:59 -0500
Date: Thu, 20 Dec 2012 10:00:56 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Steve Leung <sjleung@shaw.ca>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs warning in 3.7.0 with nfsd
Message-ID: <20121220150056.GB15740@shiny>
References: <alpine.DEB.2.02.1212192204390.6456@cubia>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.2.02.1212192204390.6456@cubia>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 19, 2012 at 10:43:28PM -0700, Steve Leung wrote:
> 
> I'm getting some kernel warnings from a btrfs raid1 filesystem that's 
> serving up nfs4 to a couple of other computers on a small home network. 
> I ran 3.6.x for several weeks before upgrading and didn't see any warnings 
> like this.
> 
> [ 1712.223791] WARNING: at fs/btrfs/tree-log.c:3716 btrfs_log_inode_parent+0x291/0x2fd [btrfs]()

I think this one is an EEXIST while we're logging a directory.  It
should be ok, but I've only been able to trigger it once or twice.  I'll
try with NFS.

-chris
