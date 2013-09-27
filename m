Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab3I0TN0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 15:13:26 -0400
Date: Fri, 27 Sep 2013 12:13:15 -0700
From: Zach Brown <zab@redhat.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, Tom Gundersen <teg@jklm.no>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: csum questions
Message-ID: <20130927191315.GY30372@lenny.home.zabbo.net>
References: <CAG-2HqV3MoRQ9E9VqjJ7NFKia7=b30_LKKL82FmV6s4u6vOrTA@mail.gmail.com>
 <20130927142535.GB28147@carfax.org.uk>
 <20130927175150.GU30372@lenny.home.zabbo.net>
 <3A64B568-616C-438A-A634-450F4514C861@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3A64B568-616C-438A-A634-450F4514C861@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 27, 2013 at 12:47:57PM -0600, Chris Murphy wrote:
> 
> On Sep 27, 2013, at 11:51 AM, Zach Brown <zab@redhat.com> wrote:
> 
> >>> 2) How may I tell btrfs to ignore all csums and just assume they are
> >>> all correct? The reason for wanting this is in case the csum is
> >>> garbled and the file is intact, or the csum is correct and the file is
> >>> only partially garbled, but may still contain useful data.
> >> 
> >>   You can't, right now. There's discussion on IRC about this very
> >> point right now. :)
> > 
> > Well, hold on.  Yes, you can't tell it to just not check checksums.
> > 
> > But keep reading.  It sounds like he thinks that *any* reads to the file
> > will error once any checksum has failed.  Surely that's not true, you
> > can do use like dd conv=noerror and read all the extents of the file
> > whose checksums are still valid.
> 
> Would that get me an identically sized copy of the file, such as it is?

As far as I know, yes.

- z
