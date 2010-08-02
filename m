From: "K. Richard Pixley" <rich@noir.com>
Subject: Re: synchronous removal?
Date: Mon, 2 Aug 2010 08:29:13 -0700
Message-ID: <9FC4BFC7-602D-4148-AA48-38F3B757E433@noir.com>
References: <4C55E2F3.3030202@noir.com> <20100802150242.GA12234@untroubled.org>
Mime-Version: 1.0 (iPhone Mail 8A306)
Content-Type: text/plain;
	charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Bruce Guenter <bruce@untroubled.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100802150242.GA12234@untroubled.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Aug 2, 2010, at 8:02, Bruce Guenter <bruce@untroubled.org> wrote:

> On Sun, Aug 01, 2010 at 02:11:15PM -0700, K. Richard Pixley wrote:
>> I notice that when I remove old snapshots and delete old directories, 
>> the free space on my disk, (according to df), doesn't rise immediately.  
> 
>> Basically, I want to check to see if there's enough space available.  If 
>> not, I want to remove some things, (including at least one snapshot), 
>> wait for the cleaner to digest, and then start over with the checking to 
>> see if there's enough space available and loop until I've removed enough 
>> things that there is enough space available.  How can I do that on a 
>> btrfs file system?
> 
> I asked a similar question a while back, and the short answer is that
> you can't, short of unmounting and remounting the filesystem.  The
> indication was made that writing a new ioctl to wait for all background
> activity wouldn't be too hard, but I don't recall seeing it in any
> recent patches.

That's interesting. Thank you. 

Would anyone like to make a bid on doing this work?  That is, is there anyone with the knowledge and code familiarity available for me to commission this work?

--rich
> 
