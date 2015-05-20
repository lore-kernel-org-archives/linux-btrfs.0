Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbbETQta (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 May 2015 12:49:30 -0400
Date: Wed, 20 May 2015 18:49:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Florian =?iso-8859-1?Q?Gamb=F6ck?= <ml@floga.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Fix bashism in fsck.btrfs for debian/ubuntu dash.
Message-ID: <20150520164928.GL23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1431721709-5146-1-git-send-email-dimitri.j.ledkov@intel.com>
 <20150515204340.GA20386@mew.dhcp4.washington.edu>
 <5556FF5F.1050907@floga.de>
 <20150516085828.GA14823@mew>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20150516085828.GA14823@mew>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 16, 2015 at 01:58:28AM -0700, Omar Sandoval wrote:
> On Sat, May 16, 2015 at 10:27:11AM +0200, Florian Gamböck wrote:
> > Am 15.05.2015 um 22:43 schrieb Omar Sandoval:
> > >I'm going to completely bikeshed here, but Yoda conditions are already
> > >ugly in C, and completely pointless in Bash, where you can't ever
> > >accidentally reassign a variable in a condition. Either way, I think:
> > >
> > >if [ ! $AUTO ]; then
> > >
> > >would be clearer anyways.
> > 
> > Ah, I'm sorry to disagree with you, but your code snippet would only work if
> > $AUTO is *empty*, and I think, to be totally correct you'd have to use the
> > -n or -z test.
> > 
> > To sum it up now, you'd have to replace "false" with an empty string in the
> > beginning of the file and the zero-test in the end. So something like the
> > following:
> > 
> > AUTO=
> > # ...
> > if [ -z "$AUTO" ]; then
> > 
> 
> Whoops, you're totally right, that was a typo. I meant
> 
> if ! $AUTO; then

That's my preference as it was implemented originally. I did not pay
close attention to how it was implemented in "silence fake fsck" as far
as it worked.
