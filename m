Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab3IWQ4L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 12:56:11 -0400
Date: Mon, 23 Sep 2013 18:56:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Sterba <dsterba@suse.cz>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: Handful of btrfs fixes for 3.11.x stable
Message-ID: <20130923165604.GQ6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1379694879-29402-1-git-send-email-dsterba@suse.cz>
 <20130920165301.GA11262@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130920165301.GA11262@kroah.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 20, 2013 at 09:53:02AM -0700, Greg KH wrote:
> On Fri, Sep 20, 2013 at 06:34:39PM +0200, David Sterba wrote:
> > 3d05ca371200b3366530621abf73769024581b79
> > b13a004528c3e5eb060a26eee795f5a0da7bfe9f
> > 7ef67ffda91cc0c56f33937bfdf1d057b9ee96ca
> > ca6d07c1d74bf7ba3083bc31a9aeeaa1d0ad86aa
> > 
> > Josef Bacik (4):
> >   Btrfs: reset ret in record_one_backref
> >   Btrfs: change how we queue blocks for backref checking
> >   Btrfs: skip subvol entries when checking if we've created a dir already
> >   Btrfs: remove ourselves from the cluster list under lock
> 
> Thanks for this, I'll queue them up soon.  Are any of these applicable
> for 3.10 as well?

The first one is not applicable.

These two apply directly (3rd, 4th):

Btrfs: skip subvol entries when checking if we've created a dir already
7ef67ffda91cc0c56f33937bfdf1d057b9ee96ca

Btrfs: remove ourselves from the cluster list under lock
ca6d07c1d74bf7ba3083bc31a9aeeaa1d0ad86aa


I'm no sure about the 2nd, this one leads to crash in 3.11 but I'm not
aware of any 3.10.x report, so ti could be affected by later changes.
Josef knows better.

Btrfs: change how we queue blocks for backref checking
b13a004528c3e5eb060a26eee795f5a0da7bfe9f


thanks,
david
