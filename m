Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933241AbbCPQZf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Mar 2015 12:25:35 -0400
Date: Mon, 16 Mar 2015 17:25:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH] Revert "Btrfs: allow superblock mismatch from older mkfs"
Message-ID: <20150316162534.GO20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1426138847-10851-1-git-send-email-bo.li.liu@oracle.com>
 <550127E1.4050606@cn.fujitsu.com>
 <20150312173414.GE20767@twin.jikos.cz>
 <20150312201508.GB10724@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150312201508.GB10724@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 13, 2015 at 04:15:08AM +0800, Liu Bo wrote:
> On Thu, Mar 12, 2015 at 06:34:15PM +0100, David Sterba wrote:
> > On Thu, Mar 12, 2015 at 01:45:05PM +0800, Qu Wenruo wrote:
> > > I sent such patch some time ago but was rejected by Chris,
> > > hopes this time it can be accepted.
> > 
> > http://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg34937.html
> > 
> > I'm OK with removing the special case now because there are additional
> > supreblock checks merged (3.19) that were motivated by your previous
> > attempt to remove it.
> 
> So David, are you going to take the above patch instead?
> 
> I'm okay with that since they're exactly same, but it'd be good that
> Qu has its commit log updated.

Although Qu's patch was first and should be normally applied in case
more patches doing the same thing, the changelog reasoning is IMHO not
all fine, so I'm inclined to take your patch if you refine the subject,
and drop the "Conflicts:". Thanks.
