From: Tobias Brunner <tobias@tobru.ch>
Subject: Re: Kernel 2.6.35 (Ubuntu 10.10): Unable to mount (orphan list)
Date: Thu, 24 Feb 2011 08:46:10 +0100 (CET)
Message-ID: <f6a6a92b-cd3a-4c49-b5c5-a8232d30df30@james>
References: <ef9c402b-8b3a-4202-accf-73eef08f38c4@lasmiranda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ef9c402b-8b3a-4202-accf-73eef08f38c4@lasmiranda>
List-ID: <linux-btrfs.vger.kernel.org>

>>> Hi,
>>> 
>>> I'm using btrfs on Ubuntu 10.10 for some test partitions.
>>> After doing some normal operations I suddenly couldn't mount the partition anymore.
>>> I always get the error "BTRFS: inode 120790 still on the orphan list" in the kernel log again and again and it's impossible to stop >the mount command or shutdown the system.
>>> Any ideas how to work around this issue?
>>
>>Josef was looking at this recently but the fixes had problems for .38
>>and we had to push them off.
>>
>>Which kernel is ubuntu on?
>>
>>-chris
>
>I tried the official maverick kernel (2.6.35.25.32) and the ppa kernel 2.6.38-rc6.
>
>-tobru

Are you speaking of this patch? https://patchwork.kernel.org/patch/530421/

I'd like to help troubleshooting this issue. Any hint how I can help?
Can I manually correct this orphan list? It would be very nice if I can mount this partition again and not lose it's data.
BTW: It's always the same inode number...

Tobias
