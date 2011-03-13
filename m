From: Peter Stuge <peter@stuge.se>
Subject: Re: Btrfs system won't start on Ubuntu (relationship problems...)
Date: Mon, 14 Mar 2011 00:21:52 +0100
Message-ID: <20110313232152.12892.qmail@stuge.se>
References: <AANLkTi=4VaXSZgeN-DeohPduQ_8FiuEroNpKCD3bTSPK@mail.gmail.com> <20110313114616.8860.qmail@stuge.se> <AANLkTimtN0FWG95dzjwzOzZoQaHEzL7t5ffZchR=BZAu@mail.gmail.com> <20110313163048.5321.qmail@stuge.se> <AANLkTin9FG5npgKS_Hj16mXFb17ixmM6XddWw45zEW62@mail.gmail.com> <AANLkTim06NUgAitTyFrACggzC=0hXYvbzPr=y04jLjky@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?utf-8?B?SsOpcsO0bWU=?= Poulin <jeromepoulin@gmail.com>,
	linux-btrfs@vger.kernel.org
To: Pau Iranzo <paulists@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim06NUgAitTyFrACggzC=0hXYvbzPr=y04jLjky@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Pau Iranzo wrote:
> it's been years since I last installed Windows on one of my
> computers (2003 maybe?).

Again, Windows or not is irrelevant.

The hard drive is physically broken and that would have happened at
the same point in time regardless of anything that software has been
doing.


> The thing was that I was excited about btrfs and I had used it
> since it was on the partition manager on the Ubuntu installer. I
> hadn't had any problems with btrfs on my computers until this. Then
> I discovered there was no fsck :(

As I explained already, just powering up the disk reduces your
chances of recovering data, and reading lots of data from the disk
even more so, so the fact that there is no fsck that you could have
run on the disk is actually in your case an advantage. I hope this
was already absolutely clear.


> I'll try what you told me.

Expect to spend some time on data recovery. Make sure to have enough
free space for a dd_rescue copy of the broken disk.

In order to avoid the risk of hitting one of those misbehaving USB
adapters better try to hook up the disk to a mainboard controller.


//Peter
