Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:33982 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab2GFOke (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jul 2012 10:40:34 -0400
Date: Fri, 6 Jul 2012 10:40:31 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Sami Liedes <sami.liedes@iki.fi>
CC: Jan Schmidt <list.btrfs@jan-o-sch.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
Message-ID: <20120706144030.GL7159@shiny>
References: <20120703224756.GA21647@sli.dy.fi>
 <20120704001713.GA8986@sli.dy.fi>
 <4FF42876.8010309@jan-o-sch.net>
 <20120704160340.GA9770@sli.dy.fi>
 <4FF47168.9010405@jan-o-sch.net>
 <20120704202452.GA8996@sli.dy.fi>
 <4FF5998D.8020205@jan-o-sch.net>
 <20120705234739.GA9736@sli.dy.fi>
 <4FF6C12A.10305@jan-o-sch.net>
 <20120706143350.GA10427@sli.dy.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120706143350.GA10427@sli.dy.fi>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 06, 2012 at 08:33:51AM -0600, Sami Liedes wrote:
> On Fri, Jul 06, 2012 at 12:42:50PM +0200, Jan Schmidt wrote:
> > I've no good idea at the moment how to go on. It might help to get a feeling if
> > it's shifting around at least a little bit or really constant in the timing of
> > occurrence. So can you please apply the next patch on top of the other two and
> > give it some more failure tries? The "checksum mismatch [1234]" line will be of
> > most interest. I'm also curious what the additional debug variables will say in
> > the extended version of the very first printk. You can leave out the stack
> > traces if you like, they won't matter much anyway.
> 
> Ok. Also turned on CONFIG_DEBUG_PAGEALLOC and CONFIG_SLUB_DEBUG_ON as
> suggested by Chris Mason.
> 
> With those and the latest patch, there's an oops already at boot. I
> don't have netconsole yet at that point, but here's the important
> parts (sure I can capture it fully if you need).
> 
> By the way, something seems to be untabifying your patches. I don't
> know if it's on my side or yours, but at least some other patches I
> receive via linux-btrfs contain tabs. Doing a M-x tabify in emacs
> mostly makes them apply cleanly for me.
> 
> 	Sami
> 
> 
> ------------------------------------------------------------
> btrfs: disk space caching is enabled
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000150
> IP: [<ffffffffa0223568>] check_node+0x138/0x250 [btrfs]

This isn't from any of the new debugging.  Can you please try it on an
unpatched kernel?

-chris
