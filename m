Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51804 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446AbcAALmZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jan 2016 06:42:25 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id C433D20439
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Jan 2016 06:42:24 -0500 (EST)
Received: from [192.168.1.17] (unknown [5.103.84.67])
	by mail.messagingengine.com (Postfix) with ESMTPA id 407D0C016C4
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Jan 2016 06:42:24 -0500 (EST)
From: Rasmus Abrahamsen <btrfs@rasmusa.net>
Content-Type: text/plain; charset=us-ascii
Subject: Add big device, remove small device, now read-only
Message-Id: <CFC493D7-E08C-4D32-9A6C-C47532636D8F@rasmusa.net>
Date: Fri, 1 Jan 2016 12:42:37 +0100
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Happy NY!
I have a raid with a 1TB, .5TB, 1.5TB and recently added a 4TB and want to remove the 1.5TB.
When saying btrfs dev delete it turned into readonly. I am on 4.2.5-1-ARCH and btrfs-progs v4.3.1 what can I do?
On top of that, my linux is on this same raid, so perhaps btrfs is writing some temp files in the filesystem but cannot?
. /dev/sdc1 on / type btrfs (ro,relatime,space_cache,subvolid=1187,subvol=/linux)

<zetok> Ralle: did you do balance before removing?

I did not, but I have experience with it balancing itself upon doing so.
Upon removing a device, that is.
I am just not sure how to proceed now that everything is read-only.

<zetok> I dunno, but generally with things that can crumble you should make it step-by-step
crumble?
<zetok> which, in combination arch + newest bleeding edge kernel should be mandatory
<zetok> I hope that you have backups?

I do have backups, but it's on Crashplan, so I would prefer not to have to go there.

<zetok> and do you have any logs?

Where would those be?
I never understood journalctl

<zetok> journalctl --since=today

Hmm, it was actually yesterday that I started the remove, so I did --since=yesterday
I am looking at the log now, please stnad by.
This is my log
http://pastebin.com/mCPi3y9r
But I fear that it became read-only before actually writing the error to the filesystem

