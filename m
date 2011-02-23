From: Tobias Brunner <tobias@tobru.ch>
Subject: Re: Kernel 2.6.35 (Ubuntu 10.10): Unable to mount (orphan list)
Date: Wed, 23 Feb 2011 23:03:09 +0100 (CET)
Message-ID: <ef9c402b-8b3a-4202-accf-73eef08f38c4@lasmiranda>
References: <1298498341-sup-488@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1298498341-sup-488@think>
List-ID: <linux-btrfs.vger.kernel.org>


>> Hi,
>> 
>> I'm using btrfs on Ubuntu 10.10 for some test partitions.
>> After doing some normal operations I suddenly couldn't mount the partition anymore.
>> I always get the error "BTRFS: inode 120790 still on the orphan list" in the kernel log again and again and it's impossible to stop >the mount command or shutdown the system.
>> Any ideas how to work around this issue?
>
>Josef was looking at this recently but the fixes had problems for .38
>and we had to push them off.
>
>Which kernel is ubuntu on?
>
>-chris

I tried the official maverick kernel (2.6.35.25.32) and the ppa kernel 2.6.38-rc6.

-tobru
