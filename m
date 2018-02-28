Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36303 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934268AbeB1Rwc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 12:52:32 -0500
Date: Wed, 28 Feb 2018 18:50:13 +0100
From: David Sterba <dsterba@suse.cz>
To: peteryuchuang@gmail.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [Bug report] BTRFS partition re-mounted as read-only after few
 minutes of use
Message-ID: <20180228175013.GG27791@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1519836220.1693.23.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1519836220.1693.23.camel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 28, 2018 at 05:43:40PM +0100, peteryuchuang@gmail.com wrote:
> On my laptop, which has just been switched to BTRFS, the root partition
> (a BTRFS partition inside an encrypted LVM. The drive is an NVMe) is
> re-mounted as read-only few minutes after boot. 
> 
> Trace:

By any chance, are there other messages from btrfs above the line?
> 
> [  199.974591] ------------[ cut here ]------------
> [  199.974593] BTRFS: Transaction aborted (error -95)

-95 is EOPNOTSUPP, ie operation not supported

> [  199.974647] WARNING: CPU: 0 PID: 324 at fs/btrfs/inode.c:3042 btrfs_finish_ordered_io+0x7ab/0x850 [btrfs]

btrfs_finish_ordered_io::

 3038         btrfs_ordered_update_i_size(inode, 0, ordered_extent);
 3039         ret = btrfs_update_inode_fallback(trans, root, inode);
 3040         if (ret) {
 3041                 btrfs_abort_transaction(trans, ret);
 3042                 goto out;
 3043         }

the return code is unexpected here. And seeing 'operation not supported'
after a inode size change looks strange but EOPNOTSUPP could be returned
from some places.

The transaction is aborted from a thread that finalizes some processing
so we don't have enough information here to see how it started. I
suspect there's a file that gets modified short after boot and hits the
problem. I don't think the EOPNOTSUPP is returned from the lower layers
(lvm encryption or nvme), so at this point seems like a btrfs bug.
