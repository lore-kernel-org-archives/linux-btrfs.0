From: jim owens <jowens@hp.com>
Subject: Re: [PATCH] Backport for 2.6.27 and 2.6.26 on the experimental	branch
Date: Tue, 24 Feb 2009 11:24:06 -0500
Message-ID: <49A41F26.2020202@hp.com>
References: <20090220174518.GA23955@tux64-01> <499EF58F.6020807@hp.com> <20090223222304.GB13878@tux64-01>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090223222304.GB13878@tux64-01>
List-ID: <linux-btrfs.vger.kernel.org>

Lee Trager wrote:
> The more and more I look at this problem the more I tend to think that
> the issue is because of some change in the way the VFS or something
> interacts with the file system. Does anyone know of any big changes? Why
> is the inode being marked dirty? Is there some kind of read error. I'm
> completly lost in solving this problem.

Being a filesystem guy, I always try blaming vm or drivers :)

Until someone with real experience gives us the answer,
I'll work with you off the mailing list to try to narrow
down why this is happening.

jim
