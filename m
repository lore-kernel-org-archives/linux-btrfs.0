From: Eric Whitney <eric.whitney@hp.com>
Subject: Re: Updated performance results
Date: Thu, 17 Sep 2009 14:32:13 -0400
Message-ID: <4AB280AD.5080306@hp.com>
References: <20090728202355.GC13940@think> <4A6F6951.9020304@austin.ibm.com> <20090805203526.GE12524@think> <4A7C32A4.9070106@austin.ibm.com> <20090807231240.GD3710@think> <4A9C0D19.5010108@austin.ibm.com> <20090911192955.GB2894@think> <4AAAC2B6.8040105@austin.ibm.com> <20090914135130.GE8839@think> <4AAEB89C.3040100@austin.ibm.com> <20090916005225.GG23965@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Steven Pratt <slpratt@austin.ibm.com>,
	Eric Whitney <eric.whitney@hp.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090916005225.GG23965@think>
List-ID: <linux-btrfs.vger.kernel.org>



Chris Mason wrote:
> On Mon, Sep 14, 2009 at 04:41:48PM -0500, Steven Pratt wrote:
>> Only bit of bad news is I did get one error that crashed the system
>> on single threaded nocow run. So that data point is missing.
>> Output below:
> 
> I hope I've got this fixed.  If you pull from the master branch of
> btrfs-unstable there are fixes for async thread races.  The single
> patch I sent before is included, but not enough.

Chris:

FYI - all five of my test systems have now finished my standard test 
cycle on the -unstable master branch, and I've not seen a single hang. 
So, your fix for the async thread shutdown race seems to have fixed my 
problems, even if Steve's still seeing trouble.

I'll note that the running times for fsstress on some of my systems have 
become rather longer with btrfs-unstable/master kernels - 3.5 rather 
than 2.5 hours on multidevice filesystems.  Running times on single 
device filesystems are roughly the same.

I'm going to start another set of tests for thoroughness unless you've 
got more patches coming.

Thanks,
Eric

> 
> -chris
> 
