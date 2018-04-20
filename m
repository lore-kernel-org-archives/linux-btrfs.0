Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:33694 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754422AbeDTJCi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 05:02:38 -0400
Subject: Re: [PATCH v2 09/16] btrfs: cleanup helpers that reset balance state
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1524146555.git.dsterba@suse.com>
 <7d7e38bf1b3031fda1b4493d4849ca8ec94d8bc6.1524146556.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <8244aae0-5134-7cd7-3268-4f258ed3b48d@oracle.com>
Date: Fri, 20 Apr 2018 17:04:46 +0800
MIME-Version: 1.0
In-Reply-To: <7d7e38bf1b3031fda1b4493d4849ca8ec94d8bc6.1524146556.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/20/2018 12:33 AM, David Sterba wrote:
> The function __cancel_balance name is confusing with the cancel
> operation of balance and it really resets the state of balance back to
> zero. The unset_balance_control helper is called only from one place and
> simple enough to be inlined.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

  Reviewed-by: Anand Jain <anand.jain@oracle.com>

