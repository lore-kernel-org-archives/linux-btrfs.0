From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 9/12] fs/btrfs: Correct redundant test
Date: Mon, 27 Jul 2009 12:28:39 -0400
Message-ID: <20090727162839.GB895@think>
References: <Pine.LNX.4.64.0907271814490.2682@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753662AbZG0Q2w@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0907271814490.2682@ask.diku.dk>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 27, 2009 at 06:15:05PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> dir has already been tested.  It seems that this test should be on the
> recently returned value inode.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://www.emn.fr/x-info/coccinelle/)

Thank you, this is queued up in my tree along with the
other btrfs patches you've sent.

-chris
