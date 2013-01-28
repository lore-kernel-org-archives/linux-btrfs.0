Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:53669 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab3A1TTt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 14:19:49 -0500
Date: Mon, 28 Jan 2013 14:19:41 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Zach Brown <zab@zabbo.net>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: do not merge logged extents if we've removed them
 from the tree
Message-ID: <20130128191941.GF3257@localhost.localdomain>
References: <1359384776-2107-1-git-send-email-jbacik@fusionio.com>
 <20130128185226.GM14246@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130128185226.GM14246@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 28, 2013 at 11:52:26AM -0700, Zach Brown wrote:
> > problem is we unconditionally try to merge it back into the em tree, but if
> > we've removed it from the em tree that will cause problems.  So fix this by
> 
> What problems?  If I were staring at the symptoms of this bug how would
> I find that this commit fixes it?
> 

I'll fix the commit message, we just add something to the tree that doesn't have
a ref so it's a basic use after free sort of scenario. Thanks,

Josef
> - z
