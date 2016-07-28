Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719AbcG1LgK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 07:36:10 -0400
Date: Thu, 28 Jul 2016 13:35:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Graham Cobb <g.btrfs@cobb.uk.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fi defrag: change default extent target
 size to 32 MiB
Message-ID: <20160728113551.GT30795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1469704629-25512-1-git-send-email-dsterba@suse.com>
 <5799EC5B.2050108@cobb.uk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5799EC5B.2050108@cobb.uk.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 28, 2016 at 12:28:27PM +0100, Graham Cobb wrote:
> On 28/07/16 12:17, David Sterba wrote:
> > diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> > index ef1f550b51c0..6b381c582ea7 100644
> > --- a/cmds-filesystem.c
> > +++ b/cmds-filesystem.c
> > @@ -968,7 +968,7 @@ static const char * const cmd_filesystem_defrag_usage[] = {
> >  	"-f             flush data to disk immediately after defragmenting",
> >  	"-s start       defragment only from byte onward",
> >  	"-l len         defragment only up to len bytes",
> > -	"-t size        target extent size hint",
> > +	"-t size        target extent size hint (default: 32 MiB)",
> 
> As a user... might it be better to say the default is 32M as that is the
> format the option requires?

Good point, thanks, I'll fix that.
