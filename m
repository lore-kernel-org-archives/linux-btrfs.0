From: Michael Tharp <gxti@partiallystapled.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Wed, 29 Apr 2009 09:11:36 -0400
Message-ID: <49F85208.1090108@partiallystapled.com>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <200904281945.10274.hjclaes@web.de> <20090428201619.GK7217@cip.informatik.uni-erlangen.de> <200904282236.07428.hjclaes@web.de> <20090428205242.GA13112@cip.informatik.uni-erlangen.de> <1240952295.15136.73.camel@think.oraclecorp.com> <20090428211255.GB13112@cip.informatik.uni-erlangen.de> <1240953977.15136.76.camel@think.oraclecorp.com> <20090428221455.GA27794@cip.informatik.uni-erlangen.de> <1240960687.15136.88.camel@think.oraclecorp.com> <20090429120300.GG22917@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Heinz-Josef Claes <hjclaes@web.de>, linux-btrfs@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090429120300.GG22917@cip.informatik.uni-erlangen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Thomas Glanzmann wrote:
> Looking at this picture, when I'm going to implement the dedup code, do I also
> have to take care to spread the blocks over the different devices or is
> there already infrastructure in place that automates that process?

If you somehow had blocks duplicated exactly across two devices such 
that the deduplicator discarded all the blocks from one disk and kept 
all the blocks from the other disk, then there would be a problem. The 
best way to solve this would be to always keep the block on the 
least-full device and discard the rest, which shouldn't be too difficult 
(especially since this would be happening in kernelspace), but the 
cheapest solution is to randomize the choice which would be sufficient 
to prevent any further imbalance from developing.

-- m. tharp
