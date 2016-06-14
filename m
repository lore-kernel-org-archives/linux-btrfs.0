Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbcFNJGq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 05:06:46 -0400
Date: Tue, 14 Jun 2016 11:07:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>, Jeff Mahoney <jeffm@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <DSterba@suse.com>
Subject: Re: [RFC] strace patches for new ioctls
Message-ID: <20160614090722.GF6205@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4a3270c7-8023-6d2c-3ab0-ffc699feb94f@suse.com>
 <20160531205103.ueklsith275g7oau@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160531205103.ueklsith275g7oau@floor.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 31, 2016 at 04:51:03PM -0400, Chris Mason wrote:
> On Tue, May 31, 2016 at 04:41:55PM -0400, Jeff Mahoney wrote:
> > Hi all -
> > 
> > Strace 4.12 was tagged for release today and it supports decoding of
> > btrfs ioctls.  I'd like to propose a requirement that future ioctl
> > additions come with a patch to strace as well so we don't get out of sync.
> > 
> > I wrote the decoding to help with some issues some of our developers
> > were seeing while writing various tools.  Rather than describing their
> > workload or showing us the code, an strace in verbose mode shows us
> > pretty much exactly what they're doing.
> > 
> > Opinions?
> 
> Maybe add a link to the wiki of your last set of patches to use as a
> template?  It's a great idea.

[ I've replied to that but the mail got lost somewhere ]

There's a new wiki page to track the notes, checklists and hints for
such things.

https://btrfs.wiki.kernel.org/index.php/Development_notes
