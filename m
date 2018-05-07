Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51172 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752158AbeEGWlr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 May 2018 18:41:47 -0400
Subject: Re: [PATCH] btrfs: remove redundant btrfs_balance_control::fs_info
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20180507154403.1628-1-dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <3f52d04a-9556-2f89-a878-401a7c5baa0d@oracle.com>
Date: Tue, 8 May 2018 06:44:06 +0800
MIME-Version: 1.0
In-Reply-To: <20180507154403.1628-1-dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/07/2018 11:44 PM, David Sterba wrote:
> The fs_info is always available from the context so we don't need to
> store it in the structure.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>
