Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbbFZNoM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jun 2015 09:44:12 -0400
Date: Fri, 26 Jun 2015 15:44:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Automatic balance after mkfs?
Message-ID: <20150626134409.GT726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <pan.2015.06.16.13.13.40@googlemail.com>
 <558022E8.7070201@gmail.com>
 <558259F3.8060505@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <558259F3.8060505@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 18, 2015 at 01:41:07PM +0800, Qu Wenruo wrote:
> >>>     Yes. It's an artefact of the way that mkfs works. If you run a
> >>> balance on those chunks, they'll go away. (btrfs balance start
> >>> -dusage=0 -musage=0 /mountpoint)
> >>
> >> Since I had to explain this very same thing to a new btrfs-using friend
> >> just yesterday I wondered if it might not make sense for mkfs to issue
> >> a general balance after creating the fs? It should be simple enough
> >> (just issue the balance ioctl?) and not have any negative side effects.
> >>
> >> Just doing such a post-mkfs cleanup automatically would certainly
> >> reduce the number of times we have to explain the this. :)
> >>
> >> Any reasons why we couldn't/shouldn't do this?
> >>
> > Following the same line of thinking, is there any reason we couldn't
> > just rewrite mkfs to get rid of this legacy behavior?

The 'single' blockgroups on multidevice filesystem are considered a bug
in mkfs, an annoying and long running one.

> Compared to the more complex auto balance, rewrite mkfs is a much better 
> idea.

Balance is a workaround besides that it requires mouting.

> The original mkfs seems easy for developers, but bad for users.

I'd argue that mkfs is primarily for users.
