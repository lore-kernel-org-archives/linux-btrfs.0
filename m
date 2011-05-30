From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Problem with latest for-linus branch
Date: Mon, 30 May 2011 10:49:38 +0800
Message-ID: <4DE305C2.1050301@cn.fujitsu.com>
References: <BANLkTikmYx+K9crXYFeBmsJm+qUq9_W+gQ@mail.gmail.com> <20110528224051.GY12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: andrea.gelmini@gmail.com,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110528224051.GY12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote:
> Hi,
> 
> On Sat, May 28, 2011 at 07:05:47PM +0200, Andrea Gelmini wrote:
>>    Everything works good with stock Ubuntu 11.04 kernel (2.6.38),
>> vanilla 2.6.38 and vanilla 2.6.39.
>>    If I use Linus' git tree, BTRFS ooops at mount.
> 
> can you please attach the oops traces?
> 
>>    So I bisected using kernel version 2.6.39 + latest for-linus branch.
>>    Bisect complains about this commit:
>> 581bb050941b4f220f84d3e5ed6dace3d42dd382 is the first bad commit
>> commit 581bb050941b4f220f84d3e5ed6dace3d42dd382
>> Author: Li Zefan <lizf@cn.fujitsu.com>
>> Date:   Wed Apr 20 10:06:11 2011 +0800
>>
>>     Btrfs: Cache free inode numbers in memory
> 
> this patch was part of the new ino allocator and it may depend
> on subsequent patches (eg. 33345d015 "Btrfs: Always use
> 64bit inode number"). In this case it could be a 32/64 bit mismatch in
> inode numbers and blame would point to a incomplete state wrt the
> filesystem.
> 

the bug probably not caused by this.

> You've created your FS from ext4, I think that the filesystem has
> 64bit inode numbers, allocated to files and this got broken during the
> conversion. (just a wild idea)
> 
>>   I can see two kind of problems, with different commit, of course.
>>   Sometimes the Ooops happens just as kernel mounts the partition,

just mount the partition, and then no other fs operations? if so, the
patch you bisected down actually won't take effect.

>> sometimes the mount is good, but HD keeps reading for more than 30
>> seconds, and the it Ooops.
> 
> This would mean something's broken during transaction commit.
> 
>>   Also, you can read but you can't write, meanwhile.
>>
>> In attachment my config.
> 
> No attachment, but not needed IMHO.
> 
>> I have photos of the Ooops, but right now I can't take 'em from the phone...
> 
> Would really help if you can :)
> 

right.

and thanks for the bug report!

btw, I'll be off till 6.5, so this week I probably won't be able to take
care of this..
