From: Josef Bacik <josef@redhat.com>
Subject: Re: disk space caching generation missmatch
Date: Wed, 1 Dec 2010 12:40:18 -0500
Message-ID: <20101201174018.GB7021@localhost.localdomain>
References: <201012011746.14458.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201012011746.14458.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 01, 2010 at 05:46:14PM +0100, Johannes Hirte wrote:
> After enabling disk space caching I've observed several log entries like this:
> 
> btrfs: free space inode generation (0) did not match free space cache generation (169594) for block group 15464398848
> 
> I'm not sure, but it seems this happens on every reboot. Is this something to
> worry about?
> 

So that usually means 1 of a couple of things

1) You didn't have space for us to save the free space cache
2) When trying to write out the cache we hit one of those cases where we would
deadlock so we couldn't write the cache out

It's nothing to worry about, it's doing what it is supposed to.  However I'd
like to know why we're not able to write out the cache.  Are you running close
to full?  Thanks,

Josef
