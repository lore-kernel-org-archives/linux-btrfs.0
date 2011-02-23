From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Kernel 2.6.35 (Ubuntu 10.10): Unable to mount (orphan list)
Date: Wed, 23 Feb 2011 16:59:26 -0500
Message-ID: <1298498341-sup-488@think>
References: <5a540bbf-a331-46d3-9f38-e7c9e1398152@james>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tobias Brunner <tobias@tobru.ch>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <5a540bbf-a331-46d3-9f38-e7c9e1398152@james>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Tobias Brunner's message of 2011-02-23 16:57:23 -0500:
> Hi,
> 
> I'm using btrfs on Ubuntu 10.10 for some test partitions.
> After doing some normal operations I suddenly couldn't mount the partition anymore.
> I always get the error "BTRFS: inode 120790 still on the orphan list" in the kernel log again and again and it's impossible to stop the mount command or shutdown the system.
> Any ideas how to work around this issue?

Josef was looking at this recently but the fixes had problems for .38
and we had to push them off.

Which kernel is ubuntu on?

-chris
