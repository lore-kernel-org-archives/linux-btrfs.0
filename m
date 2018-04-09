Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:37910 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751662AbeDIOxl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Apr 2018 10:53:41 -0400
Subject: Re: [PATCH 10/16] btrfs: remove wrong use of volume_mutex from
 btrfs_dev_replace_start
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1522780026.git.dsterba@suse.com>
 <3506f0f2a65a88ef2a5bb1cfff0617503621ba19.1522780026.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <65cccbc8-367b-4af0-f181-daed6605c815@oracle.com>
Date: Mon, 9 Apr 2018 22:55:38 +0800
MIME-Version: 1.0
In-Reply-To: <3506f0f2a65a88ef2a5bb1cfff0617503621ba19.1522780026.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/04/2018 02:34 AM, David Sterba wrote:
> The volume mutex does not protect against anything in this case, the
> comment about scrub is right but not related to locking and looks
> confusing. The comment in btrfs_find_device_missing_or_by_path is wrong
> and confusing too.
> 
> The device_list_mutex is not held here to protect device lookup, but in
> this case device replace cannot run in parallel with device removal (due
> to exclusive op protection), so we don't need further locking here.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

  Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

