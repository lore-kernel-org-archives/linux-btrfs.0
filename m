Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:56615 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582Ab2IRNKK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 09:10:10 -0400
Date: Tue, 18 Sep 2012 09:10:06 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dave@jikos.cz" <dave@jikos.cz>
Subject: Re: [PATCH 2/2 v3] Btrfs: snapshot-aware defrag
Message-ID: <20120918131006.GB2272@localhost.localdomain>
References: <1347875936-14165-1-git-send-email-bo.li.liu@oracle.com>
 <1347875936-14165-2-git-send-email-bo.li.liu@oracle.com>
 <20120917171551.GC3143@localhost.localdomain>
 <5057BEF9.6040507@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5057BEF9.6040507@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 17, 2012 at 06:23:21PM -0600, Liu Bo wrote:
> On 09/18/2012 01:15 AM, Josef Bacik wrote:
> > On Mon, Sep 17, 2012 at 03:58:56AM -0600, Liu Bo wrote:
> >> This comes from one of btrfs's project ideas,
> >> As we defragment files, we break any sharing from other snapshots.
> >> The balancing code will preserve the sharing, and defrag needs to grow this
> >> as well.
> >>
> >> Now we're able to fill the blank with this patch, in which we make full use of
> >> backref walking stuff.
> >>
> >> Here is the basic idea,
> >> o  set the writeback ranges started by defragment with flag EXTENT_DEFRAG
> >> o  at endio, after we finish updating fs tree, we use backref walking to find
> >>    all parents of the ranges and re-link them with the new COWed file layout by
> >>    adding corresponding backrefs.
> >>
> >> Originally patch by Li Zefan <lizf@cn.fujitsu.com>
> >> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > 
> > I was trying to fixup the rejects on this patch when I noticed there were no
> > tabs, only spaces.  Thats not going to work and now I have to go back and make
> > sure none of your other patches did this.  Thanks,
> > 
> > Josef
> > 
> 
> I'm quite confused about this, my local part and the email part I received show it is well formed.
> 
> There is no spaces, and every time before I send them out, I use checkpatch.pl and make sure
> checkpatch.pl does not complain about anything:
> 
> $ ./scripts/checkpatch.pl ~/Desktop/0002-Btrfs-snapshot-aware-defrag.patch 
> total: 0 errors, 0 warnings, 647 lines checked
> 
> /home/liubo/Desktop/0002-Btrfs-snapshot-aware-defrag.patch has no obvious style problems and is ready for submission.
> 
> 
> Anyway, I don't know where goes wrong but I'm attaching it for you.
> 

Yeah I don't know wtf is going on here, that patch turned out fine.  I blame
exchange ;).  Thanks,

Josef
