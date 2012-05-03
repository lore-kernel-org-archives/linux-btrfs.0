From: Waxhead <waxhead@online.no>
Subject: Re: Hot data Tracking
Date: Thu, 03 May 2012 15:09:25 +0200
Message-ID: <4FA28385.7040709@online.no>
References: <4F35F365.8000602@googlemail.com> <20120221232445.GJ1046@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Timo Witte <timo.witte@googlemail.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120221232445.GJ1046@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote:
> On Sat, Feb 11, 2012 at 05:49:41AM +0100, Timo Witte wrote:
>> What happened to the hot data tracking feature in btrfs? There are a lot
>> of old patches from aug 2010, but it looks like the feature has been
>> completly removed from the current version of btrfs. Is this feature
>> still on the roadmap?
> Removed? AFAIK it hasn't been ever merged, though it's be a nice
> feature. There were suggestions to turn it into a generic API for any
> filesystem to use, but this hasn't happened.
>
> The patches are quite independent and it was easy to refresh them on top
> of current for-linus branch. A test run did not survive a "random"
> xfstest, 013 this time, so I probably mismerged some bits. The patchset
> lives in branch foreign/ibm/hotdatatrack in my git repo.
>
>
> david
>
Someone recently mentioned bcache in another post who seems to cover 
this subject fairly well. However would it not make sense if btrfs 
actually was able to automatically take advantage of whatever disks is 
added to the pool? For example if you have 10 disk of different size and 
performance in a raid5/6 like configuration would it not be feasible if 
btrfs automagically (option) could manage it's own cache? For example it 
could reserve a chunk of free space as cache (based on how much data is 
free) and stripe data over all disks (cache). When the filesystem 
becomes idle or at set intervals it could empty the cache or 
move/rebalance pending writes over to the original raid5/6 like setup.
As far as I remember hot data tracking was all about moving the data 
over to the fastest disk. Why not utilize all disks and benefit from 
disks working together?

Svein Engelsgjerd

