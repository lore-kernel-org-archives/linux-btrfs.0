Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:41727 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241AbbAFMnR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Jan 2015 07:43:17 -0500
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Cc: Lennart Poettering <lennart@poettering.net>
Subject: Re: btrfs_inode_item's otime?
Date: Tue, 06 Jan 2015 23:43:22 +1100
Message-ID: <3797928.30urVis5AR@quad>
In-Reply-To: <1891475.iuyauiTsCQ@quad>
References: <20150105172152.GB19126@gardel-login> <1891475.iuyauiTsCQ@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 6 Jan 2015 10:47:00 PM Chris Samuel wrote:

> On Mon, 5 Jan 2015 06:21:52 PM Lennart Poettering wrote:
> 
> > It should be easy to initialize it to the mtime when the inode is
> > first created...
> 
> This I agree with, well worth doing anyway.
> 
> I'll see if I can knock up a patch.

Sadly it appears that the btrfs code sets mtime/ctime/atimeat inode creation  
via the normal filesystem inode structure, not through it's own, and as that 
doesn't include otime I'm afraid it's out of my league.  Worth a shot though!

All the best,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC


