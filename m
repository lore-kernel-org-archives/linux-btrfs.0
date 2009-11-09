From: Chris Mason <chris.mason@oracle.com>
Subject: Re: chmod errors compiling on btrfs
Date: Mon, 9 Nov 2009 10:15:03 -0500
Message-ID: <20091109151503.GA2812@think>
References: <4AF5DA58.1060600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Andrew Benton <b3nton@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AF5DA58.1060600@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 07, 2009 at 08:36:40PM +0000, Andrew Benton wrote:
> 
> Both times the files created were world writeable when they should
> have been read only. I get the same errors if I compile as myself or
> root. If I compile in my home folder (on a reiserfs partition) they
> compile with no problem. I'm using a self compiled vanila 2.6.31.4
> kernel. I created the partition with btrfs-progs-0.19.

We fixed some umask problems recently, these should be fixed in the
master branch of the btrfs-unstable repo (which is against 2.6.31).

-chris

