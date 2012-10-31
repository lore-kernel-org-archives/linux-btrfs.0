Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935543Ab2JaNXL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 09:23:11 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Steve French <sfrench@samba.org>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>, Matthew Wilcox <matthew@wil.cx>,
        linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, ocfs2-devel@oss.oracle.com
Subject: Re: [patch 05/10] vfs: pass data to alloc_inode super operation
References: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
	<1351628084-29358-8-git-send-email-jmoyer@redhat.com>
	<20121030205142.GB2616@ZenIV.linux.org.uk>
	<20121030211701.GC2616@ZenIV.linux.org.uk>
Date: Wed, 31 Oct 2012 09:22:51 -0400
In-Reply-To: <20121030211701.GC2616@ZenIV.linux.org.uk> (Al Viro's message of
	"Tue, 30 Oct 2012 21:17:01 +0000")
Message-ID: <x49liemixn8.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Tue, Oct 30, 2012 at 08:51:42PM +0000, Al Viro wrote:
>> On Tue, Oct 30, 2012 at 04:14:39PM -0400, Jeff Moyer wrote:
>> > This patch passes a data pointer along to the alloc_inode
>> > super_operations function.  The value will initially be used by
>> > bdev_alloc_inode to allocate the bdev_inode on the same numa
>> > node as the device to which it is tied.
>> 
>> Yecchhh...
>> 
>> > -static struct inode *bdev_alloc_inode(struct super_block *sb)
>> > +static struct inode *bdev_alloc_inode(struct super_block *sb, void *data)
>> >  {
>> > -	struct bdev_inode *ei = kmem_cache_alloc(bdev_cachep, GFP_KERNEL);
>> > +	struct bdev_inode *ei;
>> > +	int partno;
>> > +	int node;
>> > +
>> > +	if (data) {
>> > +		struct gendisk *disk;
>> > +		dev_t dev = *(dev_t *)data;
>> > +		disk = get_gendisk(dev, &partno);
>> > +		node = disk->node_id;
>
> Oh, _lovely_.  Such a stunningly elegant idea.  And why not pass the
> sodding node_id directly, if I may ask?

struct block_device *bdget(dev_t dev)
{
...
        inode = iget5_locked(blockdev_superblock, hash(dev),
                        bdev_test, bdev_set, &dev);

The device is used by bdev_test and bdev_set.

> Take that crap out and don't bring it back.  And consider this kludge NAKed
> once and forever.  It's unspeakably ugly, even if it didn't break just about
> every fs out there (you do realize that almost all of them have ->alloc_inode(),
> pdon't you?  Use grep and see).

Oof.  I was using cscope and it didn't show all callers.

> BTW, speaking of other reasons this is FUBAR - mknod a block device node
> for something that doesn't exist and try to open it.  struct block_device
> lifetime is not limited to that of struct gendisk; it can be allocated
> before gendisk is there.  Moreover, with static /dev and demand-loaded
> modules this will be the normal scenario.
>
> IOW, this is completely misguided.

OK, thanks for the review, Al, it's greatly appreciated.  Do you have a
suggestion on how I might achieve this in a way that would be
acceptable?  I'm not too fond of the idea of reallocating the inode when
the device does appear.  I'll give it some more thought.

Again, thanks for taking a look.

Cheers,
Jeff
