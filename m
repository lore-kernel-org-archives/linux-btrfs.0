From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Date: Wed, 29 Jun 2011 13:36:48 -0400
Message-ID: <20110629173648.GA22293@infradead.org>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
 <1309275199-10801-5-git-send-email-josef@redhat.com>
 <20110629065306.GC1026@dastard>
 <20110629074021.GA26086@infradead.org>
 <4E0B019E.8080800@draigBrady.com>
 <4E0B60DE.50908@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: P?draig Brady <P@draigBrady.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
To: Sunil Mushran <sunil.mushran@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E0B60DE.50908@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 29, 2011 at 10:29:02AM -0700, Sunil Mushran wrote:
> I'm not too sure about that. Atleast not enabled by default. Most users
> use cp to backup data. Not empty space. In this case, this empty extent
> may not even be de-dupable.
> 
> Frankly I'd be happier of cp started to exploited fallocate() to create larger
> extents before copying data into them. Atleast for the large files.

That's what delayed allocation is for.
