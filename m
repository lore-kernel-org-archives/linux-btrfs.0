Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932273AbbDVBta (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Apr 2015 21:49:30 -0400
Date: Tue, 21 Apr 2015 18:49:28 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs: clear 'ret' in btrfs_check_shared() loop
Message-ID: <20150422014928.GP17170@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20150421214733.GO17170@wotan.suse.de>
 <5536F004.3090602@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5536F004.3090602@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 21, 2015 at 08:49:08PM -0400, Chris Mason wrote:
> On 04/21/2015 05:47 PM, Mark Fasheh wrote:
> > btrfs_check_shared() is leaking a return value of '1' from
> > find_parent_nodes(). As a result, callers (in this case, extent_fiemap())
> > are told extents are shared when they are not. This in turn broke fiemap on
> > btrfs for kernels v3.18 and up.
> > 
> > The fix is simple - we just have to clear 'ret' after we are done processing
> > the results of find_parent_nodes().
> > 
> > It wasn't clear to me at first what was happening with return values in
> > btrfs_check_shared() and find_parent_nodes() - thanks to Josef for the help
> > on irc. I added documentation to both functions to make things more clear
> > for the next hacker who might come across them.
> > 
> 
> Thanks Mark, any reason not to tag this for stable?

If you all are ok with the patch then yes please send it to -stable too. It
breaks duperemove on kernels from 3.18 onward:

https://github.com/markfasheh/duperemove/issues/55

so I'm understandbly interested in seeing it backported :)

Thanks,
	--Mark

> 
> -chris
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
Mark Fasheh
