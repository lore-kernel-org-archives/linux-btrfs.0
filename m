Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:43575 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3CNSib (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 14:38:31 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 7E52B7C0446
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 12:38:31 -0600 (MDT)
Date: Thu, 14 Mar 2013 14:38:29 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: get better concurrency for snapshot-aware defrag
 work
Message-ID: <20130314183829.GC18457@shiny.masoncoding.com>
References: <1362993658-30147-1-git-send-email-bo.li.liu@oracle.com>
 <20130311172640.GF7229@twin.jikos.cz>
 <20130312014402.GC31527@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130312014402.GC31527@liubo.jp.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 11, 2013 at 07:44:04PM -0600, Liu Bo wrote:
> On Mon, Mar 11, 2013 at 06:26:40PM +0100, David Sterba wrote:
> > On Mon, Mar 11, 2013 at 05:20:58PM +0800, Liu Bo wrote:
> > > Using spinning case instead of blocking will result in better concurrency
> > > overall.
> > 
> > Do you have numbers to support that?
> > 
> 
> Sorry, I don't, just judging from what leave_spinning is desiged for and the
> similar usecases, like insert_reserved_file_extents(), which is also involved in
> endio write worker.

Leaving the path spinning is always faster.  As long as you're sure the
code inside doesn't schedule it is the right choice.

-chris

