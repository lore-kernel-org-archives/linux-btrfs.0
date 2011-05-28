From: David Sterba <dave@jikos.cz>
Subject: Re: Problem with latest for-linus branch
Date: Sun, 29 May 2011 00:40:51 +0200
Message-ID: <20110528224051.GY12709@twin.jikos.cz>
References: <BANLkTikmYx+K9crXYFeBmsJm+qUq9_W+gQ@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, lizf@cn.fujitsu.com
To: Andrea Gelmini <andrea.gelmini@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikmYx+K9crXYFeBmsJm+qUq9_W+gQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Sat, May 28, 2011 at 07:05:47PM +0200, Andrea Gelmini wrote:
>    Everything works good with stock Ubuntu 11.04 kernel (2.6.38),
> vanilla 2.6.38 and vanilla 2.6.39.
>    If I use Linus' git tree, BTRFS ooops at mount.

can you please attach the oops traces?

>    So I bisected using kernel version 2.6.39 + latest for-linus branch.
>    Bisect complains about this commit:
> 581bb050941b4f220f84d3e5ed6dace3d42dd382 is the first bad commit
> commit 581bb050941b4f220f84d3e5ed6dace3d42dd382
> Author: Li Zefan <lizf@cn.fujitsu.com>
> Date:   Wed Apr 20 10:06:11 2011 +0800
> 
>     Btrfs: Cache free inode numbers in memory

this patch was part of the new ino allocator and it may depend
on subsequent patches (eg. 33345d015 "Btrfs: Always use
64bit inode number"). In this case it could be a 32/64 bit mismatch in
inode numbers and blame would point to a incomplete state wrt the
filesystem.

You've created your FS from ext4, I think that the filesystem has
64bit inode numbers, allocated to files and this got broken during the
conversion. (just a wild idea)

>   I can see two kind of problems, with different commit, of course.
>   Sometimes the Ooops happens just as kernel mounts the partition,
> sometimes the mount is good, but HD keeps reading for more than 30
> seconds, and the it Ooops.

This would mean something's broken during transaction commit.

>   Also, you can read but you can't write, meanwhile.
> 
> In attachment my config.

No attachment, but not needed IMHO.

> I have photos of the Ooops, but right now I can't take 'em from the phone...

Would really help if you can :)


david
