Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab3CGOw4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Mar 2013 09:52:56 -0500
Date: Thu, 7 Mar 2013 15:52:54 +0100
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@redhat.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        chris.mason@fusionio.com
Subject: Re: [PATCH] btrfs: enhance superblock checks
Message-ID: <20130307145253.GO21081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1362585400-13379-1-git-send-email-dsterba@suse.cz>
 <20130306185637.GE27710@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130306185637.GE27710@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 06, 2013 at 10:56:37AM -0800, Zach Brown wrote:
> > +static int btrfs_check_super_csum(char *raw_disk_sb)
> 
> I'd have it return 0 or -errno and print warnings with additional info
> so that each caller doesn't have to.

What errno values do you suggest? For me it's 'checksum is correct:
yes/no', hence return 1/0.

I see an -EIO below, but that does not seem right here. There's a call
to btrfs_read_dev_super that would indicate an unreadable block. We
could use EFSCORRUPTED as xfs does (with value of EUCLEAN = 117) though.

As implemented now, EINVAL will make 'mount' print the instructive
message "look into the syslog", I'm not sure if we wouldn't need to
update userspace to reflect the fine grained error codes.

Ad message printk: it's a simple helper, potentially usable in other
places, I think it's better to let the caller decide whether to print
anything or not.

> > +{
> > +	struct btrfs_super_block *disk_sb =
> > +		(struct btrfs_super_block *)raw_disk_sb;
> > +	u16 csum_type = btrfs_super_csum_type(disk_sb);
> 
> > +	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
> > +		printk(KERN_ERR "btrfs: unsupported checksum algorithm %u\n",
> > +				csum_type);
> > +		return 1;
> > +	}
> 
> Does this mean we can get rid of that BUG_ON in btrfs_super_csum_size()?

Yes.

> And you can move this check down in an else after the CRC32 test to get
> rid of the extra exit path.  Have each case ret = , the end of the
> function returns ret.
> 
> > +	if (csum_type == BTRFS_CSUM_TYPE_CRC32) {
> > [...]
> > +	}
> > +
> > +	return 1;
> 
> 	int ret = 0
> 
> 	if (csum_type == BTRFS_CSUM_TYPE_CRC32) {
> 		[..]
> 		if (memcmp())
> 			ret = -EIO; /* or whatever */
> 	} else if (type > array_size() {
> 		printk("I'm sad.");
> 		ret = -EBOOHOO;
> 	}
> 
> 	return ret;

Ok, looks better structured.

david
