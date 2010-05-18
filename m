From: Jakob Unterwurzacher <jakobunt@gmail.com>
Subject: Re: Rename+crash behaviour of btrfs - nearly ext3!
Date: Tue, 18 May 2010 14:03:49 +0200
Message-ID: <4BF28225.2000908@gmail.com>
References: <4BF18525.8080904@gmail.com> <20100517193652.GC8635@think> <4BF1DBCD.7060208@gmail.com> <20100518003032.GK8635@think> <20100518005926.GM8635@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100518005926.GM8635@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 18/05/10 02:59, Chris Mason wrote:
>>> Ok, I upgraded to 2.6.34 final and switched to defconfig.
>>> I only did the rename test ( i.e. no overwrite ), the window is now
>>> 1.1s, both with vanilla and with the patch.
>>
>> Thanks, so much for the easy fix.  I'll take a look.
> 
> Ohhhhh, I read your initial email wrong, I'm sorry.  The test we're
> failing, the rentest, doesn't overwrite one file with another.  It is
> just creating a file and then renaming it.

Yes, the overwrite test goes perfectly fine.

> Btrfs is explicitly choosing not to sync the file in this case because
> the rename isn't replacing good old data with new unwritten data.  The
> rename is taking new unwritten data and giving it a different name.
> 
> Are there applications that rely on this? 
> 
> -chris

Well, dpkg (the Debian/Ubuntu package manager) did. Then ext4 became the
default fs in Ubuntu and massive breakage was reported [1]. Now dpkg is
fsync()ing everything and is about 2x slower than it was with ext3 [2].

Btrfs is so close to getting it "right" that i wondered whether the new
file name hitting the disk could be delayed that one second for the data
to make it to disk first.

Anyway, btrfs is still a factor 30 better than ext4 of xfs!

Thanks,
Jakob






[1] https://bugs.launchpad.net/ubuntu/+source/dpkg/+bug/512096 (notice
the massive duplicate list on the right!)

[2] https://bugs.launchpad.net/ubuntu/+source/dpkg/+bug/537241
