From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Avoid a NULL pointer in btrfs
Date: Wed, 19 Jan 2011 10:52:16 -0500
Message-ID: <1295452288-sup-8924@think>
References: <4D36F04D.70505@gmail.com> <20110119141334.GA2544@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Cc: Liuwenyi <qingshenlwy@gmail.com>, strongzgy <strongzgy@gmail.com>,
	onlyflyer <onlyflyer@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	ak <ak@linux.intel.com>, akpm <akpm@linux-foundation.org>,
	miaox <miaox@cn.fujitsu.com>,
	Yang Ruirui <ruirui.r.yang@tieto.com>,
	meego-kernel <meego-kernel@meego.com>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110119141334.GA2544@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Josef Bacik's message of 2011-01-19 09:14:02 -0500:
> On Wed, Jan 19, 2011 at 10:08:13PM +0800, Liuwenyi wrote:
> > In Yang Ruirui's mail, the btrfs will create a oops. This is caused by a
> > null pointer in test_range_bit() while lock the spinlock.
> > 
> > So, It is necessary to add a pointer check into test_range_bit()
> > 
> 
> 
> NAK, the tree shouldn't be null coming into this function, something else is
> going wrong.  What oops is this?  Thanks,

What was your metadata blocksize for this oops?  This call should never
happen.

I think there is a larger problem, probably in the IO error handling
code since the trace had io errors beforehand.

-chris
