Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab3KNSoe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Nov 2013 13:44:34 -0500
Date: Thu, 14 Nov 2013 19:44:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, russell@coker.com.au,
        David Sterba <dsterba@suse.cz>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: csum failure messages
Message-ID: <20131114184428.GM18494@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201311051224.44255.russell@coker.com.au>
 <CAD_cGvE-FtFxZerOKN7T11-L=cEgh_8i-=YcgwG+g1aye6Zn6w@mail.gmail.com>
 <201311052316.34979.russell@coker.com.au>
 <49B5E6AD-795D-4839-A360-7F3782ED7F2F@colorremedies.com>
 <20131105143438.GM14405@carfax.org.uk>
 <6FE6684A-6A51-421B-AC89-0848216248C6@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6FE6684A-6A51-421B-AC89-0848216248C6@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 14, 2013 at 11:37:39AM -0700, Chris Murphy wrote:
> 
> On Nov 5, 2013, at 7:34 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
> > On Tue, Nov 05, 2013 at 07:26:54AM -0700, Chris Murphy wrote:
> >> 
> >> On Nov 5, 2013, at 5:16 AM, Russell Coker <russell@coker.com.au> wrote:
> >>> 
> >>> I presume that my filesystem is still corrupt.
> >> 
> >> I'm the original reporter of the bug. The file system itself isn't corrupt, but the affected files probably are. In my case, systemd journal files were reported as corrupt by systemd following a balance, as well as btrfs scrub. Upon scrub, dmesg contains a path for each affected file. Upon deleting those files, subsequent scrubs come up clean.
> >> 
> >> Fedora merged the fix for this bug with: 3.11.5-302.fc20, 3.11.6-200.fc19, 3.11.6-101.fc18. I thought for sure it was marked for stable to go into mainline 3.11.6, so somehow it's been missed.
> > 
> >   Someone else tripped over it on IRC last night, and I was surprised
> > to discover it hadn't made it upstream yet. :(
> 
> I just checked kernel.org changelogs and I'm not seeing this fixed in
> either 3.11.7 or 3.11.8. It is listed in today's git pull by Chris for
> 3.12 as
> 
> Btrfs: relocate csums properly with prealloc extents

The stable tree process does not normally accept patches that are not in
Linus' tree first. The patch has yet to be submitted to stable right
after today's pull is merged.

david
