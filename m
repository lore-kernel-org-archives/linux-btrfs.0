Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbaBDTtK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Feb 2014 14:49:10 -0500
Date: Tue, 4 Feb 2014 11:50:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chris Mason <clm@fb.com>
Cc: dsterba@suse.cz, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs
Message-ID: <20140204195016.GA5264@kroah.com>
References: <52EAC9B6.7090603@fb.com>
 <20140203175405.GL1364@twin.jikos.cz>
 <52EFDD80.4050800@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52EFDD80.4050800@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 03, 2014 at 01:18:40PM -0500, Chris Mason wrote:
> On Mon 03 Feb 2014 12:54:05 PM EST, David Sterba wrote:
> >On Thu, Jan 30, 2014 at 04:52:54PM -0500, Chris Mason wrote:
> >>Chris Mason (3) commits (+64/-32):
> >>     Btrfs: setup inode location during btrfs_init_inode_locked (+9/-9)
> >>     Btrfs: don't use ram_bytes for uncompressed inline items (+52/-22)
> >
> >The patches are CC: stable, but haven't gone through the mailinglist.
> >Are they still going to be picked by stable?
> 
> We do need both in -stable, I'll help with backports.

Very few of the patches you marked for -stable, actually would apply (or
build once applied.)  Can you please send a set of patches you want
applied?

thanks,

greg k-h
