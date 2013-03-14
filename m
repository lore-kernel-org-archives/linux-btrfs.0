Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47601 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab3CNNE1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 09:04:27 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 991DD9A03C9
	for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 07:04:26 -0600 (MDT)
Date: Thu, 14 Mar 2013 09:04:23 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Russell Coker <russell@coker.com.au>
CC: Chris Mason <clmason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Debian 3.7.1 BTRFS crash
Message-ID: <20130314130423.GJ15014@shiny.masoncoding.com>
References: <201303131238.33692.russell@coker.com.au>
 <201303140103.53907.russell@coker.com.au>
 <20130313191918.GF15014@shiny.masoncoding.com>
 <201303141736.09724.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201303141736.09724.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 14, 2013 at 12:36:09AM -0600, Russell Coker wrote:
> On Thu, 14 Mar 2013, Chris Mason <chris.mason@fusionio.com> wrote:
> > Bad key ordering is pretty rare, and it usually means memory
> > corruptions.  Are you reproducing this on the same machine or a
> > different one?
> 
> I've attached a kernel message log of mounting it on another system (which 
> incidentally has ECC RAM) running the Debian package of kernel 3.8.2.  The end 
> result of this was a system on which the sync command blocked in D state 
> indefinitely and which couldn't be rebooted in any way other than a hardware 
> reset.

Just to make sure I've got the sequence right, this is mounting the same
corrupted image on a second system?

The end result of that should be some messages about the bad blocks we
found and then the FS forced readonly.  If not, you're right there is
definitely a bug there.

-chris
