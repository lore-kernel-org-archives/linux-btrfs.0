From: "Lee Trager" <lt73@cs.drexel.edu>
Subject: Re: [PATCH] Backport for 2.6.27 and 2.6.26 on the experimental
	branch
Date: Tue, 24 Feb 2009 15:36:29 -0500
Message-ID: <20090224203629.GB12209@tux64-01>
References: <20090220174518.GA23955@tux64-01> <499EF58F.6020807@hp.com> <20090223222304.GB13878@tux64-01> <49A41F26.2020202@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lee Trager <lt73@cs.drexel.edu>, linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49A41F26.2020202@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

I ran a few tests that Jim suggested and found that btrfs works fine on
2.6.26 as long as there are only 23 or less files on the file system.
Anymore and I experience the lockup. Jim and I will be working to find a
solution but if anyone else has any clues that would be greatly
appreciated.

Lee
On Tue, Feb 24, 2009 at 11:24:06AM -0500, jim owens wrote:
> Lee Trager wrote:
>> The more and more I look at this problem the more I tend to think that
>> the issue is because of some change in the way the VFS or something
>> interacts with the file system. Does anyone know of any big changes? Why
>> is the inode being marked dirty? Is there some kind of read error. I'm
>> completly lost in solving this problem.
>
> Being a filesystem guy, I always try blaming vm or drivers :)
>
> Until someone with real experience gives us the answer,
> I'll work with you off the mailing list to try to narrow
> down why this is happening.
>
> jim
