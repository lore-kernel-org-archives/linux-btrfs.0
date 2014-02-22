Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57570 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbaBVAD6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Feb 2014 19:03:58 -0500
Date: Sat, 22 Feb 2014 01:03:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: kreijack@inwind.it, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>,
        Kostia Khlebopros <kkhlebopros@netgear.com>
Subject: Re: [PATCH][BTRFS-PROGS][v4] Enhance btrfs fi df
Message-ID: <20140222000356.GN16073@suse.cz>
Reply-To: dsterba@suse.cz
References: <52FD1A72.5060307@libero.it>
 <20140220180857.GW16073@twin.jikos.cz>
 <53064A42.7000703@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53064A42.7000703@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 20, 2014 at 01:32:34PM -0500, Josef Bacik wrote:
> > Yes for 3), we may also export the information through the
> > existing ioctls if possible (eg. IOC_FS_INFO).
> > 
> 
> For _right now_ I'd say just not do the raid56 stuff if we don't
> notice any raid56 chunks from the normal load_space_info, and then if
> there are raid56 we try and run the tree search ioctl and notice if we
> get back EPERM or whatever you get when you don't have permissions.
> Then just spit out as much information that you can about the fs with
> a little note at the bottom that available calculation isn't 100% and
> you need to run as root if you want that info.

Works for me.

> Then what we could do is add another flag type for the existing
> SPACE_INFO ioctl to spit out the information you need about the
> raid5/6 chunks and then just test for those flags and make the
> adjustment necessary.  This way we avoid adding yet another ioctl and
> stuff will still work nicely for old kernels that don't have the
> updated ioctl.  Thanks,

Agreed. Extending SPACE_INFO looks suitable for this.
