From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Thu, 4 Jun 2009 08:43:28 -0400
Message-ID: <20090604124328.GL13945@think>
References: <1240960687.15136.88.camel@think.oraclecorp.com> <20090429120300.GG22917@cip.informatik.uni-erlangen.de> <1241010875.20099.2.camel@think.oraclecorp.com> <20090429135804.GI22917@cip.informatik.uni-erlangen.de> <1241015512.20099.30.camel@think.oraclecorp.com> <20090429152614.GJ22917@cip.informatik.uni-erlangen.de> <1241019915.20099.35.camel@think.oraclecorp.com> <20090604084919.GB22607@cip.informatik.uni-erlangen.de> <20090604114357.GK13945@think> <20090604120350.GB18999@cip.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Heinz-Josef Claes <hjclaes@web.de>,
	Edward Shishkin <edward.shishkin@gmail.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
To: Thomas Glanzmann <thomas@glanzmann.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090604120350.GB18999@cip.informatik.uni-erlangen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 04, 2009 at 02:03:50PM +0200, Thomas Glanzmann wrote:
> Chris,
> 
> > It is a counter and a back reference.  With Yan Zheng's new format
> > work, the limit is not 2^64.
> 
> That means that there is one back reference for every use of the block?
> Where is this back reference stored? (I'm asking because if one back
> reference for every copy is stored, it can obviously not be allocated
> statically).

These are all stored in the extent allocation tree.  There isn't exactly
a 1:1 mapping but it is effectively that.

-chris
