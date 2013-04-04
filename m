Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762186Ab3DDSqe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Apr 2013 14:46:34 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r34IkXAe009614
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 4 Apr 2013 14:46:33 -0400
Date: Thu, 4 Apr 2013 11:46:32 -0700
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Jan Safranek <jsafrane@redhat.com>
Subject: Re: [PATCH V2] btrfs: close any open devices if btrfs_mount fails
Message-ID: <20130404184632.GA23636@lenny.home.zabbo.net>
References: <515D9DDE.5040306@redhat.com>
 <515DAB1F.2050308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <515DAB1F.2050308@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> It's because btrfs_open_devices() may open some devices, and still
> return failure.  So the error unwinding needs to close any open
> devices in fs_devices before returning.

Yeah, looks like.

> Note, __btrfs_open_devices is weird; it seems to return success or
> failure based on the outcome of the result of the last call
> to btrfs_get_bdev_and_sb().  But that's a different bug...

I disagree that this is a different bug, I think it's the root cause of
this bug.

> @@ -1125,7 +1125,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
>  
>  	error = btrfs_open_devices(fs_devices, mode, fs_type);
>  	if (error)
> -		goto error_fs_info;
> +		goto error_close_devices;

Wouldn't open_seed_devices() also need a change like this?

I'd just rework __btrfs_open_devices to clean up after itself when it
returns an error.

>  error_close_devices:
> -	btrfs_close_devices(fs_devices);
> +	if (fs_devices->open_devices)
> +		btrfs_close_devices(fs_devices);

I guess that ->open_devices is supposed to be protected by the
uuid_mutex so it shouldn't be tested out here.  In any case, it wouldn't
be needed if btrfs_open_devices() cleaned up as it failed.

- z
