Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:46605 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772Ab3AWBkz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 20:40:55 -0500
Date: Tue, 22 Jan 2013 20:40:52 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Chris Mason <clmason@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs fixes
Message-ID: <20130123014052.GA32562@shiny>
References: <20130123004833.GA30526@shiny>
 <20130123012818.GA17162@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130123012818.GA17162@liubo.jp.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 22, 2013 at 06:28:21PM -0700, Liu Bo wrote:
> On Tue, Jan 22, 2013 at 07:48:33PM -0500, Chris Mason wrote:
> > Hi Linus,
> > 
> > My for-linus branch has our batch of btrfs fixes:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
> > 
> > We've been hammering away at a crc corruption as well, which I was
> > really hoping to get into this pull.  It isn't nailed down yet, but we
> > were finally able to get a solid way to reproduce.  The only good
> > news is it isn't a recent regression.
> > 
> > The most important batch of fixes in here come from Ilya.  They address
> > a regression Liu Bo found in the balance ioctls for pausing and resuming
> > a running balance across drives.
> > 
> > Josef's orphan truncate patch fixes an obscure corruption we'd see
> > during xfstests.
> > 
> > Arne's patches address problems with subvolume quotas.  If the user
> > destroys quota groups incorrectly the FS will refuse to mount.
> > 
> > The rest are smaller fixes and plugs for memory leaks.
> 
> Hi,
> 
> Any chance to get these in this round?  I think they're good fixes,
> a memory leak and a warning fix, both are got from xfstests.

I'll get these tested in the next pull.

-chris
