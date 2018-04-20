Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44386 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754462AbeDTJTU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 05:19:20 -0400
Subject: Re: [PATCH v2 14/16] btrfs: drop lock parameter from
 update_ioctl_balance_args and rename
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1524146555.git.dsterba@suse.com>
 <afbad2279a57354e0b71fa20fdcb4e35d0ca0211.1524146556.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <1707cf51-477b-af00-febb-4c182f7fe987@oracle.com>
Date: Fri, 20 Apr 2018 17:21:27 +0800
MIME-Version: 1.0
In-Reply-To: <afbad2279a57354e0b71fa20fdcb4e35d0ca0211.1524146556.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/20/2018 12:33 AM, David Sterba wrote:
> The parameter controls locking of the stats part but we can lock it
> unconditionally, as this only happens once when balance starts. This is
> not performance critical.
> 
> Add the prefix for an exported function.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

  Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand
