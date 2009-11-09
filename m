From: Chris Mason <chris.mason@oracle.com>
Subject: Re: chmod errors compiling on btrfs
Date: Mon, 9 Nov 2009 14:14:13 -0500
Message-ID: <20091109191413.GB4868@think>
References: <4AF5DA58.1060600@gmail.com>
 <20091109151503.GA2812@think>
 <4AF8663F.8000605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Andrew Benton <b3nton@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AF8663F.8000605@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 09, 2009 at 06:58:07PM +0000, Andrew Benton wrote:
> On 09/11/09 15:15, Chris Mason wrote:
> >We fixed some umask problems recently, these should be fixed in the
> >master branch of the btrfs-unstable repo (which is against 2.6.31).
> >
> 
> Thanks, that did the trick. Will these umask fixes be in the 2.6.32 kernel?

Great.  They are already included in 2.6.32-rc releases

-chris

