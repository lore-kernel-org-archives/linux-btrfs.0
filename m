Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57434 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751184AbdFART1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Jun 2017 13:19:27 -0400
Date: Thu, 1 Jun 2017 19:18:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz
Subject: Re: [PATCH v2 3/9] btrfs: Check name len on add_inode_ref call path
Message-ID: <20170601171826.GI12135@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170601085716.25898-1-suy.fnst@cn.fujitsu.com>
 <20170601085716.25898-4-suy.fnst@cn.fujitsu.com>
 <08abcc0c-c17c-23e9-96e6-48c48a287a83@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <08abcc0c-c17c-23e9-96e6-48c48a287a83@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 01, 2017 at 12:53:53PM +0300, Nikolay Borisov wrote:
> > +static int ref_get_fields(struct extent_buffer *eb, int slot,
> > +			  unsigned long ref_ptr, u32 *namelen, char **name,
> > +			  u64 *index)
> >  {
> >  	struct btrfs_inode_ref *ref;
> >  
> >  	ref = (struct btrfs_inode_ref *)ref_ptr;
> >  
> >  	*namelen = btrfs_inode_ref_name_len(eb, ref);
> > +	if (!btrfs_is_namelen_valid(eb, slot, (unsigned long)(ref + 1),
> > +				    *namelen))
> > +		return -EIO;
> 
> I'd like to use this to raise a point - shouldn't btrfs actually try to
> utilize a bit more the EUCLEAN error code. Both xfs/ext4 do define their
> EFSCORRUPTED to EUCLEAN and signal that a structure is corrupted and
> needs cleaning. Presumably when we btrfs_is_namelen_valid fails (or
> other validation function) this means the data on=disk is corrupted
> rather than there was an error during I/O which -EIO implies. Currently
> btrfs uses EUCLEAN in only 3 instances in disk-io.c I'd like to solicit
> opinions from other developers what their take on that is?

We've come accross EUCLEAN in the past, eg. in this thread
https://lkml.kernel.org/r/1473870467-18721-1-git-send-email-bo.li.liu@oracle.com

Use of EUCLEAN is really sparse in btrfs and now everything is EIO,
while we could make a distinction between EIO and EUCLEAN. It "just"
needs to evaluate all callpaths if the errorcode is expected, the
semantics is defined and the behaviour is consistent with the existing
filesystems that use it.
