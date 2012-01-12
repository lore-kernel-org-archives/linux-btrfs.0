From: BJ Quinn <bj@placs.net>
Subject: Re: Cloning a Btrfs partition
Date: Wed, 11 Jan 2012 18:52:04 -0600 (CST)
Message-ID: <c137d5af-bc20-41e4-95b3-480439c0e6b8@mail.placs.net>
References: <f246b736-54be-46d6-8944-701f3bd70c68@mail.placs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>,
	Phillip Susi <psusi@cfl.rr.com>,
	Freddie Cash <fjwcash@gmail.com>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f246b736-54be-46d6-8944-701f3bd70c68@mail.placs.net>
List-ID: <linux-btrfs.vger.kernel.org>

Now I've managed to basically bring my system to its knees.  My rsync script that takes weeks ends up bringing the system to a crawl long before it can ever finish.  I end up with 100% of the CPU used up by the following as shown by top

btrfs-endio-wri
btrfs-delayed-m
btrfs-transacti
btrfs-delalloc-
btrfs-endio-met

Now, I've got a bunch of snapshots, and the server is a backup server that backs up all the machines on the network.  It's using -o compress.  I've got a 6TB array of 2 3TB drives, that is now about 85% full.  There's lots of small files.  I tried to add another drive, but it won't ever finish a rebalance.  Df shows all 9TB as part of the array, but only shows available space as if the array was 6TB.  An attempt at copying all the data to a second array effectively brings the computer to its knees running the threads explained above.  The server never really recovers until a hard reboot and can't ever finish running a backup.

Are there any mount options I should change?  I need the compression and snapshots to have enough space.

-BJ
