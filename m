From: Eric Whitney <eric.whitney@hp.com>
Subject: Re: Regression/functional test suite?
Date: Thu, 13 Nov 2008 16:11:19 -0500
Message-ID: <491C97F7.6030504@hp.com>
References: <20081113192038.GC9606@tracyreed.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Tracy Reed <treed@tracyreed.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081113192038.GC9606@tracyreed.org>
List-ID: <linux-btrfs.vger.kernel.org>

Tracy:

There's not yet an official automated regression test suite for btrfs, 
but that's one of Chris Mason's V1.0 goals.  To that end, I've begun 
work on a suite I hope he'll find acceptable.  The idea is to make it 
easy for a broad range of users to contribute testing effort and 
results.  System and storage diversity will be very helpful in shaking 
out btrfs bugs.

My plan is to reuse existing file system test code or test cases from a 
number of sources where applicable and to add new test code where btrfs 
features require it.  The test suite will be released in stages as it 
grows in coverage and capability.

Until then, with Chris' caveat that btrfs isn't yet ready for production 
use and that work remains to be done in some areas, it's always useful 
to run tests or benchmarks you find important or interesting.  I know 
Chris and the other btrfs developers like all the testing they can get.

Eric


Tracy Reed wrote:
> I am watching the btrfs project with great interest and looking
> forward to the blessing of the final on-disk format (which I
> understand is coming soon) and giving it a spin in my test
> environment. Like so many others I have been disappointed that the
> very impressive ZFS filesystem isn't available on Linux in any
> meaningful way and see btrfs as the way around this and ultimately a
> better choice. Hopefully btrfs has learned from ZFS and can leapfrog
> it in some areas.
> 
> This leads me to a question: I have been following this list for a
> while and have not see anyone mention any sort of regression testing
> or automated functional test suite being run against btrfs. This would
> seem to be critically important for something like a filesystem. Does
> it exist?
> 
> I have access to a large amount of disk storage and storage systems
> and would be happy to dedicate a machine with a significant amount of
> disk in various configurations to do constant functional testing of
> btrfs. I know you may already such resources since the project is
> supported by Oracle etc. but I want to do whatever I can to help
> things along. I'm more of a system administrator than a C coder or
> filesystem expert so I can't offer code but perhaps I can help in
> another material way.
> 
