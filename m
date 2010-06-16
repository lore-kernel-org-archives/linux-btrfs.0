From: "K. Richard Pixley" <rich@noir.com>
Subject: Confused by performance
Date: Wed, 16 Jun 2010 11:08:48 -0700
Message-ID: <4C191330.5060905@noir.com>
References: <4BFAEABD.2070700@noir.com> <4BFF2024.3040509@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BFF2024.3040509@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

Once again I'm stumped by some performance numbers and hoping for some 
insight.

Using an 8-core server, building in parallel, I'm building some code.  
Using ext2 over a 5-way, (5 disk), lvm partition, I can build that code 
in 35 minutes.  Tests with dd on the raw disk and lvm partitions show me 
that I'm getting near linear improvement from the raw stripe, even with 
dd runs exceeding 10G, so I think that convinces me that my disks and 
controller subsystem are capable of operating in parallel and in 
concert.  hdparm -t numbers seem to support what I'm seeing from dd.

Running the same build, same parallelism, over a btrfs (defaults) 
partition on a single drive, I'm seeing very consistent build times 
around an hour, which is reasonable.  I get a little under an hour on 
ext4 single disk, again, very consistently.

However, if I build a btrfs file system across the 5 disks, my build 
times decline to around 1.5 - 2hrs, although there's about a 30min 
variation between different runs.

If I build a btrfs file system across the 5-way lvm stripe, I get even 
worse performance at around 2.5hrs per build, with about a 45min 
variation between runs.

I can't explain these last two results.  Any theories?

--rich
