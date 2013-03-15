Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:32977 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab3COTMo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 15:12:44 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 23BF29A036E
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Mar 2013 13:12:44 -0600 (MDT)
Date: Fri, 15 Mar 2013 15:12:41 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Josef Bacik <jbacik@fusionio.com>
CC: David Sterba <dsterba@suse.cz>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "sensille@gmx.net" <sensille@gmx.net>,
        "sbehrens@giantdisaster.de" <sbehrens@giantdisaster.de>
Subject: Re: Scrub and raid10 (3.9-rc2+) transid verify failed
Message-ID: <20130315191241.GG1980@localhost.localdomain>
References: <20130312170312.GO7229@twin.jikos.cz>
 <20130312180124.GB12725@shiny.masoncoding.com>
 <20130315120708.GE7229@twin.jikos.cz>
 <20130315131330.GE1980@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130315131330.GE1980@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 15, 2013 at 07:13:30AM -0600, Josef Bacik wrote:
> On Fri, Mar 15, 2013 at 06:07:08AM -0600, David Sterba wrote:
> > On Tue, Mar 12, 2013 at 02:01:24PM -0400, Chris Mason wrote:
> > > Please go back to just 3.9-rc2 and see if you can trigger it.  Josef put
> > > his skinny extents into btrfs-next/master, which is pretty exciting but
> > > may be related to these failures.
> > > 
> > > I'm unable to reproduce here so far.
> > 
> > Me neither, 3.9-rc2 with top commit (a2362d24764a4e9a3187fc).
> > 
> 
> :(, I'll see if I can reproduce with my skinny extent stuff.
> 

I can't reproduce with btrfs-next or btrfs-next ontop of 3.9-rc2.  Can you just
patch out the skinny metadata patch and see if the problem still happens?
Thanks,

Josef
