From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Btrfs-devel] cloning file data
Date: Mon, 5 May 2008 06:27:46 -0400
Message-ID: <200805050627.46919.chris.mason@oracle.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net> <Pine.LNX.4.64.0805022255370.15314@cobra.newdream.net> <3d0408630805030025s2c9006c1qad3c29011caf3013@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: "Sage Weil" <sage@newdream.net>, btrfs-devel@oss.oracle.com,
	linux-btrfs@vger.kernel.org
To: "Yan Zheng" <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630805030025s2c9006c1qad3c29011caf3013@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 03 May 2008, Yan Zheng wrote:
> 2008/5/3, Sage Weil <sage@newdream.net>:
> > Hi Yan-
> >
> > On Sat, 3 May 2008, Yan Zheng wrote:
> > > I think the clone ioctl won't work in some corner case. The big loop
> > > in btrfs_ioctl_clone uses path->slots[0]++ and btrfs_next_leaf to get
> > > next item in the tree. However, this approach works only when the
> > > layout of tree keeps unchangeed. In btrfs_ioctl_clone, both
> > > btrfs_insert_file_extent and dup_item_to_inode may change the layout
> > > of tree.
> > >
> > > To be safe, I think the codes should:
> > >  use btrfs_search_slot to find next item.
> > >  use a intermediate buffer when coping item between two extent buffer.

 [ ... ]

> In my previous mail, I said items of different types should be
> differentiated. Actually, there is no need to do that. Please consider
> changing the big loop in btrfs_ioctl_clone to something like:

Oh, nice catch Yan, thanks.  I've pushed out a new version to the unstable 
tree.  Sage, could you please give this a try too?

-chris
