From: Aryeh Gregor <Simetrical+list@gmail.com>
Subject: Re: BTRFS && SSD
Date: Wed, 29 Sep 2010 15:39:07 -0400
Message-ID: <AANLkTikmq5WMqMjEdFPfaAQY_Uh3UgwjkpE3CVXffGKD@mail.gmail.com>
References: <AANLkTik9qiqtePxAhaJTyM7Q-g1nTgw9krTZFf_DaYxn@mail.gmail.com> <20100929170855.GA4635@lelouch.nomadic.ncsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Yuehai Xu <yuehaixu@gmail.com>, linux-btrfs@vger.kernel.org,
	yhxu@wayne.edu, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100929170855.GA4635@lelouch.nomadic.ncsu.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 29, 2010 at 1:08 PM, Sean Bartell <wingedtachikoma@gmail.com> wrote:
> In btrfs, this is solved by doing the same thing for the inode--a new
> place for the leaf holding the inode is chosen. Then the parent of the
> leaf must point to the new position of the leaf, so the parent is moved,
> and the parent's parent, etc. This goes all the way up to the
> superblocks, which are actually overwritten one at a time.

Sorry for the useless question, but just out of curiosity: doesn't
this mean that btrfs has to do quite a lot more writes than ext4 for
small file operations?  E.g., if you append one block to a file, like
a log file, then ext3 should have to do about three writes: data,
metadata, and journal (and the latter is always sequential, so it's
cheap).  But btrfs will need to do more, rewriting parent nodes all
the way up the line for both the data and metadata blocks.  Why
doesn't this hurt performance a lot?
