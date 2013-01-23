Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:49643 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab3AWX5O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 18:57:14 -0500
Date: Wed, 23 Jan 2013 18:57:09 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: David Sterba <dsterba@suse.cz>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: put csums on the right ordered extent
Message-ID: <20130123235709.GB3752@shiny>
References: <1358887535-7241-1-git-send-email-jbacik@fusionio.com>
 <20130123110107.GG28263@twin.jikos.cz>
 <20130123152106.GI28263@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130123152106.GI28263@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 23, 2013 at 08:21:07AM -0700, David Sterba wrote:
> On Wed, Jan 23, 2013 at 12:01:08PM +0100, David Sterba wrote:
> > Survived a few hours of Chris' test and I'm running the full xfstests
> > again now.
> 
> After 4.5 hours of the same testsuite as before, this popped up in
> syslog:
> 
> [53489.998888] btrfs csum failed ino 63793 off 106496 csum 2411266714 private 3462448526
> 
> the file is $TEST/junk . Running md5sum on that file produces a
> different checksum error messages:
> 
> [54187.259285] btrfs csum failed ino 63793 off 344064 csum 2566472073 private 1022717503
> (3 times)
> 
> I've rerun chris' script again, no errors, and rechecked if I'm running
> the kernel, yes.

Looks like Josef saw the same, so we have two different bugs (missing
crcs vs incorrect crcs).  Josef mentioned a much faster test for the
incorrect crcs...Josef what was that test?

Thanks to everyone that ran my script, sorry it ended up a distraction.

-chris
