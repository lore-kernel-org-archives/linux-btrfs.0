Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33032 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab3JGUep (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 16:34:45 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 4ABDE9A067A
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Oct 2013 14:34:45 -0600 (MDT)
Date: Mon, 7 Oct 2013 16:34:43 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: David Sterba <dsterba@suse.cz>, <stable@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Handful of btrfs fixes for 3.11.x stable
Message-ID: <20131007203443.GA16461@localhost.localdomain>
References: <1379694879-29402-1-git-send-email-dsterba@suse.cz>
 <20130920165301.GA11262@kroah.com>
 <20131005235218.GG18223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20131005235218.GG18223@kroah.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 05, 2013 at 04:52:18PM -0700, Greg KH wrote:
> On Fri, Sep 20, 2013 at 09:53:02AM -0700, Greg KH wrote:
> > On Fri, Sep 20, 2013 at 06:34:39PM +0200, David Sterba wrote:
> > > Hi stable team,
> > > 
> > > please add the following commits to 3.11 tree, they fix user visible problems,
> > > were tested and are now present in 3.12-rc1.
> > > 
> > > 3d05ca371200b3366530621abf73769024581b79
> > > b13a004528c3e5eb060a26eee795f5a0da7bfe9f
> > > 7ef67ffda91cc0c56f33937bfdf1d057b9ee96ca
> > > ca6d07c1d74bf7ba3083bc31a9aeeaa1d0ad86aa
> 
> These git commit ids don't match up to anything in Linus's tree, where
> did you get them from?
> 
> > > Josef Bacik (4):
> > >   Btrfs: reset ret in record_one_backref
> > >   Btrfs: change how we queue blocks for backref checking
> > >   Btrfs: skip subvol entries when checking if we've created a dir already
> > >   Btrfs: remove ourselves from the cluster list under lock
> 
> I can dig through the tree to find these, but I'd prefer if you could
> provide the correct ids to verify I got them right.
> 
> Also, what order do I apply them in?

You can commit them in that order (top to bottom), here are their corresponding
commits

50f1319cb5f7690e4d9de18d1a75ea89296d0e53
b6c60c8018c4e9beb2f83fc82c09f9d033766571
a05254143cd183b18002cbba7759a1e4629aa762
b8d0c69b9469ffd33df30fee3e990f2d4aa68a09

Thanks,

Josef
