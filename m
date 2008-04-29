From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Btrfs-devel] cloning file data
Date: Tue, 29 Apr 2008 16:52:54 -0400
Message-ID: <200804291652.55198.chris.mason@oracle.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org
To: btrfs-devel@oss.oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 24 April 2008, Sage Weil wrote:
> Hi-
>
> I'm working on a clone ioctl that will quickly and efficiently duplicate
> the contents of a file, e.g.
>

Just FYI, I didn't sneak this into v0.14 because I didn't quite have the 
cycles to test it.  It'll go in this week.

-chris
