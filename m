Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:45904 "EHLO
	cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbbIBNJz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Sep 2015 09:09:55 -0400
Subject: Re: How to properly and efficiently balance RAID6 after more drives
 are added?
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <55E6CF72.5070005@netcologne.de>
 <20150902113021.GD11358@carfax.org.uk>
From: Christian Rohmann <crohmann@netcologne.de>
Message-ID: <55E6F51B.3000007@netcologne.de>
Date: Wed, 2 Sep 2015 15:09:47 +0200
MIME-Version: 1.0
In-Reply-To: <20150902113021.GD11358@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Hugo,

thanks for the quick response.

On 09/02/2015 01:30 PM, Hugo Mills wrote:
> You had some data on the first 8 drives with 6 data+2 parity, then 
> added four more. From that point on, you were adding block groups
> with 10 data+2 parity. At some point, the first 8 drives became
> full, and then new block groups have been added only to the new
> drives, using 2 data+2 parity.

Even though the old 8 drive RAID6 was not full yet? Read: There was
still some terabytes of free space.


>> Should I run btrfs balance on the filesystem? If so, what FILTERS
>> would I then use in order for the data and therefore requests to
>> be better distributed?
> 
> Yes, you should run a balance. You probably need to free up some 
> space on the first 8 drives first, to give the allocator a chance
> to use all 12 devices in a single stripe. This can also be done
> with a balance. Sadly, with the striped RAID levels (0, 10, 5, 6),
> it's generally harder to ensure that all of the data is striped as
> evenly as is possible(*). I don't think there are any filters that
> you should to use -- just balance everything. The first time
> probably won't do the job fully. A second balance probably will.
> These are going to take a very long time to run (in your case, I'd
> guess at least a week for each balance). I would recommend starting
> the balance in a tmux or screen session, and also creating a second
> shell in the same session to run monitoring processes. I typically
> use something like:
> 
> watch -n60 sudo btrfs fi show\; echo\; btrfs fi df /mountpoint\;
> echo\; btrfs bal stat /mountpoint

Yeah, that's what I usually do. The thing is that one does not get any
progress indication and estimate about how long a task will take.


> (*) Hmmm... idea for a new filter: min/max stripe width? Then you 
> could balance only the block groups that aren't at full width,
> which is probably what's needed here.

Consider my question and motivation a rather obvious use case of
running out of disk space (or iops) and simply adding some more
drives. A balance needs to be straightforward for people to understand
and perform such tasks.



Regards

Christian
