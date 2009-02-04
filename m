From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Backporting to 2.6.27 and below
Date: Wed, 04 Feb 2009 09:54:27 -0500
Message-ID: <1233759267.20318.0.camel@think.oraclecorp.com>
References: <20090203195352.GA7568@tux64-01>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090203195352.GA7568@tux64-01>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-02-03 at 14:53 -0500, Lee Trager wrote:
> A couple of weeks ago it was mentioned that btrfs in the stand alone
> tree would be patched to support 2.6.27 with older versions coming
> after. Has anyone actually done these patches? I'd like to get btrfs
> running on 2.6.26(Debian Lenny kernel) and if no one has done any code
> towards it I'd be happy to do it.

It would definitely be appreciated.  For the most part this should just
be digging out the commits that dropped the compat code and adding them
back.

-chris


