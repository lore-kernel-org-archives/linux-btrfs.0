Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v1.edulibre.org ([5.39.16.54]:53391 "EHLO mail.edulibre.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924AbcHOOGr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Aug 2016 10:06:47 -0400
Received: from asus17.lairdutemps.org (did75-10-82-236-230-93.fbx.proxad.net [82.236.230.93])
	by mail.edulibre.org (Postfix) with ESMTPSA id B577B1026ABE
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Aug 2016 16:06:42 +0200 (CEST)
Date: Mon, 15 Aug 2016 16:06:41 +0200
From: Daniel Caillibaud <ml@lairdutemps.org>
To: btrfs ml <linux-btrfs@vger.kernel.org>
Subject: Re: Huge load on btrfs subvolume delete
Message-ID: <20160815160641.79063cec@asus17.lairdutemps.org>
In-Reply-To: <95c98a1b-4484-c294-fcd6-001e73cd25d6@gmail.com>
References: <20160815123928.47bd2c03@asus17.lairdutemps.org>
	<95c98a1b-4484-c294-fcd6-001e73cd25d6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 15/08/16 à 08:32, "Austin S. Hemmelgarn" <ahferroin7@gmail.com> a écrit :

ASH> On 2016-08-15 06:39, Daniel Caillibaud wrote:
ASH> > I'm newbie with btrfs, and I have pb with high load after each btrfs subvolume delete
[…]

ASH> Before I start explaining possible solutions, it helps to explain what's 
ASH> actually happening here.
[…]

Thanks a lot for these clear and detailed explanations.

ASH> > Is there a better way to do so ?

ASH> While there isn't any way I know of to do so, there are ways you can 
ASH> reduce the impact by reducing how much your backing up:

Thanks for these clues too !

I'll use --commit-after, in order to wait for complete deletion before starting rsync the next
snapshot, and I keep in mind the benefit of putting /var/log outside the main subvolume of the
vm (but I guess my main pb is about databases, because their datadir are the ones with most
writes).

-- 
Daniel
