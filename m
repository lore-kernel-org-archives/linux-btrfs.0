Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3JJXXe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Oct 2013 19:23:34 -0400
Date: Thu, 10 Oct 2013 16:23:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: David Sterba <dsterba@suse.cz>, stable@vger.kernel.org,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: Handful of btrfs fixes for 3.11.x stable
Message-ID: <20131010232332.GK4301@kroah.com>
References: <1379694879-29402-1-git-send-email-dsterba@suse.cz>
 <20130920165301.GA11262@kroah.com>
 <20131005235218.GG18223@kroah.com>
 <20131007203443.GA16461@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131007203443.GA16461@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 07, 2013 at 04:34:43PM -0400, Josef Bacik wrote:
> On Sat, Oct 05, 2013 at 04:52:18PM -0700, Greg KH wrote:
> > On Fri, Sep 20, 2013 at 09:53:02AM -0700, Greg KH wrote:
> > > On Fri, Sep 20, 2013 at 06:34:39PM +0200, David Sterba wrote:
> > > > Hi stable team,
> > > > 
> > > > please add the following commits to 3.11 tree, they fix user visible problems,
> > > > were tested and are now present in 3.12-rc1.
> > > > 
> > > > 3d05ca371200b3366530621abf73769024581b79
> > > > b13a004528c3e5eb060a26eee795f5a0da7bfe9f
> > > > 7ef67ffda91cc0c56f33937bfdf1d057b9ee96ca
> > > > ca6d07c1d74bf7ba3083bc31a9aeeaa1d0ad86aa
> > 
> > These git commit ids don't match up to anything in Linus's tree, where
> > did you get them from?
> > 
> > > > Josef Bacik (4):
> > > >   Btrfs: reset ret in record_one_backref
> > > >   Btrfs: change how we queue blocks for backref checking
> > > >   Btrfs: skip subvol entries when checking if we've created a dir already
> > > >   Btrfs: remove ourselves from the cluster list under lock
> > 
> > I can dig through the tree to find these, but I'd prefer if you could
> > provide the correct ids to verify I got them right.
> > 
> > Also, what order do I apply them in?
> 
> You can commit them in that order (top to bottom), here are their corresponding
> commits
> 
> 50f1319cb5f7690e4d9de18d1a75ea89296d0e53
> b6c60c8018c4e9beb2f83fc82c09f9d033766571
> a05254143cd183b18002cbba7759a1e4629aa762
> b8d0c69b9469ffd33df30fee3e990f2d4aa68a09

All now applied, thanks.

greg k-h
