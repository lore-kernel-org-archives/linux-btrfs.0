Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48905 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab2GDOSI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jul 2012 10:18:08 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1SmQP9-0001bD-Pd
	for <linux-btrfs@vger.kernel.org>; Wed, 04 Jul 2012 07:18:07 -0700
Date: Wed, 4 Jul 2012 07:18:07 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: 3.4.4: BUG: Bad rss-counter state x
Message-ID: <20120704141807.GC6807@merlins.org>
References: <20120704050555.GB6807@merlins.org> <20120704135305.GM5326@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120704135305.GM5326@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 04, 2012 at 03:53:05PM +0200, David Sterba wrote:
> Hi,
> 
> On Tue, Jul 03, 2012 at 10:05:55PM -0700, Marc MERLIN wrote:
> > Since I heard absolutely nothing on my last but and corruption report, I'm
> > not sure if they are useful or wanted (please let me know).
> 
> They are, both useful and wanted, thanks.
> 
> > The last thing I've seen with 3.4.4 is this:
> > kernel: [116130.309667] btrfs: unlinked 25 orphans
> > kernel: [117951.440823] BUG: Bad rss-counter state mm:ffff8801e2a4c080 idx:1 val:-1
> > kernel: [117951.440832] BUG: Bad rss-counter state mm:ffff8801e2a4c080 idx:2 val:1
> > kernel: [119720.558186] btrfs: unlinked 12 orphans
> 
> This is not a btrfs bug, first hit for 'bug rss-counter' pointed me to
> 
> http://comments.gmane.org/gmane.linux.kernel/1316358 (kernel 3.4.2)
> ->
> https://lkml.org/lkml/2012/6/9/47

Doh, I was not awake when I sent this yesterday, sorry for the false alert.

Thanks for the reply,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
