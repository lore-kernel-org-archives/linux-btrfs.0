Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39974 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731569AbeGQOVO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 10:21:14 -0400
Date: Tue, 17 Jul 2018 15:48:20 +0200
From: David Sterba <dsterba@suse.cz>
To: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "anand.jain@oracle.com" <anand.jain@oracle.com>
Subject: Re: [PATCH v5 2/2] btrfs: get device pointer from
 btrfs_scan_one_device
Message-ID: <20180717134819.GY3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1531733656-23806-1-git-send-email-gujx@cn.fujitsu.com>
 <1531732277-23517-2-git-send-email-gujx@cn.fujitsu.com>
 <20180716123417.GF3126@twin.jikos.cz>
 <516DDBE5B1D92D42BCF7A2E37F045A5D01A8A35A22@G08CNEXMBPEKD02.g08.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <516DDBE5B1D92D42BCF7A2E37F045A5D01A8A35A22@G08CNEXMBPEKD02.g08.fujitsu.local>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 17, 2018 at 01:08:34AM +0000, Gu, Jinxiang wrote:
> > > -	device = device_list_add(path, disk_super, &new_device_added);
> > > -	if (IS_ERR(device)) {
> > > -		ret = PTR_ERR(device);
> > > -	} else {
> > > -		*fs_devices_ret = device->fs_devices;
> > > -		if (new_device_added)
> > > -			btrfs_free_stale_devices(path, device);
> > > -	}
> > > +	ret = device_list_add(path, disk_super, &new_device_added);
> > > +	if (new_device_added)
> > > +		btrfs_free_stale_devices(path, ret);
> > 
> > Why is this skipping the error handling? I've resolved the conflict in a
> > different way in misc-next, have you had a look there?
> 
> Since when new_device_added set to be true, the return value of device_list_add
> must not a error value.

Yeah, but this is not obvious from the context and looks like "
device_list_add fails but we'll do something anyway", so I'm for keeping
the check.

> So, I think no necessary to add the judge.
