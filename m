Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:60319 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427AbaEPOCL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 10:02:11 -0400
Received: by mail-ig0-f172.google.com with SMTP id uy17so805299igb.5
        for <linux-btrfs@vger.kernel.org>; Fri, 16 May 2014 07:02:10 -0700 (PDT)
Message-ID: <1400248927.979.2.camel@sasami.ottawa.blindsidenetworks.com>
Subject: Re: [ANNOUNCE] xfstests: new mailing list
From: Calvin Walton <calvin.walton@kepstin.ca>
To: =?UTF-8?Q?Luk=C3=A1=C5=A1?= Czerner <lczerner@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Date: Fri, 16 May 2014 10:02:07 -0400
In-Reply-To: <alpine.LFD.2.00.1405161054280.2099@localhost.localdomain>
References: <20140516044611.GA8206@dastard>
	 <20140516054009.GA17647@infradead.org>
	 <alpine.LFD.2.00.1405161047010.2099@localhost.localdomain>
	 <20140516085320.GA29279@infradead.org>
	 <alpine.LFD.2.00.1405161054280.2099@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-05-16 at 10:55 +0200, Lukáš Czerner wrote:
> On Fri, 16 May 2014, Christoph Hellwig wrote:
> > On Fri, May 16, 2014 at 10:48:42AM +0200, Luk?? Czerner wrote:
> > > > > As requested I've created a new mailing list for xfstests
> > > > > development and discussion. Reflecting the fact that the test
> > > > > harness is not really XFS specific anymore, the list is:
> > > > > 
> > > > > 	fstests@vger.kernel.org
> > > > 
> > > > Isn't there an "x" missing somewhere?
> > > 
> > > It's intentional and it is "Reflecting the fact that the test
> > > harness is not really XFS specific anymore", even though the test
> > > suite itself keep the name xfstests.
> > > 
> > > This way it's more obvious to people that this is in fact not xfs
> > > specific.
> > 
> > Having the name different from the project it is for is stupid.  Either
> > rename the test suite, or use the same name for the mailing list.
> 
> Renaming the test suite is a good option if we can agree on this.

Instead of renaming the test suite, why not just "backronym" it to mean
something different? The letter x is used to mean "cross" in many
contexts, so "xfstests" could easily mean "cross-filesystem tests" - a
name that fits perfectly!

Only kind of joking,
Calvin.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

