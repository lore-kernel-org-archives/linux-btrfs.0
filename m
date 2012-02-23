From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: 3.3 restripe between different raid levels
Date: Thu, 23 Feb 2012 12:10:58 +0200
Message-ID: <20120223101058.GA1905@zambezi.lan>
References: <loom.20120222T193235-440@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Alex <alex@bpmit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20120222T193235-440@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 22, 2012 at 07:14:44PM +0000, Alex wrote:
> [Referring to https://lkml.org/lkml/2012/1/17/381], and perhaps I'm a bit
> previous, but what are the command sequence to change the raid levels?
> 
> Wouldn't mind being pointed to git manual if better for you.

Look at http://article.gmane.org/gmane.comp.file-systems.btrfs/15211.

The only syntax change that has been merged since then is that you can
invoke balancing commands w/o 'filesystem' prefix, so instead of 'btrfs
fi balance' you can (and should) use 'btrfs balance'.

To get the code you can pull for-chris branch from my repo:

git://github.com/idryomov/btrfs-progs.git for-chris

I'll add proper man pages shortly.

Thanks,

		Ilya
