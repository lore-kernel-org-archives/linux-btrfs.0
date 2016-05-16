Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36504 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbcEPMbF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 08:31:05 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: linux-btrfs@vger.kernel.org, ptoscano@redhat.com
Subject: Re: RFE: 'btrfs' tools machine readable output
Date: Mon, 16 May 2016 14:21:07 +0200
Message-ID: <3271754.bqNJ5v1fWK@merkaba>
In-Reply-To: <20160516121456.GA16970@redhat.com>
References: <20160516121456.GA16970@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Richard,

On Montag, 16. Mai 2016 13:14:56 CEST Richard W.M. Jones wrote:
> I don't have time to implement this right now, so I'm just posting
> this as a suggestion/request ...
> 
> It would be really helpful if the btrfs tools had a machine-readable
> output.
> 
> Libguestfs parses btrfs tools output in a number of places, eg:
> https://github.com/libguestfs/libguestfs/blob/master/daemon/btrfs.c
> This is a massive PITA because each time a new release of btrfs-progs
> comes along it changes the output slightly, and we end up having
> to add all sorts of hacks.
> 
> With machine-readable output, there'd be a flag which would
> change the output.  eg:

I wonder whether parsing a text based output is really the most elegant method 
here.

How about a libbtrfs so that other tools can benefit from btrfs tools 
functionality? This was also desktop environments wishing to make use of 
snapshot functionality or advanced disk usage reporting for example can easily 
make use of it without calling external commands.

Of course it would likely me more effort than to implement structured output.

Thanks,
-- 
Martin
