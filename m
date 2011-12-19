From: Chris Mason <chris.mason@oracle.com>
Subject: Re: A sample tool how to use the new ioctl
Date: Mon, 19 Dec 2011 09:47:06 -0500
Message-ID: <20111219144706.GD24793@shiny>
References: <1324304223-19079-1-git-send-email-dsterba@suse.cz>
 <20111219142539.GE12898@ds.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111219142539.GE12898@ds.suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 19, 2011 at 03:25:39PM +0100, David Sterba wrote:
> This is a standalone tool I've used to exercise the ioctl, simply pass
> the name of a file and see the result. The numbers are a rough
> estimate. It also takes the range arguments, but the ratio will be bogus
> due to comparison to whole file (st_blocks), an exact extent length
> from fiemap/filefrag is be the correct one.

Thanks Dave.

Could you please add this to btrfs filesystem stat <filename>

-chris
