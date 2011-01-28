From: Josef Bacik <josef@redhat.com>
Subject: Re: btrfs: free space inode generation (0) did not match free
	space cache generation
Date: Fri, 28 Jan 2011 08:45:31 -0500
Message-ID: <20110128134531.GB4884@dhcp231-156.rdu.redhat.com>
References: <4D42939C.5020605@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D42939C.5020605@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 28, 2011 at 10:59:56AM +0100, Tomasz Chmielewski wrote:
> Not sure if the:
> 
> btrfs: free space inode generation (0) did not match free space cache generation
> 
> is supposed to be fixed in 2.6.38-rc2?
> 

It's not a problem, it just means that the cache is being discarded, which is
what is supposed to happen.  You probably ran out of space or one of the other
corner cases where we can't write out the space cache.  Thanks,

Josef
