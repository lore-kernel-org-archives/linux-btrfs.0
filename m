From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: btrfs and load (sys)
Date: Wed, 23 Nov 2011 15:43:14 +0100
Message-ID: <CAJ1PRSnhqo3yU4b0sbcYLfByb_pTDuAOL2xo4fryiEoacr8iYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been using btrfs for two months now. Every day between 02:00 and
08:00 I rsync some 300GB data (milions of files) to btrfs device and
then make snapshot. Next day i rsync again 300GG little changed (rsync
"in place"). First days it worked perfectly. Then loadavg (sys load)
started to rise. Now, after 60 days of rsync+shapshots sys load is so
high that whole server becames quite unresponsive betweend 02:00 and
08:00. I never deleted any shapshot (yet) to its not rebalancing
thing.
What all those btrfs benchmark does not tell you that its performance
decreases (sys load increases) with growing size of btree. Creating
btrfs filesystem is instantaneous because initial tree is just
nothing...
I tried using btrfs and nilfs2 for a half year now and I would never
trust a byte of production data to it.
