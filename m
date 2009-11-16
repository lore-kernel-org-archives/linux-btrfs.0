From: Chris Mason <chris.mason@oracle.com>
Subject: Re: nodatacsum broken?
Date: Mon, 16 Nov 2009 11:27:06 -0500
Message-ID: <20091116162706.GA27677@think>
References: <4B017C63.5000600@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B017C63.5000600@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 16, 2009 at 10:22:59AM -0600, Steven Pratt wrote:
> Did we break the ability to run with -o nodatacsum somewhere along
> the way? I had not run just this option in a while (usually doing
> nodatacow which implies nodatacsum).  Just did a full run with just
> nodatacsum and it looks like we still did csums.

Were the files created without nodatasum?  The sum option actually ends
up stored in the file itself, so if you're reading from an old dataset
you'll still sum.

-chris
