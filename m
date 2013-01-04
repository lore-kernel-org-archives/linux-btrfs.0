Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745Ab3ADNVA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Jan 2013 08:21:00 -0500
Date: Fri, 4 Jan 2013 14:20:57 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>, Gene Czarcinski <gene@czarc.net>,
        linux-btrfs@vger.kernel.org
Subject: Re: fsck.btrfs
Message-ID: <20130104132057.GF20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <50D5B92D.105@czarc.net>
 <20121222142733.GR19051@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121222142733.GR19051@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 22, 2012 at 02:27:33PM +0000, Hugo Mills wrote:
> On Sat, Dec 22, 2012 at 08:44:13AM -0500, Gene Czarcinski wrote:
> > I am new to btrfs and have begun exploring and testing it.  One of
> > these tests is to install Fedora 18 into a btrfs volume only leaving
> > /boot and swap on regular partitions.  BTW, this is on
> > qemu/kvm/libvirt virtuals.
> > 
> > I discovered an error was occurring during bootup because systemd
> > was attempting to start fsck.btrfs and it was missing.
> > 
> > 1. Would btrfsck be the appropriate program to run at bootup?  If it
> > is, with what parameters?
> 
>    No, it's not necessary to run an fs checker on every boot. You can
> either turn off the checks in fstab, or symlink /sbin/fsck.btrfs to
> /bin/true.

Wiki updated to describe the difference and best practices.

david
