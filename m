Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:35172 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbcESAT1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 20:19:27 -0400
Date: Thu, 19 May 2016 10:19:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Mason <clm@fb.com>
Cc: LKML <linux-kernel@vger.kernel.org>, btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>
Subject: Re: incoming merge conflict to linux-next
Message-ID: <20160519101921.3a45e559@canb.auug.org.au>
In-Reply-To: <20160518211043.qqzesbrmbbr7xba2@floor.thefacebook.com>
References: <20160518211043.qqzesbrmbbr7xba2@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On Wed, 18 May 2016 17:10:43 -0400 Chris Mason <clm@fb.com> wrote:
>
> Dave Sterba's tree in linux-next has a few btrfs patches that we're not
> sending yet into Linus.  We've got an update for Josef's enospc work
> that'll get sent in next week.
> 
> So he prepped a pull for me that merged up a number of his branches but
> didn't include Josef's new code.  It has all been in -next for some
> time, and then I put some fixes from Filipe on top.
> 
> Long story short, you'll get a merge conflict from my next branch:
> 
> https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git next
> 
> I've got the sample resolution in next-merge:
> 
> https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git next-merge
> 
> Please let us know if you have any problems.

A bit of a mess, but I sorted it out, thanks for the test merge.

-- 
Cheers,
Stephen Rothwell
