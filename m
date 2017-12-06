Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34261 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751208AbdLFQ0s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 6 Dec 2017 11:26:48 -0500
Date: Wed, 6 Dec 2017 17:24:48 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] btrfs: Greatly simplify btrfs_read_dev_super
Message-ID: <20171206162448.GD3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1512119984-12708-1-git-send-email-nborisov@suse.com>
 <1512119984-12708-6-git-send-email-nborisov@suse.com>
 <96aafd8d-a1e8-2846-0aa3-59b3ff97edb7@oracle.com>
 <f08faba1-2c79-bd80-34f5-f8f85e927464@suse.com>
 <20171204141337.GX3553@twin.jikos.cz>
 <897b7a95-1fd6-9647-f959-1d5f8f275685@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <897b7a95-1fd6-9647-f959-1d5f8f275685@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 04, 2017 at 06:20:09PM +0200, Nikolay Borisov wrote:
> >> I don't understand what problem *should* be solved here...
> > 
> > Without any further checks and validation, we cannot simply iterate over
> > all superblocks and try to mount anything that looks ok. Even if the
> > offsets exist on the block device.  The fsid should be at least checked,
> > but that's still not enough to ensure the 1st copy is what we want to
> > mount.
> 
> I'm more inclined to agree with Anand here, that if the users wants to
> mount with -t btrfs then the filesystem should assume it's correct to
> use any of the additional superblocks.

If and only if the additional superblocks are valid. And if we can't
read the primary superblock, we don't have enough information to
establish the validation.  EIO?  We don't have anything.  CRC mismatch?
Can't trust the whole data.  We need FSID and total_size at least. Other
actions are limited from inside kernel.

> Otherwise we should explicitly
> state somewhere that the superblock copies are there only for the sake
> of the user-space tools, in which case this patch can go in, albeit with
> some rewording.

Unless there's something I'm missing to address the concerns above, I'm
for (an updated version) of your patch.
