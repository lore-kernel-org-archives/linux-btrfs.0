Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:38085 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab3BZOZJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 09:25:09 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C4A947C0444
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 07:25:08 -0700 (MST)
Date: Tue, 26 Feb 2013 09:25:05 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: David Sterba <dsterba@suse.cz>
CC: Liu Bo <bo.li.liu@oracle.com>, Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Marios Titas <redneb8888@gmail.com>
Subject: Re: [PATCH] Btrfs: do not change inode flags in rename
Message-ID: <20130226142505.GF19641@localhost.localdomain>
References: <1361765082-6331-1-git-send-email-bo.li.liu@oracle.com>
 <20130225185647.GB2434@localhost.localdomain>
 <20130226001116.GA8524@liubo>
 <20130226123300.GU27541@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130226123300.GU27541@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 26, 2013 at 05:33:00AM -0700, David Sterba wrote:
> On Tue, Feb 26, 2013 at 08:11:17AM +0800, Liu Bo wrote:
> > On Mon, Feb 25, 2013 at 01:56:47PM -0500, Josef Bacik wrote:
> > > On Sun, Feb 24, 2013 at 09:04:42PM -0700, Liu Bo wrote:
> > > > Before we forced to change a file's NOCOW and COMPRESS flag due to
> > > > the parent directory's, but this ends up a bad idea, because it
> > > > confuses end users a lot about file's NOCOW status, eg. if someone
> > > > change a file to NOCOW via 'chattr' and then rename it in the current
> > > > directory which is without NOCOW attribute, the file will lose the
> > > > NOCOW flag silently.
> > > > 
> > > > This diables 'change flags in rename', so from now on we'll only
> > > > inherit flags from the parent directory on creation stage while in
> > > > other places we can use 'chattr' to set NOCOW or COMPRESS flags.
> > > >
> > > 
> > > I'm of the mind we definitely shouldn't drop flags we've set previously, but I
> > > think we should also inherit any flags we have set on the directory, so if we
> > > move a file into a NOCOW directory we should inherit the flag.  I'm not married
> > > to the idea, but it seems to make the most sense to me.  Thanks,
> > > 
> > (Said in another thread)
> > I'm ok with either one, but...
> > from some reports on the list, end users are more likely to control, use chattr
> > files by themselves, inheriting flags via moving a file to a new directory is
> > indeed not very welcomed.
> > 
> > So for practical use, I assume that it's fairly enough to inherit flags only on
> > creation?
> 
> I still haven't figured out in what cases the silent flag inheritance
> (for a non-empty) file would help and the user would be happy that it
> works like this.
> 

K, I'll take this as it is then and drop my previous patch.  Thanks,

Josef
