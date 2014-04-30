Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933561AbaD3MWm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 08:22:42 -0400
Date: Wed, 30 Apr 2014 14:22:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 00/14] Enhanced df - followup
Message-ID: <20140430122241.GJ5988@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1398786620.git.dsterba@suse.cz>
 <CAMU1PDhc1xp3C2fDfs1mnxofn7wA3HxAjU14yw+1pT1_TUC1YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMU1PDhc1xp3C2fDfs1mnxofn7wA3HxAjU14yw+1pT1_TUC1YQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 29, 2014 at 08:14:30PM +0100, Mike Fleetwood wrote:
> On 29 April 2014 16:56, David Sterba <dsterba@suse.cz> wrote:
> > Changes:
> > * btrfs filesystem disk_usage - renamed to usage
> >   * added a section of overall filesystem usage, that used to be in the
> >     'fi df' output
> > * btrfs device disk_usage - renamed to usage
> >   * the device size prints both blockdevie size and the size that's occupied
> >     by the filesystem
> >   * device ID is printed
> 
> >  cmds-fi-disk_usage.c | 631 +++++++++++++++++++--------------------------------
> >  cmds-fi-disk_usage.h |  35 ++-
> 
> After renaming the commands btrfs ... disk_usage to btrfs ... usage
> should the source files also be renamed to cmds-fi-usage.[ch]?

I should have mentioned that in the cover letter why they've been left
as-is - to keep the amount of unrelated cleanup changes low. The files
contain helpers for loading/calculating the space information etc and
will be moved to a separate file, possibly usable from libbtrfs.

This can be done independently of the 'enhanced df' changes.

Thanks.
