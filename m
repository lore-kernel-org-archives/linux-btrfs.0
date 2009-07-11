From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH]Btrfs:Fix discard semantic
Date: Sat, 11 Jul 2009 11:29:14 +0100
Message-ID: <1247308154.3882.36.camel@macbook.infradead.org>
References: <2c3b11250812290723t74c1f505jb0ffc8c66ebe1ead@mail.gmail.com>
	 <3d0408630901010457p5440f053tbf4fe86b2697c9cc@mail.gmail.com>
	 <2c3b11250901030733y9cf8994w984a4c110f42f4d0@mail.gmail.com>
	 <1247180277.7423.1.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Yan Zheng <yanzheng@21cn.com>, linux-btrfs@vger.kernel.org
To: Liu Hui <onlyflyer@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1247180277.7423.1.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-07-09 at 23:57 +0100, David Woodhouse wrote:
> On Sat, 2009-01-03 at 23:33 +0800, Liu Hui wrote:
> > +       /* Tell the block device(s) that the sectors can be discarded */
> > +       ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
> > +                             bytenr, &map_length, &multi, 0);
> 
> Shouldn't that READ be a WRITE, if we want to discard every stripe of a
> RAID1 rather than only one of them?

Actually it's more broken than that -- it will only discard the first
stripe_len of the extent. For any kind of RAID, including RAID0, we need
to loop over the btrfs_map_block() call.

I'll fix that too...

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

