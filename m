Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:35259 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab3CCQgX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 11:36:23 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 5D2029A0402
	for <linux-btrfs@vger.kernel.org>; Sun,  3 Mar 2013 09:36:23 -0700 (MST)
Date: Sun, 3 Mar 2013 11:36:20 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Brendan Hide <brendan@swiftspirit.co.za>
CC: Holger Hoffstaette <holger.hoffstaette@googlemail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: User feedback: raise the default leaf size to 16k
Message-ID: <20130303163620.GD18135@shiny.masoncoding.com>
References: <pan.2013.02.13.10.33.45.439956@googlemail.com>
 <513326FA.3070607@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <513326FA.3070607@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 03, 2013 at 03:33:30AM -0700, Brendan Hide wrote:
> On 2013/02/13 12:33 PM, Holger Hoffstaette wrote:
> > - raise the leaf size to 16k
> > - use single metadata profile
> >
> > ...
> >
> > the difference in behaviour on a single disk is *very* noticeable.
> Did you try an isolated change of leaf size? I think the devs would be 
> willing to look into the default size if it makes a dramatic difference 
> on its own. Personally I think you are seeing an improvement more as a 
> result of the metadata profile rather than the leafsize.
> 
> I don't think changing the default profile for metadata will be easily 
> entertained as this is very important for protecting against corruption 
> due to bitrot.

The long term plan is to set the default size to 16K, since this does
cut down on metadata fragmentation.  But in some benchmarks, it adds lock
contention because we have fewer blocks to spread the locks over.

The 3.9 merge window has fixes for lock contention, so I need to
benchmark things again.

-chris
