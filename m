Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbaEPIzv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 04:55:51 -0400
Date: Fri, 16 May 2014 10:55:22 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
cc: Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [ANNOUNCE] xfstests: new mailing list
In-Reply-To: <20140516085320.GA29279@infradead.org>
Message-ID: <alpine.LFD.2.00.1405161054280.2099@localhost.localdomain>
References: <20140516044611.GA8206@dastard> <20140516054009.GA17647@infradead.org> <alpine.LFD.2.00.1405161047010.2099@localhost.localdomain> <20140516085320.GA29279@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 16 May 2014, Christoph Hellwig wrote:

> Date: Fri, 16 May 2014 01:53:20 -0700
> From: Christoph Hellwig <hch@infradead.org>
> To: Luk?? Czerner <lczerner@redhat.com>
> Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
>     fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org,
>     linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [ANNOUNCE] xfstests: new mailing list
> 
> On Fri, May 16, 2014 at 10:48:42AM +0200, Luk?? Czerner wrote:
> > > > As requested I've created a new mailing list for xfstests
> > > > development and discussion. Reflecting the fact that the test
> > > > harness is not really XFS specific anymore, the list is:
> > > > 
> > > > 	fstests@vger.kernel.org
> > > 
> > > Isn't there an "x" missing somewhere?
> > 
> > It's intentional and it is "Reflecting the fact that the test
> > harness is not really XFS specific anymore", even though the test
> > suite itself keep the name xfstests.
> > 
> > This way it's more obvious to people that this is in fact not xfs
> > specific.
> 
> Having the name different from the project it is for is stupid.  Either
> rename the test suite, or use the same name for the mailing list.

Renaming the test suite is a good option if we can agree on this.

-Lukas
