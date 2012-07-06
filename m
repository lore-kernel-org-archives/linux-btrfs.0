Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:44823 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab2GFLuX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jul 2012 07:50:23 -0400
Date: Fri, 6 Jul 2012 07:50:19 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs GPF in read_extent_buffer() while scrubbing with kernel
 3.4.2
Message-ID: <20120706115019.GG7159@shiny>
References: <4FF3032D.1010007@jan-o-sch.net>
 <20120703224756.GA21647@sli.dy.fi>
 <20120704001713.GA8986@sli.dy.fi>
 <4FF42876.8010309@jan-o-sch.net>
 <20120704160340.GA9770@sli.dy.fi>
 <4FF47168.9010405@jan-o-sch.net>
 <20120704202452.GA8996@sli.dy.fi>
 <4FF5998D.8020205@jan-o-sch.net>
 <20120705234739.GA9736@sli.dy.fi>
 <4FF6C12A.10305@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FF6C12A.10305@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 06, 2012 at 04:42:50AM -0600, Jan Schmidt wrote:
> ... down here in the stack. The warning is printed from two levels above,
> __readahead_hook.
> 
> Either I'm absolutely blind and there's code along the (rather short) road
> between those two that might do this I haven't seen. Or someone else messes
> with our extent buffers or the underlying pages. What really confuses me is
> that it happens so reproducibly.
> 
> I've no good idea at the moment how to go on. It might help to get a feeling if
> it's shifting around at least a little bit or really constant in the timing of
> occurrence. So can you please apply the next patch on top of the other two and
> give it some more failure tries? The "checksum mismatch [1234]" line will be of
> most interest. I'm also curious what the additional debug variables will say in
> the extended version of the very first printk. You can leave out the stack
> traces if you like, they won't matter much anyway.

I would suggest turning on slab debug and CONFIG_DEBUG_PAGEALLOC.
Something really strange is happening here.

-chris
