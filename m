Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab3H1RWc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Aug 2013 13:22:32 -0400
Date: Wed, 28 Aug 2013 19:22:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: How btrfs resize should work ?
Message-ID: <20130828172229.GE23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <alpine.LFD.2.00.1308161011160.1968@localhost.localdomain>
 <20130816163039.GK12314@lenny.home.zabbo.net>
 <F668151D-F261-4093-9E6F-A7F7A3F10EF4@colorremedies.com>
 <36466B86-DD77-48D2-8C37-CF9988D9088A@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <36466B86-DD77-48D2-8C37-CF9988D9088A@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 16, 2013 at 02:11:23PM -0600, Chris Murphy wrote:
> 
> On Aug 16, 2013, at 12:02 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> > When a Btrfs multiple device volume is shrunk resized, it directly affects the partition size…
> 
> Oops, this obviously happens with single or multiple device.
> 
> I also think the command needs to return some information about
> exactly where the end of the file system is, maybe in file system
> blocks? resize2fs states the number of fs blocks in the fs, after a
> resize. From that I can figure out the exact ending LBA needed when
> changing the partition table. Btrfs leaves me totally guessing what
> this value should be.

It should be possible to obtain the information from the device tree via
the SEARCH_TREE ioctl.
