Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355Ab3AGP6O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 10:58:14 -0500
Message-ID: <50EAF092.20907@redhat.com>
Date: Mon, 07 Jan 2013 09:58:10 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Kiran Patil <kirantpatil@gmail.com>
CC: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com,
        xfs-oss <xfs@oss.sgi.com>
Subject: Re: Open for contribution towards xfstests for btrfs
References: <CANT588vv8xYNWGBSZUDu0vui2ZH4QqL7tvQX8zOGof7nucC6_Q@mail.gmail.com> <CANT588tZd8y3G0jZD3Ti-nHexk1jwmD-fJP1f1bttFP8kyEgqg@mail.gmail.com>
In-Reply-To: <CANT588tZd8y3G0jZD3Ti-nHexk1jwmD-fJP1f1bttFP8kyEgqg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/7/13 4:18 AM, Kiran Patil wrote:
> Hello,
> 
> We have a team of 5 students who would like to contribute to btrfs
> filesystem testing using xfstests.
> 
> Is there space for them to contribute?
> 
> If yes, to whom do they need to keep in touch for guidance.

(cc: xfs list)

Are you thinking of writing new tests, or doing more formal testing
with the existing testsuite?  Both would be useful.

In particular, any time there's a bugfix, a regression test is helpful.
Generic new tests of btrfs functionality would be good, too.

I would suggest starting with a couple new tests, and cc: the xfs list
for review.  In the course of the review you'll get a sense of the various
conventions used in xfstests, etc.

Simply running xfstests over various btrfs configurations would also
be useful, to be sure any regressions caught by existing tests don't go
unnoticed.

thanks,
-Eric

> Thank you,
> Kiran Patil (Director)
> Green Turtles Technologies, INDIA.


