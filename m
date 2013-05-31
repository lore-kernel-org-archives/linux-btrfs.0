Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59642 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3EaOeQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 May 2013 10:34:16 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 451DA7C0428
	for <linux-btrfs@vger.kernel.org>; Fri, 31 May 2013 08:34:16 -0600 (MDT)
Date: Fri, 31 May 2013 10:34:13 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Chris Mason <clmason@fusionio.com>
CC: Josef Bacik <JBacik@fusionio.com>, Zach Brown <zab@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: testing stable pages being modified
Message-ID: <20130531143413.GG9829@localhost.localdomain>
References: <20130530223610.GA24721@lenny.home.zabbo.net>
 <20130531051158.7927.24213@localhost.localdomain>
 <20130531062430.GB24721@lenny.home.zabbo.net>
 <20130531132907.GF9829@localhost.localdomain>
 <20130531135329.14188.80309@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130531135329.14188.80309@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 31, 2013 at 07:53:29AM -0600, Chris Mason wrote:
> Quoting Josef Bacik (2013-05-31 09:29:07)
> > On Fri, May 31, 2013 at 12:24:30AM -0600, Zach Brown wrote:
> > > > Changing O_DIRECT in flight has always been a deep dark corner case, and
> > > > crc errors are the expected result.  Have you found anyone doing this in
> > > > real life?
> > > 
> > > Agreed; and no, I haven't heard of people accidentally modifying stable
> > > pages.
> > > 
> > 
> > Windows does this, it also will send down the same page for different offsets
> > which is why we have that special check in check_direct_IO for reads because
> > that would cause lots of csum errors too.  I tried to fix the modified in flight
> > problem by checking the csums of the pages in the io completion handler and
> > re-submitting the IO if the pages had changed, but this of course dramatically
> > reduced performance for all of those well behaved O_DIRECT applications, so in
> > the end I just set nodatasum for that vm image and carried on.  I'm not sure
> > what the solution is for this problem.  Thanks,
> 
> Ugh, I forgot about the windows case.  KVM should really be copying the
> pages for sectors where IO is already in flight.
> 
> We could do the copies ourselves: mount -o dio_copies
>

That would work for us, but what about other people that rely on stable pages,
like *fs on iscsi and such?  It might be good to have a generic mount option
that the vfs notices and makes the copying happen before it gets to the file
system and that way we're all save and don't have a different solution/mount
option for each fs.  Thanks,

Josef 
