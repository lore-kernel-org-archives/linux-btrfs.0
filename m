From: "Tommy Jonsson" <quazzie@gmail.com>
Subject: Fsck, parent transid verify failed
Date: Wed, 1 Dec 2010 12:00:56 +0100
Message-ID: <003501cb9147$09197540$1b4c5fc0$@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks!

Been using btrfs for quite a while now, worked great until now. 
Got power-loss on my machine and now i have the "parent transid verify
failed on X wanted X found X" problem.
So I can't get it to mount.

My btrfs is spread over sda (2tb), sdc(2tb), sdd(1tb).

Is this something that an offline fsck could fix ? 
If so is the fsck-util being developed ?
Is there a way to mount the FS in a read-only mode or something to rescue
the data ?

Thanks, Tommy.


