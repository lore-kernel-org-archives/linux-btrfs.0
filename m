Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab3KNSk4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 13:40:56 -0500
Date: Thu, 14 Nov 2013 19:40:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <chris.mason@fusionio.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs: enable extended refs by default
Message-ID: <20131114184054.GL18494@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1384438193-13237-1-git-send-email-dsterba@suse.cz>
 <20131114174913.3802.72670@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131114174913.3802.72670@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 14, 2013 at 12:49:13PM -0500, Chris Mason wrote:
> Quoting David Sterba (2013-11-14 09:09:53)
> > The feature has been introduced in kernel 3.7 and enabling it by
> > default is desired.
> > 
> > All features enabled by default are marked as such in
> > 'mkfs.btrfs -O list-all' output.
> 
> Has anyone already tested syslinux and grub with extrefs enabled?

Extrefs and grub2 is used in opensuse 13.1 and this combination works, I
think that the extended refs are not used for the /boot files at all, so
it works as if no extrefs were enabled.  There is not incompat bit
handling in grub afaics.

david
