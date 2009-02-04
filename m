From: Christian Hesse <mail@earthworm.de>
Subject: Re: Backporting to 2.6.27 and below
Date: Wed, 4 Feb 2009 18:33:44 +0100
Message-ID: <200902041833.45435.mail@earthworm.de>
References: <20090203195352.GA7568@tux64-01> <1233759267.20318.0.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Cc: Lee Trager <lt73@cs.drexel.edu>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1233759267.20318.0.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday 04 February 2009 15:54:27 Chris Mason wrote:
> On Tue, 2009-02-03 at 14:53 -0500, Lee Trager wrote:
> > A couple of weeks ago it was mentioned that btrfs in the stand alone
> > tree would be patched to support 2.6.27 with older versions coming
> > after. Has anyone actually done these patches? I'd like to get btrfs
> > running on 2.6.26(Debian Lenny kernel) and if no one has done any code
> > towards it I'd be happy to do it.
>
> It would definitely be appreciated.  For the most part this should just
> be digging out the commits that dropped the compat code and adding them
> back.

You just have to revert commit 9ca03b997f71787e345951e6267fbd8eba14d49f to 
compile btrfs for 2.6.27.

http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-
unstable.git;a=commitdiff_plain;h=9ca03b997f71787e345951e6267fbd8eba14d49f

Regards,
Chris
