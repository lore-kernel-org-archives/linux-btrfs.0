From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: do not BUG if we fail to remove the orphan item
	for dead snapshots
Date: Fri, 10 Dec 2010 08:30:36 -0500
Message-ID: <20101210133035.GC1226@dhcp231-156.rdu.redhat.com>
References: <1291829142-22255-1-git-send-email-josef@redhat.com> <4D01D3BF.2010702@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D01D3BF.2010702@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 10, 2010 at 03:16:15PM +0800, Li Zefan wrote:
> 01:25, Josef Bacik wrote:
> > Not being able to delete an orphan item isn't a horrible thing.  The worst that
> > happens is the next time around we try and do the orphan cleanup and we can't
> > find the referenced object and just delete the item and move on.  Thanks,
> > 
> 
> Would be better to add code comment? Otherwise later people may wonder why
> the return value is not checked and see it as a bug.
>

Comments are against Btrfs' coding style guidlines.

Josef 
