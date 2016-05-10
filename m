Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbcEJWLV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 18:11:21 -0400
Date: Tue, 10 May 2016 15:11:19 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About in-band dedupe for v4.7
Message-ID: <20160510221119.GD7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 10, 2016 at 03:19:52PM +0800, Qu Wenruo wrote:
> Hi, Chris, Josef and David,
> 
> As merge window for v4.7 is coming, it would be good to hear your
> ideas about the inband dedupe.
> 
> We are addressing the ENOSPC problem which Josef pointed out, and we
> believe the final fix patch would come out at the beginning of the
> merge window.(Next week)

How about the fiemap performance problem you referenced before? My guess is
that it happens because you don't coalesce writes into anything larger than
a page so you're stuck deduping at some silly size like 4k. This in turn
fragments the files so much that fiemap has a hard time walking backrefs.

I have to check the patches to be sure but perhaps you can tell me whether
my hunch is correct or not.


In fact, I actually asked privately for time to review your dedupe patches,
but I've been literally so busy cleaning up after the mess you left in your
last qgroups rewrite I haven't had time.

You literally broke qgroups in almost every spot that matters. In some cases
(drop_snapshot) you tore out working code and left in a /* TODO */ comment
for someone else to complete.  Snapshot create was so trivially and
completely broken by your changes that weeks later, I'm still hunting a
solution which doesn't involve adding an extra _commit_ to our commit.  This
is a MASSIVE regression from where we were before.

IMHO, you should not be trusted with large features or rewrites until you  
can demonstrate:

 - A willingness to *completely* solve the problem you are trying to 'fix',
   not do half the job which someone else will have to complete for you.

 - Actual testing. The snapshot bug I reference above exists purely because
   nobody created a snapshot inside of one and checked the qgroup numbers!  

Sorry to be so harsh.
   --Mark

--
Mark Fasheh
