Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42467 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab3COBmA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 21:42:00 -0400
Date: Fri, 15 Mar 2013 09:39:29 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <chris.mason@fusionio.com>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: get better concurrency for snapshot-aware defrag
 work
Message-ID: <20130315013928.GB16268@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1362993658-30147-1-git-send-email-bo.li.liu@oracle.com>
 <20130311172640.GF7229@twin.jikos.cz>
 <20130312014402.GC31527@liubo.jp.oracle.com>
 <20130314183829.GC18457@shiny.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130314183829.GC18457@shiny.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 14, 2013 at 02:38:29PM -0400, Chris Mason wrote:
> On Mon, Mar 11, 2013 at 07:44:04PM -0600, Liu Bo wrote:
> > On Mon, Mar 11, 2013 at 06:26:40PM +0100, David Sterba wrote:
> > > On Mon, Mar 11, 2013 at 05:20:58PM +0800, Liu Bo wrote:
> > > > Using spinning case instead of blocking will result in better concurrency
> > > > overall.
> > > 
> > > Do you have numbers to support that?
> > > 
> > 
> > Sorry, I don't, just judging from what leave_spinning is desiged for and the
> > similar usecases, like insert_reserved_file_extents(), which is also involved in
> > endio write worker.
> 
> Leaving the path spinning is always faster.  As long as you're sure the
> code inside doesn't schedule it is the right choice.
> 

Yeah, I've taken care of schedule thing :)

thanks,
liubo
> 
