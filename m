From: Pat Regan <thehead@patshead.com>
Subject: Re: some issues with lots of snapshots
Date: Tue, 26 Oct 2010 15:15:28 -0400
Message-ID: <20101026151528.555ccee9@zaphod>
References: <20101026102853.GX13205@jeru.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101026102853.GX13205@jeru.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 26 Oct 2010 12:28:53 +0200
Xavier Nicollet <nicollet@jeru.org> wrote:

> I can't reproduce this right know, but it seems that creating lots of
> snapshots, one per minute (keeping only a dozens of them) may block
> the system. Every btrfs snap processes stay idle and the load
> skyrockets to 900.
> 
> I use an old version: 2.6.34.5 kernel, and the system is still very
> responsive (web and mysql server).

I had the same thing happen with a 2.6.36-rc6 kernel on my laptop.  My
cron jobs were creating snapshots and 5 minute intervals and keeping 12
of them active.

I turned off the 5-minute snapshots and I'm now just keeping 4 weekly, 7
daily, and 24 hourly snapshots alive.

Pat
