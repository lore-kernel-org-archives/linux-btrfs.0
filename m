From: David Sterba <dave@jikos.cz>
Subject: Re: strange filefrag output on btrfs
Date: Mon, 13 Jun 2011 13:50:18 +0200
Message-ID: <20110613115018.GT12709@twin.jikos.cz>
References: <4DF38C23.7010603@gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DF38C23.7010603@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 11, 2011 at 05:39:15PM +0200, Andreas Philipp wrote:
> On one of my btrfs volumes I see a strange output from filefrag when
> run against a particular large (~8GB) file. filefrag and filefrag -v
> give me a different number of extents, see below.
> 
> aph@thor /mnt/nutshell $ sudo filefrag -v funtoo.img | grep extents
> funtoo.img: 2624 extents found
> aph@thor /mnt/nutshell $ sudo filefrag funtoo.img | grep extents
> funtoo.img: 2653 extents found

is the file open and being written to? did you run sync before the first
command?


david
