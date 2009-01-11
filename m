From: Andreas Dilger <adilger@sun.com>
Subject: Re: source line numbers with x86_64 modules? [Was: Re: [patch]
	measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact]
Date: Sun, 11 Jan 2009 18:11:35 +0800
Message-ID: <20090111101135.GA3306@webber.adilger.int>
References: <170fa0d20901100621m74680e0ewd1916c70f1636c9b@mail.gmail.com>
 <20090110153446.GA13976@elte.hu>
 <170fa0d20901101021s3b9a18e9qe6150c374efa4d6f@mail.gmail.com>
 <20090110211531.GD31579@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Theodore Tso <tytso@mit.edu>, Mike Snitzer <snitzer@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Nicholas Miell <nmiell@comcast.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	jim
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20090110211531.GD31579@mit.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Jan 10, 2009  16:15 -0500, Theodore Ts'o wrote:
> In my experience, there are very few kernel versions and hardware for
> which kdump works.  I've talked to the people who have to make kdump
> work, and every 12-18 months, with a new set of enterprise kernels
> comes out, they have to go and fix kdump so it works again for the set
> of hardware that they care about, and for the kernel version involved.

I'm sad that netconsole/netdump never made it big.  It was fairly useful,
and extending the eth drivers to add the polling mode was trivial to do.
We were using that for a few years, but it got replaced by kdump and it
appears to be less usable IMHO.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

