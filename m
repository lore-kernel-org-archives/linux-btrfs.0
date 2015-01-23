Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38362 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057AbbAWQf5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 11:35:57 -0500
Date: Fri, 23 Jan 2015 17:35:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
Subject: Re: [PATCH 1/1] Btrfs: move super_kobj and device_dir_kobj from
 fs_info to btrfs_fs_devices
Message-ID: <20150123163555.GQ13289@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421683347-18226-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1421683347-18226-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 20, 2015 at 12:02:27AM +0800, Anand Jain wrote:
> This patch will provide a framework and help to create attributes
> from the structure btrfs_fs_devices which are available even before
> fs_info is created. So by moving the parent kobject super_kobj from
> fs_info to btrfs_fs_devices, it will help to create attributes
> from the btrfs_fs_devices as well.

Ok.

> Just to note, this does not change any of the existing btrfs sysfs
> external kobject names and its attributes and not even the life
> cycle of them. Changes are internal only. And to ensure the same,
> this path has been tested with various device operations and,
> checking and comparing the sysfs kobjects and attributes with
> sysfs kobject and attributes with out this patch, and they remain
> same.

Good.

Reviewed-by: David Sterba <dsterba@suse.cz>
