Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53388 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756518AbeD0CIL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Apr 2018 22:08:11 -0400
Subject: Re: [PATCH v2 12/16] btrfs: track running balance in a simpler way
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1524146555.git.dsterba@suse.com>
 <6d512cf2c8f825592703ee0d45c51f22396e6078.1524146556.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2e28020f-ef28-ee43-d9e3-1c74c03a472d@oracle.com>
Date: Fri, 27 Apr 2018 10:10:24 +0800
MIME-Version: 1.0
In-Reply-To: <6d512cf2c8f825592703ee0d45c51f22396e6078.1524146556.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/20/2018 12:33 AM, David Sterba wrote:
> Currently fs_info::balance_running is 0 or 1 and does not use the
> semantics of atomics. The pause and cancel check for 0, that can happen
> only after __btrfs_balance exits for whatever reason.
> 
> Parallel calls to balance ioctl may enter btrfs_ioctl_balance multiple
> times but will block on the balance_mutex that protects the
> fs_info::flags bit.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

  Though it appears to me that we could optimize the lock and atomic bit
  usage a little more, however it can be taken for the next round of
  cleanups. So for now..

  Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand
