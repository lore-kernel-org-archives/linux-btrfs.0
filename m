Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40548 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731607AbeGQOXX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 10:23:23 -0400
Date: Tue, 17 Jul 2018 15:50:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>, "Gu, Jinxiang" <gujx@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v5 2/2] btrfs: get device pointer from
 btrfs_scan_one_device
Message-ID: <20180717135030.GZ3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1531733656-23806-1-git-send-email-gujx@cn.fujitsu.com>
 <1531732277-23517-2-git-send-email-gujx@cn.fujitsu.com>
 <20180716123417.GF3126@twin.jikos.cz>
 <516DDBE5B1D92D42BCF7A2E37F045A5D01A8A35A22@G08CNEXMBPEKD02.g08.fujitsu.local>
 <61d50b9c-9230-c841-7d07-8b47799c34c8@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <61d50b9c-9230-c841-7d07-8b47799c34c8@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 17, 2018 at 12:54:00PM +0800, Anand Jain wrote:
> 
> ::
> 
> >>> @@ -1561,12 +1564,15 @@ static struct dentry *btrfs_mount_root(struct file_system_type *fs_type,
> >>>   		goto error_fs_info;
> >>>   	}
> >>>
> >>> -	error = btrfs_scan_one_device(device_name, mode, fs_type, &fs_devices);
> >>> -	if (error) {
> >>> +	device = btrfs_scan_one_device(device_name, mode, fs_type);
> >>> +	if (IS_ERR(device)) {
> >>> +		error = PTR_ERR(device);
> >>>   		mutex_unlock(&uuid_mutex);
> >>>   		goto error_fs_info;
> >>>   	}
> >>>
> >>> +	fs_devices = device->fs_devices;
> >>> +
> 
>   The version at misc-next is missing this assignment and it panics.

Thanks, that was my mismerge. Now added back and pushed.
