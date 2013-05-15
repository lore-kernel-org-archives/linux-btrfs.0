Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755975Ab3EOLKA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 07:10:00 -0400
Date: Wed, 15 May 2013 13:09:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: increase the max global reserve size to 1gig
Message-ID: <20130515110957.GW16456@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1367585814-18076-1-git-send-email-jbacik@fusionio.com>
 <20130503152834.GE16411@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130503152834.GE16411@liubo.jp.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 03, 2013 at 11:28:35PM +0800, Liu Bo wrote:
> On Fri, May 03, 2013 at 08:56:54AM -0400, Josef Bacik wrote:
> > Apparently 512mb was too small, with a fs_mark command we could get so much
> > delayed work built up that we'd never trip the "lets commit the transaction"
> > logic until we'd gotten too much delayed refs built up.  Increasing this to 1
> > gig makes us much safer and we no longer abort with Dave's fs_mark tester.
> > Thanks,
> 
> I remember that last time I made a similar commit, but users complains that
> they cannot boot their system on root btrfs partition due to lacking space and
> Chris eventually got to revert that one...

That was long time ago (3.5) and enospc has been updated since, so this
needs re-evaluation if it still leads to early enospc.

This patch is not in next queue, i wonder if your concern is the reason
of that.

david
