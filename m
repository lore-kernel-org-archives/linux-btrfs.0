From: Chris Mason <chris.mason@oracle.com>
Subject: Re: 2.6.36-rc1 btrfs still unstable
Date: Mon, 16 Aug 2010 08:16:58 -0400
Message-ID: <20100816121658.GT3315@think>
References: <1281948382.1888.7.camel@chotu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Ameya Palande <ameya.palande@nokia.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1281948382.1888.7.camel@chotu>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 16, 2010 at 11:46:22AM +0300, Ameya Palande wrote:
> Hi Chris,
> 
> Today I was checking the Kconfig option for btrfs and it still says,
> "Btrfs filesystem (EXPERIMENTAL) Unstable disk format"
> 
> I remember that some time back we had discussion about this on meego-dev
> mailing list:
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg04881.html
> 
> In case if you have forgotten about this, then can we still change this
> for 36-rc2?

Yes, I'll go ahead and send this one in. 

I've spent a great deal of time trying to nail down the interaction
between raid56 stripe size and adding/removing volumes from the FS
(basically restriping the raid).

The end result just isn't as user friendly as I wanted yet, but the raid
code is holding up very well.

-chris

