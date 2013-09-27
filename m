Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726Ab3I0Rvz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 13:51:55 -0400
Date: Fri, 27 Sep 2013 10:51:50 -0700
From: Zach Brown <zab@redhat.com>
To: Hugo Mills <hugo@carfax.org.uk>, Tom Gundersen <teg@jklm.no>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: csum questions
Message-ID: <20130927175150.GU30372@lenny.home.zabbo.net>
References: <CAG-2HqV3MoRQ9E9VqjJ7NFKia7=b30_LKKL82FmV6s4u6vOrTA@mail.gmail.com>
 <20130927142535.GB28147@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130927142535.GB28147@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > 2) How may I tell btrfs to ignore all csums and just assume they are
> > all correct? The reason for wanting this is in case the csum is
> > garbled and the file is intact, or the csum is correct and the file is
> > only partially garbled, but may still contain useful data.
> 
>    You can't, right now. There's discussion on IRC about this very
> point right now. :)

Well, hold on.  Yes, you can't tell it to just not check checksums.

But keep reading.  It sounds like he thinks that *any* reads to the file
will error once any checksum has failed.  Surely that's not true, you
can do use like dd conv=noerror and read all the extents of the file
whose checksums are still valid.

- z
