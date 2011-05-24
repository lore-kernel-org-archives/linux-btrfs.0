From: Arne Jansen <sensille@gmx.net>
Subject: Re: Integration branch pushed out to btrfs-unstable
Date: Tue, 24 May 2011 11:01:23 +0200
Message-ID: <4DDB73E3.8050800@gmx.net>
References: <1306179381-sup-443@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306179381-sup-443@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 23.05.2011 21:54, Chris Mason wrote:
> I've pushed out my current kernel git tree to a new branch called
> integration-test.  This is meant for integration testing only and should
> not be run by anyone who doesn't love crashes.
> 
> Scrub, chunk allocator fixes

please note that in order to test scrub functionality you need an
updated btrfs utility. You can pull it from:

git://git.kernel.org/pub/scm/linux/kernel/git/arne/btrfs-progs-unstable-arne.git
scrub

Thanks,
Arne
