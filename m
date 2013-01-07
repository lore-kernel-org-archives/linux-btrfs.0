Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab3AGPbf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Jan 2013 10:31:35 -0500
Date: Mon, 7 Jan 2013 16:31:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Kiran Patil <kirantpatil@gmail.com>
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com
Subject: Re: Open for contribution towards xfstests for btrfs
Message-ID: <20130107153132.GH20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CANT588vv8xYNWGBSZUDu0vui2ZH4QqL7tvQX8zOGof7nucC6_Q@mail.gmail.com>
 <CANT588tZd8y3G0jZD3Ti-nHexk1jwmD-fJP1f1bttFP8kyEgqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANT588tZd8y3G0jZD3Ti-nHexk1jwmD-fJP1f1bttFP8kyEgqg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 07, 2013 at 03:48:43PM +0530, Kiran Patil wrote:
> We have a team of 5 students who would like to contribute to btrfs
> filesystem testing using xfstests.

By any chance, are these the same people behind
http://sourceforge.net/projects/btrfstest/ ?

> Is there space for them to contribute?

Sure. As an example of where to start, look at a some patches from Miao
Xie with reproducers for several bugs. This IMHO is a smooth path to
start with xfstests, the task is to embody the test itself into the
teitesinfrastructure.

The more advanced tasks:
* look at commits in btrfs and try to write a specific test for them
  (depends on the nature of the bug, the difficulty ranges from easy to
  impossible)
* write test coverage for a particular feature (eg. for Jeff Liu's label
  setting patches)
* several btrfs specific xfstests were sent to the mailinglists over
  time, I'm sure not all of them were merged

> If yes, to whom do they need to keep in touch for guidance.

You can learn a lot from existing xfstests and review comments of
proposed tests.  Feel free to ask in the respective mailinglists or IRC
channels.


david
