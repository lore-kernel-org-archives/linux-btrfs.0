From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC][PATCH 1/2] Btrfs: try to allocate new chunks with degenerated profile
Date: Wed, 18 Jan 2012 13:34:51 +0100
Message-ID: <20120118123451.GI7322@twin.jikos.cz>
References: <4F154738.8000709@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F154738.8000709@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 17, 2012 at 06:02:32PM +0800, Miao Xie wrote:
> So we'd better make the behaviour of chunk allocation correspond with space
> reservation and free space allocation, if there is no enough disk space to
> allocate RAID(RAID0, RAID1, RAID10) chunks, we degenerate the profile and try
> to allocate chunks again. Otherwise, enospc will happen though we reserve
> the space successfully and BUG_ON() will be triggered.
> 
> Degenerating rule:
>   RAID10 -> RAID1 -> DUP
>   RAID0 -> SINGLE

I think that silently changing RAID level under unpredictable conditions
could be a very unpleasant suprise to the administrator. Even worse when
it requires manual intervention to undo the change and without any
possibility to prevent it to happen again.

In case ENOSPC happens early due to overbooking (like untarring lots of
files as reported several times), will probably make it happen sooner
than when "there is absolutely no free space available". We will lose
automatic raid1-repair and scrub repair capabilities, that's not good.


david
