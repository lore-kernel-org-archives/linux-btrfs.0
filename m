From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Btrfs: only inherit btrfs specific flags when creating
 files
Date: Wed, 28 Sep 2011 10:45:03 -0400
Message-ID: <20110928144502.GA4018@infradead.org>
References: <1317135747-8198-1-git-send-email-josef@redhat.com>
 <4E82717D.6080008@cn.fujitsu.com>
 <4E831261.9010100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liu Bo <liubo2009@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E831261.9010100@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 28, 2011 at 08:26:09AM -0400, Josef Bacik wrote:
> > 
> > It shows EXT[3,4]_APPEND_FL should be inherited from their parent, is this the standard?
> > 
> 
> I have no idea actually, it was just failing on xfstest 79 and when I
> took out the inheritance thing it passed so I took the test to be the
> standard, maybe we should open this up to a wider audience.  Thanks,

We had a little discussion on this when Stefan Behrens made this
test generic, and the conclusion was that the other filesystems should
adopt the xfs behaviour.

