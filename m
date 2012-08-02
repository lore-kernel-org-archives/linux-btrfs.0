Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:55581 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab2HBNlG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2012 09:41:06 -0400
Received: from 89-156-116-126.rev.numericable.fr ([89.156.116.126] helo=[192.168.0.10])
	by licorne.daevel.fr with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <btrfs.list@daevel.fr>)
	id 1SwveC-0007Dw-Fy
	for linux-btrfs@vger.kernel.org; Thu, 02 Aug 2012 15:41:04 +0200
Message-ID: <501A836F.90506@daevel.fr>
Date: Thu, 02 Aug 2012 15:41:03 +0200
From: Olivier Bonvalet <btrfs.list@daevel.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:5038 (linux 3.4.7)
References: <501987FF.9080304@daevel.fr> <20120802132259.GO17430@twin.jikos.cz>
In-Reply-To: <20120802132259.GO17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/08/2012 15:22, David Sterba wrote:
> On Wed, Aug 01, 2012 at 09:48:15PM +0200, Olivier Bonvalet wrote:
>> I have some trouble with a btrfs filesystem.
>> As you can see in logs, there is lines which are from btrfs (I
>> supposed), then some warnings at fs/btrfs/extent-tree.c, and finally a
>> "kernel BUG" at fs/btrfs/extent-tree.c:5038.
>
> Did you really see this BUG ? It comes from some unused and disabled code:
>
> 5036 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
> 5037         if (item_size<  sizeof(*ei)) {
> 5038                 BUG_ON(found_extent || extent_slot != path->slots[0]);
> ^^^^
>
> 5039                 ret = convert_extent_item_v0(trans, extent_root, path,
> 5040                                              owner_objectid, 0);
> 5041                 if (ret<  0)
> 5042                         goto abort;
> 5043
> 5044                 btrfs_release_path(path);
> 5045                 path->leave_spinning = 1;
> 5046
> 5047                 key.objectid = bytenr;
> 5048                 key.type = BTRFS_EXTENT_ITEM_KEY;
> 5049                 key.offset = num_bytes;
> 5050
> 5051                 ret = btrfs_search_slot(trans, extent_root,&key, path,
> 5052                                         -1, 1);
> 5053                 if (ret) {
> 5054                         printk(KERN_ERR "umm, got %d back from search"
> 5055                                ", was looking for %llu\n", ret,
> 5056                                (unsigned long long)bytenr);
> 5057                         btrfs_print_leaf(extent_root, path->nodes[0]);
> 5058                 }
> 5059                 if (ret<  0)
> 5060                         goto abort;
> 5061                 extent_slot = path->slots[0];
> 5062                 leaf = path->nodes[0];
> 5063                 item_size = btrfs_item_size_nr(leaf, extent_slot);
> 5064         }
> 5065 #endif
>
>
> david
>

Yes... it's a copy from my /var/log/kern.log. Is it really "disabled" ?
