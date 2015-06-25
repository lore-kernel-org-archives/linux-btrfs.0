Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbbFYRVj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 13:21:39 -0400
Date: Thu, 25 Jun 2015 19:21:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: NULL pointer dereference during snapshot removal
Message-ID: <20150625172137.GO726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434811494@msgid.manchmal.in-ulm.de>
 <20150623031036.GB14577@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150623031036.GB14577@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2015 at 11:10:37AM +0800, Liu Bo wrote:
> On Sat, Jun 20, 2015 at 04:53:24PM +0200, Christoph Biedl wrote:
> > Hi there,
> > 
> > I'm having trouble with btrfs where removing a snapshot causes a
> > kernel Oops at blk_get_backing_dev_info+0x10/0x1c (plus or minus a
> > byte bytes). Is this a known issue? Else I'll dig further. Stack
> > traces below.
> 
> Can you use gdb to locate the line of blk_get_backing_dev_info+0x10/0x1c?

The helper is trivial:

 89 struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev)
 90 {
 91         struct request_queue *q = bdev_get_queue(bdev);
 92 
 93         return &q->backing_dev_info;
 94 }

There are 2 dereferences:

Dump of assembler code for function blk_get_backing_dev_info:
   0xc12aa3c0 <+0>:     push   %ebp
   0xc12aa3c1 <+1>:     mov    %esp,%ebp
   0xc12aa3c3 <+3>:     call   0xc15cbd90 <mcount>

first deref is ok

   0xc12aa3c8 <+8>:     mov    0x5c(%eax),%eax
   0xc12aa3cb <+11>:    pop    %ebp
   0xc12aa3cc <+12>:    mov    0x210(%eax),%eax

this one crashes

   0xc12aa3d2 <+18>:    add    $0xe8,%eax
   0xc12aa3d7 <+23>:    ret


863 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
864 {
865         return bdev->bd_disk->queue;    /* this is never NULL */
866 }

so bdev or bdev->bd_disk might be NULL, but according to the offsets it seems to
be 'bdev->bd_disk'. Strangely, pahole (the structure dumper) does not work here
on the 32bit vmlinux so I can't check excactly, but in the 64bit build the offset
of bd_disk is 152, if we subtract padding and 4B per pointer, this looks plausible.

Anyawy, this is below btrfs layer.
