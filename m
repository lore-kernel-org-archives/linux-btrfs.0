Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-11v.sys.comcast.net ([69.252.207.43]:46426 "EHLO
	resqmta-ch2-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932916AbaLDSHc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Dec 2014 13:07:32 -0500
Message-ID: <5480A2E2.8060506@pobox.com>
Date: Thu, 04 Dec 2014 10:07:30 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs df not really doing df?
References: <CAH-HCWWUF-D9DoJCpa8ZWuJ1fVPuBp0qUs+dmCZrp6tx=5jDuA@mail.gmail.com>
In-Reply-To: <CAH-HCWWUF-D9DoJCpa8ZWuJ1fVPuBp0qUs+dmCZrp6tx=5jDuA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/04/2014 05:51 AM, Shriramana Sharma wrote:
> IIUC df means "disk free" and is supposed to display the disk's (or
> partition's) free space -- but while btrfs fi df displays the
> allocated and used sizes, it doesn't actually display the total
> capacity of the devices, and subtract the allocated size and display
> the rest.

You are correct.

> One should not need to run the additional (regular) df command to find
> out that info, IMO.

See Below.


> Anyone have any objection to my submitting a bug requesting this
> additional info to be printed?

This is a recurring argument and/or "bug". It does not need a new report.

Things are not as cut-and-dried as they appear.

The classic df ("disk free") and du ("disk usage") commands go back to a 
time when things were simple and every atomic item on the disk used up a 
discrete and predictable amount of space on the disk

df classically tells you an array of information, and generally does it 
by subtraction. That is, it finds total size and amount used and 
computes the free space based on those two numbers.

But in a filesystem like BTRFS, what is "free space" really. If the 
chunk allocator has allocated 1GB of data space and put 1KB of file in 
there, there is room for 1G-1K of data, but there may be no space left 
for any metadata if that 1G data allocation was the very last 1G 
"available" on the disk.

And lets not even start in on compression and snapshots as complicating 
factors.

So the regular df on the system has it's role of giving you aproximate 
disk blocks (though I honestly don't know whether they include or 
exclude the 1G-1K blocks "free" in the allocated data extent or not). 
And if that very simplified view is what you want, then thats the tool 
you should use.

btrfs filesystem df tells you all the other information in a way that 
you can actually evaluate the state of your filesystem. And, indeed, you 
do need to use _both_ tools to fully understand what your storage system 
is up to. But "btrfs fi df" is not, and wasn't intended to be, a drop-in 
replacement for good old /bin/df. When you need /bin/df answers you use 
the /bin/df tool. When you need more information you use various other 
programs like /sbin/btrfs and its various show/df/whatever subcommands.

So why is it called "btrfs fi df" instead of "btrfs fi du"? Well because 
/bin/du is in a _completely_ _different_ problem space.

I suspect (I was not here when the decision was made) that the name "df" 
was chosen for the sub-command's sub-command because nothing better 
occurred to anybody and the information from "btrfs fi df" completes the 
view of the filesystem that /bin/df starts. That is, it's in the same 
domain of information (as opposed to du etc.)

Keep in mind as well that if you want to be _picky_ about the name, 
since the filesystem can span media, the command name shouldn't even hae 
a "d" in it. It doesn't measure "disk", full, used, or whatever.

And even "df" is wrong to use d since it tells you about partitions and 
psudo-filesystems (such as tmpfs and the various cgroup things).

In more limited times there were simple answers.  8-)

So no, it's not a bug, its just the best of the not particularly good 
options that gives the least-incorrect idea for what the subcommand was 
designed to tell you.

