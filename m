Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:49948 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab3CONNd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 09:13:33 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 6E93B7C067B
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Mar 2013 07:13:33 -0600 (MDT)
Date: Fri, 15 Mar 2013 09:13:30 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: David Sterba <dsterba@suse.cz>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "sensille@gmx.net" <sensille@gmx.net>,
        "sbehrens@giantdisaster.de" <sbehrens@giantdisaster.de>
Subject: Re: Scrub and raid10 (3.9-rc2+) transid verify failed
Message-ID: <20130315131330.GE1980@localhost.localdomain>
References: <20130312170312.GO7229@twin.jikos.cz>
 <20130312180124.GB12725@shiny.masoncoding.com>
 <20130315120708.GE7229@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130315120708.GE7229@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 15, 2013 at 06:07:08AM -0600, David Sterba wrote:
> On Tue, Mar 12, 2013 at 02:01:24PM -0400, Chris Mason wrote:
> > Please go back to just 3.9-rc2 and see if you can trigger it.  Josef put
> > his skinny extents into btrfs-next/master, which is pretty exciting but
> > may be related to these failures.
> > 
> > I'm unable to reproduce here so far.
> 
> Me neither, 3.9-rc2 with top commit (a2362d24764a4e9a3187fc).
> 

:(, I'll see if I can reproduce with my skinny extent stuff.

Josef
