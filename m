Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:42796 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754149AbeDTJX3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 05:23:29 -0400
Subject: Re: [PATCH v2 15/16] btrfs: use mutex in btrfs_resume_balance_async
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1524146555.git.dsterba@suse.com>
 <a17bb1118ad18ab1b823cfd472dbb57bce6e1e88.1524146556.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <992f610e-7a86-6163-b49b-f829ce5a26a9@oracle.com>
Date: Fri, 20 Apr 2018 17:25:36 +0800
MIME-Version: 1.0
In-Reply-To: <a17bb1118ad18ab1b823cfd472dbb57bce6e1e88.1524146556.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/20/2018 12:33 AM, David Sterba wrote:
> While the spinlock does not cause problems, using the mutex is more
> correct and consistent with others. The global status of balance is eg.
> checked from btrfs_pause_balance or btrfs_cancel_balance with mutex.
> 
> Resuming balance happens during mount or ro->rw remount. In the former
> case, no other user of the balance_ctl exists, in the latter, balance
> cannot run until the ro/rw transition is finished.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand
