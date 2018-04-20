Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60708 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753738AbeDTHgA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Apr 2018 03:36:00 -0400
Subject: Re: [PATCH v2 08/16] btrfs: add sanity check when resuming balance
 after mount
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1524146555.git.dsterba@suse.com>
 <32c7579ceb072a870ec8a2e4f0348cfb37bd61d5.1524146556.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <4dba5057-e0de-53e0-9cc0-45a6cf52f291@oracle.com>
Date: Fri, 20 Apr 2018 15:38:05 +0800
MIME-Version: 1.0
In-Reply-To: <32c7579ceb072a870ec8a2e4f0348cfb37bd61d5.1524146556.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/20/2018 12:33 AM, David Sterba wrote:
> Replace a WARN_ON with a proper check and message in case something goes
> really wrong and resumed balance cannot set up its exclusive status.
> The check is a user friendly assertion, I don't expect to ever happen
> under normal circumstances.
> 
> Also document that the paused balance starts here and owns the exclusive
> op status.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand
