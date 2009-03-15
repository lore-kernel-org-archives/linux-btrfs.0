From: Grigory Makarevich <grigorymakarevich@gmail.com>
Subject: Re: Btrfs experimental branch updates
Date: Sun, 15 Mar 2009 15:13:15 -0400
Message-ID: <49BD534B.7030303@gmail.com>
References: <1236959774.17095.3.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1236959774.17095.3.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Dear All,

I was wondering if the experimental branch is smth. different or it is 
the same
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable-standalone.git

That repository does not seem to have any branches other than head and 
master.

Thank you,
Best regards,
Grigory Makarevich

Chris Mason wrote:
> Hello everyone,
>
> I've rebased the experimental branch to include most of the
> optimizations I've been working on.
>
> The two major changes are doing all extent tree operations in delayed
> processing queues and removing many of the blocking points with btree
> locks held.
>
> In addition to smoothing out IO performance, these changes really cut
> down on the amount of stack btrfs is using, which is especially
> important for kernels with 4k stacks enabled (fedora).
>
> -chris
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

