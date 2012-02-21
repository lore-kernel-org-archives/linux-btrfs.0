From: David Sterba <dave@jikos.cz>
Subject: Re: Hot data Tracking
Date: Wed, 22 Feb 2012 00:24:45 +0100
Message-ID: <20120221232445.GJ1046@twin.jikos.cz>
References: <4F35F365.8000602@googlemail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Timo Witte <timo.witte@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F35F365.8000602@googlemail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 11, 2012 at 05:49:41AM +0100, Timo Witte wrote:
> What happened to the hot data tracking feature in btrfs? There are a lot
> of old patches from aug 2010, but it looks like the feature has been
> completly removed from the current version of btrfs. Is this feature
> still on the roadmap?

Removed? AFAIK it hasn't been ever merged, though it's be a nice
feature. There were suggestions to turn it into a generic API for any
filesystem to use, but this hasn't happened.

The patches are quite independent and it was easy to refresh them on top
of current for-linus branch. A test run did not survive a "random"
xfstest, 013 this time, so I probably mismerged some bits. The patchset
lives in branch foreign/ibm/hotdatatrack in my git repo.


david
