Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27552 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168Ab3BZAN0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 19:13:26 -0500
Date: Tue, 26 Feb 2013 08:11:17 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Marios Titas <redneb8888@gmail.com>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: do not change inode flags in rename
Message-ID: <20130226001116.GA8524@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1361765082-6331-1-git-send-email-bo.li.liu@oracle.com>
 <20130225185647.GB2434@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130225185647.GB2434@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 25, 2013 at 01:56:47PM -0500, Josef Bacik wrote:
> On Sun, Feb 24, 2013 at 09:04:42PM -0700, Liu Bo wrote:
> > Before we forced to change a file's NOCOW and COMPRESS flag due to
> > the parent directory's, but this ends up a bad idea, because it
> > confuses end users a lot about file's NOCOW status, eg. if someone
> > change a file to NOCOW via 'chattr' and then rename it in the current
> > directory which is without NOCOW attribute, the file will lose the
> > NOCOW flag silently.
> > 
> > This diables 'change flags in rename', so from now on we'll only
> > inherit flags from the parent directory on creation stage while in
> > other places we can use 'chattr' to set NOCOW or COMPRESS flags.
> >
> 
> I'm of the mind we definitely shouldn't drop flags we've set previously, but I
> think we should also inherit any flags we have set on the directory, so if we
> move a file into a NOCOW directory we should inherit the flag.  I'm not married
> to the idea, but it seems to make the most sense to me.  Thanks,
> 
> Josef 

Hi Josef,

(Said in another thread)
I'm ok with either one, but...
from some reports on the list, end users are more likely to control, use chattr
files by themselves, inheriting flags via moving a file to a new directory is
indeed not very welcomed.

So for practical use, I assume that it's fairly enough to inherit flags only on
creation?

thanks,
liubo
