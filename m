Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:34243 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259Ab2FYOsK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 10:48:10 -0400
Date: Mon, 25 Jun 2012 10:48:08 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs deadlock in 3.5-rc3
Message-ID: <20120625144807.GC7404@localhost.localdomain>
References: <4FE58366.8000302@profihost.ag>
 <4FE862D7.3060005@fusionio.com>
 <4FE870DF.90308@profihost.ag>
 <20120625142048.GB7404@localhost.localdomain>
 <4FE8796E.9030300@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FE8796E.9030300@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 25, 2012 at 08:45:02AM -0600, Stefan Priebe - Profihost AG wrote:
> >
> > Thats weird, sysrq+w should have a bunch of stacktraces but it's empty, so
> > unless theres a bug theres nothing blocked.  Is the box actually hung or is it
> > just taking forever?  Maybe try sysrq+w again to see if the one you pasted was
> > just a fluke?  Thanks,
> 
> This one looks better:
> http://pastebin.com/raw.php?i=R4pztDRt
> 

Ok looks like you have discard turned on.  Can you turn that off and see if you
can still reproduce the deadlock?  If so sysrq+w again, if not then I know where
to look ;).  Thanks,

Josef
