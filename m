From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Updated performance results
Date: Tue, 15 Sep 2009 20:52:25 -0400
Message-ID: <20090916005225.GG23965@think>
References: <20090728202355.GC13940@think>
 <4A6F6951.9020304@austin.ibm.com>
 <20090805203526.GE12524@think>
 <4A7C32A4.9070106@austin.ibm.com>
 <20090807231240.GD3710@think>
 <4A9C0D19.5010108@austin.ibm.com>
 <20090911192955.GB2894@think>
 <4AAAC2B6.8040105@austin.ibm.com>
 <20090914135130.GE8839@think>
 <4AAEB89C.3040100@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AAEB89C.3040100@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 14, 2009 at 04:41:48PM -0500, Steven Pratt wrote:
> 
> Only bit of bad news is I did get one error that crashed the system
> on single threaded nocow run. So that data point is missing.
> Output below:

I hope I've got this fixed.  If you pull from the master branch of
btrfs-unstable there are fixes for async thread races.  The single
patch I sent before is included, but not enough.

-chris

