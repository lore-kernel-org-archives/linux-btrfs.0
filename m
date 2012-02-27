From: David Sterba <dave@jikos.cz>
Subject: Re: SELinux inode size gotcha in btrfs.
Date: Tue, 28 Feb 2012 00:17:49 +0100
Message-ID: <20120227231749.GR1046@twin.jikos.cz>
References: <loom.20120227T210703-631@post.gmane.org>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Alex <alex@bpmit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20120227T210703-631@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 27, 2012 at 10:18:55PM +0000, Alex wrote:
> From my reading of the btrfs specs [2] it doesn't look like you'll get caught
> with that as the inodes "will not contain embedded file data or extended
> attribute data. These things are stored in other item types."
>
> Have I read that right? I've seen xattr bugs patches etc but nothing that would
> hit the SE Linux domain.

That's right. Inode represented as btrfs_inode_item does not contain any
xattr fields, they're stored independently as a btrfs_dir_item of type
BTRFS_FT_XATTR . Due to the way the b-tree keys are built, the xattr
item key should be stored near the inode item key, that's for the tree
search side. The xattr data are always stored inline in the b-tree leaf.


david
