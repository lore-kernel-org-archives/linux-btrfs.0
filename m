Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:35952 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751690AbbDAWMG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Apr 2015 18:12:06 -0400
Date: Thu, 2 Apr 2015 09:12:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Brian Foster <bfoster@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, fstests@vger.kernel.org
Subject: Re: [PATCH] xfstests: generic: test for discard properly discarding
 unused extents
Message-ID: <20150401221202.GE28621@dastard>
References: <55199FCA.9040503@suse.com>
 <20150401184434.GG4756@bfoster.bfoster>
 <551C4073.8010201@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <551C4073.8010201@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 01, 2015 at 03:01:07PM -0400, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 4/1/15 2:44 PM, Brian Foster wrote:
> > On Mon, Mar 30, 2015 at 03:11:06PM -0400, Jeff Mahoney wrote:
> >> This tests tests four conditions where discard can potentially 
> >> not discard unused extents completely.
> >> 
> >> We test, with -o discard and with fstrim, scenarios of removing 
> >> many relatively small files and removing several large files.
> >> 
> >> The important part of the two scenarios is that the large files 
> >> must be large enough to span a blockgroup alone. It's possible 
> >> for an entire block group to be emptied and dropped without an 
> >> opportunity to discard individual extents as would happen with 
> >> smaller files.
> >> 
> >> The test confirms the discards have occured by using a sparse 
> >> file mounted via loopback to punch holes and then check how many 
> >> blocks are still allocated within the file.
> >> 
> >> Signed-off-by: Jeff Mahoney <jeffm@suse.com> ---
> > 
> > The code looks mostly Ok to me, a few notes below. Those aside, 
> > this is a longish test. It takes me about 8 minutes to run on my 
> > typical low end vm.
> 
> My test hardware is a 16 core / 16 GB RAM machine using a commodity
> SSD. It ran pretty quickly.

Yup, I have a test VM like that, too. However, like many other
people, I also have small VMs that share single spindles with other
test VMs, so we need to cater for them, too.

> >> +	if [ "$FSTYP" = "btrfs" ]; then
> >> +		_run_btrfs_util_prog filesystem sync $tmpdir
> >> +  fi
> >> +	sync
> >> +	sync
> > 
> > Any reason for the double syncs?
> 
> Superstition? IIRC, at one point in what is probably the ancient past,
> btrfs needed two syncs to be safe. I kept running into false failures
> without both a sync and the btrfs filesystem sync, so I just hit the
> "no really, just do it" button.

Urk. If btrfs requires two sync passes to really sync data/metadata,
then that's a bug that needs to be fixed. Let's not encode
superstition or work around bugs that really should be fixed in the
test code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
