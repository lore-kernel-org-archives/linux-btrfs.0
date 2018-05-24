Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55897 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030394AbeEXRpd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 13:45:33 -0400
Date: Thu, 24 May 2018 19:42:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v3 1/3] btrfs: Move btrfs_check_super_valid() to avoid
 forward declaration
Message-ID: <20180524174249.GK6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180511053527.28378-1-wqu@suse.com>
 <20180511053527.28378-2-wqu@suse.com>
 <72a2ebde-6aa3-297a-dcf8-a78a7760f8d1@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <72a2ebde-6aa3-297a-dcf8-a78a7760f8d1@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 25, 2018 at 12:24:10AM +0800, Anand Jain wrote:
> On misc-next this patch is causing regression, the seed sprout 
> functionality test [1] (in the mailing list) fails.

This patch merly moves the function so it must have been broken before
that already.

> > +	if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_FSID_SIZE) != 0) {
> > +		btrfs_err(fs_info,
> > +			   "dev_item UUID does not match fsid: %pU != %pU",
> > +			   fs_info->fsid, sb->dev_item.fsid);
> > +		ret = -EINVAL;
> > +	}
> 
> 
> No. Not all devices will have the same fsid in case of seed-sprout
> mounted devices.

So we need to check if the filesystem has seeding enabled and then
compare the correct uuids, right?
