From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Random write regression
Date: Mon, 20 Jul 2009 09:34:31 -0400
Message-ID: <20090720133431.GB25193@think>
References: <4A646D0E.1060006@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A646D0E.1060006@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 20, 2009 at 08:11:42AM -0500, Steven Pratt wrote:
> Finally got around to going through latest data.  Seems like we lost all  
> the random write performance gains.  Creates are better, but total  
> regression on the random workload.  Sequential reads seem to have  
> dropped as well.

Interesting, was this filesystem freshly created?

-chris
