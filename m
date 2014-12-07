Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41856 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaLGR7c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 12:59:32 -0500
Date: Sun, 7 Dec 2014 09:59:29 -0800
From: Marc MERLIN <marc@merlins.org>
To: moparisthebest <admin@moparisthebest.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20141207175929.GD8916@merlins.org>
References: <5481EB59.2020603@moparisthebest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5481EB59.2020603@moparisthebest.com>
Subject: Re: abort device removal?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 05, 2014 at 12:28:57PM -0500, moparisthebest wrote:
> Hello all,
> 
> I had a 6-device array I added a 4tb device to last night and ran the
> command to remove a previous 4tb device that still worked fine
> overnight.  Unfortunately, one of the OTHER devices completely failed
> while this was happening, and it *looks* like btrfs did the right thing
> and stopped the move, except it's still marked as 0 space in btrfs fi
> show.  The delete command is still running, though iotop shows it's not
> actually reading or writing anything and no further moving messages in
> dmesg/kern.log seems to indicate that too.
> 
> So what I think I *need* to do is re-add the drive it's currently trying
> to remove so I can delete the now non-functioning other drive without
> losing any data.  My fear is a reboot or unmount/remount will fail to
> mount the currently-being-removed drive as well causing me to lose
> everything.

So I didn't try this, but my understanding is that remove actually runs
a rebalance to remove all the data from that drive.
If the rebalance didn't finish, the drive is still good and part of the
array.

Obviously, you'd be better off with a full backup, but my guess is that
you could just shutdown, remove the failing drive, and leave all the
other drives.
Then run rebalance and it should recreate the missing data from your
failed drive from parity.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
