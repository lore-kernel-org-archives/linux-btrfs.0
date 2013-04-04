Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:34690 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763432Ab3DDUFw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Apr 2013 16:05:52 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 0D48A9A040D
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2013 14:05:52 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>, Zach Brown <zab@redhat.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <515DD858.4000102@redhat.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Jan Safranek <jsafrane@redhat.com>
References: <515D9DDE.5040306@redhat.com> <515DAB1F.2050308@redhat.com>
 <20130404184632.GA23636@lenny.home.zabbo.net> <515DD858.4000102@redhat.com>
Message-ID: <20130404200549.27335.7058@localhost.localdomain>
Subject: Re: [PATCH V2] btrfs: close any open devices if btrfs_mount fails
Date: Thu, 4 Apr 2013 16:05:49 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Eric Sandeen (2013-04-04 15:45:28)
> On 4/4/13 1:46 PM, Zach Brown wrote:
> >> It's because btrfs_open_devices() may open some devices, and still
> >> return failure.  So the error unwinding needs to close any open
> >> devices in fs_devices before returning.
> > 
> > Yeah, looks like.
> > 
> >> Note, __btrfs_open_devices is weird; it seems to return success or
> >> failure based on the outcome of the result of the last call
> >> to btrfs_get_bdev_and_sb().  But that's a different bug...
> > 
> > I disagree that this is a different bug, I think it's the root cause of
> > this bug.
> > 
> >> @@ -1125,7 +1125,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
> >>  
> >>      error = btrfs_open_devices(fs_devices, mode, fs_type);
> >>      if (error)
> >> -            goto error_fs_info;
> >> +            goto error_close_devices;
> > 
> > Wouldn't open_seed_devices() also need a change like this?
> > 
> > I'd just rework __btrfs_open_devices to clean up after itself when it
> > returns an error.
> > 
> >>  error_close_devices:
> >> -    btrfs_close_devices(fs_devices);
> >> +    if (fs_devices->open_devices)
> >> +            btrfs_close_devices(fs_devices);
> > 
> > I guess that ->open_devices is supposed to be protected by the
> > uuid_mutex so it shouldn't be tested out here.  In any case, it wouldn't
> > be needed if btrfs_open_devices() cleaned up as it failed.
> 
> I guess I had a feeling that in something like a degraded mount scenario
> you might live with failures.  But I guess that is initiated on the mount
> commandline, i.e. "mount this subset; it's degraded" not "mount these devices,
> and if some fail that's cool."

btrfs_open_devices just means: go off and open every bdev you can from
this uuid.  It should return success if we opened any of them at all.

__btrfs_open_devices() already ignores failures, and this is the
only place it is explicitly setting ret.  It should only happen if there
are no devices to close.

        if (fs_devices->open_devices == 0) {
                ret = -EINVAL;
                goto out;
        }

Unless of course we happen to fail to open the last device in the list:

	ret = btrfs_get_bdev_and_sb(device->name->str, flags, holder, 1, &bdev, &bh);
	if (ret)
		continue;

This is two curlies and a ret = 0 away from correct.

-chris

