From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: WARNING: at fs/btrfs/inode.c:2143
 btrfs_orphan_commit_root+0x7f/0x9b
Date: Mon, 7 Feb 2011 18:39:11 +1100
Message-ID: <20110207073911.GB16034@onthe.net.au>
References: <20110204084808.GA3814@onthe.net.au>
 <1296830292.2408.0.camel@wido-desktop>
 <20110207062306.GB25062@onthe.net.au>
 <20110207063102.GD25062@onthe.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ceph-devel@vger.kernel.org
To: linux-btrfs@vger.kernel.org
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20110207063102.GD25062@onthe.net.au>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 07, 2011 at 05:31:02PM +1100, Chris Dunlop wrote:
> G'day,
> 
> Using Josef's btrfs-work bacae123 (+ ceph-client 9aae8faf), I
> can consistently reproduce the following btrfs warning by simply
> creating and starting a new btrfs-based ceph file system:
> 
> [  549.767234] ------------[ cut here ]------------
> [  549.767276] WARNING: at fs/btrfs/inode.c:2143 btrfs_orphan_commit_root+0x7f/0x9b [btrfs]()

Sorry, just found I've been booting wrong kernel. I've been
seeing the warning *without* Josef's btrfs-work.  Will re-test
tomorrow.
