From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH V3] btrfs: implement delayed inode items operation
Date: Tue, 8 Mar 2011 17:56:40 +0100
Message-ID: <20110308165640.GN17108@twin.jikos.cz>
References: <4D6F2FE0.8020508@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D6F2FE0.8020508@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I did some testing, the speedup results match yours. I was watching kmem cache
stats of the delayed_node, seem to behave well. Increase and decrease of
number of active objects, from 3 to about ~400 (creat_unlink 50000) and went
back to initial values after a few seconds. On my setup, there are 13
delayed_node objects per page, which gives a good chance of quick allocation of
the spare objects.

Size of the delayed_node is 304 bytes, which would slack 208 bytes (hitting the
nearest kmalloc bucket of 512 bytes) per node.

So to justify the recommendation of kmem_cache use.

I was thinking about reducing size of the structure by a few bytes, to 292
bytes.  In this case it would make 14 objects per slab page. There are padding
holes after
* atomic_t count (4 bytes)
* bool inode_dirty (2 bytes)

you may want to reorder the fileds like this:
* [no change up to inode_item]
* index_cnt
* refs
* count
* the bool fields

Still needed to reduce by 7 from 304-6=298. Does not seem to be possible, the
bool flags provide only 1 byte. Under these conditions, I suggest to make the
bool fields int again to reduce instruction count which manage these flags.
Compiler did not make them int automatically (altough it is free to do it).


dave
