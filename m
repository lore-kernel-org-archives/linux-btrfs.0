Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44868 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbcERWuY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 18:50:24 -0400
Date: Thu, 19 May 2016 00:49:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: incoming merge conflict to linux-next
Message-ID: <20160518224955.GD511@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160518211043.qqzesbrmbbr7xba2@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160518211043.qqzesbrmbbr7xba2@floor.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 18, 2016 at 05:10:43PM -0400, Chris Mason wrote:
> Dave Sterba's tree in linux-next has a few btrfs patches that we're not
> sending yet into Linus.  We've got an update for Josef's enospc work
> that'll get sent in next week.
> 
> So he prepped a pull for me that merged up a number of his branches but
> didn't include Josef's new code.  It has all been in -next for some
> time, and then I put some fixes from Filipe on top.

JFYI, the enospc branch was not the way to Linus because there were some
unexpected warnings, the v2 patch update hasn't fixed them. So I won't
redo the for-chris branch yet, but will keep the enospc patchset in my
for-next for other testing.
