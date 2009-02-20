From: srimugunthan dhandapani <muggy.mit@gmail.com>
Subject: ssd optimised mode
Date: Fri, 20 Feb 2009 16:56:55 +0530
Message-ID: <934e480c0902200326m7647d87cq28bfa1675ef012f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hi all,
I would like to know what are the ssd specific optimisations in btrfs .
I read from the archives that

"mount -o ssd option, which clusters file data writes together regardless of
the directory the files belong to.  There are a number of other performance
tweaks for SSD, aimed at clustering metadata and data writes to better take
advantage of the hardware"
Also I read that there are some allocator changes specific to ssd. I
would like to know what these changes are.

I tried to see the  v 0.17 code  to understand what ssd specific changes are.
I saw that the SSD option was used in two places in function
find_free_extent and in function btrfs_defrag_leaves.
I couldn't gather much information from the code.
So can somebody help me understand the optimisations and changes in btrfs.
are any documentation or reading material available?
Thanks in advance for helping,
Mugunthan
