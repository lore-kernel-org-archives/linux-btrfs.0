From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [RFC PATCH 2/2] Btrfs: introduce free space cluster for each
 node
Date: Wed, 02 Nov 2011 10:16:31 +0800
Message-ID: <4EB0A7FF.8060602@cn.fujitsu.com>
References: <4E687A41.8080101@cn.fujitsu.com> <4EAFA21F.5010200@cn.fujitsu.com> <20111101160440.GA13340@shiny>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111101160440.GA13340@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 1 Nov 2011 12:04:40 -0400, Chris Mason wrote:
> On Tue, Nov 01, 2011 at 03:39:11PM +0800, Miao Xie wrote:
>> Any Comment?
> 
> This is definitely interesting, in terms of trying to avoid btree
> fragmentation and improve the performance of the allocator.
> 
> But I'm worried about what happens to performance as the FS fills up?
> What kind of benchmarks have you done on larger filesystems that are
> almost full?

Sorry, I have not done test in this condition.
I think you are right, on the filesystems that are almost full, the performance
will go down. My next work may fix this problem, that is:
I. the buddy system of the free space (just like the buddy system of the memory management)
II. pre-node cluster degradation on almost full filesystems (If the free space is not enough,
    use the global cluster)
    Or maybe we can use the cluster of other nodes to allocate free space instead of pre-node
    cluster degradation

Thanks
Miao Xie


> 
> -chris
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

