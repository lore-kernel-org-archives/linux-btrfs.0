From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: [patch] btrfs: fix inode rbtree corruption
Date: Wed, 19 Aug 2009 02:56:54 +0800
Message-ID: <3d0408630908181156l16ccbc92p529f38cf622949cb@mail.gmail.com>
References: <20090818164542.GB30325@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090818164542.GB30325@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

2009/8/19 Nick Piggin <npiggin@suse.de>:
> Hi,
>
> Ran into a problem stress testing my btrfs truncate conversion attempt...
> Unfortunately it was an existing btrfs problem. Fortunately I think I
> was able to fix it.
>
> Thanks,
> Nick
>
> --
> btrfs: fix inode rbtree corruption
>
> Node may not be inserted over existing node. This causes inode tree
> corruption and I was seeing crashes in inode_tree_del which I can not
> reproduce after this patch.
>
> The other way to fix this would be to tie inode lifetime in the rbtree
> with inode while not in freeing state. I had a look at this but it is
> not so trivial at this point. At least this patch gets things working again.
>

I'm not quite understand this. rbtree allows entries having the same keys.
I guess your problem is because of some nodes get inserted into the tree
twice. But I have no idea how can it happen.

Regards
Yan, Zheng
