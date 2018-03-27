Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48126 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbeC0UMY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Mar 2018 16:12:24 -0400
Subject: Re: [PATCH 4/6] btrfs: use RCU in btrfs_show_devname for device list
 traversal
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1522176187.git.dsterba@suse.com>
 <7c574ffc98700bda85d92ffc7b9ad49b65017e9d.1522176187.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <789a6571-e79c-5cda-1b90-57d5de8322c6@oracle.com>
Date: Wed, 28 Mar 2018 04:09:13 +0800
MIME-Version: 1.0
In-Reply-To: <7c574ffc98700bda85d92ffc7b9ad49b65017e9d.1522176187.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/28/2018 02:48 AM, David Sterba wrote:
> The show_devname callback is used to print device name in
> /proc/self/mounts, we need to traverse the device list consistently and
> read the name that's copied to a seq buffer so we don't need further
> locking.
> 
> If the first device is being deleted at the same time, the RCU will
> allow us to read the device name, though it will become stale right
> after the RCU protection ends. This is unavoidable and the user can
> expect that the device will disappear from the filesystem's list at some
> point.
> 
> The device_list_mutex was pretty heavy as it is used eg. for writing
> superblock and a few other IO related contexts. This can stall any
> application that reads the proc file for no reason.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

