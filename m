From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: Do not use free space caching!
Date: Thu, 31 Mar 2011 17:06:42 -0400
Message-ID: <1301605604.12638.5.camel@ayu>
References: <4D939E76.1060801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D939E76.1060801@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2011-03-30 at 17:19 -0400, Josef Bacik wrote:
> Hello,
> 
> Just found a big bug in the free space caching stuff that will result in 
> early ENOSPC.  I'm working on fixing this bug, but it won't be until 
> tomorrow that I'll have it completely working, so for now make sure to 
> mount -o clear_cache so that it just clears the cache and doesn't use it.
> 
> NOTE: It doesn't cause problems other than early ENOSPC, you won't get 
> corruption or anything like that, tho you could possibly panic.
> 
> Sorry for the inconvenience.  Thanks,

Any chance you could provide a little more information about which
kernels are affected? Is it any kernel with free space cache support (is
2.6.38.x included?) - and if so, do you plan on submitting the fix to
the stable kernel series?

-- 
Calvin Walton <calvin.walton@kepstin.ca>

