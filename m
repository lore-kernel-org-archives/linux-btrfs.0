From: "K. Richard Pixley" <rich@noir.com>
Subject: Confused by performance
Date: Mon, 24 May 2010 14:08:13 -0700
Message-ID: <4BFAEABD.2070700@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've just started to work with btrfs so I started with a benchmark.  On 
four identical servers, (2 dual core cpus, single local disk), I built 
filesystems - ext3, ext4, nilfs2, and btrfs.  I checked out a sizable 
code tree and timed a build.  The build is parallelized to use 4 threads 
when possible.

I'm seeing similar build times on ext[34] and nilfs2 but I'm seeing 
almost double the times for btrfs using default options.  And I'm having 
trouble reconciling this performance cost with the benchmarks I'm seeing 
around the net.

Is this a common result?  Is there a trick to getting ext4 competitive 
performance out of btrfs?  Is my application a poor choice for btrfs?  
Am I missing something obvious here?

--rich


