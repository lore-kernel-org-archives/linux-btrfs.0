Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxout015.mail.hostpoint.ch ([217.26.49.175]:58955 "EHLO
	mxout015.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423409AbcFHTbN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jun 2016 15:31:13 -0400
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
	by mxout015.mail.hostpoint.ch with esmtp (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1bAidG-0000xK-8t
	for linux-btrfs@vger.kernel.org; Wed, 08 Jun 2016 20:55:14 +0200
Received: from 217-162-125-82.dynamic.hispeed.ch ([217.162.125.82] helo=imac.lan)
	by asmtp013.mail.hostpoint.ch with esmtpa (Exim 4.84 (FreeBSD))
	(envelope-from <btrfs@bueechi.net>)
	id 1bAidG-000AU0-6r
	for linux-btrfs@vger.kernel.org; Wed, 08 Jun 2016 20:55:14 +0200
From: boli <btrfs@bueechi.net>
Content-Type: text/plain; charset=us-ascii
Subject: Replacing drives with larger ones in a 4 drive raid1
Date: Wed, 8 Jun 2016 20:55:13 +0200
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list

I've had a 4 drive btrfs raid1 setup in my backup NAS for a few months now. It's running Fedora 23 Server with kernel 4.5.5 and btrfs-progs v4.4.1.

Recently I had the idea to replace the 6 TB HDDs with 8 TB ones ("WD Red"), because their price is now acceptable.
(More back story: That particular machine has only 4 HDD bays, which is why I originally dared run it as raid5, but later converted to raid1 after having experienced very slow monthly btrfs scrubs and figuring that 12 TB total capacity would be enough for a while; my main NAS on the other hand has always had 6 x 6 TB raid1, that's from where I knew that scrubs can be much faster).

Anyway, so I physically replaced one of the 6 TB drives with an 8 TB one. Fedora didn't boot properly, but went into emergency mode, apparently because it couldn't mount the filesystem.

Because I have to use a finicky Java console when it's booted in emergency mode, I figured I should probably get it to boot normally again as quickly as possible, so I can connect properly with SSH instead.

I guessed the way to do that would be to remove the missing drive from /etc/crypttab (all drives use encryption) and from the btrfs raid1, then reboot and add the new drive to the btrfs volume (also I'd like to completely zero the new drive first, to weed out bad sectors).

In the wiki I read about replace as well as delete/add and figured since I will eventually have to replace all 4 drives one-by-one, I might as well try out different methods and gain insight while doing it. :)

So for this first replacement I mounted the volume degraded and ran "btrfs device delete missing /mnt", and that's where it's been stuck for the past ~23 hours. Only later did I figure out that this command will trigger a rebalance, and of course that will take a long time.

I'm not entirely sure that this rebalance has a chance to work, as a 3x6 TB raid1 would only have 9 TB of space, which may just be enough (but not by much). I can't currently check how much space is actually used, but it must be at least 8.1 TB (that's how much data is on my main NAS), but probably not much more than that (my main NAS may still have most if not all of the snapshots synched to the backup NAS too, for now).

Regarding a few gotchas: I use btrbk to copy and thin snapshots, so there are < 100 snapshots. I might still have quotas active though, because that allows determining the diff size between 2 snapshots. In practice I don't use this often, so will turn it off once things are stable, because I read in other list mails that it makes things slow.

I assume I could probably just Ctrl+C that "btrfs device delete missing /mnt", and the balance would continue as usual in the background, but I have not done that yet, as I'd rather consult you guys first (a bit late, I know).

Anyway, if you have any tips, I'm glad to read them.

For now my plan is to continue waiting what happens. Since it's a just my personal backup NAS, the downtime is not that bad, only that it won't get the usual nightly backups from my main NAS for some time.

Losing data and having to start from scratch would just be an inconvenience, but not a disaster, particularly because the backup NAS is at a friend's house and my upstream is only 50 Mbit/s.

Also thanks to Hugo and Duncan for their awesome/insightful replies to my first question a few months ago (didn't want to spam the list just to say thanks).

Best regards, boli