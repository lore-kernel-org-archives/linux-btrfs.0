Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53657 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754127AbaBSRv5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 12:51:57 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Incremental backup over writable snapshot
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <16991840.tqyQc6bZHr@linuxpc>
Date: Wed, 19 Feb 2014 10:51:55 -0700
Message-Id: <1985F36E-E720-415C-8BCD-9D7D2847C5DF@colorremedies.com>
References: <17860756.QfG9CfNMqv@linuxpc> <2285169.jbztTl7OC0@linuxpc> <880EBF41-577C-4791-B022-DECE2960748F@colorremedies.com> <16991840.tqyQc6bZHr@linuxpc>
To: GEO <1g2e3o4@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 19, 2014, at 10:29 AM, GEO <1g2e3o4@gmail.com> wrote:

> On Wednesday 19 February 2014 10:26:02 you wrote:
>> Snapshotting, deleting a bunch of directories in that snapshot, then backing
>> up the snapshot, then deleting the snapshot will work. But it sounds more
>> involved. But if you're scripting it, probably doesn't matter either way.
> 
> Will it work as good? 
> I am scripting things, so it does not matter. If it makes no difference in the 
> end result it should be just a matter of taste.
> The question for me is whether both lead to the same result. If I did not 
> understand things the wrong way they should, shouldn't they?

Please also reply to the list directly.

It sounds like it's the same outcome but actually I don't know that send/receive will see it that way. It's necessary for the receive destination to be identical to the source parent, or the increment will not work. And I don't know that the way you're doing this means the source and destination are really identical even though you're deleting the same folders every time. So you'll just have to test it and see if it works. I wouldn't rely on this as a sole backup strategy.

Chris Murphy