From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: Subvolume level allocation policy
Date: Mon, 24 Oct 2011 11:44:16 +0200
Message-ID: <4EA53370.1060909@jan-o-sch.net>
References: <4EA4620A.3060702@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Phillip Susi <psusi@cfl.rr.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EA4620A.3060702@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 23.10.2011 20:50, Phillip Susi wrote:
> Is it ( yet? ) possible to manipulate the allocation policy on a
> subvolume level instead of the fs level?  For example, to make / use
> raid1, and /home use raid0?  Or to have / allocated from an ssd and
> /home allocated from the giant 2tb hd.

At least the latter can be achieved with speed profiles. I worked on
those together with Arne Jansen who sent patches in January 2011,
subject "[PATCH] Btrfs: introducing speed profiles and dedicated log
devices".

I don't assume they apply nowadays without a major rework, though. We
should get those patches merged sometime.

-Jan
