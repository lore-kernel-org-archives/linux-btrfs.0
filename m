From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH V3] btrfs: implement delayed inode items operation
Date: Fri, 11 Mar 2011 16:24:21 +0100
Message-ID: <20110311152421.GR17108@twin.jikos.cz>
References: <4D6F2FE0.8020508@cn.fujitsu.com>
 <20110308165640.GN17108@twin.jikos.cz>
 <4D7712CC.9030807@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D7712CC.9030807@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 09, 2011 at 01:40:28PM +0800, Miao Xie wrote:
> Thanks for your advice. But AFAIK, reordering the fields like what you
> said can not reduce the space of delayed_nodes, because a hole is
> placed on the end to make the structure big enough to pack tightly
> into arrays and maintain proper alignment. So although we reorder the
> fields, the size of delayed_node is still 304 bytes.

Let me redo it explicitly:

Your patch does not specify alignment of the cache object

+int __init btrfs_delayed_inode_init(void)
+{
+       delayed_node_cache = kmem_cache_create("delayed_node",
+                                       sizeof(struct btrfs_delayed_node),
+                                       0,
                                        ^^

+                                       SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+                                       NULL);
+       if (!delayed_node_cache)
+               return -ENOMEM;
+       return 0;
+}

and default BYTES_PER_WORD == sizeof(void*) will be used. Let's assume
it's 8 (eg. on x86_64). The delayed_node is 304, which is multiple of 8
and the objects will have no padding at the end. A quick test, comparing
adresses of 2 adjacent allocated objects, confirmed that.

If I did the math correctly, we are able to reduce size by 7 bytes:
reorder fileds (6b) and merge bools into one-byte bitfield (1b). This is
not enough, padding to next object alignment will consume this (as you
wrote above).

Hm, nice exercise, no improvement.

> > Still needed to reduce by 7 from 304-6=298. Does not seem to be possible, the
> > bool flags provide only 1 byte. Under these conditions, I suggest to make the
> > bool fields int again to reduce instruction count which manage these flags.
> > Compiler did not make them int automatically (altough it is free to do it).
> 
> Sorry, I don't understand what you said above clearly, Did you mean
> we can not access bool variables by one instruction?

Ah, no I confused myself, I was thinking of bitfields. Checked that gcc
emits one instruction on x86_64, I did not check other arches.

dave
