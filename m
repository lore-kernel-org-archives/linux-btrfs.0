Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab2GITFx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Jul 2012 15:05:53 -0400
Date: Mon, 9 Jul 2012 12:05:52 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/3] btrfs: extended inode refs
Message-ID: <20120709190551.GB8323@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1337636781-12575-1-git-send-email-mfasheh@suse.de> <1337636781-12575-2-git-send-email-mfasheh@suse.de> <4FF6FCA8.2060100@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FF6FCA8.2060100@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 06, 2012 at 04:56:40PM +0200, Jan Schmidt wrote:
> Hi Mark,
> 
> Sorry, I'm a bit late with my feedback.

No problem, thank you for taking the time to read these patches! Reply to
your most substantial comment is below. Everything else you pointed out I'll
have fixed up for an updated patch (don't think I need to reply individually
to those).


> On Mon, May 21, 2012 at 23:46 (+0200), Mark Fasheh wrote:

> > @@ -189,6 +435,19 @@ int btrfs_insert_inode_ref(struct btrfs_trans_handle *trans,
> >  
> >  out:
> >  	btrfs_free_path(path);
> > +
> > +	if (ret == -EMLINK) {
> > +		struct btrfs_super_block *disk_super = root->fs_info->super_copy;
> > +		/* We ran out of space in the ref array. Need to
> > +		 * add an extended ref. */
> > +		if (btrfs_super_incompat_flags(disk_super)
> > +		    & BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
> 
> Uhm. Good place to check here. But please help me to find the place where this
> is added to the super block's flags in the first place.

mkfs.btrfs  :)

The kernel should never be adding the flag as things are currently designed.

Thanks again!
	--Mark

--
Mark Fasheh
