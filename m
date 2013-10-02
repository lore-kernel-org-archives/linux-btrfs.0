Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from detritus.pyropus.ca ([64.5.53.58]:46950 "HELO
	detritus.pyropus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753610Ab3JBT50 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Oct 2013 15:57:26 -0400
Date: Wed, 2 Oct 2013 13:56:55 -0600
From: Charles Cazabon <charlesc-lists-btrfs@pyropus.ca>
To: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Re: Is `btrfsck --repair` supposed to actually repair problems?
Message-ID: <20131002195655.GA23426@pyropus.ca>
References: <20131001211255.GA5946@pyropus.ca>
	<13617928-CDCE-439D-B887-ED42F0E43F12@colorremedies.com>
	<20131001234655.GA7937@pyropus.ca>
	<441F4B12-E813-43E0-9933-79D1C3BF68C3@colorremedies.com>
	<20131002031355.GA11675@pyropus.ca>
	<DFC049CD-209E-49CB-91A3-05BB2F766BC8@colorremedies.com>
	<20131002165324.GA21508@pyropus.ca>
	<DBA8B3F5-F070-48AC-8EF7-20CCCAD9C732@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <DBA8B3F5-F070-48AC-8EF7-20CCCAD9C732@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com> wrote:
> On Oct 2, 2013, at 10:53 AM, Charles Cazabon wrote:
> 
> >> I'd wait until the raid is finished syncing.
> > 
> > Strictly speaking, this shouldn't be necessary.
> 
> I know but it's a 16TB array, do you really want to start over from scratch?
> No. And neither do most people. So this isn't a use case that's probably
> getting a ton of testing.

Fair enough.  The sync should be done late today or early tomorrow, and I am
waiting for it to complete before continuing to debug this.  I'll start with
the scrub you mentioned.

> Also the write-intent bitmap isn't configured by default, and you didn't
> previous say that it was. Is this an internal or external bitmap?

Internal.

Thanks for your assistance to date.

Charles
-- 
-----------------------------------------------------------------------
Charles Cazabon
GPL'ed software available at:               http://pyropus.ca/software/
-----------------------------------------------------------------------
