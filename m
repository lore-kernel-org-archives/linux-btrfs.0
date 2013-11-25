Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:56398 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3KYVhy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 16:37:54 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 1B5169A06B1
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Nov 2013 14:37:54 -0700 (MST)
Date: Mon, 25 Nov 2013 16:37:51 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Josef Bacik <jbacik@fusionio.com>, <xfs@oss.sgi.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfstests: add generic/321 to test fsync() on
 directories V2
Message-ID: <20131125213751.GA3949@localhost.localdomain>
References: <1384538464-7384-1-git-send-email-jbacik@fusionio.com>
 <20131125161216.GA5085@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20131125161216.GA5085@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 25, 2013 at 08:12:16AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 15, 2013 at 01:01:03PM -0500, Josef Bacik wrote:
> > Btrfs had some issues with fsync()'ing directories and fsync()'ing after
> > renames.  These three new tests cover the 3 different issues we were seeing.
> > This breaks out the dmflakey stuff into a common helper to be shared between
> > generic/311 and generic/321. Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> 
> This doesn't seem to actually create the common/dmflakey file.

Eek sorry about that, I'll resend.

Josef
