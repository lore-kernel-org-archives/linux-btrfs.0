Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60798 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732639AbeHGRRS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 13:17:18 -0400
Date: Tue, 7 Aug 2018 17:02:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 4/4] btrfs: add helper btrfs_num_devices() to deduce
 num_devices
Message-ID: <20180807150227.GI3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180726065334.30594-5-anand.jain@oracle.com>
 <20180802100934.12468-1-anand.jain@oracle.com>
 <b1c8c566-5850-da69-b756-5036dca33975@suse.com>
 <20180802122136.GM3218@twin.jikos.cz>
 <f2f5a582-1bc4-617a-0d38-6c212d93bb56@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f2f5a582-1bc4-617a-0d38-6c212d93bb56@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 02, 2018 at 09:07:00PM +0800, Anand Jain wrote:
> >>> -	num_devices = fs_devices->num_devices;
> >>> -	btrfs_dev_replace_read_lock(&fs_info->dev_replace);
> >>> -	if (btrfs_dev_replace_is_ongoing(&fs_info->dev_replace)) {
> >>> -		BUG_ON(num_devices < 1);
> >>> -		num_devices--;
> >>> -	}
> >>> -	btrfs_dev_replace_read_unlock(&fs_info->dev_replace);
> >>> +	num_devices = btrfs_num_devices(fs_info);
> >>
> >> How about lifting the BUG_ON from btrfs_num_devices into a check in this
> >> function, so if num_devices < 1 then we just exit with -EINVAL or some
> >> such. We should be aiming at eliminating BUG_ONs.
> > 
> > Right, in both cases it's possible to return with an error instead of
> > the BUG_ON.
> 
> Actually we should just remove it as its a logical bug if num_devices < 
> 1, so long we didn't hit this bug which means its stable OR keep BUG_ON 
> it until we add RAID-N. ?

I think the BUG_ON is redundant, all the sanity checks at mount time or
ioctl remove/replace make sure that there are enough devices to perform
the action. Still, it can be an assert, such things do not hurt and may
be catch other errors someday.
