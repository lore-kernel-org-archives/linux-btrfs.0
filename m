From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Warning and BUG using btrfs-vol -b
Date: Tue, 6 Oct 2009 23:17:54 -0400
Message-ID: <20091007031754.GB3757@think>
References: <200910062048.32381.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Diego Calleja <diegocg@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200910062048.32381.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 06, 2009 at 08:48:32PM +0200, Diego Calleja wrote:
> I was playing with btrfs with 2 files of 3.5 GB (using loop), I completely
> zeroed one of the files. As expected, I had checksum failures, and I run
> btrfs-vol -b just to see what happened, and I got this (using -rc3):

Thanks, I'll try to reproduce.  Which raid level did you use for data?
If not raid1, could you try with raid1? ;)

-chris
