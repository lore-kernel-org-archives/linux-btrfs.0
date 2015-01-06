Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbbAFSlD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Jan 2015 13:41:03 -0500
Date: Tue, 6 Jan 2015 19:41:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Samuel <chris@csamuel.org>
Cc: linux-btrfs@vger.kernel.org, Lennart Poettering <lennart@poettering.net>
Subject: Re: btrfs_inode_item's otime?
Message-ID: <20150106184100.GF24104@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20150105172152.GB19126@gardel-login>
 <1891475.iuyauiTsCQ@quad>
 <3797928.30urVis5AR@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3797928.30urVis5AR@quad>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 06, 2015 at 11:43:22PM +1100, Chris Samuel wrote:
> On Tue, 6 Jan 2015 10:47:00 PM Chris Samuel wrote:
> 
> > On Mon, 5 Jan 2015 06:21:52 PM Lennart Poettering wrote:
> > 
> > > It should be easy to initialize it to the mtime when the inode is
> > > first created...
> > 
> > This I agree with, well worth doing anyway.
> > 
> > I'll see if I can knock up a patch.
> 
> Sadly it appears that the btrfs code sets mtime/ctime/atimeat inode creation  
> via the normal filesystem inode structure, not through it's own, and as that 
> doesn't include otime I'm afraid it's out of my league.  Worth a shot though!

Set the otime in btrfs_new_inode after the call to fill_inode_item.
