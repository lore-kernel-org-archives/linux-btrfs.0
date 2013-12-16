Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab3LPPTT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 10:19:19 -0500
Date: Mon, 16 Dec 2013 16:19:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gczarcinski@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: moving a subvol
Message-ID: <20131216151917.GH6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <52AB30D4.7050408@czarc.net>
 <52AB3673.1030607@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52AB3673.1030607@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 13, 2013 at 11:31:47AM -0500, Gene Czarcinski wrote:
> On 12/13/2013 11:07 AM, Gene Czarcinski wrote:
> >I have hunted high and low for the information but, if it is out there,
> >it is well hidden.
> >
> >What I want to do:  I want to relocate (move) a subvolume from one BTRFS
> >volume to a different BTRFS volume.
> >
> >I have seen the writeup for incremental backup which takes a snapshot,
> >and then using btrfs-send and btrfs-receive to create a copy on a
> >different volume.  That works fine except the btrfs-receive set the new
> >copy to be readonly.
> >
> >What I want to do is to use that new subvolume read/write.  The only way
> >I have figured out to do this is to create another snapshot on the new
> >volume which is NOT readonly.  I believe that means I need to keep both
> >of these subvolumes around.
> 
> As soon as I sent this I believe I found the answer.
> 
> I was sort of right about creating the new read-write (NOT readonly)
> snapshot.  After it is created simply delete the one which was created by
> btrfs-receive.

ATM, this is the way to do it. There's an ioctl to toggle the RO/RW
status of a subvolume, so it could save you one snapshot, but there's
not tool support to do that. I hope this will be possible with the
upcomming 'per-object properties' feature.

david
