Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:39552 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114Ab2GDOx4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 10:53:56 -0400
Date: Wed, 4 Jul 2012 10:53:53 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Alexander Block <ablock84@googlemail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH 0/6] Experimental btrfs send/receive (btrfs-progs)
Message-ID: <20120704145353.GL14928@shiny>
References: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1341409174-13619-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 04, 2012 at 07:39:28AM -0600, Alexander Block wrote:
> Hello all,
> 
> This is the user space side of btrfs send/receive.
> 
> You can apply them manually or use my git repo:
> 
> git://github.com/ablock84/btrfs-progs.git (branch send)
> 
> The branch is based on Hugo's integration-20120605 branch. I had to add a temporary
> commit to fix a bug introduced in one of the strncpy/overflow patches that got into
> btrfs-progs. This fix is not part of the btrfs send/receive patchset, but you'll
> probably need it if you want to base on the integration branch. I hope this is not
> required in the future when a new integration branch comes out.

Just awesome.  I'm playing with this now.

Except for the arm patch, I have the integration here in final testing
for 0.20.  This stuff will make 0.21 when it is all done.

-chris
