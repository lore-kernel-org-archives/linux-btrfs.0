From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrstress caused kernel oops after 8-ish days.
Date: Tue, 27 Apr 2010 07:46:28 -0400
Message-ID: <20100427114628.GC6513@think>
References: <4BD6C712.6090202@tummy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Sean Reifschneider <jafo@tummy.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BD6C712.6090202@tummy.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 27, 2010 at 05:14:26AM -0600, Sean Reifschneider wrote:
> I ported my zfsstress program over to btrfs, and started running it on
> a test machine a few weeks ago.  See here for more information and a link
> to the program:
> 
>    http://www.tummy.com/journals/entries/jafo_20100418_124309

Interesting, I'll take a look.
> 
> dmesg output of oops below.
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000075
> IP: [<ffffffff810e380f>] page_cache_sync_readahead+0x15/0x3a

This oops is fixed in later kernels, and it's why things stopped.

-chris
