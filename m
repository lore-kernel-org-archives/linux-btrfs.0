Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41814 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbeDEJjK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Apr 2018 05:39:10 -0400
Subject: Re: [PATCH 03/16] btrfs: export and rename free_device
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1522780026.git.dsterba@suse.com>
 <bb954b4f9305318f582c3a355c6e677979d3c7b0.1522780026.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <79e0b2aa-52f0-c2eb-135e-3f34b00eecc1@oracle.com>
Date: Thu, 5 Apr 2018 17:41:09 +0800
MIME-Version: 1.0
In-Reply-To: <bb954b4f9305318f582c3a355c6e677979d3c7b0.1522780026.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/04/2018 02:34 AM, David Sterba wrote:
> The function will be used outside of volumes.c, the allocation
> btrfs_alloc_device is also exported.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand
