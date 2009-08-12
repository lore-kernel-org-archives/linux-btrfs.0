From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Project idea regarding transparency for distributed systems to
 be incorporated in the btrfs design
Date: Wed, 12 Aug 2009 14:53:25 -0400
Message-ID: <20090812185325.GB4652@think>
References: <ce8c6160908082359u5dd1df12gee1e3066aae6d3db@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "sparx, India" <sparx.mailing.list@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ce8c6160908082359u5dd1df12gee1e3066aae6d3db@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 09, 2009 at 12:29:23PM +0530, sparx, India wrote:
> Hi,
> We are a group of four undergraduate students studying in final year
> completing our computer engineering course from the University of
> Pune, India.
> 
> We would like to do an operating system related project over a period
> of 6 months.
> We have studied and understood the design of Btrfs.
> 
> We came across this paper presented in Fast '07 on transparent file
> systems in distributed networks. (TFS)
> The paper basically suggests some design changes in a regular file
> system so as to support (and minimize) the efforts of contributory
> applications for storage resources in a distributed system. This would
> enable greater resource contribution without affecting local
> performance ( Storage contribution can increase upto 40% in corporate
> networks)
> 
> To support transparent memory allocation to a shared pool efficiently
> a file sytem should:
> 1.Allocate most blocks in a given region
> 2.View storage media as a series of chunks
> 3.Some replicative power of its own.
> However the TFS design does not interfere with a file systems own
> allocation policy.
> 
>  We could not find any article/information which specifically mentions
> that Btrfs handles memory allocation in distributed systems
> transparently.
> 
> We would like to ask your suggestions on the following points:
> 
> 1. Are we correct in our assumption that Btrfs does not handle
> transparent allocation as yet or have we missed something?

I'm not sure I fully understand the concept of transparent allocation.
Could you please describet his in more detail?

> 2. Would the Btrfs community appreciate this contribution   to the
> file system?(i.e. do you think it is worth our investing our time and
> effort in this and that it contributes positively to btrfs?)

We're always interested in btrfs contributions ;)  Thanks for taking the
time to read about the FS and propose this.

-chris
