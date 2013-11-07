Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab3KGQFf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 11:05:35 -0500
Date: Thu, 7 Nov 2013 17:05:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 02/17] btrfs: Added btrfs_workqueue_struct implemented
 ordered execution based on kernel workqueue
Message-ID: <20131107160529.GI16662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1383803527-23736-3-git-send-email-quwenruo@cn.fujitsu.com>
 <527B5E6C.9000506@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <527B5E6C.9000506@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 07, 2013 at 10:33:32AM +0100, Stefan Behrens wrote:
> > +struct btrfs_work_struct {
> > +	void (*func)(struct btrfs_work_struct *arg);
> > +	void (*ordered_func)(struct btrfs_work_struct *arg);
> > +	void (*ordered_free)(struct btrfs_work_struct *arg);
> > +
> > +	/* Don't touch things below */
> > +	struct work_struct normal_work;
> > +	struct work_struct ordered_work;
> > +	struct completion normal_completion;
> > +};
> 
> If you compare the Btrfs sources before applying your patchset and after
> applying all 17 patches, one change is this:
> -struct btrfs_work {
> +struct btrfs_work_struct {
> 
> Which causes changes s/struct btrfs_work/struct btrfs_work_struct/ like
> in patch 16/17:
> -	struct btrfs_work	work;
> +	struct btrfs_work_struct
> +				work;
> 
> -static void scrub_bio_end_io_worker(struct btrfs_work *work);
> +static void scrub_bio_end_io_worker(struct btrfs_work_struct *work);
> 
> I just don't see any good reason for renaming 'struct foo' to 'struct
> foo_struct'.

It seems to be meaningfull only though out this patchset. The old
contents of btrfs_work is different from btrfs_work_struct, I agree it's
right to have the name without _struct suffix. But then the change to
new worker structs would have to be done in one single patch, while
there are 10+ patches converting each worker type.

I suggest to add one more patch to the end that removes the _struct
suffix again, so the series does not have to be redone.

david
