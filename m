Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965207AbbI2OfG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 10:35:06 -0400
Date: Tue, 29 Sep 2015 16:34:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
Subject: Re: [PATCH 00/23] btrfs device related patch set
Message-ID: <20150929143406.GD11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439548388-29686-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 14, 2015 at 06:32:45PM +0800, Anand Jain wrote:
> Anand Jain (22):
>   Btrfs: rename btrfs_sysfs_add_one to btrfs_sysfs_add_mounted
>   Btrfs: rename btrfs_sysfs_remove_one to btrfs_sysfs_remove_mounted
>   Btrfs: rename btrfs_kobj_add_device to btrfs_sysfs_add_device_link
>   Btrfs: rename btrfs_kobj_rm_device to btrfs_sysfs_rm_device_link
>   Btrfs: rename super_kobj to fsid_kobj
>   Btrfs: SB read failure should return EIO for __bread failure
>   Btrfs: __btrfs_std_error() logic should be consistent w/out
>     CONFIG_PRINTK defined

FYI, I'm picking the above for 4.4 as they're quite straightforward, the
other patches touch interfaces and I have some comments.
