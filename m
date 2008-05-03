From: "Yan Zheng" <yanzheng@21cn.com>
Subject: Re: [Btrfs-devel] cloning file data
Date: Sat, 3 May 2008 12:44:08 +0800
Message-ID: <3d0408630805022144h3dd137e6k40f5c315c7b18f36@mail.gmail.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
	 <200804250941.35343.chris.mason@oracle.com>
	 <Pine.LNX.4.64.0804251119260.23551@cobra.newdream.net>
	 <Pine.LNX.4.64.0804251531510.20107@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Chris Mason" <chris.mason@oracle.com>, btrfs-devel@oss.oracle.com,
	linux-btrfs@vger.kernel.org
To: "Sage Weil" <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804251531510.20107@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Sage,

I think the clone ioctl won't work in some corner case. The big loop
in btrfs_ioctl_clone uses path->slots[0]++ and btrfs_next_leaf to get
next item in the tree. However, this approach works only when the
layout of tree keeps unchangeed. In btrfs_ioctl_clone, both
btrfs_insert_file_extent and dup_item_to_inode may change the layout
of tree.

To be safe, I think the codes should:
 use btrfs_search_slot to find next item.
 use a intermediate buffer when coping item between two extent buffer.

Regards
YZ
