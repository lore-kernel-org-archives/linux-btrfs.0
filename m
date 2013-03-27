Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:36600 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751829Ab3C0Uwl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 16:52:41 -0400
Date: Wed, 27 Mar 2013 15:52:40 -0500
From: Ben Myers <bpm@sgi.com>
To: Zach Brown <zab@zabbo.net>
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Rich Johnston <rjohnston@sgi.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
Subject: Re: Announce re-factor all current xfstests patches request
Message-ID: <20130327205240.GT22182@sgi.com>
References: <5152F2BB.4000709@sgi.com>
 <20130327134606.GJ5861@thunk.org>
 <5153217B.5070909@sgi.com>
 <20130327190512.GA22889@thunk.org>
 <20130327204217.GC16651@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130327204217.GC16651@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

On Wed, Mar 27, 2013 at 01:42:17PM -0700, Zach Brown wrote:
> On Wed, Mar 27, 2013 at 03:05:12PM -0400, Theodore Ts'o wrote:
> > What do you think about renaming the existing tests from NNN to
> > NNN-descriptive-name?  That way it will be easier for people who are
> > trying to track regressions, since they can easily map from the new
> > more descriptive name to the old test number for comparison purposes
> > (i.e., to see whether a failure is a regression or not, etc.)
> 
> It does seem like a good idea to help people map from descriptive names
> to their previous numeric file names.
> 
> But do we want to bake it in to the file names forevermore?  Would it be
> good enough to start the old tests with something like
> 
> _was_test_nr 45
> 
> that spits out the old test number in the log?
> 
> Just thinking out loud over here.

Maybe a text file containing the mapping would be sufficient.  It's not as if
it's going to grow.

-Ben
