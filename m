From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Updated performance results
Date: Wed, 16 Sep 2009 14:17:14 -0400
Message-ID: <20090916181714.GF2641@think>
References: <4A9C0D19.5010108@austin.ibm.com>
 <20090911192955.GB2894@think>
 <4AAAC2B6.8040105@austin.ibm.com>
 <20090914135130.GE8839@think>
 <4AAEB89C.3040100@austin.ibm.com>
 <20090916005225.GG23965@think>
 <4AB1010F.70001@austin.ibm.com>
 <4AB12702.30601@austin.ibm.com>
 <20090916180719.GE2641@think>
 <4AB12B30.1020205@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <eric.whitney@hp.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AB12B30.1020205@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 16, 2009 at 01:15:12PM -0500, Steven Pratt wrote:
> Chris Mason wrote:
> >On Wed, Sep 16, 2009 at 12:57:22PM -0500, Steven Pratt wrote:
> >>Steven Pratt wrote:
> >>>Chris Mason wrote:
> >>>>On Mon, Sep 14, 2009 at 04:41:48PM -0500, Steven Pratt wrote:
> >>>>>Only bit of bad news is I did get one error that crashed the system
> >>>>>on single threaded nocow run. So that data point is missing.
> >>>>>Output below:
> >>>>I hope I've got this fixed.  If you pull from the master branch of
> >>>>btrfs-unstable there are fixes for async thread races.  The single
> >>>>patch I sent before is included, but not enough.
> >>>Glad you said that.  Keeps me from sending the email that said the
> >>>patch didn't help :-)
> >>>
> >>>Steve
> >>Well, still getting oopses even with new code.
> >>
> >>Lots of:
> >>Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] BUG: soft lockup -
> >>CPU#10 stuck for 61s! [btrfs-endio-1:30250]
> >>Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] Pid: 30250, comm:
> >>btrfs-endio-1 Not tainted 2.6.31-autokern1 #1 IBM x3950-[88726RU]-
> >>Sep 16 11:07:27 btrfs1 kernel: [ 1862.942754] RIP:
> >>0010:[<ffffffff81153920>]  [<ffffffff81153920>] crc32c+0x20/0x26
> >
> >If I'm reading this right, you've got a softlockup in crc32c?  Something
> >has gone really wrong here.  Are you reusing datasets from old runs?
> No, mkfs before every run.

Could you please send me the full softlockup output?  Its hard to read
all line wrapped, so the original files would help.

-chris

