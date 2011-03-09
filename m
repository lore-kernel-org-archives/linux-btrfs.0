From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH V3] btrfs: implement delayed inode items operation
Date: Wed, 09 Mar 2011 13:40:28 +0800
Message-ID: <4D7712CC.9030807@cn.fujitsu.com>
References: <4D6F2FE0.8020508@cn.fujitsu.com> <20110308165640.GN17108@twin.jikos.cz>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110308165640.GN17108@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On tue, 8 Mar 2011 17:56:40 +0100, David Sterba wrote:
> Hi,
> 
> I did some testing, the speedup results match yours. I was watching kmem cache
> stats of the delayed_node, seem to behave well. Increase and decrease of
> number of active objects, from 3 to about ~400 (creat_unlink 50000) and went
> back to initial values after a few seconds. On my setup, there are 13
> delayed_node objects per page, which gives a good chance of quick allocation of
> the spare objects.
> 
> Size of the delayed_node is 304 bytes, which would slack 208 bytes (hitting the
> nearest kmalloc bucket of 512 bytes) per node.
> 
> So to justify the recommendation of kmem_cache use.
> 
> I was thinking about reducing size of the structure by a few bytes, to 292
> bytes.  In this case it would make 14 objects per slab page. There are padding
> holes after
> * atomic_t count (4 bytes)
> * bool inode_dirty (2 bytes)
> 
> you may want to reorder the fileds like this:
> * [no change up to inode_item]
> * index_cnt
> * refs
> * count
> * the bool fields

Thanks for your advice. But AFAIK, reordering the fields like what you said can not
reduce the space of delayed_nodes, because a hole is placed on the end to make the
structure big enough to pack tightly into arrays and maintain proper alignment. So
although we reorder the fields, the size of delayed_node is still 304 bytes.

> Still needed to reduce by 7 from 304-6=298. Does not seem to be possible, the
> bool flags provide only 1 byte. Under these conditions, I suggest to make the
> bool fields int again to reduce instruction count which manage these flags.
> Compiler did not make them int automatically (altough it is free to do it).

Sorry, I don't understand what you said above clearly, Did you mean
we can not access bool variables by one instruction?

Thanks
Miao

> 
> dave
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

