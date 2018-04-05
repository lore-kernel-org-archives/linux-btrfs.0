Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41380 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbeDEJi1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Apr 2018 05:38:27 -0400
Subject: Re: [PATCH 01/16] btrfs: squeeze btrfs_dev_replace_continue_on_mount
 to its caller
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1522780026.git.dsterba@suse.com>
 <c231bf7bd55260809fd6cd7f3e835eba933914fe.1522780026.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2b3fce8e-32f3-e217-9490-def0bc00bf39@oracle.com>
Date: Thu, 5 Apr 2018 17:40:25 +0800
MIME-Version: 1.0
In-Reply-To: <c231bf7bd55260809fd6cd7f3e835eba933914fe.1522780026.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/04/2018 02:34 AM, David Sterba wrote:
> The function is called once and is fairly small, we can merge it with
> the caller.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand
