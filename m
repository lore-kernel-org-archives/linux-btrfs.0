Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47618 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab2LLP5f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Dec 2012 10:57:35 -0500
Date: Wed, 12 Dec 2012 23:55:40 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: no full sync flag on new inode when we do not
 reuse inode id
Message-ID: <20121212155538.GA2379@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1354849914-14123-1-git-send-email-bo.li.liu@oracle.com>
 <20121211150117.GD3126@localhost.localdomain>
 <20121212014259.GB12318@liubo>
 <20121212145004.GC3152@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121212145004.GC3152@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 12, 2012 at 09:50:04AM -0500, Josef Bacik wrote:
> On Tue, Dec 11, 2012 at 06:43:04PM -0700, Liu Bo wrote:
> > On Tue, Dec 11, 2012 at 10:01:17AM -0500, Josef Bacik wrote:
> > > On Thu, Dec 06, 2012 at 08:11:54PM -0700, Liu Bo wrote:
> > > > When we are not with inode_cache option, we won't reuse inode id, which
> > > > means all of inodes will own different inode id, thus we don't worry
> > > > about "reuse of inode id leads to log tree's corruption" thing.
> > > > 
> > > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > > 
> > > With the new fsync stuff I have I still need to make sure all new xattrs and
> > > such are on disk so this needs to stay the way it is.  Thanks,
> > 
> > So with new fsync we cannot bare any old items even if their keys's
> > objectid(actually inode id) are different, is it right?
> > 
> 
> No its more that I need to know that I should log everything related to the
> inode, xattrs and all.  Otherwise I'll just log the inode item and make selinux
> very sad.  Thanks,
> 
> Josef

Oh, I see, I've mixed with another different problem, sorry.

thanks,
liubo
