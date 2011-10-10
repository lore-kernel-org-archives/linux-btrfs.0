From: David Sterba <dave@jikos.cz>
Subject: Re: Corrupt file in subvolume
Date: Mon, 10 Oct 2011 13:29:17 +0200
Message-ID: <20111010112917.GG17912@twin.jikos.cz>
References: <loom.20111010T040355-185@post.gmane.org> <20111010103723.GE17912@twin.jikos.cz> <loom.20111010T124733-121@post.gmane.org>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: dima <dolenin@parallels.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20111010T124733-121@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 10, 2011 at 11:03:34AM +0000, dima wrote:
> The last shutdown was clean, but I had to powercycle several times this month.
> I am also mounting a swapfile via loop device, so maybe this also adds up to
> instability.
> 
> The corrupt file is a firefox source file
> (mozilla-central/js/src/tests/e4x/XML/13.4.4.40.js). Interesting thing that I
> did not touch this file or rebuild firefox for about 3-4 days, so I do not have
> any idea why it got corrupted suddenly.
> 
> When trying to remove the directory containing this file I am getting:
> 
> Oct 10 14:03:13 yukikaze kernel: [ 9836.993172] ------------[ cut here
> ]------------                                           
> Oct 10 14:03:13 yukikaze kernel: [ 9836.993261] kernel BUG at
> fs/btrfs/inode.c:3024!                                           

fixed by:

commit b532402e4d147e4f409c4e7f50d4413e8450101d
Author: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date:   Tue Jul 19 07:27:20 2011 +0000

    Btrfs: return error to caller when btrfs_unlink() failes

    When btrfs_unlink_inode() and btrfs_orphan_add() in btrfs_unlink()
    are error, the error code is returned to the caller instead of
    BUG_ON().


david
