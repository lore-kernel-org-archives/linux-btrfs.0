Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59270 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311Ab3EaNxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 May 2013 09:53:33 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C55047C0690
	for <linux-btrfs@vger.kernel.org>; Fri, 31 May 2013 07:53:32 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Josef Bacik <JBacik@fusionio.com>, Zach Brown <zab@redhat.com>
From: Chris Mason <clmason@fusionio.com>
In-Reply-To: <20130531132907.GF9829@localhost.localdomain>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20130530223610.GA24721@lenny.home.zabbo.net>
 <20130531051158.7927.24213@localhost.localdomain>
 <20130531062430.GB24721@lenny.home.zabbo.net>
 <20130531132907.GF9829@localhost.localdomain>
Message-ID: <20130531135329.14188.80309@localhost.localdomain>
Subject: Re: testing stable pages being modified
Date: Fri, 31 May 2013 09:53:29 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Josef Bacik (2013-05-31 09:29:07)
> On Fri, May 31, 2013 at 12:24:30AM -0600, Zach Brown wrote:
> > > Changing O_DIRECT in flight has always been a deep dark corner case, and
> > > crc errors are the expected result.  Have you found anyone doing this in
> > > real life?
> > 
> > Agreed; and no, I haven't heard of people accidentally modifying stable
> > pages.
> > 
> 
> Windows does this, it also will send down the same page for different offsets
> which is why we have that special check in check_direct_IO for reads because
> that would cause lots of csum errors too.  I tried to fix the modified in flight
> problem by checking the csums of the pages in the io completion handler and
> re-submitting the IO if the pages had changed, but this of course dramatically
> reduced performance for all of those well behaved O_DIRECT applications, so in
> the end I just set nodatasum for that vm image and carried on.  I'm not sure
> what the solution is for this problem.  Thanks,

Ugh, I forgot about the windows case.  KVM should really be copying the
pages for sectors where IO is already in flight.

We could do the copies ourselves: mount -o dio_copies

-chris

